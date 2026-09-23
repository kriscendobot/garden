---
date: 2026-05-15T03:53:09Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--91314c
cycle: 60
---

# Scholar cycle 60: chat-spaces-inbox (2 sections; completes the chat-spaces trio)

## Ingested

`endo-but-for-bots/llm/designs/chat-spaces-inbox.md` — **Complete**
upstream, 161 lines, 2026-02-24, Kris Kowal. Upstream commit
`0ee0cbb3c7639985c971c30c2fb6f32e1944d55b` (later commit than
chat-spaces-gutter or chat-spaces-home; landed separately as the
third refinement). No prior source-index; fresh ingestion. Slug
`chat-spaces-inbox`.

The structurally interesting property: **zero new files**. The
inbox mode is pure composition of existing chat-client components
(`inboxComponent`, `bodyComponent`, `sendFormComponent`,
`resolvePowers`) with the space's `profilePath`. The deepest
application of the *client-side convention over a complete daemon
API* discipline in the chat cluster.

## Section files (2)

- `chat-spaces-inbox/mode-flow-and-power-resolution` — what `mode: 'inbox'` does (navigate, render, enable messaging); the pre-existing `inboxComponent` preserved unchanged; `resolvePowers` walks the profilePath; two integration flows (space-selection chain + messaging chain); the *zero new files* claim.
- `chat-spaces-inbox/badges-message-context-and-future` — proposed unread-count badges with the **daemon-vs-client tradeoff** explicit (a new `getUnreadCount` daemon API vs. client-side "last seen" tracking); in-space message context (send-target default; command scoping); 4 future-enhancement items, only one of which would extend the daemon API.

## Topic refreshes

- `chat-ui.md` — 2 new rows; 15 → 17.
- `agent-conventions.md` — 2 new rows for the *composition over creation* and *daemon-vs-client API tradeoff* conventions; 41 → 43.
- `topics/README.md` — counts updated.

## Master indexes

- `sources/README.md` — 1 new row.
- `sections/README.md` — new cycle-60 group; total **470 → 472**.
- `concepts/space.md` — Sections-that-touch-this-concept table extended with the 2 new sections (and the cycle-58-corrected description for the chat-spaces-home/indelible row).

## Cross-cluster cross-references woven in

- `chat-spaces-inbox/mode-flow-and-power-resolution` links to:
  - `chat-components/file-structure-and-component-map` (the components being composed)
  - `chat-components/profile-system-and-error-handling` (the profile-as-current-"I" discipline this design extends)
  - `chat-spaces-gutter/motivation-and-architecture` (the parent design that established *client-side convention over a complete daemon API*)

- `chat-spaces-inbox/badges-message-context-and-future` links to:
  - `chat-invariants/principles` (progressive disclosure shows in the send-target-default behavior)
  - `chat-components/profile-system-and-error-handling` (breadcrumbs)
  - `chat-spaces-gutter/interactions-keyboard-and-future` (the cycle-58-corrected Cmd+N numbering)

## Notable: a clean daemon-API tradeoff is named

The badge-indicators section is the first chat-cluster design that
**explicitly names the daemon-API tradeoff for a feature** — either
ship `getUnreadCount` as a new daemon API, or implement
last-seen-timestamp tracking client-side without daemon changes.
The design records both paths and defers the decision; future
builder cycles picking up the badges enhancement will need to make
the call.

This is the cleanest worked example so far of the *daemon-vs-client
boundary as a deliberate design surface*, and is added to the
agent-conventions topic page as such.

## Library state

- Sources: 106 → **107**
- Sections: 470 → **472**
- Topics: 26 (unchanged); 3 topic pages refreshed.
- Concepts: 21 (unchanged; the `space` concept page's table was extended).
- Keywords: ~211 (unchanged this cycle — the *space* aliases already cover the inbox-mode terminology).
- Roles: 3 (unchanged).

## Notes for the next cycle

- **Chat-spaces trio is complete**: gutter (cycle 56) + home (cycle 57) + inbox (cycle 60). The `space` concept page now collects 7 sections across 3 sources plus chat-components.
- **Chat backlog ~14 files** remaining. Natural next picks:
  - `chat-per-space-color-scheme.md` — extends chat-spaces-home's `scheme` field.
  - `chat-edit-message-ui.md` — would extend `token-chip` with edit-mode chip behavior.
  - `chat-markdown-render.md` — the markdown rendering pipeline.
  - `chat-test-coverage.md` — testing conventions.
- **Library-lookup caller-driven writeback** still pending. With 5 chat sources now indexed (invariants + components + 3 spaces) plus chat-command-bar, a designer dispatch designing any new chat feature would have heavy library leverage.
