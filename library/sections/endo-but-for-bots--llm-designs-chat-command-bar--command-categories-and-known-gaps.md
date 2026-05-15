---
title: Nine command categories, inline-hints discipline, and the known-gaps list
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## Nine command categories

| Category | Commands | What it covers |
|---|---|---|
| **Messaging** | request, dismiss, adopt, resolve, reject | Peer communication |
| **Execution** | js (eval) | JavaScript evaluation |
| **Storage** | list (ls), show, remove (rm), move (mv), copy (cp), mkdir | Inventory management |
| **Connections** | invite, accept | Peer connections |
| **Workers** | spawn | Worker management |
| **Agents** | mkhost (host), mkguest (guest) | Profile creation |
| **Profile** | enter, exit | Profile navigation |
| **Bundles** | mkbundle, mkplugin | Module instantiation |
| **System** | cancel, help | System operations |

Parentheses indicate aliases (`list` ≡ `ls`, `remove` ≡ `rm`, etc.) —
the design preserves both Unix-shell-familiar short forms and the
spelled-out long forms.

The **Profile** category (`/enter`, `/exit`) is the chat-bar
counterpart of the breadcrumb navigation discussed in
[[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]];
either surface gets the user to the same agent perspective.

The **Agents** and **Connections** categories together (`mkhost`,
`mkguest`, `invite`, `accept`) cover everything a user needs to do
to bring up a new identity and connect it to a peer — the user-
facing analogue of the daemon's per-agent keypair and per-agent
NETS work covered in
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] and
[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]].

The **Execution** category's single command (`js`) opens the
eval-proposal flow that
[[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]]'s
*Eval-proposal messages* describes — Grant / Counter-proposal /
Reject buttons appear in the recipient's inbox.

## Inline hints — complement, not duplicate, the modeline

The modeline at the bottom of the chat bar shows the **overall
command-bar state**. Autocomplete dropdown menus contain their own
**inline hints** specific to menu navigation:

| Autocomplete | Inline hint |
|---|---|
| Token autocomplete | `↑↓ navigate · Tab/Enter select · : add label · Esc cancel` |
| Pet name path autocomplete | `↑↓ navigate · Tab select · . drill down · Esc cancel` |
| Pet name paths autocomplete | `↑↓ navigate · . drill down · Space add · Enter submit · Esc cancel` |

> *These inline hints complement, rather than duplicate, the
> modeline.*

The discipline is two-layered:

- **Modeline (bottom of chat bar):** what the *whole command bar*
  is doing.
- **Inline hint (inside dropdown menu):** what *the menu* is doing.

Both are visible simultaneously; together they cover every
keystroke the user can use. This is the modeline-completeness
invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]
factored across two surfaces: each surface covers its own scope,
and the union covers everything.

## Known gaps — the design's own punch list

The design records three gaps under three headings:

### Modeline gaps

- Verify all inline command forms show appropriate modeline hints.
- Verify eval form modeline is complete.

These are *coverage* gaps — the modeline-completeness invariant
holds for the states documented above, but inline command forms
(State 7 in
[[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]])
have per-command modelines that each need an audit. Tracked, not
yet done.

### Keyboard-manual parity gaps

- `Space` to insert last recipient has **no manual equivalent** (acceptable convenience).
- Edge name entry (`:`) has **no manual equivalent**.

Both are deliberate exceptions to the keyboard-manual parity
invariant, recorded as such. The design acknowledges them; they
are not bugs.

### Other

- Command history (up / down arrow) **not yet implemented**.
- Chip × button **not always visible for deletion** — keyboard fallback works (Backspace at chip boundary), but the manual-equivalent affordance is incomplete.

## Where this design sits relative to its siblings

Among the cycle-54-57 chat ingests, this design is the most
**operationally specified** — it converts the chat-invariants'
abstract *"modeline completeness"* + *"keyboard-manual parity"*
invariants into a concrete state-by-state, key-by-key spec. The
chat-components design covers package-level structure; chat-spaces-
gutter and chat-spaces-home cover the spaces affordance specifically;
this design covers *what happens when the user types*.

If a future builder dispatch implements a new command or refactors
the autocomplete machinery, this section is the load-bearing
specification — every state needs its modeline; every keyboard
action needs its manual equivalent (or an explicit acknowledged
exception).
