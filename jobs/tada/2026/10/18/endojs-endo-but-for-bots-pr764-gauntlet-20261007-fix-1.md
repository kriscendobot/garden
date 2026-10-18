Fix round 1 for endojs/endo-but-for-bots#764 is done and CI is green; I pushed nothing new. An earlier run of this job had already pushed every must-fix item from the panel-1 review (review 5562906978) to the PR head, in commits `a69e0baed9`, `82b80563c0` and `320266286f` on 2026-10-18.

**Panel items already on the PR head:**
- **URL cached in `node-powers.js`:** `const { Function, Promise, URL } = globalThis;` at line 42. This settles the findings from assessor, locksmith, saboteur, breaker, spec-keeper, engine-realist, corner-prober, wire-watcher and purist. It also makes the old commit message, which says URL is cached, true (integrator's finding).
- **Changeset:** `.changeset/cache-compartment-mapper-intrinsics.md` is a `patch` changeset for `@endo/compartment-mapper` that describes capturing the five globals when the modules load (packager, migrator, changeset-auditor, releaser).
- **Regression tests:** `packages/compartment-mapper/test/cached-intrinsics.test.js` replaces `URL`, `Function`/`Promise` and `Proxy`/`Set` with throwing stand-ins after the modules load, then drives the code in `node-powers.js`, `parse-cjs-shared-export-wrapper.js` and `import-hook.js` (prover).
- **PR body:** rewritten section by section to follow the upstream template, which also removes the file tour and the "Note" padding (integrator, pruner).
- **CI workflow:** the paths-filter version comment in `ci.yml` is pinned to the exact tag `v3.0.3`.

**What I checked:**
- All 5 tests in the new file pass locally.
- I removed the `URL` cache from `import-hook.js` and the import-hook test failed, so it does catch that regression. I restored the file afterwards.
- `ci-wait-merge.sh --no-merge` returned 0: 15 checks, none failed.

**Follow-up:** two `fixup!` commits are still on the branch, which packager and integrator flagged as should-fix. They need to be autosquashed before or at merge. I left them in place rather than force-pushing in the middle of the gauntlet.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 114 tokens (4911548 cached reads)
- Output: 27480 tokens
- Cost: $2.8376775999999992
- Wall-clock: 1461s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
