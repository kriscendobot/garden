Fix round 1 for PR #1596 is pushed and CI is green: all 35 checks passed with no failures (`ci-wait-merge` exit code 0). The new commit is `4f6b05fa86` on `build/m3-mvs-resolver-reference`, pushed with `safe-push-pr-head.sh`.

**What changed in `packages/exo-npm/src/mvs-resolver.js`, by panel finding:**
- **`0.x` ranges colliding (must-fix, assessor):** `parseRangeMajor` now groups ranges the way a semver caret does. Versions 1.x and up group by major, `0.x` by minor, and `0.0.x` by patch, so `^0.1.0` and `^0.2.0` each get their own version instead of failing.
- **Wide ranges sharing a major slot (must-fix, corner-prober):** a union range like `^1.0.0 || ^2.0.0` is now grouped by its first alternative. A range with only an upper bound, like `<2.0.0`, goes in the `any` group. So `<2.0.0` and `^2.1.0` no longer collide.
- **Pre-releases selected (must-fix, saboteur):** a pre-release such as `1.0.0-rc.1` is only picked when a range names a pre-release of that same version. Ties between equal versions are now broken in a fixed order, so the result no longer depends on the order the registry lists versions.
- **Leftover dependencies (should-fix, four jurors):** when a later requirement moves a package to a newer version, anything only the older version needed is now removed from the final resolution. The older version's range requirements still constrain the graph, as in Go's MVS, and the module docs now say so.
- **Stale docs and test title (breaker, pruner):** the module header, the `satisfiesRange` docs and the slot comment now describe least-satisfying selection. The old test "picks greatest mentioned minor" is renamed "picks least version satisfying all requesters", and the redundant test comment is cut.

**Tests:** `test/mvs-resolver.test.js` gains these cases:
- requester order doesn't change the result, including the incompatible-range test run in both orders
- `0.x` minors coexist
- pre-releases are skipped unless a range names one
- a union range intersects with a narrower range
- an upper-bound-only range stays out of the major slot
- duplicate ranges from several importers merge
- a satisfiable optional range narrows a shared selection, and a conflicting one leaves it unchanged
- dependencies of a superseded version are removed

When I disabled the pre-release filter or the cleanup step, the matching tests failed, so they do catch those bugs. Locally, all 53 exo-npm tests pass, and eslint and the package type check are clean. The repo-root type check shows 15 lines of existing errors, none in exo-npm.

**PR description:** I applied the pruner's cuts to the Scaling, Documentation, Testing and Compatibility sections. The body is now 231 words, under the 300-word threshold.

**Not done:**
- The resolver still keeps the cache pin on a superseded tarball (wire-watcher, should-fix). Unpinning safely needs reference-count semantics from `@endo/mem-cas`.
- Checking fetched bytes against the packument's integrity hash (wire-watcher) predates this PR.

Both could be follow-ups. Panel round 2 will judge whether they block.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2302962 cached reads)
- Output: 19640 tokens
- Cost: $1.6084964000000004
- Wall-clock: 810s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
