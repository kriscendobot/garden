## Press report — npm-via-CAS registry proxy (endojs/endo-but-for-bots, base `llm`)

**Assessment.** PR #276 (Phase 2 HTTP fetch) is MERGEABLE/CLEAN with all panel follow-ups addressed and CI green — awaiting a merge decision, nothing to press there. PR #772 (Phase 4 resolver core, opened by the 03:20 tick) is draft, CI green, no review activity; no live peer holds either branch. The registry-capability edge (#403/#671/#563) stays with the byte-array arc per the no-duplication instruction. The next unblocked XS-free increment was **Phase 5: offline mode + `.npmrc` support**, which the previous tick explicitly queued up.

**What I did.**
- Built Phase 5 on a branch stacked on #772's head and opened **DRAFT PR endojs/endo-but-for-bots#782** (base `llm`; only the top commit is new review surface, per the stacked-PR convention #772 itself uses).
  - New `rust/endo/src/npmrc.rs`: `NpmConfig` parsing the npm ini subset the fetch layer consumes — `registry`, `@scope:registry`, nerf-dart `//host/path/:_authToken` — with npm's source precedence (user `~/.npmrc` → project `.npmrc` → `NPM_CONFIG_REGISTRY`) and longest-prefix token matching on path-component boundaries (a `registry.example.com.evil.example` host can never steal a `//registry.example.com/` token).
  - `fetch.rs`: typed `FetchError::Offline` + `OfflineClient` (the `--offline` client — every network request refused, so only registry-table/`package_meta` cache hits resolve), and `UreqClient::with_config` attaching `Authorization: Bearer` per matching token.
  - `resolver.rs`: `NpmResolver` now routes each package through `NpmConfig::registry_for`, so scoped packages fetch from their scope's registry; `with_config` exposes the full configuration while `new` keeps the single-URL shape (zero churn for existing callers/tests).
- **Real-execution evidence.** Hermetic: `cargo test -p endo --lib` **116/116 pass** (12 new tests; baseline was 104). Live network: `ENDOR_REGISTRY_LIVE_TEST=1 … live_registry` — real transitive resolution of `is-odd@^3.0.0` → `is-number@6.0.0` from registry.npmjs.org into the CAS (tree hashes `a46a5a58…`/`51e96a7a…`), then a re-resolution through `OfflineClient` that served both packages with **zero HTTP** — the live test's replay leg now hard-fails on any network access, so the registry-table-as-lock-file behavior is observed, not assumed.
- Reproduced the known base-build workaround in my isolated worktree (moddable submodule init + stubbed gitignored XS boot bundles); the verified suites never boot XS.

**Follow-ups (not pressed this tick).**
1. #276 still needs a merge decision; once it lands, #772 and #782 collapse to one commit each on rebase.
2. The remaining Phase 4 half (wiring `resolvePackage`/`fetchPackageJson`/`fetchModuleSource` into the XS mapper's hooks and `endor run <entry.js>`, plus the `--offline` CLI flag) stays gated on the `llm` base-build gap — no in-tree generators for the XS boot bundles. That structural blocker, already surfaced by the 21:05 tick for a designer/shepherd job, is now the arc's only path to the finish line.
3. Library-side Phases 1–5 are now all either merged (1, 3) or in open PRs (2: #276, 4-core: #772, 5: #782).
