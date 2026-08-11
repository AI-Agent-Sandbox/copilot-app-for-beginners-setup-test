# Course Review Issues

This file tracks issues found during course reviews of the root README and Chapters 00-08.

## ✅ Issue 1: Course files were too text-heavy for beginners

**Severity:** Blocking

**Files:** `README.md`, `00-quick-start/README.md` through `07-putting-it-all-together/README.md`

**Problem:** The plan called for course imagery and app capture placeholders throughout the course, but the chapters only included the SVG header images. That made a desktop app course feel too text-heavy for beginners.

**Resolution:** Added PNG assets from the `visual-image` items, replaced those prompt placeholders with image references, and kept the `app-screenshot` placeholders for future app captures.

## ✅ Issue 2: Chapter template consistency drifted between Chapters 00-04 and 05-08

**Severity:** High

**Files:** `00-quick-start/README.md` through `07-putting-it-all-together/README.md`

**Problem:** The first half and second half of the course used noticeably different conventions for hook style, estimated time formatting, prerequisites headings, separators, and notes.

**Resolution:** Standardized the chapter rhythm around the template pattern: header image, H1, blockquote hook, learning objectives, bold estimated time, visual checklist, prerequisites, analogy, core concepts, hands-on examples, notes, troubleshooting, takeaways, assignment, navigation, and sources.

## ✅ Issue 3: Later chapters used top-level headings for repeated sub-sections

**Severity:** High

**Files:** later course chapter READMEs through `07-putting-it-all-together/README.md`

**Problem:** Repeated sections such as `Expected output`, `Expected result`, `How it works`, `Pause point`, `Try the comparison`, and `Why this matters` were marked as `##` headings, which made them appear as peers of the hands-on examples.

**Resolution:** Demoted those repeated supporting sections to `###` headings so they nest under the relevant hands-on example or capstone part.

## ✅ Issue 4: Chapter 03 cited the internal planning document

**Severity:** High

**File:** `03-development-workflows/README.md`

**Problem:** A learner-facing source reference linked to `.plans/course-plan.md`, which exposed internal planning notes and made the published course look unfinished.

**Resolution:** Removed the internal planning citation and left the public GitHub Copilot app, sessions, canvas, changelog, and product-blog references.

## ✅ Issue 5: Root README promised chapter imagery that chapters did not yet provide

**Severity:** Medium

**File:** `README.md`

**Problem:** The README said each chapter includes course imagery or screenshot guidance, but the chapters did not include the planned capture placeholders or image references beyond header art.

**Resolution:** Added generated visual images and planned screenshot placeholders to every chapter, so the README promise now matches the course structure.

## ✅ Issue 6: Chapters 02 and 03 used the same seeded issue too closely

**Severity:** Medium

**Files:** `02-sessions-worktrees-context/README.md`, `03-development-workflows/README.md`

**Problem:** Chapter 02 planned around the unread-count bug and Chapter 03 implemented the unread-count bug, which narrowed learner exposure to the seeded scenarios.

**Resolution:** Updated Chapter 02 to use Issue 3, the empty-state copy task, for session planning and context practice. Chapter 03 now owns the Issue 2 unread-count debugging workflow.

## ✅ Issue 7: Empty `src/test` directory could confuse sample app exploration

**Severity:** Low

**File path:** `samples/book-app-web/src/test/`

**Problem:** The sample app tests live in `src/tests`, while an empty `src/test` directory also existed.

**Resolution:** Removed the empty directory.

## ✅ Issue 8: Common beginner mistakes were not called out explicitly

**Severity:** Low

**Files:** `00-quick-start/README.md` through `07-putting-it-all-together/README.md`

**Problem:** The chapters had troubleshooting sections, but they did not consistently include beginner mistake callouts that reinforce safe habits before problems occur.

**Resolution:** Added `Common beginner mistakes` sections to all chapters.

## ✅ Issue 9: Chapter 07 asks learners to use a canvas that is only documented as a concept

**Severity:** High

