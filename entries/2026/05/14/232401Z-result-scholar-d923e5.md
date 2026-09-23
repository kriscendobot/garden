---
date: 2026-05-14T23:24:01Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--f77945
cycle: 52
refs:
  - entries/2026/05/14/230131Z-result-liaison-1b5881.md
---

# Scholar cycle 52: base64-native-fallthrough (4 sections; rounds out the shim family) + 3 library bug fixes from round-2 A/B report

## Two pieces of work this cycle

1. **Ingest**: `base64-native-fallthrough.md` (slug `b64nf`) — the third member of the vetted-shim family alongside hurl and htcs, distinguished by providing a JS *ponyfill* fallback rather than degrading silently.
2. **Library bug fixes**: the three failure modes identified in the round-2 A/B test report (`entries/2026/05/14/230131Z-result-liaison-1b5881.md`) — the consolidation/cross-reference work this cycle's prompt mandates.

## Ingested (b64nf)

`endo-but-for-bots/llm/designs/base64-native-fallthrough.md` — 639
lines, **Not Started** upstream, 2026-04-23, Kris Kowal. Upstream
commit `102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3`. No prior source-
index entry; fresh ingestion. Slug `b64nf`.

### Section files (4)

- `b64nf/problem-and-detection-strategy` — `@endo/base64` is hot path; TC39 native intrinsics 10× to several-orders-of-magnitude faster; ponyfill-shim pattern: detect via `typeof` at module load + capture references at top level before lockdown; independent feature tests for each direction.
- `b64nf/module-layout-and-option-mapping` — new `src/native.js` splits dispatch from polyfill; top-level `encode.js`/`decode.js` become two-line dispatchers; option-bag mapping (`alphabet: 'base64'`, `omitPadding: false`, `lastChunkHandling: 'strict'`); structurally isomorphic with `@endo/hex` sibling.
- `b64nf/error-semantics-and-test-strategy` — `Error` widens to `Error | SyntaxError`; no monorepo consumer regex-matches polyfill messages; `name` parameter ignored on native path; `ENDO_BASE64_FORCE` env-var test gate (not a `globalThis` flag, which would be a capability leak); test files split into polyfill-message-specific and native-error-type-only.
- `b64nf/decisions-rollout-and-known-gaps` — 9 design decisions; 3 S-sized phases; 6 known gaps before merging.

## Library bug fixes (the consolidation work)

The round-2 A/B test identified three places where library content
misled or under-served a treatment agent. Each fix is exactly the
*indexing-on-the-fly writeback* the `library-lookup` skill would
have produced inline if a caller had used it — but since this run
was scholar-driven and not caller-driven, the fixes are applied
manually.

### Bug 1 (round-2 Q5) — Syrup record field positionality

**New concept page**: `library/concepts/syrup-record-positionality.md`.
The page foregrounds the fact that JS field names in
`makeOcapnRecordCodecFromDefinition` are *positional bindings, not
on-the-wire field names* — only the record label and field order are
serialized. Renaming `transport` → `network` is therefore a source-
only, wire-compatible refactor. The page has a `## Common
confusions` block warning specifically against the failure mode the
A/B test surfaced.

~6 new keywords (`makeOcapnRecordCodecFromDefinition`,
`OcapnLocation field rename`, `Syrup record positionality`, etc.).

### Bug 2 (round-2 Q7) — Formula store JSON vs retention SQLite

**Extended concept page**: added a `## Storage substrate — two distinct
layers` section to `library/concepts/formula-graph.md`. The new
subsection has a four-row table distinguishing:

- Formula store — **JSON files** at `<statePath>/formulas/<head>/<tail>.json`.
- Content-addressed blob store — file-per-hash at `<statePath>/store-sha256/`.
- Pet-name binding store — small files per pet name.
- **Retention table** — **SQLite** at `daemon-database.js:87`, only for cross-peer retention edges.

Includes the explicit clarification *"Capability policies (allowlists,
TOFB bindings, etc.) are persisted as ordinary formulas in the JSON
formula store, not in a separate SQLite table"* — the exact statement
that would have prevented the round-2 treatment agent's SQLite
confusion.

2 new keywords (`formula store JSON vs SQLite`, `retention table
SQLite`) point at `formula-graph`.

### Bug 3 (round-2 Q1) — netstring Reader/Writer naming in abstract

**Lifted into section abstract**: edited the abstract block of
`endo--pkg-netstring-readme--overview.md` to surface the factory
names (`makeNetstringReader(input, {name?, maxMessageLength?})` /
`makeNetstringWriter(output, {chunked?})`) and the `@endo/stream`
`Reader<Uint8Array, undefined, undefined>` / `Writer<...>` typed
shape — both facts that were in the body but not the abstract, which
is what an agent navigating from a topic-page row reads first.

2 new keywords (`makeNetstringReader`, `makeNetstringWriter`) point
at the section.

## Topic refreshes (4 pages)

- `tooling.md` — 4 new b64nf rows; 60 → 64.
- `hardened-javascript.md` — 3 new b64nf rows; 87 → 90.
- `testing.md` — 1 new b64nf row; 11 → 12.
- `bundles.md` — 1 new b64nf row; 28 → 29.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row (b64nf).
- `sections/README.md` — new "cycle 52" group added; total **451 → 455**.
- `concepts/README.md` — 1 new row (syrup-record-positionality).

## Library state

- Sources: 100 → **101**
- Sections: 451 → **455**
- Concepts: 18 → **19** (new: `syrup-record-positionality`)
- Keywords: ~140 → ~155 (~15 new entries spanning b64nf, the 3 bug fixes, and aliases)
- Topics: 25 (unchanged); 4 topic pages refreshed.

## Notes for the next cycle

- **Shim family is now complete in the library**: hurl + htcs + b64nf, with `permits-buckets` as the shared concept page bridging them. The fourth would be `@endo/hex` (sibling parallel proposal to b64nf, not yet ingested upstream as a standalone design — it shares this design's structure).
- **All three round-2 library bugs are fixed.** A round-3 A/B test (if commissioned) would isolate whether these fixes close the failure modes; absent that, the failures should not recur on the same questions.
- **Daemon-cluster review still pending** — 9 daemon-cluster sources now indexed (d256, dani, dcp, dcpg, dlt, drp, rpn, daemon-content-store-gc, dp); a future cycle should walk the cluster looking for thin cross-references the new concept pages (delegates-and-epithets, caretaker-pattern, pass-invariant-handle-equality) should anchor.
- **First library-lookup *writeback exercise* still hasn't happened** — this cycle's bug fixes were scholar-applied, not caller-applied. The skill's *Indexing on the fly* discipline is still untested in practice.
