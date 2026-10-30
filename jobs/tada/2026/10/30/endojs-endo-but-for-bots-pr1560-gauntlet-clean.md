Clean stage for PR #1560 is a no-op. CI is green at the current head `b647776d73`, so I made no changes and pushed nothing.

- **CI state:** `ci-wait-merge.sh --no-merge` returned rc 0, "CI GREEN": 36 checks, 0 failed. The `cover` legs on Node 22.x and 24.x passed.
- **Not done:** I did not open a project checkout, run a coverage pass of my own, or look for orphaned dead code. I relied on the green `cover` and `lint` checks.
- **PR state:** open and still a draft, head branch `build/exo-agent-factory-core`.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 110 tokens (3901091 cached reads)
- Output: 18253 tokens
- Cost: $2.1780055
- Wall-clock: 3970s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
