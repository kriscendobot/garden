Press tick complete for the npm-via-CAS registry-proxy arc. This dispatch moved the arc two increments forward: Phase 2 landed on `llm`, and the Phase 4 resolver half is up as a new draft PR with live-network proof.

**1. Merged PR #276 (Phase 2, npm-registry HTTP fetch layer).** It was green across all 24 checks, panel-reviewed, un-drafted, and `MERGEABLE/CLEAN` with no conduct job on the board and no live peer on the branch, so I carried the merge with the conductor spine (`ci-wait-merge.sh`, exit 0, state MERGED). `rust/endo/src/fetch.rs` is now on `llm`.

**2. Built and pushed the Phase 4 resolver half — draft PR endojs/endo-but-for-bots#799** (`feat/endor-npm-resolve`, base `llm`, kept DRAFT per the press charter):
- `rust/endo/src/npm_resolve.rs`: `resolve_transitive` drives fetch + MVS to a fixpoint — ranges accumulate per package, each range anchors to a major, each anchor group picks the greatest satisfying version of that major (distinct majors coexist), and each fetched package's `package.json` is read back from its CAS tree to feed the next round. Capped at 4096 packages against hostile registries.
- `endor npm-resolve [--registry <url>] <name[@range]>...` CLI, with state at `<state>/store-sha256` + `<state>/registry.db`.
- Extended the semver `Range` grammar with partial/wildcard forms (`2`, `2.1`, `2.x`, `>=2`, `~0`, `^0`) via a new `Prefix` comparator — the first live run failed on `inherits: "2"`, so this was integration-forced, and the fix is correct for major 0 where the caret rule collapses.
- Design doc status section updated to match reality.

**Real-execution evidence (the green bar):** `endor npm-resolve rimraf@^3.0.0` live against registry.npmjs.org resolved and fetched the full 12-package transitive graph into the CAS (output cited in the PR); re-running against `https://registry.invalid.example/` with the same state dir returned the identical set with zero network — the registry table + CAS acting as the npm-registry proxy. `cargo test -p endo --lib`: 105 passed (13 new).

**Follow-ups for future ticks:** Phase 4's loader half (compartment-mapper `moduleMapHook`/`importHook` so `endor run entry.js` executes from the CAS) is next; it is adjacent to the xsnap worker-bundle build gap the xs2rust arc owns (missing `bundle-bus-worker-xs.mjs` — I stubbed the gitignored bundles locally for tests only, nothing committed). Phase 5 (`--offline`, `.npmrc`) after that. PR #799's CI was still starting at completion time; the next tick should check it and press the panel/fix loop.
