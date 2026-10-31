Clean stage for PR #1587 is done. CI is green on all 35 checks at the current head, and I pushed no changes.

- **No new coverage run:** At the start, both `cover` jobs (22.x and 24.x on ubuntu) had already passed at this head. I did not check out the branch or run a separate coverage pass or dead-code sweep.
- **CI wait:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 15 minutes. Only the `test (24.x, macos-15)` job was still queued when I started.
- **PR state:** The PR is still a draft and open.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1587-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 64 tokens (2050121 cached reads)
- Output: 11609 tokens
- Cost: $1.3512646999999998
- Wall-clock: 5977s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