**Files:** `05-canvases/README.md`, `.github/extensions/release-checklist/README.md`

**Problem:** Chapter 07 correctly starts by calling the release checklist a prepared canvas concept, but the next workflow asks learners to "use the canvas" and update checklist state. The repository currently contains a concept README, not a working canvas extension, so beginners may think something is broken or missing.

**Suggested resolution:** Either reword Chapter 07 so the release checklist is consistently framed as a concept/simulation exercise, or add a minimal working release checklist canvas extension that learners can actually open and update.

**Resolution:** Reworded Chapter 07 so the release checklist is consistently framed as a concept or simulation unless the learner's app build supports a visible project-scoped canvas. The prompts now include a markdown fallback.

## ✅ Issue 10: GitHub issue and PR workflows need a clearer setup path for self-paced learners

**Severity:** High

**Files:** `03-development-workflows/README.md`, `07-putting-it-all-together/README.md`, `samples/app-course-issues.md`, `samples/app-course-pr-scenarios.md`

**Problem:** Chapters 04 and 09 rely on seeded issues, pull requests, review comments, failing checks, and merge-readiness scenarios. The repository provides strong Markdown drafts for those scenarios, but self-paced learners are not given a clear setup path for turning those drafts into real GitHub issues, branches, PRs, comments, and CI states.

**Suggested resolution:** Add a short setup section or appendix for creating the training issues and PR scenarios, then link to it before Chapter 04 and Chapter 08.

**Resolution:** Added `appendices/training-github-scenarios.md`, linked it from the appendices index, and linked it from Chapters 04 and 09 before the GitHub issue and PR workflows.

## ✅ Issue 11: Capstone workflow image says "Merge" instead of "Merge ready"

**Severity:** Medium

**File:** `07-putting-it-all-together/assets/end-to-end-workflow.png`

**Problem:** Chapter 08 consistently teaches merge readiness, human review, and pause points before merge automation. The final step in the capstone workflow image says "Merge," which is a little stronger than the safer lesson language.

**Suggested resolution:** Regenerate or edit the image so the final step says "Merge ready" or "Merge readiness."

**Resolution:** Regenerated `07-putting-it-all-together/assets/end-to-end-workflow.png` so the final workflow step says "Merge Ready."

## ✅ Issue 12: MCP acronym is not expanded on first beginner-facing use

**Severity:** Low

**Files:** `README.md`, `04-skills-mcp-plugins/README.md`

**Problem:** The course introduces "MCP servers" before spelling out Model Context Protocol. Chapter 06 explains the concept later, but beginners should see the expanded term the first time the acronym appears.

**Suggested resolution:** Use "Model Context Protocol (MCP) servers" on first use in the root README and Chapter 06.

**Resolution:** Expanded Model Context Protocol (MCP) on first beginner-facing use in the root README, Chapter 01, Chapter 05, Chapter 06, Chapter 08, the glossary, and related appendices.

---

# Deep Content and Template Review (Round 2)

The issues below come from a deep review of the root README and Chapters 00-08 focused on: (0) matching the `copilot-cli-for-beginners` template, (1) chapter flow and readability for newcomers, (2) hands-on developer scenario coverage, (3) the `samples/book-app-web` code sample, and (4) consistency between what chapters claim and what exists in the repository.

## ✅ Issue 13: Chapters and README were missing the CLI course's frontmatter block

**Severity:** High

**Files:** `README.md`, `00-quick-start/README.md` through `07-putting-it-all-together/README.md`

**Problem:** Every `copilot-cli-for-beginners` chapter and its README begin with an HTML frontmatter comment block (`id`, `title: !translate`, `description: !translate`, `audience`, `slug`, `weight`) used by the Awesome Copilot learning hub. The App course had no frontmatter at all, so the template did not match.

**Resolution:** Added the frontmatter comment block to the root README and all nine chapters, using `id: CopilotApp-ROOT`/`CopilotApp-00..08`, `audience: Developers / Students / Desktop users`, per-chapter slugs, and `weight` values 0-9, mirroring the CLI course pattern.

