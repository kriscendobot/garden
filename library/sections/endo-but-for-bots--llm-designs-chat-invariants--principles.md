---
title: The six design principles — aesthetic guidelines behind the invariants
source: designs/chat-invariants.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

Where the six invariants
([[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]])
are *must* rules whose violation is a bug, the six principles are
the *should* guidelines whose violation may or may not be: they are
the aesthetic shape of the interface, not its correctness contract.

### 1. Structured input over text parsing

Commands use structured form fields rather than parsing free-form
text. Each command has a defined schema with typed fields (pet-name
paths, message numbers, text). This gives:

- Clear visual affordances for each parameter.
- Field-specific autocomplete and validation.
- Reduced parsing errors and ambiguity.
- Easier keyboard navigation between fields.

The structured-input choice is the UI-side counterpart of the
daemon-side
[[producer-typed-shape-consumer-rendering]] convention — the typed
shape lives in the form fields; *parsing* is what the form
deliberately avoids.

### 2. Keyboard-first navigation

```
/      triggers command selection from any state
@      creates token references in messages and endowment fields
Tab/Space  advances between fields or completes selections
Enter      submits or inspects depending on context
Backspace  in empty fields removes chips or returns to base mode
↑↓     navigates autocomplete menus
```

### 3. Progressive disclosure

Simple operations stay simple; complexity is revealed as needed:

| Layer | Surface |
|---|---|
| Base mode | Direct message sending — `@recipient message` |
| Slash commands | Structured forms for specific operations |
| Inline eval | Quick expressions with optional endowments |
| Modal eval | Full editor for complex code (⌘Enter to expand) |

### 4. Visual feedback

| Cue | Purpose |
|---|---|
| Token chips | Named values appear as styled chips with `@` prefix |
| Path chips | Multi-value fields show completed paths as removable chips |
| Error bubbles | Positioned above the command line with a speech pointer |
| Message badges | Number indicators for message picking |
| Mode indicators | Command label shows the active command |
| Modeline hints | Contextual keyboard shortcuts (the modeline-completeness invariant feeds this) |
| Profile indicator | Shows current profile path in the header |

### 5. Contextual autocomplete

- Pet-name paths: hierarchical completion with `.` separator.
- Case-sensitive matching for precision.
- Menu positioned near input field.
- Tab / Space to accept suggestions.
- `.` to drill down into path.
- Enter to inspect (in send-mode token autocomplete).
- List navigation: ↑ ↓ by row; Home / End first / last; Page Up /
  Down by *(visible rows − 1)* so the user *sees* motion (see
  invariant 6 in the sibling section).

### 6. Platform-appropriate modifier keys

Keyboard modifiers display per-platform:

| Platform | Display |
|---|---|
| macOS | Unicode: `⌘` (Command), `⌥` (Option), `⇧` (Shift), `⌃` (Control) |
| Windows / Linux | Text abbreviations: `Ctrl`, `Alt`, `Shift` |

Example: "Cmd+Enter" displays as `⌘Enter` on Mac and `Ctrl+Enter` on
Windows / Linux. This is a small surface rule that compounds across
every modeline hint, button label, and tooltip.
