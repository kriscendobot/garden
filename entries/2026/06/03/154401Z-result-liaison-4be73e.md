---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--4be73e
ts: 2026-06-03T15:44:01Z
ref_id: 4be73e
---

# Cycle 160 result — marshal/src/marshal-stringify.js (milestone tick; thirty-ninth comment-fragment ingest)

**Cycle 160 — milestone tick.** Nominally chat-lane (exhausted at
20/20); papers-lane blocked **54+ consecutive cycles**. Pivoted to
comments-lane.

**25 cycles of design+comment alternation** since the daemon-
observability-pair landed at cycles 145+147 (runtime-introspection-
trio completed by cycle 159).

## Source

`endo/packages/marshal/src/marshal-stringify.js` (69 lines). Kris
Kowal authored; last touched 2025-10-09 in cycle 108's coordinated-
update commit `e56bf00f`.

**Sixth @endo/marshal source file ingested** (cluster: marshal.js
cycle 74 / encodeToSmallcaps.js cycle 69 / encodePassable.js cycle
81 / rankOrder.js cycles 84-85 / dot-membrane.js cycle 144 /
marshal-stringify.js this cycle).

## Structural moves captured

- **§Pure-data-version-of-marshal**: §JSON-equivalent-for-pure-
  data-Passable surface. Exports `stringify` / `parse` symmetric
  to JSON.stringify/JSON.parse but operating on Passable values.

- **Single most structurally interesting move**: §badArray-Proxy-
  traps-on-slot-access. The `parse` function passes a proxy that
  pretends to be an empty array but throws on any property access
  (other than `length`) as the `slots` argument. §loud-failure-
  when-input-violates-contract: any slot-bearing input *immediately
  errors* with a useful message naming the offending position
  (rather than the silent type confusion that `[]` would produce).

- **§Three-layered-defense**: refuse-converter on encode side +
  refuse-converter on decode side + badArray slot-access trap.
  §Each-layer-has-its-own-error-message discipline.

- **§Freeze-but-not-harden-the-target** discipline — third file in
  the §triple-stabilize-citation cluster after cycles 146
  (eventual-send/src/E.js) and 154 (captp/src/trap.js). §verbatim-
  comment-shared-across-derived-files pattern; §every-mention-
  cites-the-rationale discipline.

- **§Stringify-discards-the-empty-slots-array** idiom; §parse-
  passes-freeze-with-badArray-slots.

- **§Capdata-not-smallcaps with §TODO-pin** — explicit
  `serializeBodyFormat: 'capdata'` + TODO comment about smallcaps
  test brittleness. §legacy-format-pinned-with-TODO; §upgrade-
  blocked-on-test-rewrite; §honest-TODO-not-silent-pin.

- **§errorTagging-off configuration** — §round-trip-identity not
  §logically-equivalent-with-new-tag.

- **§Throw-is-noop-since-Fail-throws** linter comment — §linter-
  noise-as-documentation pattern.

- **§Same-substrate-three-API-faces** observation: one
  `makeMarshal` factory, three quite different end-user APIs —
  full marshal (cycle 74) / membrane marshal (cycle 144) /
  stringify marshal (this).

## Output summary

- **Source slug**: `endo--packages-marshal-src-marshal-stringify-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access.md`
- **Topics**: marshal, pass-style, hardened-javascript
- **Library totals**: 664 sections from 205 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 54+ consecutive cycles); pivoted to comments-lane

## Milestone

**Cycle 160 closes** — 25 cycles of alternating design+comment
ingest since the daemon-observability-pair (cycles 145+147). Three
clusters now well-mapped:

| Cluster | Cycles | Files |
|---------|--------|-------|
| @endo/pass-style | 71+87+134+136+138+140+142+148+150 | 9 |
| @endo/marshal | 74+69+81+84-85+144+160 | 6 |
| @endo/captp | 154+156+158 | 3 |
| Coordinated-update `e56bf00f` | cycles 108+110+115+118+123+125+132+134+136+138+140+144+148+150+152+154+158+160 | 18-file cluster |

Cycle 160 closes. Schedule next wake 1500s for cycle 161.
