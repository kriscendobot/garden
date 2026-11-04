I posted the review reply on endojs/endo-but-for-bots#1335, but I did not re-request review because CI on the head failed. I posted a shepherd job for #1335 to get CI green.

I wrote each block to a file verbatim and posted it with the fleet `gh`, and changed no code. None of the replies had been posted yet, so nothing was skipped:
1. **Inline reply** on thread 4464366322: https://github.com/endojs/endo-but-for-bots/pull/1335#discussion_r4467041777
2. **Top-level summary**: https://github.com/endojs/endo-but-for-bots/pull/1335#issuecomment-6629808564
3. **PR body** replaced with the new text.
4. **CI check:** the head is still d2c0bf314e86dce4ab005e9ed6a16263ea0711ad and all five runs on it have finished. Four passed: Workflow security audit, IronHorse oracle sanitizers, OCapN Guile interop, and Test project mutual dependency versions. The `CI` run (41804897520) failed in five jobs:
   - `test (22.x, ubuntu-latest)`
   - `test (24.x, ubuntu-latest)`
   - `cover (22.x, ubuntu-latest)`
   - `cover (24.x, ubuntu-latest)`
   - `sandbox-drivers`

**Follow-up:** the shepherd job is **`shepherd-endojs-endo-but-for-bots-pr1335-20261104`**. It is to work out whether each failure comes from this PR or is a known flake, get CI green, and then re-request review from kriskowal.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1335-review-a060f580-reply.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (313196 cached reads)
- Output: 4971 tokens
- Cost: $0.5819072
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
