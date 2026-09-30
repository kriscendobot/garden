## Retro report for endojs-endo-but-for-bots-pr1343-review-0d84baf9-retro

I recorded this review as **not a review miss** (category: new direction). The dismissal is stored at `review-misses/dismissed/endojs-endo-but-for-bots-pr1343-review-0d84baf9.md`; the store writer pushed it after one lost push race. No cluster was touched and no improvement job was posted.

**Idempotency:** no miss or dismissal record existed for this primary job before this run.

**Why it isn't a miss:** kriskowal's review 5360774903 asks for two things:
- The value side of `endowments` should be a pet-name path (an array of path components), not a single name.
- A follow-up job should make the whole Endo Exo surface accept only pet-name paths and reject a bare string.

At review time the PR head was `6c49234d80`, where the values were single host pet names. That followed the maintainer's own wording two days earlier (review 5344774604: "use pet names … instead of formula identifiers"). It also matched the existing Exo convention, which accepts either a pet name or a path.

No seat brief, skill or standing instruction requires array-only paths. The closest earlier signal is the 2026-09-04 direction on #897 and the design PR it produced, #1151. That PR is still an open draft with unresolved questions, including whether the pet-name registry is in scope. So the rule wasn't a settled convention a panel seat could have enforced. This review is the first place it's stated as policy for the whole surface, and the follow-up is a scope expansion.

**Process check:** #1343 is still a draft under the manual gauntlet trigger. This journal has no gauntlet or panel job for it and none was requested, so no review was skipped that should have run. This matches the earlier dismissal for the same PR (`…pr1343-review-fcb5f817`).

**Checked on GitHub, not taken from the primary's report:**
- Commit `eaa3fd3534` (2026-09-30T05:44Z) is on the PR head. It makes the values array-only paths, rejects bare strings, and merges `introducedNames` into `endowments`.
- Bot replies and a summary comment on the PR cite that commit.

**Discrepancy — follow-up job not confirmed:** the primary was acknowledged from host `endolin-garden2-5bcdff64` and posted jobs `ebfb-pr1343-endowments-fix` and `ebfb-petname-path-only`. None of these, nor the primary job itself, appears anywhere on this instance's journal. The fix on the PR exists, but from here I could not confirm that the path-only follow-up the maintainer asked for is actually queued on a board. Someone with access to endolin-garden2's board should check that `ebfb-petname-path-only` exists.

**Follow-up:** design PR #1151 has been an open draft since 2026-09-05, stuck after six design-panel rounds that all came back must-fix. It overlaps heavily with the new path-only follow-up, so the maintainer may want to fold the two together or close one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-review-0d84baf9-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (883177 cached reads)
- Output: 6913 tokens
- Cost: $0.7482393999999999
- Wall-clock: 316s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
