Completion report: endojs-endo-but-for-bots-cbor-encode-decode-design

Design-stage follow-up to kriskowal's approving review of PR #885, which asked for a refactor splitting `@endo/cbor` into `@endo/cbor/encode` and `@endo/cbor/decode` so readers retain no writers and vice versa.

**What I did**
- Wore the designer role; read the project's `designs/AGENTS.md` conventions, the originating review on #885, the existing `designs/cbor-codec.md`, and the live `packages/cbor/index.js` plus the #885 ocapn consumer import patterns.
- Drafted `designs/cbor-encode-decode.md` matching the project's metadata-table/section conventions.
- Registered the design in `designs/README.md` (summary table, M4 milestone table, per-design estimate XS <1 day, M4 count 8→9, recently-added header + list).
- Committed on `design/cbor-encode-decode`, pushed to the `kriscendobot` fork, opened **draft PR #896** against the `llm` roadmap branch: https://github.com/endojs/endo-but-for-bots/pull/896 (draft, base `llm`, head `kriscendobot:design/cbor-encode-decode`).

**What changed**
- `designs/cbor-encode-decode.md` (new, 445 lines)
- `designs/README.md` (5 additive registration edits)

**Design summary**
Factors `packages/cbor/index.js` (741 lines) into `encode.js` (write-side + encode-private helpers), `decode.js` (read-side + decode-private helpers), and an internal `internals.js` (not a subpath export) holding the four shared runtime bindings both halves need from one definition: `canonicalInfo`, `CANONICAL_NAN`, `UINT64_BOUND`, `UINT32_BOUND` — keeping the writer's emit and the reader's minimality-rejection agreeing structurally. `package.json` declares `./encode` and `./decode` subpath exports; the root `.` re-export is preserved (`export *` from both halves, disjoint name sets asserted by the test plan). No signature/canonicality/number-domain change. Migration retargets ocapn (post-#885) and slots imports; root import stays valid. Does not modify PR #885.

**Verification**
- Not verified by execution: design-stage deliverable, no code changed in `packages/cbor`. The design's test plan specifies the builder-run checks (ported suite across all three entry points, export-name disjointness, root re-export completeness, internals-not-exported, ocapn suites green post-retarget).
- No mermaid fences in the design; README graphs untouched (diff purely additive).
- PR #896 confirmed draft/base `llm`.

**Follow-ups**
- Builder dispatch implements the split once accepted (phase 1 split; phase 2 retarget ocapn post-#885; phase 3 retarget slots post-#124; phase 4 optional daemon envelope).
- Open questions for the maintainer: (1) whether to deprecate the root import later (design says keep); (2) whether `internals.js` warrants a subpath export for audit (design says no).
