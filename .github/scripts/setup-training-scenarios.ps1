param(
    [switch]$DryRun,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

function Show-Usage {
    @"
Set up GitHub Copilot app course training scenarios.

This script seeds a fork or disposable training repository with:
- course issue labels
- five seeded issues
- practice branches with intentional regressions
- pull requests for conversation-comment, failing-check, and merge-readiness lessons
- a PR comment for the empty-state copy review scenario

Run it from the repository root after you fork and clone the course repo.

Usage:
  powershell -ExecutionPolicy Bypass -File .\.github\scripts\setup-training-scenarios.ps1
  powershell -ExecutionPolicy Bypass -File .\.github\scripts\setup-training-scenarios.ps1 -DryRun

Options:
  -DryRun   Print what would happen without changing GitHub or branches.
  -Help     Show this help.

Requirements:
  git, gh, PowerShell
  gh auth login
"@
}

if ($Help) {
    Show-Usage
    exit 0
}

function Write-Log {
    param([string]$Message)
    [Console]::Error.WriteLine($Message)
}

function Require-Command {
    param([string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Missing required command: $Name"
    }
}

function Invoke-External {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [switch]$AllowFailure,
        [switch]$Quiet
    )

    if ($Quiet) {
        & $FilePath @Arguments *> $null
    }
    else {
        & $FilePath @Arguments
    }

    $exitCode = $LASTEXITCODE
    if (-not $AllowFailure -and $exitCode -ne 0) {
        throw "$FilePath failed with exit code ${exitCode}: $($Arguments -join ' ')"
    }

    return $exitCode
}

function Get-ExternalOutput {
    param(
        [string]$FilePath,
        [string[]]$Arguments
    )

    $output = & $FilePath @Arguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "$FilePath failed with exit code ${exitCode}: $($Arguments -join ' ')"
    }

    return ($output | Out-String).Trim()
}

function ConvertFrom-GhJson {
    param([string[]]$Arguments)

    $json = Get-ExternalOutput -FilePath "gh" -Arguments $Arguments
    if ([string]::IsNullOrWhiteSpace($json)) {
        return $null
    }

    return $json | ConvertFrom-Json
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Value
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Resolve-Path $Path), $Value, $encoding)
}

function Replace-Text {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New,
        [string]$Scenario
    )

    $text = [System.IO.File]::ReadAllText((Resolve-Path $Path))
    if ($text.Contains($New)) {
        return
    }

    $oldCandidate = $Old
    $newCandidate = $New
    if (-not $text.Contains($oldCandidate)) {
        $oldCandidate = $Old.Replace("`n", "`r`n")
        $newCandidate = $New.Replace("`n", "`r`n")
    }

    if (-not $text.Contains($oldCandidate)) {
        throw "Expected text not found in $Path for scenario $Scenario"
    }

    Write-Utf8NoBom -Path $Path -Value $text.Replace($oldCandidate, $newCandidate)
}

function Add-ReadmeNote {
    param(
        [string]$Path,
        [string]$Marker,
        [string]$Note
    )

    $text = [System.IO.File]::ReadAllText((Resolve-Path $Path))
    if ($text.Contains($Marker)) {
        return
    }

    $newline = "`n"
    if ($text.Contains("`r`n")) {
        $newline = "`r`n"
    }

    $normalizedNote = $Note.Replace("`n", $newline)
    Write-Utf8NoBom -Path $Path -Value ($text.TrimEnd() + $newline + $normalizedNote + $newline)
}

