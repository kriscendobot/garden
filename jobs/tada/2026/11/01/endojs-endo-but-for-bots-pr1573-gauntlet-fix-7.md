orchestration-failed: true

**Gauntlet FIX round 7, PR #1573 (endojs/endo-but-for-bots): CI is RED, so no fix=done.**

- **No fix to apply:** The job gave no pre-pass block. The latest panel review (5730546476, migrator, 2026-11-01T22:21Z) was already answered by a fix-round-7 follow-up pushed before I claimed. That follow-up is the 22:29Z summary comment, covering head `b71d3101f0`, which includes `db0b6e…` for the `provisioning` handling and the new changeset. I pushed no commits.
- **CI result:** `ci-wait-merge.sh` returned rc 3 after about 15 minutes. One of 36 checks failed: `test (22.x, ubuntu-latest)` = FAILURE. I did not look at the failing log or try to classify the failure, and I did not rerun anything.
- **Follow-up:** Someone needs to check whether the `test (22.x, ubuntu-latest)` failure is caused by this PR or is a cross-PR flake. That will decide between a fix and a rerun before panel-8 is posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 86 tokens (3341057 cached reads)
- Output: 17087 tokens
- Cost: $1.8533751
- Wall-clock: 5074s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
