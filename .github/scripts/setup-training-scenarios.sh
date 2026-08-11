#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Set up GitHub Copilot app course training scenarios.

This script seeds a fork or disposable training repository with:
- course issue labels
- five seeded issues
- practice branches with intentional regressions
- pull requests for conversation-comment, failing-check, and merge-readiness lessons
- a PR comment for the empty-state copy review scenario

Run it from the repository root after you fork and clone the course repo.

Usage:
  .github/scripts/setup-training-scenarios.sh
  .github/scripts/setup-training-scenarios.sh --dry-run

Options:
  --dry-run   Print what would happen without changing GitHub or branches.
  --help      Show this help.

Requirements:
  git, gh, python3
  gh auth login
USAGE
}

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

log() {
  printf '%s\n' "$*" >&2
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] %q' "$1"
    shift || true
    for arg in "$@"; do
      printf ' %q' "$arg"
    done
    printf '\n'
  else
    "$@"
  fi
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command git
require_command gh
require_command python3

if [[ ! -d .git ]]; then
  echo "Run this script from the root of a cloned Git repository." >&2
  exit 1
fi

if [[ ! -f samples/book-app-web/src/App.tsx ]]; then
  echo "Could not find samples/book-app-web/src/App.tsx. Run from the course repository root." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Your working tree has uncommitted changes. Commit, stash, or discard them before running this setup script." >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 0 ]]; then
  gh auth status >/dev/null
fi

REPO="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
DEFAULT_BRANCH="$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')"
START_BRANCH="$(git branch --show-current || true)"
GH_USER="$(gh api user --jq '.login')"

if [[ -z "$DEFAULT_BRANCH" ]]; then
  echo "Could not determine the repository default branch." >&2
  exit 1
fi

log "Repository: $REPO"
log "Default branch: $DEFAULT_BRANCH"

if [[ "$DRY_RUN" -eq 0 ]]; then
  git fetch origin "$DEFAULT_BRANCH"
  git switch "$DEFAULT_BRANCH"
  git pull --ff-only origin "$DEFAULT_BRANCH"
else
  log "[dry-run] would fetch and update $DEFAULT_BRANCH"
fi

ensure_label() {
  local name="$1"
  local color="$2"
  local description="$3"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would ensure label: $name"
    return
  fi

  if gh label list --limit 200 --json name --jq '.[].name' | grep -Fxq "$name"; then
    gh label edit "$name" --color "$color" --description "$description" >/dev/null
  else
    gh label create "$name" --color "$color" --description "$description" >/dev/null
  fi
}

ensure_issue() {
  local title="$1"
  local labels_csv="$2"
  local body="$3"

  local existing=""
  if [[ "$DRY_RUN" -eq 0 ]]; then
    existing="$(TITLE="$title" gh issue list --state all --limit 200 --json number,title --jq '.[] | select(.title == env.TITLE) | .number' | head -n 1)"
  fi

  if [[ -n "$existing" ]]; then
    log "Issue exists: #$existing $title"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would create issue: $title"
    return
  fi

  local body_file
  body_file="$(mktemp)"
  printf '%s\n' "$body" > "$body_file"

  local args=(issue create --title "$title" --body-file "$body_file" --assignee "$GH_USER")
  IFS=',' read -ra labels <<< "$labels_csv"
  for label in "${labels[@]}"; do
    args+=(--label "$label")
  done

  gh "${args[@]}" >/dev/null
  rm -f "$body_file"
  log "Created issue: $title"
}

