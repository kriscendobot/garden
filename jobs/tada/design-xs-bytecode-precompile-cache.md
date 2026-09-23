The work is complete. Draft PR #945 is open against the `llm` roadmap branch with the design as its only diff, the mermaid diagram is validated, and the doc is style-clean.

<<<REPORT>>>

**Job: design-xs-bytecode-precompile-cache** — designer role, gated on endojs/endo-but-for-bots#600 (Ironhorse), which merged 2026-08-06T14:52Z and auto-promoted this job.

**Deliverable:** `designs/endor-bytecode-precompile-cache.md` on the `llm` roadmap branch, as **draft PR https://github.com/endojs/endo-but-for-bots/pull/945** (base `llm`, head `kriscendobot:design/endor-bytecode-precompile-cache`, single-file diff, 522 lines). Draft state confirmed via `gh pr view`.

**What the design covers** (all amendment points addressed):
- **Both engines' compile/load surfaces**, verified against the code: XS `fxParseScript` → `txScript{codeBuffer, symbolsBuffer}` (already exercised by the in-tree `xs-oracle` shim), loaded via `fxRunScript`/`fxResolveModule`/`fxRunModule`; Ironhorse `compile_atoms` → `(bytecode, symbols)`, loaded via `evaluate_with_symbols`. Corrected a prior-investigation assumption: the Moddable archive/`.xsa`/`xsc`/`xsl` toolchain is **absent** from this fork (`fxCreateMachine`'s `archive` arg is always null), so the cache is greenfield rather than built on the mod format.
- **Precise cache key:** source identity `S = SHA-256(exact bytes)` plus a compile-identity tuple `C = (engine, bytecode-format-version, engine-build-version, compile-options)` folded into the Tier-B address so a stale-format or cross-engine entry cannot be mis-loaded.
- **Cross-engine invariant:** common content identity, engine-namespaced compiled payloads by construction; a shared `xsbc/<pin>` format only when the `xs-oracle`/test262 differential harness *proves* byte-identical output, never assumed.
- **Two tiers:** engine-independent source-analysis cache (`pre-mjs-json`) and engine-namespaced bytecode cache, both keyed off `S`.
- **`@endo/module-source` as explicit input:** names `PrecompiledModuleSource`/`pre-mjs-json` as the documented serializable seam; specifies minimal additive refactors where internals are insufficient (sidecar version marker, `src-xs` array normalization, engine-native analysis producer, framed compile accessors).
- **AOT vs lazy population** through archives/mounts/CAS trees; invalidation-by-key, framed-payload corruption detection, LRU eviction (safe because re-derivable), atomic-rename concurrent writers, deterministic fallback.
- **Reconciliation with `daemon-make-archive` + `daemon-worker-import-from-mount`:** source-only wire contract unchanged; cache is a local, re-derivable side cache under `ENDO_CACHE_PATH`, off the wire and out of the CAS; bytecode may ride only a separate, self-describing, non-portable deployment bundle.
- Seven open questions surfaced (position-independence of `txScript->codeBuffer`, module- vs script-goal caching, per-module vs whole-bundle granularity, `engine_build_version` composition, Tier-A functor need, CJS scope).

**Method:** four parallel Explore agents (module-source internals, XS-C machinery, Ironhorse #600 surface, archive/mount/CAS designs) plus the journal's prior `xs-from-rust-investigation.md` as the research floor. Mermaid diagram validated parse-only (`flowchart-v2 OK`); doc is ASCII-clean with no Latin shorthand.

**Follow-ups:** none blocking. Implementation is a separate builder dispatch (per project convention, designs and implementations are separate PRs) after maintainer review and un-drafting. The design leaves the open questions for maintainer resolution; several are natural probe targets (the `txScript` position-independence question especially).

**Self-improvement:** nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-xs-bytecode-precompile-cache.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (2084370 cached reads)
- Output: 32972 tokens
- Cost: $7.568749999999998
- Wall-clock: 791s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
