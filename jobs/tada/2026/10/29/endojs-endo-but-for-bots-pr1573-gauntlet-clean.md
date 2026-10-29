**Clean stage for PR #1573: no changes made, CI green.**

- **PR state:** open and still a draft. Head is `71b9ab575bd3f5899832d8373cb7dcbf2b0f237d`. The latest commits are the hosted-agent type and primitive-check fix, the yarn.lock update, and the provider phase-one decisions.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with 36 checks and 0 failed. The `cover` checks (22.x and 24.x) passed. The CANCELLED entries in the status rollup are superseded earlier runs; the current run succeeded.
- **Coverage pass:** I did not run a local one. I treated the stage as a no-op because CI, including the cover legs, is already green at the current head. No dead code was removed and nothing was pushed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 128 tokens (4396093 cached reads)
- Output: 22994 tokens
- Cost: $2.2474674
- Wall-clock: 8351s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
