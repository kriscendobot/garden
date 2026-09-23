Inbox empty. The fix stage is complete: panel must-fix items applied, pushed, CI green. Writing the completion report.

---

## FIX round 1 — endojs/endo-but-for-bots PR #1117 — complete

Applied the gauntlet panel-1 must-fix items in one pass, pushed as a review-feedback follow-up commit (`5d2fb0a46`) to the PR head `build/npm-registry-as-directory-tree`, and watched CI to terminal: **all 27 checks pass, rollup SUCCESS (GREEN)**.

**Code fixes (`packages/exo-npm`, `packages/daemon`, `rust/endo`):**
- `comparePublishedVersions` (JS + Rust) made a **total order** — parseable versions sort before unparseable ones, killing the intransitive lexicographic fallback that let packument key order drive `list()`/MVS (saboteur, breaker).
- `makeLookupTreeView` now **rejects the empty path** and **re-attenuates every traversable node** it returns, so `list` authority is not recoverable through the view (locksmith, warden, breaker).
- `npmHub.lookup` normalizes the leading segment through `scopedPackageSegments` regardless of path length, so **`has` and `lookup` agree** on `@scope/package` + version (assessor).
- `makePackageRegistryTree` indexes `registries` via `Object.hasOwn`, and the resolver's `packagesByKey` is null-prototype — **no intrinsic leaks** through `__proto__`/`constructor`/`toString` (warden).
- Scope hubs are **minted on demand** instead of memoized in an unbounded map, closing a guest memory-exhaustion vector (breaker).
- Resolver **shape-checks third-party dependency tables** before iterating (saboteur).
- `makeEndorReadableTree.lookup` returns **not-found instead of a raw TypeError** when a path descends through a blob (assessor, prover, breaker).
- Registry error **classification survives the marshal boundary** — non-enumerable tags plus message-prefix fallbacks for not-found/path-syntax, family predicate via the concrete name (purist).
- `inproc.rs`: spelled out `project_directory`/`home_directory` (stylist).

**Types / docs / changeset:**
- `RegistryNodeInfo` → `type` alias so `RegistryVersionTree` legally extends `EndoReadableTree`; dropped inline `import()` JSDoc tags (typist).
- Corrected the `snapshot-mapper.js` header and `type-guards.js` comment that cited unamended/deprecated designs (archivist).
- Added `@endo/exo-npm` to the changeset, named the `registry → registryRoot` rename, and folded the stale `registry-capability.md` sibling (packager, curator, migrator).

**Tests added:** MVS within-major upgrade, malformed dependency tables, Endor success-envelope `treeHash` threading, comparator total-order, attenuator depth, has/lookup agreement, prototype-pollution, and marshal-boundary error classification (prover, breaker, saboteur). Local: `@endo/exo-npm` 59/59 and `@endo/daemon` registry-tree 5/5 pass; lint/tsc clean.

**Notes/follow-ups (deferred to panel-2, not blocking):** several should-fix items were left for the driver's re-review — ambient `globalThis.fetch` sniff vs injected power, Node offline-mode reachability, `RegistryVersionLeaf`/`RegistryPackageLeaf` naming unification, and full extraction of the Endor projection in `manager.js` for direct unit coverage. The `@endo/daemon` bump was kept `minor` on the grounds (curator/migrator) that the superseded `@registry` method surface was never released.

Note: one intermediate push failed CI on a Prettier formatting nit in the new test file; fixed and re-pushed as the final `5d2fb0a46`, which is green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 194 tokens (15910021 cached reads)
- Output: 68631 tokens
- Cost: $15.302001499999996
- Wall-clock: 1709s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
