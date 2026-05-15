---
title: Inventory panel and message-display shapes
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
---

## Inventory panel

The inventory displays named values with contextual actions per row:

- **Disclosure triangle** to expand directories.
- **Click the name** to inspect a value (opens a value modal).
- **× button** to remove (disabled for SPECIAL names).
- **SPECIAL toggle** to show / hide system names like `@self`, `@host`, `@keypair`, `@main`, `@endo`, etc.

The disclosure-triangle disclosure-row pattern, combined with the
SPECIAL toggle, gives the user a single panel that grades from
*"the names I created"* to *"the daemon's full bill of materials"*.

### Expansion behavior

Directory-like values (those with `followNameChanges`) can be
expanded:

- Click disclosure triangle to expand / collapse.
- Nested items use **wrapped powers** for correct paths — the
  sub-directory shown inside the inventory is reached through a
  Powers object whose name-resolution is scoped to that sub-tree.
- Collapse **cleans up subscriptions** — `followNameChanges` is a
  subscription; collapsing terminates it.

The wrapped-powers + subscription-cleanup discipline is what keeps
the inventory's expansion *capability-correct*: a child directory
cannot see its parent's names; collapsing prevents subscription
leaks across re-expand cycles.

## Message display

Messages in the inbox come in three kinds, each with a distinct
visual shape:

### Package messages

- **Sender chip** (`@name`).
- **Markdown-rendered content** (via `markdown-render.js`).
- **Token chips** for embedded values (clickable to inspect — the
  chip is the address of the value; clicking opens the value
  modal).

### Eval-proposal messages

- **Proposer chip**.
- **Source code** in a syntax-highlighted fence.
- **Endowments mapping** — table of `codeName ← @petName` rows
  showing what the proposed eval will be given as named bindings.
- **Action buttons**: Grant / Counter-proposal / Reject.

The endowment-mapping render is the user's *informed consent
surface* for an eval — the user can see exactly which of their
pet names will be passed into the proposed code before granting.

### Request messages

- **Description text**.
- **Resolve / Reject inputs** — the request is a deferred message
  awaiting a response; the inputs let the recipient settle it.
- **Status after settlement** — once Resolve or Reject fires, the
  request displays the outcome inline rather than re-prompting.

Across all three message kinds, **token chips embed reference
identity** — the chip is the pet-name-as-rendered surface of the
underlying formula key. Clicking inspects; dragging (where
supported per [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]'s
keyboard-manual parity invariant) initiates a multi-recipient or
multi-value flow.

## See also

- [[token-chip]] — concept page collecting chip behaviors across the chat sources; covers identity, removability, multi-chip composition, and the rendering-side vs. typed-shape distinction.
