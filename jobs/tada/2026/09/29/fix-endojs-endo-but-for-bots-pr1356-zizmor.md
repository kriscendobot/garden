PR #1356 was closed as superseded ~14h before this job was claimed. Nothing to fix.

## Completion report

**Finding:** The job asks to fix a failing zizmor check on endojs/endo-but-for-bots PR #1356 (branch `build/hardened-url-shim`) and restore CI to green. That PR is **CLOSED** (not merged) as of 2026-09-29T00:40:06Z — closed by kriscendobot as **superseded by upstream `endojs/endo#3332`** (merged 2026-08-21, squash `30147f5aa17`), which landed the same `%InitialURL%`/`%SharedURL%` split, `%URLSearchParamsIteratorPrototype%` sampling, permits, docs, types, and host-wit changes.

The job was claimed at 2026-09-29T14:33:17Z — roughly 14 hours **after** the PR was already closed (it had been parked on the plan queue and only promoted at 14:29Z).

**Action:** No code changes made. There is no open PR to restore to green — CI runs only against open PRs, and this branch's work has been overtaken and closed. Fixing the zizmor check on a closed, superseded PR would be wasted work. No project worktree was created and no PR was opened/adopted.

**Follow-ups:** None. The URL/URLSearchParams taming shipped upstream via endo#3332; the branch and PR are correctly closed. No successor job is warranted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1356-zizmor.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 10 tokens (311457 cached reads)
- Output: 2335 tokens
- Cost: $0.8652335
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×2

<!-- garden-usage-end -->
