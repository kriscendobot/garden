Viability verdict for endojs/endo-but-for-bots PR #60: **proceed**. The PR is open, unmerged and not a draft. Nothing newer has replaced it, and the gap it fills is still there.

**Deciding question:** Does the base branch (`master` or `llm`), or upstream endojs/endo, now have a replacement for the deleted get-intrinsics test, or has endojs/endo#390 been closed? If so, PR #60 has been overtaken. Answer: **no**.

**Evidence:**
- **PR state:** open, not a draft, head `488646a2b3`, base pinned to `master-46d4edf`. The only file it changes is `packages/ses/test/get-intrinsics.test.js`, a new test that rebuilds the shim's expected values for each anonymous intrinsic independently and checks they are the same objects (`===`) the shim returns.
- **Motivating issue:** endojs/endo#390 ("Need new test that tests something like obsolete get-intrinsics.test.js") is still open upstream.
- **No replacement exists:** `packages/ses/test` on `master`, on `llm`, and on upstream endojs/endo has only `_check-intrinsics.js`, `frozen-anon-intrinsics.test.js`, `permits-intrinsics.test.js` and `repair-intrinsics.test.js`. There is no get-intrinsics test or equivalent.
- **Review history:** kriskowal asked on 2026-06-09 to rerun the gauntlet ("Please rerun the improved gamut."). That rerun ended clean, and nobody has commented since asking to close or replace the PR.
- **Rebase risk:** `master` is 77 commits ahead of the pinned base and touches `packages/ses/src/get-anonymous-intrinsics.js`, `intrinsics.js` and `permits.js`. That means a rebase will be needed, and the test's final check that the shim's set of intrinsic names matches the test's may need updating. This is normal maintenance, not a sign the PR is obsolete. In fact, that final check exists to catch exactly this kind of drift.

I spent no clean, panel, fix, CI-wait or un-draft budget. I made no commits or pushes and opened no PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr60-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (224878 cached reads)
- Output: 2782 tokens
- Cost: $0.9075880000000001
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
