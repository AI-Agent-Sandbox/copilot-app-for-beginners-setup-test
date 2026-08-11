# Screenshot Capture Guide

Screenshots are part of the learning experience for this course. They help beginners connect app concepts to visible UI, but they must be captured safely.

## Capture goals

Every app screenshot should be:

- useful for a specific lesson,
- readable at course size,
- free of private or identifying information,
- tied to the app version, operating system, and sample repo commit used,
- saved in a durable image format.

## Privacy-safe workflow

1. Use a clean training account when possible.
2. Use the course sample repository, not a private customer or work repository.
3. Close unrelated apps and browser tabs.
4. Hide or crop personal account names, avatars, email addresses, private repo names, organization names, tokens, provider keys, and internal URLs.
5. Capture only the app window or the specific visible area needed.
6. Review the image at full size before saving it.
7. Save the source screenshot as PNG.
8. Export an optimized WebP copy for web delivery when the course page uses it.
9. Record the screenshot in the manifest.

## Visible-window limitation

Normal screenshot tools capture visible pixels. They do not capture hidden sessions, covered windows, collapsed panels, background terminal output, or content outside the visible scroll area.

Before capturing:

- bring the Copilot App window to the front,
- expand the panel or canvas you'd like to show,
- scroll to the relevant content,
- make sure no sensitive popover or notification is visible,
- avoid relying on background work that is not visible in the frame.

If a workflow needs multiple states, capture separate screenshots rather than one crowded image.

## Required formats

Store source screenshots as PNG:

```text
CHAPTER/assets/app-screenshot-short-description.png
```

Export optimized WebP copies for published web pages:

```text
CHAPTER/assets/app-screenshot-short-description.webp
```

Use PNG for source quality and WebP for faster delivery. Keep filenames lowercase, descriptive, and stable.

## Suggested naming

| Asset type | Pattern |
|---|---|
| App screenshot PNG | `CHAPTER/assets/app-screenshot-short-description.png` |
| App screenshot WebP | `CHAPTER/assets/app-screenshot-short-description.webp` |
| Conceptual visual PNG | `CHAPTER/assets/visual-short-description.png` |
| Conceptual visual WebP | `CHAPTER/assets/visual-short-description.webp` |
| Demo GIF | `CHAPTER/assets/demo-short-description.gif` |

Examples:

```text
02-sessions-worktrees-context/assets/app-screenshot-session-worktree-path.png
03-development-workflows/assets/app-screenshot-browser-preview.png
03-development-workflows/assets/app-screenshot-pr-failing-check.png
```

## Screenshot manifest

Record screenshot batches in `assets/screenshot-manifest.md`. Create that file the first time you capture screenshots if it does not exist yet.

Each batch should include:

- capture date,
- app version,
- operating system and version,
- sample repository commit,
- chapter or appendix,
- screenshot filenames,
- account type, such as training account or sanitized account,
- notes about redaction or cropping.

Suggested entry:

```markdown
## 2026-06-21, Chapter 02 worktree screenshots

- App version: GitHub Copilot app 1.x.x
- OS: macOS 15.x
- Repository commit: abc1234
- Account: training account
- Files:
  - 02-sessions-worktrees-context/assets/app-screenshot-session-worktree-path.png
  - 02-sessions-worktrees-context/assets/app-screenshot-session-worktree-path.webp
- Redaction notes: cropped account menu and private path prefix
```

## Chapter-specific guidance

- Chapter 00: Hide sign-in details, account names, and private repository lists.
- Chapter 01: Hide model provider credentials and account settings.
- Chapter 02: Show branch and worktree concepts, but crop personal home folder paths if needed.
- Chapter 03: Show terminal, browser, and diff evidence without secrets or unrelated file paths, and use safe training issues and PRs only.
- Chapter 01: Never show tokens, provider keys, private endpoints, or organization-only policies in settings screenshots.
- Chapter 04: Show skills, Model Context Protocol (MCP) servers, plugins, and agents only with safe names and no credentials.
- Chapter 05: Treat canvas content as publishable course content. Remove private notes first.
- Chapter 06: Hide repository secrets, cloud configuration, billing details, and organization settings.

## Final review checklist

Before publishing a screenshot, confirm:

- no personal account name, avatar, or email is visible,
- no private repository or organization name is visible,
- no token, secret, key, or provider credential is visible,
- no customer data or internal project detail is visible,
- the image is readable at the size used in the chapter,
- the PNG source and WebP copy are stored in the correct chapter asset folder,
- the manifest entry includes app version, OS, and commit.

Related appendix: [Privacy-Safe Course Assets](privacy-safe-course-assets.md).