apply_scenario() {
  local scenario="$1"
  python3 - "$scenario" <<'PY'
from pathlib import Path
import sys

scenario = sys.argv[1]
app = Path("samples/book-app-web/src/App.tsx")
stats = Path("samples/book-app-web/src/components/ReadingStats.tsx")
sample_readme = Path("samples/book-app-web/README.md")

def replace(path: Path, old: str, new: str) -> None:
    text = path.read_text()
    if new in text:
        return
    if old not in text:
        raise SystemExit(f"Expected text not found in {path} for scenario {scenario}")
    path.write_text(text.replace(old, new))

if scenario == "search-case-bug":
    replace(
        app,
        """const normalizedSearchTerm = filters.searchTerm.trim().toLowerCase();

  return bookList.filter((book) => {
    const matchesSearch =
      normalizedSearchTerm.length === 0 ||
      book.title.toLowerCase().includes(normalizedSearchTerm) ||
      book.author.toLowerCase().includes(normalizedSearchTerm);""",
        """const normalizedSearchTerm = filters.searchTerm.trim();

  return bookList.filter((book) => {
    const matchesSearch =
      normalizedSearchTerm.length === 0 ||
      book.title.includes(normalizedSearchTerm) ||
      book.author.includes(normalizedSearchTerm);""",
    )
elif scenario == "unread-count-bug":
    replace(app, "<ReadingStats books={filteredBooks} />", "<ReadingStats books={books} />")
elif scenario == "empty-state-regression":
    replace(
        app,
        """<h2>No matching books found</h2>
            <p>Try a different search term, genre, or reading status.</p>""",
        """<h2>No results</h2>
            <p>Try again.</p>""",
    )
elif scenario == "empty-state-pr":
    replace(
        app,
        """<h2>No matching books found</h2>
            <p>Try a different search term, genre, or reading status.</p>""",
        """<h2>No books found</h2>
            <p>Adjust your filters and try again.</p>""",
    )
elif scenario == "failing-stats-check":
    replace(
        stats,
        "const favoriteCount = books.filter((book) => book.isFavorite).length;",
        "const favoriteCount = books.filter((book) => book.isFavorite && book.isRead).length;",
    )
elif scenario == "reading-dashboard-note":
    note = """

## Training scenario note

This branch is used for the Agent Merge readiness discussion in the course. It keeps the app behavior stable while giving learners a safe pull request to inspect.
"""
    text = sample_readme.read_text()
    if "## Training scenario note" not in text:
        sample_readme.write_text(text.rstrip() + note + "\n")
elif scenario == "card-polish-branch":
    note = """

## Visual polish practice

Use this branch to practice planning responsive card improvements before changing UI code.
"""
    text = sample_readme.read_text()
    if "## Visual polish practice" not in text:
        sample_readme.write_text(text.rstrip() + note + "\n")
else:
    raise SystemExit(f"Unknown scenario: {scenario}")
PY
}

branch_exists_remote() {
  git ls-remote --exit-code --heads origin "$1" >/dev/null 2>&1
}

branch_exists_local() {
  git show-ref --verify --quiet "refs/heads/$1"
}

ensure_branch() {
  local branch="$1"
  local scenario="$2"
  local message="$3"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would create or reuse branch: $branch ($scenario)"
    return
  fi

  if branch_exists_remote "$branch"; then
    log "Remote branch exists: $branch"
    return
  fi

  if branch_exists_local "$branch"; then
    log "Local branch exists; pushing it: $branch"
    git switch "$branch"
    git push -u origin "$branch"
    git switch "$DEFAULT_BRANCH"
    return
  fi

  git switch -c "$branch" "origin/$DEFAULT_BRANCH"
  apply_scenario "$scenario"

  git add samples/book-app-web
  if git diff --cached --quiet; then
    git commit --allow-empty -m "$message"
  else
    git commit -m "$message"
  fi

  git push -u origin "$branch"
  git switch "$DEFAULT_BRANCH"
  log "Created branch: $branch"
}

ensure_pr() {
  local branch="$1"
  local title="$2"
  local body="$3"

  local existing=""
  if [[ "$DRY_RUN" -eq 0 ]]; then
    existing="$(gh pr list --state all --head "$branch" --json number --jq '.[0].number // empty')"
  fi

  if [[ -n "$existing" ]]; then
    log "PR exists: #$existing $title"
    printf '%s' "$existing"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would create PR from $branch: $title"
    return
  fi

  local body_file
  body_file="$(mktemp)"
  printf '%s\n' "$body" > "$body_file"
  local url
  url="$(gh pr create --head "$branch" --base "$DEFAULT_BRANCH" --title "$title" --body-file "$body_file")"
  rm -f "$body_file"
  local number="${url##*/}"
  log "Created PR: #$number $title" >&2
  printf '%s' "$number"
}

ensure_pr_comment() {
  local pr_number="$1"
  local marker="$2"
  local body="$3"

  if [[ -z "$pr_number" ]]; then
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would add PR comment to #$pr_number"
    return
  fi

  if gh pr view "$pr_number" --comments --json comments --jq '.comments[].body' | grep -Fq "$marker"; then
    log "PR comment exists on #$pr_number"
    return
  fi

  gh pr comment "$pr_number" --body "$body" >/dev/null
  log "Added PR comment to #$pr_number"
}

log "Ensuring labels..."
ensure_label "book-app-web" "1f883d" "Course sample app scenario"
ensure_label "good first issue" "7057ff" "Beginner-friendly course issue"
ensure_label "bug" "d73a4a" "Intentional course bug scenario"
ensure_label "tests" "0052cc" "Testing or CI scenario"
ensure_label "accessibility" "0e8a16" "Accessibility-focused scenario"
ensure_label "copy" "5319e7" "Content or copy scenario"
ensure_label "ui" "c2e0c6" "User interface scenario"
ensure_label "responsive" "bfd4f2" "Responsive layout scenario"
ensure_label "ci" "fbca04" "Continuous integration scenario"

