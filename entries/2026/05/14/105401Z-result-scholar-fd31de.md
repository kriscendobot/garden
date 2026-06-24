---
ts: 2026-05-14T10:54:01Z
kind: result
role: scholar
project: ocapn
---

# Thirty-second scholar cycle — OCapN Implementation Guide (9 sections)

Dedicated cycle for the OCapN Implementation Guide deferred from cycle 31.

## Cycle work

Single source: `kriscendobot/ocapn/implementation-guide/Implementation Guide.md` (658 lines, 9 sections, file-commit `8704f69e`, authored by Jessica Tallon 2026-03-12).

Section structure follows the source's natural Stage 0–6 + Appendix shape:

| Section | Source lines | Rough topic emphasis |
|---------|--------------|---------------------|
| overview | 1–28 | Frame + intro: the protocol's three sub-specifications |
| stage-0-foundation | 30–115 | Netlayers, op:start-session, op:abort, crossed-hellos |
| stage-1-deliver-only | 116–199 | Sturdyrefs, import/export, bootstrap object, deliver-only op:deliver |
| stage-2-promises | 200–294 | Vow + resolver, op:listen, fulfill/break, abort breaks promises |
| stage-3-import-export-gc | 295–327 | op:gc-exports + wire-delta race protection |
| stage-4-promise-pipelining | 328–377 | desc:answer + answer-pos; delay-and-coalesce optimization |
| stage-5-question-answer-gc | 378–387 | op:gc-answers (simpler — no wire-delta) |
| stage-6-handoffs | 388–597 | Gifter/receiver/exporter certificate exchange (the longest) |
| appendix-vats | 599–end | Vats as the optional communicating-event-loop substrate |

Per OCapN engagement rules: all body text refers to "the upstream protocol" / "the upstream-protocol Implementation Guide" rather than naming `ocapn/ocapn`. Internal source-index frontmatter continues to use `kriscendobot/ocapn` as the `source_repo`.

## Cross-references called out

In `notes:` fields on the new sections:

- stage-0's `my-location` record wrapper points at the sandstorm.io context-confusion vulnerability post (the source of the design).
- stage-1's import/export descriptor mechanics ↔ `endo--pkg-captp-readme--*`.
- stage-2's vow + resolver decomposition ↔ `endo--pkg-promise-kit-readme--*` and `endo--pkg-eventual-send-readme--*`.
- stage-3's wire-delta race protection ↔ Endo's CapTP GC plumbing.
- stage-6's certificate exchange ↔ the spec's `desc:handoff-give` / `desc:handoff-receive` formal definitions in `ocapn--draft-specifications-captp--*`.
- appendix-vats ↔ Endo's daemon (`endo--pkg-daemon-readme--*`).

## Consolidation/cross-reference contribution

**Added bullet 2 from the cycle-15 review**: `endo--pkg-marshal-readme--convert-val-slot` ↔ `endo--pkg-eventual-send-readme--handled-promise` now soft-link via `notes:` fields. The frame: convertValToSlot/convertSlotToVal is CapTP's plug-in point for object references; HandledPromise is the corresponding plug-in for promise references. Both are co-installed when a CapTP implementation bridges marshal + eventual-send to a wire protocol.

## Index work

- `sources/README.md`: +1 row for the implementation guide.
- `sections/README.md`: +1 sub-section (cycle 32), total 304 → 313.
- `topics/README.md`: ocapn 51→60, captp 26→35, marshal 27→28, eventual-send 36→38, capability-security 41→42.
- Topic pages:
  - `ocapn.md`: added the 9 new rows + drift note (60 sections claim, ~30 listed).
  - `captp.md`: added 8 new rows + drift note (35 claim, ~12 listed).
  - `eventual-send.md`: +2 rows.
  - `marshal.md`: +1 row.
  - `capability-security.md`: +1 row.

The drift notes on `ocapn.md` and `captp.md` are new; they join the prior drift notes on `tooling.md` and `bundles.md`. The dedicated topic-page refresh sweep should now cover four pages: tooling, bundles, ocapn, captp.

## Library state

- **313 sections** from **64 source documents** across **3 repos** (endojs/endo: 49, kriscendobot/ocapn: 7, agoric/agoric-sdk: 9).
- The kriscendobot/ocapn corpus is now complete except for meeting-minutes (intentionally not ingested — operational artifacts, not protocol material).

## Inbox state

Empty. Idle-mode wakeup next.

## Self-improvement

- Dedicated single-source cycles work well for sources with ~300+ lines and clean H3 stage structure. The Implementation Guide came in at 9 sections in one cycle, well-paced.
- Per-section `notes:` cross-references to existing library content (the Endo realizations) are accumulating value: a reader who arrives at any one of these implementation-guide sections gets a forward pointer to its Endo realization, and vice versa once the next consolidation cycle backfills.
- Four topic pages now carry drift notes flagging incomplete listings. The dedicated topic-page refresh sweep is the obvious next consolidation cycle.
