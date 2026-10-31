CI on PR #1560 is green, but I pushed nothing this round. The panel-2 review (posted 2026-10-31T09:27Z) was against `d8fb029efd`. Fix round 1 had already pushed `ae6faf9c64` and `bccc126f77` at 09:41Z, which cover nearly all of its must-fix items. I checked each item against the current head.

**Already fixed at head `bccc126f77`:**
- Fresh responders are proved over the driver guest before `Pinned`, with a no-crash test.
- The lifecycle is rebound on recovery.
- Reconciliation failures propagate instead of being swallowed.
- The public types moved to `src/types.ts`, with a required `RootPolicy`, and are exposed through the types index.
- Abbreviated identifiers are spelled out.
- The `@pins` and handle-leak tests are strengthened, and the fake-host exports are hardened.
- The boundary tests the corner-prober asked for were added.
- The changeset is `major`, the CHANGELOG stub exists, and the README documents every export.
- The design's implementation plan now lands as two PRs, and the PR body follows the template without the invented headings.
- The benchmarker's performance claim was replaced with an explicit deferral.

**Not applied:** the purist's should-fix to reuse `isPetName` from `@endo/daemon/pet-name.js`. It would add a heavy workspace dependency on `@endo/daemon`, plus lockfile and tsconfig changes, for one small predicate. The local copy documents its source. I'm leaving it for the maintainer to decide.

**CI:**
- **First run:** red on `test (24.x, ubuntu-latest)`. `@endo/sandbox#test` failed after 52 minutes with no assertion output, in a package this PR doesn't touch.
- **Rerun:** I reran only that failed job, and it passed. All 36 checks now pass or are skipped, with 0 failures.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 180 tokens (10429960 cached reads)
- Output: 47400 tokens
- Cost: $4.363156400000001
- Wall-clock: 9244s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