## ✅ Issue 14: Headings used sentence case instead of the CLI course's Title Case

**Severity:** High

**Files:** `README.md`, `00-quick-start/README.md` through `07-putting-it-all-together/README.md`

**Problem:** The App course used sentence-case headings ("Learning objectives", "Real-world analogy", "Hands-on example", "Estimated time") while the CLI course uses Title Case ("Learning Objectives", "Real-World Analogy", "Hands-On Example", "Estimated Time").

**Resolution:** Converted every heading (and the bold "Estimated Time" label and the README top-nav link text) to Title Case across all ten files, preserving code spans and acronyms (PR, MCP, CI, UI, GitHub, Copilot). GitHub generates lowercase anchors, so internal and cross-file anchor links still resolve.

## ✅ Issue 15: 26 `app-screenshot` placeholders rendered as broken-looking text

**Severity:** Medium

**Files:** `02-sessions-worktrees-context/README.md`, `03-development-workflows/README.md`, `04-skills-mcp-plugins/README.md`, `05-canvases/README.md`, `06-automations/README.md`, `07-putting-it-all-together/README.md`

**Problem:** Capture placeholders were left as visible Markdown list items, for example `- [app-screenshot: My Work view ...]`. On GitHub these render as literal bullet text that looks unfinished or broken to a newcomer, hurting reading flow.

**Resolution:** Converted all 26 placeholders to HTML comments (`<!-- app-screenshot: ... -->`). They no longer render for learners but remain in the source as capture TODOs for the author.

## ✅ Issue 16: Chapter 01 settings list mismatched between objective and hands-on

**Severity:** Medium

**File:** `01-first-steps/README.md`

**Problem:** The learning objective listed settings areas as "General, Sessions, Projects, Skills, Voice dictation, and accessibility or keyboard shortcuts," but the hands-on tour and table listed "General, Accounts, Sessions, Themes, Accessibility, Voice dictation." Projects/Skills appeared only in the objective, and Accounts/Themes only in the hands-on.

**Resolution:** Aligned the objective to the settings areas the learner actually tours: "General, Accounts, Sessions, Themes, Accessibility, and Voice dictation." Skills/MCP/Plugins/Model providers remain in the "Additional settings" collapsible.

## ✅ Issue 17: Chapter 01 sidebar tour omitted Quick chats and used inconsistent "My work" casing

**Severity:** Low

**File:** `01-first-steps/README.md`

**Problem:** The "Tour the App" numbered list showed only My work, Automations, Search, and Sessions, even though the objective, image alt text, and Chapter 00 all reference Quick chats as a sidebar area. The list also used "My work" while the rest of the course uses the product term "My Work."

**Resolution:** Added "Quick chats" as item 5 and corrected "My work" to "My Work."

## ✅ Issue 18: Chapter 01 minor copy issues

**Severity:** Low

**File:** `01-first-steps/README.md`

**Problem:** "For the second prompts, the response may say..." used a plural where one prompt is meant, and a sample response used a curly apostrophe (`I’ll`) inconsistent with the straight apostrophes used elsewhere.

**Resolution:** Changed to "For the second prompt..." and replaced the curly apostrophe with a straight one.

## ✅ Issue 19: Chapter 01 objective "select a model and reasoning effort" was never demonstrated

**Severity:** Low

**File:** `01-first-steps/README.md`

**Problem:** A stated learning objective was to "Select a model and reasoning effort based on task complexity," but no hands-on example pointed learners at those controls; they were only mentioned later in Notes.

**Resolution:** Extended the "Compare Session Modes" example to note the model and reasoning effort dropdowns beside the mode selector, plus a tip on choosing capability to match task complexity.

## ✅ Issue 20: Troubleshooting collapsible labels were inconsistent across chapters

**Severity:** Low

**Files:** `04-skills-mcp-plugins/README.md`, `05-canvases/README.md`, `06-automations/README.md`, `07-putting-it-all-together/README.md`

