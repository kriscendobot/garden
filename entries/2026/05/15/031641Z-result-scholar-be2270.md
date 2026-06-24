---
date: 2026-05-15T03:16:41Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--925995
cycle: 59
---

# Scholar cycle 59: chat-command-bar (4 sections; biggest chat ingest yet)

## Ingested

`endo-but-for-bots/llm/designs/chat-command-bar.md` — **Complete**
upstream, **255 lines** (largest chat design so far). Upstream
commit `3b031592e5f97a86e317cb96f1b7c44abb4e41f9` — same as
chat-invariants, chat-components, and chat-spaces-gutter (all four
extracted together when `packages/chat/DESIGN.md` was split).

Slug `chat-command-bar`. The *operational unfolding* of the
chat-invariants' *modeline completeness* and *keyboard-manual
parity* invariants — converts the abstract rules into a state-by-
state, key-by-key specification.

## Section files (4)

- `chat-command-bar/command-bar-states-and-modeline` — 9 distinct command-bar states (Empty/Send, Token Autocomplete Visible, Token Only, Token + Message Text, Text Only, Command Selecting, Inline Command Form, Eval Command Inline, per-command variants). Each state lists modeline + keyboard table + manual-equivalent column.
- `chat-command-bar/value-modal-and-states` — value-modal title rendering along two axes (has-ID/has-pet-names × has-message-context/ephemeral) giving 4 shapes; both axes can apply simultaneously. 4 modal actions; `Enter Profile` is the lone keyboard-manual parity gap.
- `chat-command-bar/field-types-and-autocomplete-mechanics` — 8 typed field types (`petNamePath`, `petNamePaths`, `messageNumber`, `text`, `edgeName`, `locator`, `source`, `endowments`); single-path `.`-drilling; multi-path chip-composition with distinct `.` (drill) vs `Space` (fresh) grammars.
- `chat-command-bar/command-categories-and-known-gaps` — 9 command categories with Unix-shell aliases; *inline-hints-complement-modeline* discipline (two surfaces, disjoint scopes, union = full coverage); 3 categories of known gaps distinguishing deliberate exceptions from unimplemented affordances.

## Topic refreshes (3 pages)

- `chat-ui.md` — 4 new chat-command-bar rows; 11 → 15. Also updated the chat-spaces-home/indelible row description (cycle-58 follow-through to remove the "corrected numbering" framing that was incorrect).
- `agent-conventions.md` — 4 new rows for the per-section design conventions (state-machine documentation, inline-hints discipline, typed-input vocabulary, plus the existing per-concern layout); 38 → 41.
- `topics/README.md` — counts updated; bundles row already accurate.

## Master indexes

- `sources/README.md` — 1 new row; also updated chat-spaces-home's row to reflect cycle-58's "aspirational not corrective" finding.
- `sections/README.md` — new cycle-59 group; total **466 → 470**.

## Cross-cluster cross-references woven in

The chat-command-bar sections explicitly link to:

- **[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]** — multiple times; this design is the invariants' operational counterpart.
- **[[token-chip]]** — chip composition in multi-path autocomplete is the same concept applied to inputs.
- **[[producer-typed-shape-consumer-rendering]]** — the 8 field types are an instance of typed-shape applied to UI input.
- **[[pass-invariant-handle-equality]]** — the value-modal title-bar pattern is its display-layer counterpart.
- **[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]** and **[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]** — the Agents and Connections command categories surface the daemon-side per-agent identity work.

This is the densest set of daemon-cluster ↔ chat-cluster cross-links so far.

## Library state

- Sources: 105 → **106**
- Sections: 466 → **470**
- Topics: 26 (unchanged); 3 topic pages refreshed.
- Concepts: 21 (unchanged).
- Keywords: ~211 (unchanged — no new ones this cycle; the design's vocabulary is mostly already covered).
- Roles: 3 (unchanged).

## Notes for the next cycle

- **Chat backlog ~15 files**. Natural next picks:
  - `chat-edit-message-ui.md` — would extend the `token-chip` concept with edit-mode chip behavior.
  - `chat-spaces-inbox.md` — third in the spaces family; would extend the `space` concept with per-space inbox behavior.
  - `chat-per-space-color-scheme.md` — covers the scheme-picker territory; complements `chat-spaces-home`'s scheme field.
  - `chat-markdown-render.md` — the markdown rendering pipeline; standalone but referenced by chat-components.
- **The cycle-58 *notice/investigate/propose* discipline** is now formalized via the gardener missive. Future cycles that surface inconsistencies between sources and source-code (or between sibling source documents) should follow the three-step procedure: notice → investigate against source → draft a PR proposal via boatman.
- **Library-lookup caller-driven writeback** still pending; the chat cluster is now substantial enough (4 sources, 15 sections) that a designer dispatch using `library-lookup` against any chat term would be likely to exercise the writeback for the first time.
