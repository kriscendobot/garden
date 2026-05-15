---
title: Nine command-bar states with per-state modeline and keyboard table
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. Same upstream commit as chat-invariants and chat-components. This document is the operational unfolding of the *modeline completeness* invariant from [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — every state below maps a list of available keyboard actions to a modeline string.
---

The command bar is the chat client's primary input area. It moves
through nine distinct states; each state has a modeline showing
available actions and a keyboard table giving the precise key →
action → manual-equivalent mapping. The modeline-completeness
invariant means *every keyboard action in the state must appear in
the modeline*; the keyboard-manual parity invariant means *every
keyboard action must have a manual equivalent (or be marked
explicitly as a convenience without one)*.

## State 1: Empty (Send Mode)

**Visual:** Empty input, placeholder visible.

**Modeline:**
- `@ inspect or message` — type @ to start token entry.
- `/ commands` — type / to open command menu.
- `Space continue with @{lastRecipient}` — only if previous recipient exists.

| Key | Action | Manual equivalent |
|---|---|---|
| `@` | Begin token autocomplete | Click token button (if exists) |
| `/` | Open command menu | Click menu button |
| `Space` | Insert last recipient | N/A — convenience shortcut |

## State 2: Token Autocomplete Visible

**Visual:** Autocomplete menu showing matching pet names.

**Modeline:**
- `select reference`
- `Space chat` — complete token and continue typing message.
- `Enter inspect` — complete token and inspect the value.
- `↑↓ navigate`

| Key | Action | Manual equivalent |
|---|---|---|
| `↑` / `↓` | Navigate suggestions | Click on suggestion |
| `Space` / `Tab` | Complete token, add space, continue typing | Click suggestion |
| `Enter` | Complete token and inspect value | Double-click suggestion |
| `:` | Enter edge name mode | N/A — keyboard shortcut |
| `Escape` | Close menu | Click outside menu |
| `Backspace` | Delete character / close if at trigger | N/A |

## State 3: Token Only (Chip present, no message)

**Visual:** Single token chip in input, cursor after it.

**Modeline:**
- `Enter inspect or write message` — dual purpose based on content.
- `⌫ delete chip` — backspace removes the chip.

| Key | Action | Manual equivalent |
|---|---|---|
| `Enter` | Inspect the referenced value | Click chip |
| `Backspace` | Delete the chip | Click × on chip (if visible) |
| Any text | Begin composing message | Type directly |

## State 4: Token + Message Text

**Visual:** Token chip followed by message text.

**Modeline:**
- `Enter send`
- `@ embed reference`
- `⌫ delete chip` — backspace at chip boundary deletes it.

| Key | Action | Manual equivalent |
|---|---|---|
| `Enter` | Send message | Click Send button |
| `@` | Begin another token | N/A — keyboard shortcut |
| `Backspace` (at chip) | Delete chip | Click × on chip |

## State 5: Text Only (no token)

**Visual:** Text but no token chip.

**Modeline:**
- `@ add recipient to send` — need recipient to send.

| Key | Action | Manual equivalent |
|---|---|---|
| `@` | Begin token autocomplete | N/A |

## State 6: Command Selecting (after `/`)

**Visual:** Command menu visible with filtered options.

**Modeline:**
- `type command name`
- `Enter select`
- `Esc cancel`

| Key | Action | Manual equivalent |
|---|---|---|
| Type | Filter commands | N/A |
| `↑` / `↓` | Navigate | Hover over command |
| `Enter` / `Tab` / `Space` | Select command | Click command |
| `Escape` | Cancel, return to send | Click outside menu |

## State 7: Inline Command Form

**Visual:** Command form with labeled fields.

**Modeline** (varies by command; example for general):
- `Enter submit`
- `Tab next field`
- `Esc cancel`

| Key | Action | Manual equivalent |
|---|---|---|
| `Tab` | Next field | Click field |
| `Shift+Tab` | Previous field | Click field |
| `Enter` | Submit form | Click Execute button |
| `Escape` | Cancel command | Click × button |

## State 8: Eval Command (Inline)

**Modeline:**
- `@ add endowment`
- `Enter evaluate`
- `⌘Enter expand to editor`
- `Esc cancel`

This is the only state whose modeline shows `⌘Enter` —
demonstrating the platform-appropriate modifier-keys principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] at
the modeline layer: the displayed string is `⌘Enter` on macOS,
`Ctrl+Enter` on Windows / Linux.

## State 9: (Other inline-form variants)

Each inline command form has its own modeline. Per the design's
*Known Gaps* — *"Verify all inline command forms show appropriate
modeline hints"* — coverage is not yet complete; some inline forms
may not yet show their action set. This is a tracked gap, not a
design flaw.

## The state machine, abstractly

The states are organized as a small graph; transitions are
documented per-state by the available keystrokes. The graph's
**only entry points** are State 1 (Empty / Send Mode); every other
state is reached by exactly one keystroke (`@` → token autocomplete;
`/` → command selecting; `Space` from State 1 → State 4 via
last-recipient injection; etc.). **Every state's `Escape` returns to
a safer / simpler ancestor** — this is the escape-consistency
invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]
realized at the state-machine level.

The complete listing of states + their modelines + their keyboard
tables is itself the operational embodiment of the modeline-
completeness invariant: *if every keyboard action appears in the
modeline*, then exhaustively listing every state's keyboard actions
gives the modeline its content. This document is therefore the
*specification* of what the modeline must show in every state.