function Apply-Scenario {
    param([string]$Scenario)

    $app = "samples/book-app-web/src/App.tsx"
    $stats = "samples/book-app-web/src/components/ReadingStats.tsx"
    $sampleReadme = "samples/book-app-web/README.md"

    switch ($Scenario) {
        "search-case-bug" {
            Replace-Text -Path $app -Scenario $Scenario -Old @'
const normalizedSearchTerm = filters.searchTerm.trim().toLowerCase();

  return bookList.filter((book) => {
    const matchesSearch =
      normalizedSearchTerm.length === 0 ||
      book.title.toLowerCase().includes(normalizedSearchTerm) ||
      book.author.toLowerCase().includes(normalizedSearchTerm);
'@ -New @'
const normalizedSearchTerm = filters.searchTerm.trim();

  return bookList.filter((book) => {
    const matchesSearch =
      normalizedSearchTerm.length === 0 ||
      book.title.includes(normalizedSearchTerm) ||
      book.author.includes(normalizedSearchTerm);
'@
        }
        "unread-count-bug" {
            Replace-Text -Path $app -Scenario $Scenario -Old "<ReadingStats books={filteredBooks} />" -New "<ReadingStats books={books} />"
        }
        "empty-state-regression" {
            Replace-Text -Path $app -Scenario $Scenario -Old @'
<h2>No matching books found</h2>
            <p>Try a different search term, genre, or reading status.</p>
'@ -New @'
<h2>No results</h2>
            <p>Try again.</p>
'@
        }
        "empty-state-pr" {
            Replace-Text -Path $app -Scenario $Scenario -Old @'
<h2>No matching books found</h2>
            <p>Try a different search term, genre, or reading status.</p>
'@ -New @'
<h2>No books found</h2>
            <p>Adjust your filters and try again.</p>
'@
        }
        "failing-stats-check" {
            Replace-Text -Path $stats -Scenario $Scenario -Old "const favoriteCount = books.filter((book) => book.isFavorite).length;" -New "const favoriteCount = books.filter((book) => book.isFavorite && book.isRead).length;"
        }
        "reading-dashboard-note" {
            Add-ReadmeNote -Path $sampleReadme -Marker "## Training scenario note" -Note @'

## Training scenario note

This branch is used for the Agent Merge readiness discussion in the course. It keeps the app behavior stable while giving learners a safe pull request to inspect.
'@
        }
        "card-polish-branch" {
            Add-ReadmeNote -Path $sampleReadme -Marker "## Visual polish practice" -Note @'

## Visual polish practice

Use this branch to practice planning responsive card improvements before changing UI code.
'@
        }
        default {
            throw "Unknown scenario: $Scenario"
        }
    }
}

function Branch-ExistsRemote {
    param([string]$Branch)

    $exitCode = Invoke-External -FilePath "git" -Arguments @("ls-remote", "--exit-code", "--heads", "origin", $Branch) -AllowFailure -Quiet
    return $exitCode -eq 0
}

function Branch-ExistsLocal {
    param([string]$Branch)

    $exitCode = Invoke-External -FilePath "git" -Arguments @("show-ref", "--verify", "--quiet", "refs/heads/$Branch") -AllowFailure -Quiet
    return $exitCode -eq 0
}

function Ensure-Label {
    param(
        [string]$Name,
        [string]$Color,
        [string]$Description
    )

    if ($DryRun) {
        Write-Log "[dry-run] would ensure label: $Name"
        return
    }

    $labels = ConvertFrom-GhJson -Arguments @("label", "list", "--limit", "200", "--json", "name")
    $exists = $false
    if ($labels) {
        $exists = @($labels | Where-Object { $_.name -eq $Name }).Count -gt 0
    }

    if ($exists) {
        Invoke-External -FilePath "gh" -Arguments @("label", "edit", $Name, "--color", $Color, "--description", $Description) -Quiet | Out-Null
    }
    else {
        Invoke-External -FilePath "gh" -Arguments @("label", "create", $Name, "--color", $Color, "--description", $Description) -Quiet | Out-Null
    }
}

function Ensure-Issue {
    param(
        [string]$Title,
        [string]$LabelsCsv,
        [string]$Body
    )

    $existing = $null
    if (-not $DryRun) {
        $issues = ConvertFrom-GhJson -Arguments @("issue", "list", "--state", "all", "--limit", "200", "--json", "number,title")
        if ($issues) {
            $existing = @($issues | Where-Object { $_.title -eq $Title } | Select-Object -First 1)
        }
    }

    if ($existing) {
        Write-Log "Issue exists: #$($existing.number) $Title"
        return
    }

    if ($DryRun) {
        Write-Log "[dry-run] would create issue: $Title"
        return
    }

    $bodyFile = [System.IO.Path]::GetTempFileName()
    try {
        Write-Utf8NoBom -Path $bodyFile -Value ($Body + "`n")
        $arguments = @("issue", "create", "--title", $Title, "--body-file", $bodyFile, "--assignee", $script:GitHubUser)
        foreach ($label in $LabelsCsv.Split(",")) {
            $trimmed = $label.Trim()
            if ($trimmed.Length -gt 0) {
                $arguments += @("--label", $trimmed)
            }
        }

        Invoke-External -FilePath "gh" -Arguments $arguments -Quiet | Out-Null
        Write-Log "Created issue: $Title"
    }
    finally {
        Remove-Item -Path $bodyFile -Force -ErrorAction SilentlyContinue
    }
}

function Ensure-Branch {
    param(
        [string]$Branch,
        [string]$Scenario,
        [string]$Message
    )

    if ($DryRun) {
        Write-Log "[dry-run] would create or reuse branch: $Branch ($Scenario)"
        return
    }

    if (Branch-ExistsRemote -Branch $Branch) {
        Write-Log "Remote branch exists: $Branch"
        return
    }

    if (Branch-ExistsLocal -Branch $Branch) {
        Write-Log "Local branch exists; pushing it: $Branch"
        Invoke-External -FilePath "git" -Arguments @("switch", $Branch) | Out-Null
        Invoke-External -FilePath "git" -Arguments @("push", "-u", "origin", $Branch) | Out-Null
        Invoke-External -FilePath "git" -Arguments @("switch", $script:DefaultBranch) | Out-Null
        return
    }

    Invoke-External -FilePath "git" -Arguments @("switch", "-c", $Branch, "origin/$script:DefaultBranch") | Out-Null
    Apply-Scenario -Scenario $Scenario

    Invoke-External -FilePath "git" -Arguments @("add", "samples/book-app-web") | Out-Null
    $exitCode = Invoke-External -FilePath "git" -Arguments @("diff", "--cached", "--quiet") -AllowFailure -Quiet
    if ($exitCode -eq 0) {
        Invoke-External -FilePath "git" -Arguments @("commit", "--allow-empty", "-m", $Message) | Out-Null
    }
    else {
        Invoke-External -FilePath "git" -Arguments @("commit", "-m", $Message) | Out-Null
    }

    Invoke-External -FilePath "git" -Arguments @("push", "-u", "origin", $Branch) | Out-Null
    Invoke-External -FilePath "git" -Arguments @("switch", $script:DefaultBranch) | Out-Null
    Write-Log "Created branch: $Branch"
}

function Ensure-PR {
    param(
        [string]$Branch,
        [string]$Title,
        [string]$Body
    )

    $existing = $null
    if (-not $DryRun) {
        $pulls = ConvertFrom-GhJson -Arguments @("pr", "list", "--state", "all", "--head", $Branch, "--json", "number")
        if ($pulls) {
            $existing = @($pulls | Select-Object -First 1)
        }
    }

    if ($existing) {
        Write-Log "PR exists: #$($existing.number) $Title"
        return $existing.number.ToString()
    }

    if ($DryRun) {
        Write-Log "[dry-run] would create PR from ${Branch}: $Title"
        return ""
    }

    $bodyFile = [System.IO.Path]::GetTempFileName()
    try {
        Write-Utf8NoBom -Path $bodyFile -Value ($Body + "`n")
        $url = Get-ExternalOutput -FilePath "gh" -Arguments @("pr", "create", "--head", $Branch, "--base", $script:DefaultBranch, "--title", $Title, "--body-file", $bodyFile)
        $number = ($url.Trim().Split("/") | Select-Object -Last 1)
        Write-Log "Created PR: #$number $Title"
        return $number
    }
    finally {
        Remove-Item -Path $bodyFile -Force -ErrorAction SilentlyContinue
    }
}

function Ensure-PRComment {
    param(
        [string]$PrNumber,
        [string]$Marker,
        [string]$Body
    )

    if ([string]::IsNullOrWhiteSpace($PrNumber)) {
        return
    }

    if ($DryRun) {
        Write-Log "[dry-run] would add PR comment to #$PrNumber"
        return
    }

    $pr = ConvertFrom-GhJson -Arguments @("pr", "view", $PrNumber, "--comments", "--json", "comments")
    $exists = $false
    if ($pr -and $pr.comments) {
        $exists = @($pr.comments | Where-Object { $_.body -like "*$Marker*" }).Count -gt 0
    }

    if ($exists) {
        Write-Log "PR comment exists on #$PrNumber"
        return
    }

    Invoke-External -FilePath "gh" -Arguments @("pr", "comment", $PrNumber, "--body", $Body) -Quiet | Out-Null
    Write-Log "Added PR comment to #$PrNumber"
}

Require-Command "git"
Require-Command "gh"

if (-not (Test-Path ".git" -PathType Container)) {
    throw "Run this script from the root of a cloned Git repository."
}

if (-not (Test-Path "samples/book-app-web/src/App.tsx" -PathType Leaf)) {
    throw "Could not find samples/book-app-web/src/App.tsx. Run from the course repository root."
}

$status = Get-ExternalOutput -FilePath "git" -Arguments @("status", "--porcelain")
if (-not [string]::IsNullOrWhiteSpace($status)) {
    throw "Your working tree has uncommitted changes. Commit, stash, or discard them before running this setup script."
}

if (-not $DryRun) {
    Invoke-External -FilePath "gh" -Arguments @("auth", "status") -Quiet | Out-Null
}

$repoView = ConvertFrom-GhJson -Arguments @("repo", "view", "--json", "nameWithOwner,defaultBranchRef")
$repo = $repoView.nameWithOwner
$script:DefaultBranch = $repoView.defaultBranchRef.name
$startBranch = Get-ExternalOutput -FilePath "git" -Arguments @("branch", "--show-current")
$script:GitHubUser = Get-ExternalOutput -FilePath "gh" -Arguments @("api", "user", "--jq", ".login")

if ([string]::IsNullOrWhiteSpace($script:DefaultBranch)) {
    throw "Could not determine the repository default branch."
}

Write-Log "Repository: $repo"
Write-Log "Default branch: $script:DefaultBranch"

if ($DryRun) {
    Write-Log "[dry-run] would fetch and update $script:DefaultBranch"
}
else {
    Invoke-External -FilePath "git" -Arguments @("fetch", "origin", $script:DefaultBranch) | Out-Null
    Invoke-External -FilePath "git" -Arguments @("switch", $script:DefaultBranch) | Out-Null
    Invoke-External -FilePath "git" -Arguments @("pull", "--ff-only", "origin", $script:DefaultBranch) | Out-Null
}

Write-Log "Ensuring labels..."
Ensure-Label "book-app-web" "1f883d" "Course sample app scenario"
Ensure-Label "good first issue" "7057ff" "Beginner-friendly course issue"
Ensure-Label "bug" "d73a4a" "Intentional course bug scenario"
Ensure-Label "tests" "0052cc" "Testing or CI scenario"
Ensure-Label "accessibility" "0e8a16" "Accessibility-focused scenario"
Ensure-Label "copy" "5319e7" "Content or copy scenario"
Ensure-Label "ui" "c2e0c6" "User interface scenario"
Ensure-Label "responsive" "bfd4f2" "Responsive layout scenario"
Ensure-Label "ci" "fbca04" "Continuous integration scenario"

Write-Log "Ensuring issues..."
Ensure-Issue "Make search case-insensitive" "bug,good first issue,book-app-web" @'
The book search should match titles and authors regardless of letter case.

Training branch: `practice-search-case-bug`

Repro:
1. Open `samples/book-app-web`.
2. Run `npm run dev -- --host 127.0.0.1 --port 5173`.
3. Search for `hobbit`.

Expected result: `The Hobbit` appears in the results.

Learner goal: Ask Copilot to find the search logic, write or update a test, and make the smallest safe fix.
'@

Ensure-Issue "Keep unread stats correct when filters are active" "bug,tests,book-app-web" @'
Stats should describe the books currently shown after filters are applied.

Training branch: `practice-unread-count-bug`

Repro:
1. Filter status to `Unread`.
2. Compare the book cards with the stats row.

Expected result: The unread count matches the visible unread cards.

Learner goal: Ask Copilot to trace props from `App.tsx` to `ReadingStats.tsx`.
'@

Ensure-Issue "Improve the empty state copy" "accessibility,copy,book-app-web" @'
The empty state should be clear for beginners and screen reader users.

Training branch: `practice-empty-state-copy`

Repro:
1. Search for text that matches no books.
2. Review the empty state.

Expected result: The message explains that no matching books were found and suggests changing filters.

Learner goal: Use a PR conversation comment to request clearer copy, then ask Copilot to address the comment.
'@

Ensure-Issue "Polish book card spacing and responsive layout" "ui,responsive,book-app-web" @'
Book cards should have clear hierarchy, comfortable spacing, and a useful mobile layout.

Training branch: `practice-card-polish`

Repro:
1. Open the app in the browser.
2. Resize the viewport below 560px.
3. Inspect the card spacing and status labels.

Expected result: Cards stay readable and controls remain easy to use.

Learner goal: Use browser validation or a Pick and Polish exercise to compare visual changes before accepting them.
'@

Ensure-Issue "Simulate a failing stats test for CI practice" "ci,tests,book-app-web" @'
The default app should pass tests. This scenario creates a training branch that changes favorite counting incorrectly so CI fails on the stats test.

Training branch and PR: `practice-failing-stats-check`

Expected failure: `npm test -- --run` fails in `src/tests/stats.test.tsx` because unread favorites are valid favorites too.

Learner goal: Use Copilot to inspect the failing check, explain the regression, and restore the correct favorite count.
'@

Write-Log "Ensuring practice branches..."
Ensure-Branch "practice-search-case-bug" "search-case-bug" "Seed search case practice bug"
Ensure-Branch "practice-unread-count-bug" "unread-count-bug" "Seed unread stats practice bug"
Ensure-Branch "practice-empty-state-copy" "empty-state-regression" "Seed empty-state copy practice"
Ensure-Branch "practice-card-polish" "card-polish-branch" "Seed card polish practice branch"
Ensure-Branch "practice-failing-stats-check" "failing-stats-check" "Seed failing stats check practice"
Ensure-Branch "fix-empty-state-copy" "empty-state-pr" "Draft empty-state copy PR scenario"
Ensure-Branch "feature-reading-dashboard" "reading-dashboard-note" "Draft merge-readiness PR scenario"

Write-Log "Ensuring pull requests..."
$emptyPr = Ensure-PR "fix-empty-state-copy" "Improve empty-state copy" @'
This PR updates the empty state shown when filters match no books.

Course use:
- Practice responding to a PR conversation comment.
- Ask Copilot for the smallest safe improvement.
- Inspect the diff before accepting changes.
'@

$failingPr = Ensure-PR "practice-failing-stats-check" "Failing stats check practice" @'
This PR intentionally changes stats logic so CI can demonstrate a failing check.

Expected course behavior:
- `npm test -- --run` fails in `src/tests/stats.test.tsx`.
- Learners ask Copilot to explain the failure and restore the correct favorite count.
'@

$mergePr = Ensure-PR "feature-reading-dashboard" "Reading dashboard merge-readiness practice" @'
This PR is a safe merge-readiness discussion scenario.

Course use:
- Confirm tests and build pass.
- Discuss review state and branch protection.
- Decide whether Agent Merge would be appropriate after human review.
'@

Ensure-PRComment $emptyPr "Please mention that they can change the search term, genre, or reading status." "The copy is better, but can we make it more helpful for a first-time learner? Please mention that they can change the search term, genre, or reading status."

Write-Log ""
Write-Log "Setup complete."
Write-Log "Next checks:"
Write-Log "- Open the GitHub Copilot app and connect this fork/training repository."
Write-Log "- Confirm the seeded issues and PRs appear in My work."
Write-Log "- Wait for the failing-check PR workflow to finish before using that lesson."

if (-not [string]::IsNullOrWhiteSpace($startBranch) -and -not $DryRun) {
    Invoke-External -FilePath "git" -Arguments @("switch", $startBranch) -AllowFailure -Quiet | Out-Null
}
