---
date: 2026-05-15T02:32:03Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--b2fdc0
cycle: 57
---

# Scholar cycle 57: chat-spaces-home (2 sections + new `space` concept page; corrects gutter numbering)

## Ingested

`endo-but-for-bots/llm/designs/chat-spaces-home.md` — **Complete**
upstream, 140 lines, 2026-03-02, Kris Kowal. Sibling refinement of
`chat-spaces-gutter.md` (cycle 56). Upstream commit
`7f5671c6114a0100d8cc51064f9f68acf5a00ffb` — note this is a **later
commit** than the chat-spaces-gutter ingestion (`3b031592`), which
shows the design landed after the gutter and corrects its
numbering. No prior source-index; fresh ingestion. Slug
`chat-spaces-home`.

## Section files (2)

- `chat-spaces-home/indelible-space-zero-and-numbering` — 4 indelible invariants (always first, always named "Home", always root-bound, cannot delete) + 2 configurable fields (icon, scheme); `HOME_SPACE_DEFAULTS`; merge-on-load + normalize-on-save (the *belt-and-suspenders discipline*); corrected numbering scheme `spaces/N` ↔ `Cmd+N` for N = 0..9 with Home at 0.
- `chat-spaces-home/context-menu-scope-modal-reuse-and-shared-affordances` — four reusable patterns: `data-menu-scope` attribute on menu items; `showName`-parameterized modal reuse (one factory, two configurations); shared `icon-selector.js` extraction; watcher specialization that resets-zero-to-defaults rather than deletes.

## New concept page: `space`

Per the threshold set at cycle 56 followup ("after chat-spaces-home
lands, a space concept page becomes warranted"). The concept page
collects all 6 chat-spaces sections under one entry point — three
from chat-spaces-gutter, two from chat-spaces-home, and one from
chat-components/file-structure-and-component-map.

The concept page also carries an explicit **Common confusions**
block flagging two known misreadings:

1. *"Home is space 1"* — only in the earlier chat-spaces-gutter description; the corrected numbering is **home = space 0 = Cmd+0**.
2. *"Spaces are stored in the daemon"* — partially. Storage is in the host's pet-store; the *concept of a space* is purely client-side.

This is the **third concept page born from inter-source patterns** (after token-chip from cycles 54-55 and permits-buckets from cycles 41+51), confirming the concept-axis pattern: a concept page emerges when 2-3 sources independently use the same term distinctively.

## Inter-source correction (consolidation work)

The chat-spaces-gutter design says "Home space is always first (Cmd+1)"
and its keyboard handler dispatches `Cmd+1..9` to `sortedSpaces[num - 1]`.
The chat-spaces-home design moves Home to `spaces/0` / **Cmd+0** with
user spaces at `spaces/1..9` / **Cmd+1..9**. This is a genuine
*correction*, not a re-framing.

Corrective See-also added to
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future]]
pointing forward to chat-spaces-home, with the explicit note: *"the
keyboard handler shown above (`Cmd+1..9` → `sortedSpaces[num - 1]`)
is out of date — the corrected mapping per chat-spaces-home is
Cmd+N → position N for N = 0..9."*

This is the same shape as the cycle-53 corrective See-also on
ntsep/compatibility-and-upgrade (Syrup record field positionality):
the older section's text faithfully captures its design's claim,
while the new concept page or section corrects the claim — the
See-also is the disambiguation surface for the next reader.

## Topic refreshes (3 pages)

- `chat-ui.md` — 2 new rows; 9 → 11.
- `agent-conventions.md` — 2 new rows (the belt-and-suspenders discipline + the declarative-scope-attribute discipline); 36 → 38.
- `patterns.md` — 1 new row (the four-reusable-patterns section is broadly applicable beyond chat); 29 → 30.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row, noting the correction.
- `sections/README.md` — new cycle-57 group; total **464 → 466**.
- `concepts/README.md` — new `space` row inserted alphabetically before `syrup-record-positionality`.
- `keywords.md` — 14 new entries pointing at `space` or the new sections.

## Cross-cluster cross-references woven in

The `space` concept page links to:

- `[[token-chip]]` — sibling chat-UI concept; the two together cover the chat client's main visual abstractions.
- `[[producer-typed-shape-consumer-rendering]]` — `SpaceConfig` typed shape vs. rendered gutter button.
- `[[per-agent-keypair]]` — each space's `profilePath` resolves to an agent with its own `@keypair`; spaces are user-facing handles for those agents.

## Library state

- Sources: 104 → **105**
- Sections: 464 → **466**
- Topics: 26 (unchanged); 3 topic pages refreshed.
- **Concepts: 20 → 21** (new: `space`).
- Keywords: ~196 → ~211 (~15 new entries).
- Roles: 3 (unchanged).

## Notes for the next cycle

- **Chat backlog still ~16 files**. Natural next picks:
  - `chat-spaces-inbox.md` — third in the spaces family; would extend the `space` concept page further with the inbox-mode behavior.
  - `chat-per-space-color-scheme.md` — covers the scheme-picker / color-scheme territory referenced by chat-spaces-home but not detailed.
  - `chat-command-bar.md` (255 lines, the modeline-bearing component, biggest remaining chat file).
  - `chat-edit-message-ui.md` — would extend `token-chip` with chip-editing behavior.
- **The chat sub-cluster has internal corrections worth tracking** — chat-spaces-gutter's keyboard handler is out of date. Future chat ingests should watch for similar drift between siblings.
- **Library-lookup caller-driven writeback** still pending.
