The build is complete and verified. Here is my completion report.

---

## Completion report: Build SES import attributes (design #248)

**Delivered: Phase 1 — the SES runtime + normalization core — as draft PR [endojs/endo-but-for-bots#1292](https://github.com/endojs/endo-but-for-bots/pull/1292)** (head `llm-ses-import-attributes`, base `llm`, draft, marker recorded for idempotent re-adoption).

The accepted design is large and explicitly calls for a phased/stacked PR series ("ses/module-source core first, then compartment-mapper"). I implemented the coherent, self-contained, fully-tested core in this build and durably parked the two format-touching follow-ups.

### What landed (11 files, +669/−41)
- **Normalization** — `normalizeImportAttributes` / `EMPTY_ATTRIBUTES` + the `attributesMemoKey` encoding in new `packages/ses/src/module-attributes.js`, re-exported from `ses`. Clone-then-freeze, null-prototype, string-validated, sorted keys, empty-case sentinel.
- **Memo-key extension** with the legacy-collapse rule threaded through `module-load.js`, `module-link.js`, `module-instance.js`, and the deferred-exports namespace map (`module-proxy.js`) — so attribute variants of one specifier get distinct records/instances/namespaces while unattributed graphs keep the byte-identical bare-specifier key.
- **Arity-based `importHook`/`importNowHook`** back-compat, throwing the exact documented `TypeError` on a non-JS attribute against a legacy single-arg hook.
- **`modulesWithAttributes`** compartment option (priming) and the **dynamic-import** `import(spec, { with })` path (bypassing `resolveHook` per design).
- Types (`Attributes`, `ModuleWithAttributes`, augmented hooks, option) and `test/import-attributes.test.js` (12 tests).

### Verification (all real runs)
- `packages/ses`: **411 passed** + my **12 new tests pass**, 1 pre-existing known failure, 2 skipped.
- `packages/compartment-mapper`: **1182 passed**, 53 pre-existing known failures — including all `makeArchive`/`parseArchive`/**`hashArchive` consistency** tests, confirming pre-attributes bundles/archives load and hash **byte-identically** (the design's backward-compat guarantee).
- `packages/module-source`: 156 passed.
- `yarn lint:types` and `yarn lint:eslint` clean for `packages/ses` (no new errors/warnings).

### Deferred (durably parked as maintainer-gated `--go-ahead` plan jobs)
- `endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source` — parser static `with`-clause capture + precompiled-functor/linking rework for same-specifier-differing-attributes static imports.
- `endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper` — archive read/write + synthetic-hook plumbing.

### Notes / intentional deviations (flagged in PR body)
- The design says the normalizer "lives in `@endo/module-source`, re-exported from `ses`." Because `ses` is a foundational shim that cannot depend on its parser, the canonical copy lives in `ses`; the module-source-side export lands with Phase 2 (parser).
- The job spec's bullet about a `JsonModuleSource` v1 source type **contradicts the authoritative design**, which explicitly rejects a new source shape (JSON/CSS/Wasm are served via the existing `VirtualModuleSource`). I followed the design; no new source shape was introduced.
- Design-doc status updated (Draft → In Progress, Phase 1 landed) in `designs/ses-import-attributes.md` and `designs/README.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-248-build-ses-import-attributes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 270 tokens (22830917 cached reads)
- Output: 114434 tokens
- Cost: $16.6527265
- Wall-clock: 1891s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
