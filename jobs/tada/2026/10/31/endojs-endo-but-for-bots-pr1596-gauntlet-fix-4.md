Fix round 4 for endojs/endo-but-for-bots PR #1596 is pushed and CI is green: all 35 checks passed, none failed.

**The blocking finding (`no-plain-reexport`, `packages/exo-npm/index.js:19`):** the PR did not add a new re-export here. It removed `parseRangeMajor` from an existing export list, which collapsed `export { makeMvsResolveHook, satisfiesRange } from './src/mvs-resolver.js'` onto one line, and the probe read that line as new. `index.js` is the package's own entry point, and these names have no older location to deprecate. So I added the `reexport-policy-exempt` marker in the file's first five lines, which is the probe's documented way out. The wording matches the marker already used in `packages/npm-registry-server/index.js`.
- Commit `c3d374a37` ("chore(exo-npm): mark package entry point reexport-policy-exempt") was pushed with `safe-push-pr-head.sh` as a fast-forward of `build/m3-mvs-resolver-reference` (`3eaff5678..c3d374a37`).

**The advisory note (pruner, `mvs-resolver.js:232`):** I left that comment alone. It records a rule that isn't obvious from the code: under npm semantics, a pre-release version satisfies a range only if the range names a pre-release of the same `major.minor.patch`. It isn't just restating the code next to it.

**CI:** `ci-wait-merge.sh --no-merge` finished with rc 0. My command wrapper cut off the first wait at about 590s, so a second call ran to the result.

**Follow-ups:** none from this stage. The driver will re-post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (640190 cached reads)
- Output: 3766 tokens
- Cost: $0.5614460000000001
- Wall-clock: 1170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
