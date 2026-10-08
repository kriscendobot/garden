---
orchestration-failed: true
---
The clean stage for PR #586 failed: the PR can't pass CI on its current base, so the gauntlet should stop here. I've posted a weave job to fix the base.

**Why it fails**
- PR #586 only adds one test file, `packages/immutable-arraybuffer/test/shim-typedarray-ctor-bounds.test.js`. Its 107 cases test the TypedArray emulation (`makePseudoTypedArrayConstructor`) that #468 added. #468 is merged on ebfb `master` (commit `80e9b3e906`).
- On 2026-07-17 the PR was force-pushed and its base moved to `master-46d4edf`. That commit is upstream endo and doesn't contain #468.
- I ran the test file locally at the current head (`24e992ed3`): **96 of the 107 cases fail**. Only the 11 `BYTES_PER_ELEMENT` checks pass. A typical failure: `view.buffer` comes back as a plain ArrayBuffer instead of the immutable wrapper.
- With `src/` swapped for `origin/master`'s, all 107 new cases pass. The only 4 failures are existing "limitations" tests from the old base that master has since updated.
- CI has not run since the re-pin. The only check at `24e992ed3` is "Copilot Setup Steps" (green). The last full CI run was green on `3f026ca05` on 07-01, before the base changed. So the PR shows as mergeable with no failing checks, but it would go red as soon as CI runs.
- `ci-wait-merge.sh` couldn't read the PR: GitHub's GraphQL API is rate-limited for the bot (REST still works), so it gave no CI verdict. The decision above rests on the local test run.

**Coverage and dead code:** nothing to do. The PR changes no source code, so it can't leave anything unused. I pushed nothing to the PR.

**Follow-up:** I posted `endojs-endo-but-for-bots-pr586-weave-20261008` (weaver). It moves the PR base to the current ebfb `master` (the frozen `master-6ee3fda` already exists), rebases the 4 commits onto it, and verifies the package tests and CI. Once that's done, the gauntlet can be re-run. One correction: that job's body says 88 of 96 cases fail; the right figure is 96 of 107. The fix itself is unaffected.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr586-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1556734 cached reads)
- Output: 10341 tokens
- Cost: $1.0313908
- Wall-clock: 281s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
