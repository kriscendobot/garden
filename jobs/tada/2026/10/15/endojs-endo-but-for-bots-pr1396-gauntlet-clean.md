---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage, PR #1396 (endojs/endo-but-for-bots): CI is RED, and the cause is inherited from lower PRs in the stack. Nothing in this PR is at fault.**

**What I did**
- Checked the PR: it is a draft and open, head `3202ecdd9`, base is the frozen `build/parcel-captp-wire-6d089a6`. The diff touches only `.changeset/parcel-cross-instance-forwarding.md` and `packages/ocapn/test/parcel.test.js` (+28/−0).
- Made an isolated project checkout at `/Users/dom/garden/scratch/project-wt-endojs--422e6a529294-7f1a01bc`.
- Coverage and dead-code pass: the change adds only a test and a changeset. There is no new source code to cover and nothing left orphaned, so I made no changes and pushed nothing. Prettier passes on the PR's own test file.
- Ran `ci-wait-merge.sh --no-merge`, which returned **rc=3 (RED)**.

**Failing checks**
- `lint`: FAILURE. Prettier flags two files that this PR does not touch:
  - `packages/pass-style/test/parcel-gated-global.test.js` (added by #1392, `build/sturdyref-pass-style-recognition`)
  - `packages/patterns/test/rankCover.test.js` (added by #1393, `build/sturdyref-marshal-representation`, commit `d4f9539f4`)
  
  The base commit `6d089a6` fails `lint` on the same two files, so the failure comes from lower in the stack. The heads of #1392 and #1393 still have it.
- `test-thixotrope-ironhorse`: CANCELLED. Nothing in this PR touches it.
- Every test, cover, interop and release check passed.

**Follow-ups**
- I did not apply the Prettier fix here, because it would add an unrelated duplicate diff to this stacked PR. The board already has `pr1392-gauntlet-clean`, `pr1393-gauntlet-clean` and the `parcel-restack-20261015-r5527149922` jobs for #1392, #1393 and #1394. Once those reformat the files in their own PRs and the restack re-pins this PR's base, re-run this clean stage. Whoever handles #1392 and #1393 needs to run `prettier --write` on those two files.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (849160 cached reads)
- Output: 5836 tokens
- Cost: $0.6651440000000002
- Wall-clock: 435s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
