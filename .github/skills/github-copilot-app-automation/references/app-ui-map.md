# GitHub Copilot app UI Map

- app_version: 1.0.4
- captured: 2026-06-22 (macOS, Home screen)
- privacy: project names, session names, pull request titles, and the account name
  are redacted to `<placeholder>`. Regenerate with
  [map-app.sh](../sample_codes/macos-accessibility/map-app.sh) from a sanitized
  account, then re-redact before committing.

A factual reference for grounding course steps and screenshots in the app's real
UI. Menus are always mappable; window controls below were captured with the Home
screen visible on the active Space. Re-run `map-app.sh` after an app update and
diff against this file.

## Menus

- **GitHub Copilot**: About GitHub Copilot · Settings… · Check for Updates… · Services · Hide… · Quit
- **File**: New Session · New Session from Recent · New Chat · Open URL From Clipboard · Create from Local Folder or Repository · Create from GitHub · Create from URL · Close Window
- **Edit**: Undo · Redo · Cut · Copy · Paste · Select All · Writing Tools · AutoFill · Start Dictation… · Emoji & Symbols
- **View**: Toggle Sidebar · Toggle Review Panel · Toggle Terminal · Open Search · Reload · Back · Forward · Actual Size · Zoom In · Zoom Out · Enter Full Screen
- **Window**: New Window · Minimize · Zoom · Bring All to Front
- **Help**: Documentation · Keyboard Shortcuts · What's New · Manage Copilot Subscription · Automations · MCP Servers · Skills · Share Feedback · Run Health Check · Show Home Tips Again · Credits

## Sidebar (navigation)

- Toggle sidebar (checkbox) · Go back · Go forward · Resize sidebar
- **Quick links**: Home · My work · Automations · Search
- **Sessions**: "Change how sessions are grouped" · "Create new project or session"
  - Quick chats (+ "New chat in Quick chats")
  - One row per connected project: `<project-name>`, each with
    "Create project from pull requests, branches, or issues in `<project-name>`"
    and "New session in `<project-name>`"
- **User profile and settings** (bottom): "Open user menu for `<user>`" · Share feedback · Settings

## Session composer (Home / new session)

- AXTextArea **Message** — placeholder: "Ask anything, paste a URL, type / for commands or # to reference issues…"
- AXPopUpButton **Add files or folders**
- AXPopUpButton **Mode: Interactive** (session mode selector)
- AXComboBox **Select model** (e.g., "GPT-5.5")
- AXPopUpButton **Reasoning effort: High**
- AXButton **Start voice recording**
- AXComboBox **Project: `<project-name>`**
- AXPopUpButton **Workspace: Local**
- AXComboBox **Branch: main**
- AXPopUpButton **Add project**

## Home content cards

- **Up next**: "Recently updated pull requests and issues across your connected repos." · View all · (rows: `<repo>#<n>: <title>`)
- **Extend your experience**: Read documentation
- **Run recurring automations**: Browse templates · Create automation
- **Turn issues into pull requests**: Open inbox
- **What's new**: latest release notes · Check for updates · Read changelog
- Footer: "GitHub Copilot uses AI. Check for mistakes."

## Window chrome

- Close · Minimize · Enter Full Screen · Notifications

## Notes for the course

- The composer exposes Mode, Select model, and Reasoning effort controls directly
  (grounds Chapter 01's model/reasoning guidance).
- The File menu's "Create from Local Folder or Repository / GitHub / URL" matches
  Chapter 00's connect-the-repository options.
- "My work", "Automations", "Search", and "Quick chats" are top-level sidebar
  destinations (grounds Chapter 01's tour).
