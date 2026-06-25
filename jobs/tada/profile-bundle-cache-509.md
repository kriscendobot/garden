Done. Scratch torn down, artifacts preserved in the git content store, report on #509 and the journal.

---

## Completion report — `profile-bundle-cache-509`

**What I did.** Profiled the `@endo/bundle-source` per-bundle read cache (the `cachedReads` map in `packages/bundle-source/src/zip-base64.js`) from PR #509's branch (`mirror-endo-3099`) to find which files the cache repeatedly reads.

**Target used: the Endo-bundles proxy (maintainer-authorized fallback), not agoric-sdk.** Standing up agoric-sdk's full bundle generation (heavy monorepo install + Go/submodule build) was not feasible in this run. The proxy exercises the *exact #509 cache code* over real `@endo/compartment-mapper` module graphs. Because the cache is scoped to a single bundle operation (it does not persist across bundles), per-bundle behavior is the entire story for what this cache governs, and the proxy reproduces it faithfully. **agoric-sdk was kept strictly read-only — no clone was even stood up; no PRs/commits/comments.**

**Method.** Instrumented the cache's `maybeRead` wrapper (read-only, scratch copy only) with a per-location read counter, then bundled 9 representative Endo entrypoints (marshal, captp, far, eventual-send, exo, patterns, nat, promise-kit, pass-style) via `endoZipBase64`. Captured heavy output silently into the git content store per local-verify discipline.

**Key finding.** The cache hot-files are **`package.json` descriptors — 100% of them** (506/506 repeated files), each read **exactly twice** per bundle; **no source `.js` is ever re-read**; max reads of any file in a bundle is 2. Per-bundle hit-rate 24.5–26.9% (`dev:true`); a `dev:false` cross-check (agoric-shaped) shows the identical pattern at ~44%. **Cause:** compartment-mapper's two phases — `mapNodeModules` (graph build) and `makeAndHashArchiveFromMap` (archive assembly) — each read every descriptor once; the cache collapses the second read.

**Takeaways posted:** (1) a `package.json`-only cache, or threading already-parsed descriptors from the map phase into the archive phase, captures ~100% of the benefit and could make the read-cache redundant for its hot set; (2) the cache being per-bundle means multi-entry agoric runs re-read shared descriptors 2× *per bundle* from disk — a cross-bundle persistent descriptor cache would save far more (aligned with the PR's multi-entry speedup goal); (3) source files are a non-factor for the byte budget / eviction policy.

**Where it landed.** Report comment on endojs/endo-but-for-bots#509 (`issuecomment-4803936373`) and a `result` journal entry (`203710Z-result-gardener-6dcc00.md`). Artifacts in the git content store: `profile-result.json` `ef659aa7`, `profile-harness.mjs` `4bc47f06`, `install.log` `69a7f26c`. Scratch worktree torn down. Inbox was empty at checkpoints.

**Follow-ups (for the maintainer / PR author).** Two concrete cache-design options surfaced — descriptor-only caching vs. eliminating the double-read at the compartment-mapper source — and the cross-bundle persistence idea for multi-entry agoric runs. None actioned (out of scope for this read-only profiling job).