**Problem:** Chapters 00-04 used descriptive `<summary>Troubleshooting: <topic></summary>` labels (matching the Intermediate:/Advanced: prefix style used for other collapsibles), while Chapters 05-08 used a generic `<summary>🔧 Troubleshooting</summary>`.

**Resolution:** Standardized Chapters 05-08 to the descriptive form (for example, "Troubleshooting: Canvas issues").

## ✅ Issue 21: Chapter 00 connect-repository step used a UI label not in its own table

**Severity:** Low

**File:** `00-quick-start/README.md`

**Problem:** The connect-repository table lists "Add local folder," "Add GitHub repository," and "Add repository URL," but the following sentence told learners to "Select `Local folder or repository...`," a fourth label that matches none of the table options and could confuse a newcomer.

**Resolution:** Verified the actual dialog against `00-quick-start/assets/add-project.webp`: it is titled **Add project from** with options **Local folder or repository**, **GitHub repository**, and **Repository URL**. Aligned both the table and the follow-up sentence to these real app labels. (An earlier pass had changed the sentence to "Add local folder" to match the table, but the table itself did not match the app; the labels above are the screenshot-verified source of truth.)

## ✅ Issue 22: Chapter 02 slash-command "Confirmed" claims — verified against changelog, README, and docs

**Severity:** Low (verification)

**File:** `02-sessions-worktrees-context/README.md`

**Problem:** The slash-command reference table asserts that many commands are "Confirmed in the app changelog" or "Confirmed in GitHub Docs." Those claims needed checking against authoritative sources.

**Resolution:** Verified every claim against the public `github/app` `changelog.md`, the `github/app` README, and GitHub Docs (`agent-sessions`). All claims hold up, so no wording changes were needed:

- `/agent` — confirmed (changelog v0.2.32 "Use the /agent slash command ... to select a custom agent"; v1.0.2 "User, plugin, and remote agents are now shown in the /agent command ... not just project-scoped agents").
- `/chronicle` — confirmed (GitHub Docs "Using `/chronicle` with app sessions," including `/chronicle standup`; changelog v0.2.9).
- `/context` — confirmed (changelog v0.2.33 "/context opens the session usage summary (token count, context window, and AI credit spend)").
- `/usage` — confirmed (changelog v0.2.33 "/usage opens your plan's usage and rate limits").
- `/rubber-duck` — confirmed (GitHub Docs "Using the rubber duck agent"; changelog v0.2.14 "via the /rubber-duck slash command").
- `/orchestrate` — confirmed (changelog v0.2.33 "Added a /orchestrate composer command for coordinating multi-session and multi-repo work").
- `/skills` — confirmed (changelog v0.2.2 lists `/skills` among command-palette enum-argument slash commands; v0.2.3/v0.2.4 add skill `/skill-name` invocation).
- `/collect-debug-logs` — confirmed (README "Logs from the `/collect-debug-logs` command"; changelog v0.2.2).
- `/agent-merge` — confirmed (changelog v0.2.8 "The /agent-merge slash command now correctly enables the agent-merge loop").
- `/remote` — confirmed (changelog v0.2.2 lists `/remote` among command-palette slash commands).
- `/create-canvas` — the course hedges this appropriately ("available when canvas-authoring capabilities are installed or exposed"); canvases are a confirmed feature and the course does not over-claim a changelog confirmation.

(CLI-only commands the course steers away from — `/review`, `/plan`, `/model`, `/pr`, `/diff` — are being cross-checked by a separate web/CLI research pass.)

**Follow-up after the broader web/docs research pass:** The research pass corroborated every command above with the same sources, and confirmed `/review`, `/plan`, `/model`, `/pr`, and `/diff` are all real Copilot CLI slash commands (the app intentionally exposes equivalent UI surfaces instead, so steering learners to the UI is correct). It found exactly one inaccuracy, now fixed: the `/create-canvas` row previously read "Available when canvas-authoring capabilities are installed or exposed in the app," but GitHub Docs present `/create-canvas` as a built-in skill available to all app users (canvases are GA and enabled by default). The row now reads "Confirmed in GitHub Docs as a built-in skill for creating a canvas from a session." Optional, applied: Chapter 08 now lists the full `/chronicle` subcommand set (`standup`, `tips`, `cost tips`, `search`, `improve`, `reindex`) alongside the standup and cost-tips examples.

