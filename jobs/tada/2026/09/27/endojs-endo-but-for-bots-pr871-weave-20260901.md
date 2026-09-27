Rebased and force-pushed #871 as `e88511ea` onto frozen current upstream `llm` base `llm-efabaed` (`efabaed2`), and updated the draft PR base. GitHub reports `mergeable=MERGEABLE`; 63 CI checks are attached/in progress.

Checked supersession with `git cherry -v upstream/llm HEAD`: all 42 PR commits remained non-equivalent (`+`), so this was not a duplicate upstream.

Resolved conflicts preserving current daemon/Fae/Thixotrope behavior and SturdyRef intent. Removed one stale OCapN export exposed by the rebase. Posted the PR summary comment.

Verified:
- pass-style: 85 tests passed
- sturdyref: 8 passed
- agent-tools escrow: 3 passed
- OCapN SturdyRef tests: 19 passed per mode
- daemon SturdyRef tests: 32 passed
- Thixotrope hub: 11 passed per mode
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr871-weave-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (7 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (7 engagement(s) unpriced)
- Wall-clock: 3053s

<!-- garden-usage-end -->
