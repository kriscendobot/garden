---
date: 2026-05-14T19:31:24Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--9164a1
cycle: 46
---

# Scholar cycle 46: cross-peer-gc + locator-terminology (11 sections, 2 sources)

## Ingested

Both designs are new to the library; the idempotency check found no
prior `journal/library/sources/` entries for either path. Upstream
commits captured from `git --git-dir=worktrees/endojs-endo-but-for-bots.git log -1 --format=%H llm -- <path>`:

| Source | Upstream commit | Sections written |
|---|---|---|
| `endo-but-for-bots/llm/designs/daemon-cross-peer-gc.md` | `1570e88926e0fe3146b30458b6148f33c76fe02a` (2026-04-29, Kris Kowal, **Complete**) | 6 |
| `endo-but-for-bots/llm/designs/daemon-locator-terminology.md` | `bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42` (2026-03-17, Kris Kowal, **In Progress**) | 5 |

Slugs `dcpg` and `dlt` respectively, following the existing
acronym-slug convention (cf. `drp`, `rpn`, `gbta`, `hurl`, `ntsep`).

## Section files (11)

**`dcpg`** (`daemon-cross-peer-gc`):
- status-and-why-crdt-abandoned
- retention-set-model
- wire-and-batching
- event-sources-and-subscription
- persistence-and-graph
- crash-reconnect-and-revocation

**`dlt`** (`daemon-locator-terminology`):
- terminology-rename
- locator-format-evolution
- method-additions
- local-node-sentinel
- dehydration-and-hydration

## Topic refreshes

- `daemon.md` — 11 new rows (every section files under daemon); 21 → 32.
- `capability-security.md` — 5 new rows (dcpg's status / retention-set / crash-reconnect, dlt's local-node / dehydration); 92 → 97.
- `persistence.md` — 3 new rows (dcpg's persistence-and-graph + crash-reconnect, dlt's dehydration); 18 → 21.
- `async-flow.md` — 2 new rows (dcpg's wire-and-batching + event-sources); 5 → 7.
- `eventual-send.md` — 1 new row (dcpg's wire-and-batching); 48 → 49.
- `ocapn.md` — 1 new row (dlt's locator-format-evolution); 70 → 71.
- `patterns.md` — 1 new row (dlt's local-node-sentinel as a "stable-internal-id externalized-per-identity" pattern); 21 → 22.
- `agent-conventions.md` — 2 new rows (dlt's terminology-rename + method-additions, as bridging-via-type-aliases + signature-preserving-rename disciplines); 23 → 25.

`topics/README.md` updated to reflect the new counts.

## Master indexes

- `sources/README.md` — 2 new rows appended under the endo-but-for-bots designs block.
- `sections/README.md` — new "cycle 46" group added under the endo-but-for-bots/llm/designs heading; total updated **417 → 428**.

## Consolidation / cross-reference work this cycle

The two designs cross-reference each other and prior cycles via
explicit `[[...]]` wiki-links:

- `dcpg/wire-and-batching` calls out the same **coalesce-then-deliver**
  microtask-flush pattern used in `drp/daemon-surface-and-subscription`
  and `rpn/subscription-and-follow-protocol`. The retention-accumulator
  is the named primitive at the daemon level; the topic page row notes
  this as a daemon-wide async-flow convention.
- `dcpg/persistence-and-graph` notes the same "in-memory authoritative
  during session, on-disk authoritative across restart" discipline as
  `rpn/persistence-and-recovery`.
- `dlt/dehydration-and-hydration` ties the dehydrate/hydrate split to
  the **producers-own-typed-shape, consumers-own-rendering** principle
  added to `conventions.md` in cycle 44 (originally from
  `rpn/rpn-string-notation`). The locator/pet-store split is a
  worked example: formula key is the typed shape; the URL locator is
  the rendered form.
- `dlt/local-node-sentinel` records the **stable internal id,
  externalized per identity** pattern and links to the asymmetry-of-
  authority observation in `dcpg/retention-set-model`. This is added
  to the `patterns.md` topic page as a new daemon-level pattern row.

No new sources were proposed for merge or supersession this cycle; the
overlap clusters in `entries/2026/05/14/051241Z-message-scholar-1f9a9e.md`
were left unchanged.

## Inbox state

Not advanced. Recent cycles (43, 44, 45) have not touched
`inboxes/endolin/scholar.md`; the long-running deferral discipline
warrants its own dedicated cycle or a missive to the gardener, but is
not appropriate to retroactively perform inside an ingestion cycle. The
inbox advance step from the loop prompt is treated as a no-op until the
deferral problem is addressed end-to-end.

## Library state

- Sources: 93 → **95**
- Sections: 417 → **428**
- Topics: 25 (unchanged); 8 topic pages refreshed.
- Drift: not measured this cycle; section files were authored against
  current frontmatter conventions and topic-row inserts were
  alphabetical.

## Notes for the next cycle

- The remaining endo-but-for-bots/llm/designs queue from the cycle-38
  meta-catalog still has ~100 untriaged designs; the daemon-related
  cluster (now four ingested: content-store-gc, retention-paths,
  retention-path-notation, cross-peer-gc, locator-terminology) is
  beginning to look like a *coherent sub-corpus* that could justify a
  dedicated topic page or sub-cluster review on the next consolidation
  pass.
- `daemon-256-bit-identifiers.md` is referenced by `dlt` as
  prerequisite reading and is not yet ingested; it would be a natural
  pick for cycle 47.
- The patterns topic page now has one endo-but-for-bots row (the
  LOCAL_NODE sentinel). If subsequent designs surface similar
  daemon-level patterns, the patterns topic may need a
  "daemon-internal-patterns" subsection to keep the user-facing
  match-language patterns visually distinct from infrastructure ones.
