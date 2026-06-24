---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal-stringify.js
source_line_range: 1-69
file_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
file_commit_date: 2025-10-09
file_commit_author: Kris Kowal
comment_subject: JSON-equivalent for Passable pure-data via badArray Proxy that traps on slot access
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-ninth comment-fragment ingest (cycle 160 — milestone
  tick). 69-line tight surface for *pure-data* Passable
  serialization. Kris Kowal authored; same coordinated-update
  commit `e56bf00f` as cycles 108 + 110 + 115 + 118 + 123 +
  125 + 132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 +
  154 + 158 + 160 (18-file cluster now).

  **Sixth @endo/marshal source file ingested** (cluster:
  marshal.js cycle 74 / encodeToSmallcaps.js cycle 69 /
  encodePassable.js cycle 81 / rankOrder.js cycles 84-85 /
  dot-membrane.js cycle 144 / marshal-stringify.js this cycle).

  §JSON-equivalent-for-pure-data-Passable surface. Exports
  `stringify` and `parse`. §pure-data-version-of-marshal —
  strips slot-bearing capability of full marshal to get a
  JSON-like API. §accepts (Passable atoms + composites +
  byteArrays + bigints + tagged) / §rejects (remotables,
  promises, slot-references).

  Single most structurally interesting move: §badArray-Proxy-
  traps-on-slot-access. Why a proxy instead of `[]`?
  `unserialize({body, slots: []})` would *silently accept*
  slot-bearing input (lookup gives undefined). The badArray
  Proxy *immediately errors* with `Marshal's parse must not
  encode any slot positions <n>`. §loud-failure-when-input-
  violates-contract.

  §badArrayHandler shape: `get` trap returns `0` for `length`
  (marshal iteration sees empty array), throws on any other
  property. §length-returns-zero-everything-else-throws.

  §Refuse-converter-as-explicit-config discipline: both
  `doNotConvertValToSlot` and `doNotConvertSlotToVal` are
  deliberately-failing functions with clear messages.
  §three-layered-defense: (1) encode-side refuse converter;
  (2) decode-side refuse converter; (3) badArray slot-access
  trap. §each-layer-has-its-own-error-message discipline.

  §Freeze-but-not-harden-the-target discipline (third
  appearance after cycles 146 + 154's funcTarget/objTarget):
  §stabilize-discipline reference to packages/ses/docs/
  preparing-for-stabilize.md. §verbatim-comment-shared-
  across-derived-files pattern (cycle 154 named it). §triple-
  stabilize-citation in this file (arrayTarget + badArray
  discussion + inline freeze comment).

  §Stringify-discards-the-empty-slots-array idiom:
  `stringify = val => serialize(val).body` (drops the always-
  empty slots). §symmetric-API-via-asymmetric-bodies.

  §Parse-passes-freeze-with-badArray-slots: `freeze({body:
  str, slots: badArray})`. §inline-comment-cites-stabilize-md;
  §every-mention-cites-the-rationale discipline.

  §Capdata-not-smallcaps with §TODO-pin: explicit
  `serializeBodyFormat: 'capdata'` + TODO comment about
  smallcaps test brittleness. §legacy-format-pinned-with-TODO
  discipline; §upgrade-blocked-on-test-rewrite observation;
  §honest-TODO-not-silent-pin.

  §errorTagging-off configuration: no cross-CapTP error-
  correlation needed since there's no CapTP. §round-trip-
  identity not §logically-equivalent-with-new-tag.

  §Throw-is-noop-since-Fail-throws linter comment:
  §linter-noise-as-documentation pattern (`throw` is
  technically redundant since `Fail` already throws; the
  explicit `throw` appeases ESLint's flow analysis).
  §comment-explains-the-extra-throw discipline.

  §Same-substrate-three-API-faces observation: one
  `makeMarshal` factory, three quite different end-user APIs
  selected by configuration + wrapping — full marshal (cycle
  74) / membrane marshal (cycle 144) / stringify marshal
  (this).

  Cycle 160 is a **milestone tick** — 25 cycles of
  alternating design+comment ingest since the daemon-
  observability-pair landed at cycles 145+147 (runtime-
  introspection-trio completed by cycle 159).

  Cycle 160 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 54+ consecutive cycles. Pivoted to
  comments-lane.
---

> Abstract: `marshal-stringify.js` (69 lines) is the
> **§JSON-equivalent-for-pure-data-Passable surface** —
> exports `stringify` and `parse`, symmetric to
> `JSON.stringify`/`JSON.parse` but operating on Passable
> values (cycle 71's pass-style classification).
>
> §Pure-data-version-of-marshal: strips slot-bearing
> capability of full marshal to get a JSON-like API. Accepts
> Passable atoms + composites + byteArrays + bigints +
> tagged; rejects remotables / promises / slot-references.
>
> **Single most structurally interesting move**: §badArray-
> Proxy-traps-on-slot-access. The `parse` function passes a
> proxy that pretends to be an empty array but throws on any
> property access (other than `length`) as the `slots`
> argument. §loud-failure-when-input-violates-contract: any
> slot-bearing input *immediately errors* with a useful
> message naming the offending position.
>
> §Three-layered-defense: refuse-converter on encode side +
> refuse-converter on decode side + badArray slot-access
> trap.
>
> §Freeze-but-not-harden-the-target (third file in the
> §triple-stabilize-citation cluster after cycles 146 + 154).
> §verbatim-comment-shared-across-derived-files pattern.
> §every-mention-cites-the-rationale discipline.
>
> §Stringify-discards-the-empty-slots-array; §parse-passes-
> freeze-with-badArray-slots.
>
> §Capdata-not-smallcaps §legacy-format-pinned-with-TODO;
> §errorTagging-off (§round-trip-identity not §logically-
> equivalent-with-new-tag).
>
> §Throw-is-noop-since-Fail-throws §linter-noise-as-
> documentation pattern.
>
> §Same-substrate-three-API-faces observation (marshal /
> dot-membrane / stringify).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access](../sections/endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access.md) | marshal, pass-style, hardened-javascript | current |

Tight 69-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `e56bf00f289ff8484094b785b11636b8bc71d87e`) via the local
  bare-clone.
- Last substantive touch 2025-10-09 by Kris Kowal in commit
  `e56bf00f` ("feat: Adopt @endo/harden"). Same coordinated-
  update commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
  132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 + 154 +
  158 + 160 (18-file cluster).
- **Thirty-ninth comment-fragment ingest.**
- **Sixth @endo/marshal source file ingested** (cluster: 74 +
  69 + 81 + 84-85 + 144 + 160).
- **Cycle 160 milestone tick** — 25 cycles of alternating
  design+comment ingest since the daemon-observability-pair
  landed at cycles 145+147 (runtime-introspection-trio
  completed by cycle 159).
- Cycle 160 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane has been blocked for **54+ consecutive cycles**.
  Cycle 160 pivoted to comments-lane.
- One cohesion-honest section.
