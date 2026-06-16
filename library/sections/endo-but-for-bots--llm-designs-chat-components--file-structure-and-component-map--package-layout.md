---
title: Package layout
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]; this document is the *architecture* counterpart to invariants' *interface contract*. Extracted from `packages/chat/DESIGN.md`.
parent: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map
---

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
