---
title: Motivation, architecture, and the "no daemon changes" property
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Created 2026-02-21. References sibling design `chat-spaces-home.md` (also referenced but not yet ingested). Both this and chat-spaces-gutter live under the same upstream commit as chat-invariants and chat-components (`3b031592`) — the three were committed together when `packages/chat/DESIGN.md` was split.
---

## The friction this design solves

The Chat UI today operates in **single-profile hierarchical
drill-down** mode: start at `endo.Host`, expand the navigation pane,
select a guest or capability to navigate deeper. This works for
exploring the pet-name graph but breaks for users actively managing
**multiple AI agent project loops simultaneously**.

Each AI coding agent (Fae, etc.) is typically a guest under Host,
with its own inbox, conversations, and tool capabilities. Switching
between agents under the drill-down model requires four steps:

1. Navigate back up to Host.
2. Expand the "guests" directory.
3. Select the target guest.
4. Navigate into its inbox or relevant capability.

The design names the consequence: *"this friction discourages
context-switching and forces users to finish one agent interaction
before attending to another."*

## The solution: a spaces gutter

A **spaces gutter** is a left-edge sidebar providing one-click
access to top-level navigation targets. Properties:

- Each **space is a bookmark** into the capability graph, pre-
  configured with a profile path.
- Spaces are **persistent** (stored as values in the host's pet-
  store).
- Spaces are **orderable**.
- Spaces are **keyboard-accessible** via `Cmd+1..9` (per the
  keyboard-first navigation principle from
  [[endo-but-for-bots--llm-designs-chat-invariants--principles]]).

## Architecture

### Component style

The implementation follows the existing Chat UI patterns established
in [[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]:

- Template literals for HTML / CSS.
- Factory functions returning API objects: `createSpacesGutter({ $container, powers, onNavigate })`.
- Direct DOM manipulation.
- JSDoc types for type safety.

### "No daemon changes"

The most structurally interesting property of this design: **the
entire feature requires no new daemon APIs and no new formula
types**. Spaces ride on the existing host pet-store:

- Host's pet-store already supports arbitrary directories via
  `E(host).write(['spaces', id], value)`.
- Values can be stored directly via
  `E(host).storeValue(JSON.stringify(spaceConfig))`.

This is a worked example of the daemon's API surface being
**complete enough that a substantive UI feature is purely client-
side**. The spaces gutter could have been an extension to the daemon
(a new `spaces` formula type, a new API for listing them); instead
it's a *convention* over an existing API (`spaces` is just a pet-name
directory). The design's *"No new formula types, no new daemon APIs"*
statement is the load-bearing claim that makes this design portable
across daemon implementations and forwards-compatible without daemon
coordination.

This shape — *"the daemon API is complete; the client builds the
feature as a convention"* — is the inverse of the per-agent NETS
design ([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]),
which had to add a `networks` field to `GuestFormula` because the
daemon's existing API didn't expose the affordance. Knowing which
side a feature lands on is a daemon-vs-client API-design judgment
call; this design picks the client side and the choice is examined
worth noting.

## Layout

The gutter is positioned at the absolute left edge:

```
| gutter | #pets (sidebar) | #messages (inbox) |
| 48px   | var(--sidebar-width)                |
```

CSS variables added (extending the 13-token theme set named in
[[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]]):

- `--gutter-width: 48px` — width of the spaces gutter.
- Existing elements shifted right by `--gutter-width`.

The single-variable extension is the canonical way to add a layout
element without breaking existing component CSS — all rule sets that
position content from the left edge consume `--gutter-width`, so a
future theme can resize the gutter without touching component
stylesheets.