log "Ensuring issues..."
ensure_issue "Make search case-insensitive" "bug,good first issue,book-app-web" \
"The book search should match titles and authors regardless of letter case.

Training branch: \`practice-search-case-bug\`

Repro:
1. Open \`samples/book-app-web\`.
2. Run \`npm run dev -- --host 127.0.0.1 --port 5173\`.
3. Search for \`hobbit\`.

Expected result: \`The Hobbit\` appears in the results.

Learner goal: Ask Copilot to find the search logic, write or update a test, and make the smallest safe fix."

ensure_issue "Keep unread stats correct when filters are active" "bug,tests,book-app-web" \
"Stats should describe the books currently shown after filters are applied.

Training branch: \`practice-unread-count-bug\`

Repro:
1. Filter status to \`Unread\`.
2. Compare the book cards with the stats row.

Expected result: The unread count matches the visible unread cards.

Learner goal: Ask Copilot to trace props from \`App.tsx\` to \`ReadingStats.tsx\`."

ensure_issue "Improve the empty state copy" "accessibility,copy,book-app-web" \
"The empty state should be clear for beginners and screen reader users.

Training branch: \`practice-empty-state-copy\`

Repro:
1. Search for text that matches no books.
2. Review the empty state.

Expected result: The message explains that no matching books were found and suggests changing filters.

Learner goal: Use a PR conversation comment to request clearer copy, then ask Copilot to address the comment."

ensure_issue "Polish book card spacing and responsive layout" "ui,responsive,book-app-web" \
"Book cards should have clear hierarchy, comfortable spacing, and a useful mobile layout.

Training branch: \`practice-card-polish\`

Repro:
1. Open the app in the browser.
2. Resize the viewport below 560px.
3. Inspect the card spacing and status labels.

Expected result: Cards stay readable and controls remain easy to use.

Learner goal: Use browser validation or a Pick and Polish exercise to compare visual changes before accepting them."

ensure_issue "Simulate a failing stats test for CI practice" "ci,tests,book-app-web" \
"The default app should pass tests. This scenario creates a training branch that changes favorite counting incorrectly so CI fails on the stats test.

Training branch and PR: \`practice-failing-stats-check\`

Expected failure: \`npm test -- --run\` fails in \`src/tests/stats.test.tsx\` because unread favorites are valid favorites too.

Learner goal: Use Copilot to inspect the failing check, explain the regression, and restore the correct favorite count."

log "Ensuring practice branches..."
ensure_branch "practice-search-case-bug" "search-case-bug" "Seed search case practice bug"
ensure_branch "practice-unread-count-bug" "unread-count-bug" "Seed unread stats practice bug"
ensure_branch "practice-empty-state-copy" "empty-state-regression" "Seed empty-state copy practice"
ensure_branch "practice-card-polish" "card-polish-branch" "Seed card polish practice branch"
ensure_branch "practice-failing-stats-check" "failing-stats-check" "Seed failing stats check practice"
ensure_branch "fix-empty-state-copy" "empty-state-pr" "Draft empty-state copy PR scenario"
ensure_branch "feature-reading-dashboard" "reading-dashboard-note" "Draft merge-readiness PR scenario"

log "Ensuring pull requests..."
empty_pr="$(ensure_pr "fix-empty-state-copy" "Improve empty-state copy" \
"This PR updates the empty state shown when filters match no books.

Course use:
- Practice responding to a PR conversation comment.
- Ask Copilot for the smallest safe improvement.
- Inspect the diff before accepting changes.")"

failing_pr="$(ensure_pr "practice-failing-stats-check" "Failing stats check practice" \
"This PR intentionally changes stats logic so CI can demonstrate a failing check.

Expected course behavior:
- \`npm test -- --run\` fails in \`src/tests/stats.test.tsx\`.
- Learners ask Copilot to explain the failure and restore the correct favorite count.")"

merge_pr="$(ensure_pr "feature-reading-dashboard" "Reading dashboard merge-readiness practice" \
"This PR is a safe merge-readiness discussion scenario.

Course use:
- Confirm tests and build pass.
- Discuss review state and branch protection.
- Decide whether Agent Merge would be appropriate after human review.")"

ensure_pr_comment "$empty_pr" "Please mention that they can change the search term, genre, or reading status." \
"The copy is better, but can we make it more helpful for a first-time learner? Please mention that they can change the search term, genre, or reading status."

log ""
log "Setup complete."
log "Next checks:"
log "- Open the GitHub Copilot app and connect this fork/training repository."
log "- Confirm the seeded issues and PRs appear in My work."
log "- Wait for the failing-check PR workflow to finish before using that lesson."

if [[ -n "$START_BRANCH" && "$DRY_RUN" -eq 0 ]]; then
  git switch "$START_BRANCH" >/dev/null 2>&1 || true
fi