**Follow-up (common-commands table alignment):** Per author decision, `/research` and `/review` are kept in the Chapter 02 "common slash commands you might use" table and were also added to the verified reference table above so the two tables stay consistent. Note: the CLI research classified `/review` as a CLI-only command with an app UI equivalent; re-verify `/review` (and `/research`) as app slash commands before publishing, since this differs from that earlier assessment.

## ✅ Issue 23: Chapter header images are SVG while the CLI course uses PNG

**Severity:** Low

**Files:** `00-quick-start/assets/chapter-header.svg` through `07-putting-it-all-together/assets/chapter-header.svg`

**Problem:** The CLI course uses `assets/chapter-header.png` for each chapter header; the App course uses `chapter-header.svg`. The SVGs render correctly on GitHub, but it is one remaining difference from the CLI template.

**Resolution:** Confirmed with the author that SVG is intentional for the App course, so the headers are left as SVG. Recorded as a repository convention so future template-matching does not convert them to PNG.

## Issue 24: App screenshots still need to be captured before publishing

**Severity:** Low (pending task, not a defect)

**Files:** Chapters 02-08 (26 `<!-- app-screenshot: ... -->` comments)

**Problem:** The course relies heavily on the app UI as the learning surface, but 26 planned app screenshots are still unfilled (now tracked as HTML comments). The visuals are described in each comment and in `.plans/course-plan.md`.

**Suggested resolution:** Capture the screenshots from a sanitized training account per `appendices/screenshot-capture-guide.md`, then replace each comment with an image reference.

## ✅ Issue 25: No explicit refactoring hands-on scenario in Chapter 03

**Severity:** Low (enhancement)

**File:** `03-development-workflows/README.md`

**Problem:** The course plan lists "refactor" among development workflows, and the CLI course has a dedicated refactoring workflow. Chapter 03 covered review, debug/fix, tests, rubber duck, and Pick and Polish, but not an explicit refactor-with-tests example.

**Resolution:** Added "Hands-On Workflow 4: Refactor Safely with Tests" (an extract-function refactor of `filterBooks` in `App.tsx` that runs tests before and after to prove behavior is unchanged), renumbered Rubber Duck Review to Workflow 5, added a matching learning objective ("Refactor code safely using tests as a guardrail") and a key takeaway.

## ✅ Issue 26: Chapter 02 learning objective "decide local repo vs worktrees" is never taught (and its image is orphaned)

**Severity:** Medium

**Files:** `02-sessions-worktrees-context/README.md`, `02-sessions-worktrees-context/assets/session-run-location-comparison.webp`

**Problem:** Chapter 02 lists the learning objective "Decide between working directly with a local repository or using worktrees" (line 26), but no section, table, or exercise in the chapter actually covers that decision. The only chapter mentions of "local" / "directly" (lines 119, 228) are unrelated. Separately, the asset `assets/session-run-location-comparison.webp` exists but is never referenced in the README, the only unused image across Chapters 00-02. The image's name ("session run location comparison") strongly suggests it was generated to support exactly this missing objective. A learner who reads the objective will expect guidance on when to run directly in their clone versus in a worktree-backed session and never receives it.

**Resolution:** Added a new "Where a Session Runs" Core Concepts subsection grounded in the composer's **Workspace** selector (confirmed as `AXPopUpButton Workspace: Local` in the app-ui-map reference). It includes a three-row table (Local repo / New worktree / Cloud sandbox) matching the previously orphaned `session-run-location-comparison.webp`, which is now embedded, plus a "when in doubt, use a worktree" tip. Expanded the learning objective to name all three run locations and added a matching Key Takeaway.

