---
title: File structure and component-responsibility map
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]; this document is the *architecture* counterpart to invariants' *interface contract*. Extracted from `packages/chat/DESIGN.md`.
---

## Package layout

```
packages/chat/
  # Core
  chat.js                          # Main entry, UI orchestrator
  main.js                          # Application bootstrap
  connection.js                    # WebSocket connection to daemon

  # UI Components (extracted from chat.js)
  inbox-component.js               # Message display with tokens
  inventory-component.js           # Pet name listing panel
  chat-bar-component.js            # Command input and execution
  value-component.js               # Value inspection modal

  # Shared utilities
  value-render.js                  # Value rendering to DOM
  time-formatters.js               # Date/time formatting
  icon-selector.js                 # Shared icon selector (emoji grid + letter tab)

  # Command system
  command-registry.js              # Command definitions and field types
  command-selector.js              # Slash command menu
  command-executor.js              # Command execution logic
  inline-command-form.js           # Dynamic form rendering

  # Autocomplete
  token-autocomplete.js            # Token chip autocomplete for send mode
  petname-path-autocomplete.js     # Single path autocomplete
  petname-paths-autocomplete.js    # Multi-path chip autocomplete

  # Eval
  inline-eval.js                   # Inline eval form
  eval-form.js                     # Modal eval editor
  counter-proposal-form.js         # Counter-proposal editor
  monaco-wrapper.js                # Monaco editor integration (inline)

  # Message components
  send-form.js                     # Message sending with tokens
  message-picker.js                # Message number selection
  markdown-render.js               # Markdown to DOM

  # Spaces
  spaces-gutter.js                 # Spaces sidebar with home config
  add-space-modal.js               # Add space dialog
  edit-space-modal.js              # Edit space dialog (showName option)
  scheme-picker.js                 # Color scheme picker

  # Other
  help-modal.js                    # Help overlay
  ref-iterator.js                  # Reference iteration
  index.css                        # Styles
  playwright.config.ts             # Playwright E2E test configuration
```

## Component responsibilities (high-level)

| Component | Responsibility |
|---|---|
| `chat.js` | Orchestrates components, manages profile navigation |
| `inbox-component.js` | Renders messages, token chips, eval proposals |
| `inventory-component.js` | Displays pet names, handles expansion |
| `chat-bar-component.js` | Command input, mode management, modeline (the modeline-completeness invariant lives here) |
| `value-component.js` | Value modal, save functionality |
| `send-form.js` | Message composition, state tracking |
| `token-autocomplete.js` | Token chip creation, autocomplete |
| `spaces-gutter.js` | Space navigation, home config, context menus |
| `icon-selector.js` | Shared emoji / letter icon selector |

## Architectural notes

The split into per-concern files (Core / UI / Utilities / Command system / Autocomplete / Eval / Message / Spaces) is the result of **extracting** components from a previously-monolithic `chat.js`. Each grouped sub-set is a *layer* — the UI layer mounts components, the command layer is a registry + selector + executor + dynamic form, the autocomplete layer has three peer modules (token / single-path / multi-path) that share conventions but no code (per the autocomplete-list-navigation invariant in
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]).

The presence of `playwright.config.ts` alongside source files indicates **E2E tests live in the same package**, not under a sibling `chat-test` package — a project-specific testing convention.

The `monaco-wrapper.js` module is a deliberate boundary: Monaco itself runs in a sandboxed iframe, and the wrapper is what crosses the boundary. The wrapper is also the only place in the package that touches non-SES-safe code, since Monaco is too large to ship under SES.