## ✅ Issue 27: Chapter 00 fork link points to a repository that returns 404

**Severity:** Medium

**File:** `00-quick-start/README.md`

**Problem:** The `[course-repository]` reference link resolves to `https://github.com/github/copilot-app-for-beginners` (line 293). That URL currently returns **404**, while the working repository is `https://github.com/DanWahlin/copilot-app-for-beginners` (HTTP 200, confirmed via `git remote -v`). The link is used in the very first hands-on setup steps: the Prerequisites bullet "A fork of the [course repository]" (line 37) and the "Fork this [course's repository on GitHub]" instruction (line 110). A beginner who clicks it on day one lands on a 404 and cannot fork.

**Resolution:** Author confirmed the live repository is canonical. Updated `[course-repository]` to `https://github.com/DanWahlin/copilot-app-for-beginners` (verified HTTP 200). This was the only `github/copilot-app-for-beginners` reference in the course, so all fork/clone cross-references now resolve.

## ✅ Issue 28: Chapter 01 voice dictation cites a Copilot CLI doc, not an app doc

**Severity:** Low

**File:** `01-first-steps/README.md`

**Problem:** Exercise 5 teaches the app's **Voice dictation** feature, but the Source References `[voice-input]` link points to `https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input` (line 358), which is the Copilot **CLI** documentation path. The link resolves (HTTP 200) but documents a different surface than the one the chapter teaches, which can confuse a learner who follows it expecting app guidance.

**Resolution:** Verified via web research that no GitHub Copilot app-specific voice/dictation doc exists yet; the desktop app is built on the Copilot CLI, and the CLI voice-input page is the only official reference. Kept the valid link but relabeled the citation to "Voice input documentation (Copilot CLI, which the app is built on)" so learners know what they are opening.

## ✅ Issue 29: Chapter 02 "Start from an Issue" reuses the branch screenshot

**Severity:** Low

**File:** `02-sessions-worktrees-context/README.md`

**Problem:** Exercise 3 ("Start from an Issue") embeds `assets/app-create-from-icon.webp` with alt text "Open Issue in Copilot App" (line 236). That is the same screenshot used earlier for the branch-based step (line 139, alt "Create from branch"). The steps tell the learner to open the **Issues** tab and "Select Issue #3 from the list," but the reused image shows the Create-from icon, not the Issues tab or the issue list, so the visual does not match the instructions a beginner is trying to follow.

**Resolution:** Replaced the misleading reused image with an `<!-- app-screenshot: ... -->` placeholder describing the Create-from dialog's Issues tab with Issue #3 selectable, matching the repo's pending-screenshot convention (Issue 24). The accurate capture is now tracked alongside the other planned app screenshots.

## ✅ Issue 30: Minor copy and grammar nits in Chapters 00 and 02

**Severity:** Low

**Files:** `00-quick-start/README.md`, `02-sessions-worktrees-context/README.md`

**Problem:** A few small wording issues a careful learner notices:

- `00-quick-start/README.md` line 96: "navigation areas such as Home, My work, Automations, Search, and Sessions, and Quick chats" has a doubled "and" and reads awkwardly; it also lists the surfaces in a slightly different grouping than Chapter 01's sidebar order.
- `02-sessions-worktrees-context/README.md` line 137: "selecting the projects' `Create from` icon" uses the plural possessive "projects'" where the singular "project's" is intended.

**Resolution:** Reworded line 96 to a single clean list ("Home, My work, Automations, Search, Sessions, and Quick chats") and changed "projects'" to "project's" on line 137.

## ✅ Issue 31: Chapters 05-08 drifted to lowercase "Copilot app" for the product name

**Severity:** Medium (consistency)

**Files:** `04-skills-mcp-plugins/README.md`, `05-canvases/README.md`, `06-automations/README.md`, `07-putting-it-all-together/README.md`

**Problem:** The deep review of Chapters 03-08 (the line-by-line pass that Chapters 00-02 got via Issues 16-30 but 03-08 had not) found the product name written inconsistently. The root `README.md` (15 uses, 0 lowercase) and Chapters 00-04 always write "GitHub Copilot **App**" with a capital A, but Chapters 05-08 used lowercase "Copilot app" 18 times across prose, an analogy table, and Source Reference link labels (for example `05` line 41, `06` line 39, `07` line 38, `08` lines 53/55/427). A learner reading straight through sees the app's name change casing mid-course.

**Resolution:** Normalized all 18 prose/label occurrences to "GitHub Copilot app" to match the root README and Chapters 00-04. Verified the change touched only visible text: every documentation URL still uses the lowercase `github-copilot-app` path (a 20-insertion/20-deletion casing-only diff), and all external links in these chapters return HTTP 200.

## ✅ Issue 32: Chapter 07 referred to a hands-on step as "Hands-on example 3" instead of "Exercise 3"

**Severity:** Low (consistency)

**File:** `06-automations/README.md`

**Problem:** Chapter 07 (line 99) told learners to "skip to the local validation reminder in Hands-on example 3," but the established in-text convention (Chapter 03 lines 153, 188, 295) refers to numbered hands-on steps as "Exercise N." The mismatched label makes the cross-reference read like it points to a different section.

**Resolution:** Changed "Hands-on example 3" to "Exercise 3" to match the Chapter 03 cross-reference convention.

## Issue 33: Chapter 03 still contains three "MANUAL STEP TO VERIFY" author notes

**Severity:** Low (pending task, not a defect)

**File:** `03-development-workflows/README.md` (lines 202, 236, 360)

**Problem:** Three `<!-- MANUAL STEP TO VERIFY: ... -->` comments remain in the shipping content. They flag app affordances the author must confirm in the live app before publishing: the exact control that approves/applies Copilot's edits in Interactive mode (a "Keep" or "Approve" action), and how to open the integrated browser/preview. These require in-app verification and cannot be confirmed from the CLI.

**Suggested resolution:** Verify each affordance in the current GitHub Copilot app build, update the surrounding step wording if the labels differ, capture the paired screenshot, and remove the `MANUAL STEP TO VERIFY` comment. These pair with the pending app screenshots tracked in Issue 24.

## Positive highlights

- Hands-on examples cover a strong, realistic range of developer scenarios: setup, Quick chat, sessions/modes, focused context, issue-driven sessions, worktree inspection, `/chronicle` and `/context`, code review, debug-and-fix, test generation, rubber duck, Pick and Polish, My Work, PR creation/review, responding to review comments, fixing failing checks, Agent Merge, repo-local skills, canvases, automations, and an end-to-end capstone.
- Chapter-to-repository consistency is excellent: the `book-app-reviewer` skill, `.github/extensions/release-checklist` concept, `.github/copilot-instructions.md`, the `Book app web` CI workflow, the `appendices/training-github-scenarios.md` guide, the seeded issues/PR scenarios, and every practice branch referenced in the chapters all exist, and the setup script creates them.
- The `samples/book-app-web` sample is solid and appropriately simple: clean React/TypeScript/Vite/Vitest, pure testable `filterBooks`/`getReadingStats` functions, accessible labels and regions, a responsive stylesheet, and 12 seed books whose read/unread/favorite counts match the tests.
- No em-dashes were found anywhere in the course Markdown.

## Open questions

Prior questions remain resolved:

- **Chapter header image format (Issue 23):** SVG is intentional for the App course (author confirmed).
- **Slash-command claims (Issue 22):** All Chapter 02 slash-command claims were verified against the `github/app` changelog, the `github/app` README, and GitHub Docs. They are accurate.

New questions from the Chapters 00-02 review:

- **Canonical fork URL (Issue 27):** Resolved. Author confirmed the live `DanWahlin/copilot-app-for-beginners` repo is canonical; the link now points there and resolves.
- **App voice documentation (Issue 28):** Resolved. No app-specific voice doc exists yet; the CLI voice-input page is the official reference and the citation is now labeled accordingly.
