Clean stage for endojs/endo-but-for-bots PR #1659 is done: nothing needed cleaning, and CI is green at head `7c100929afcbd42998a471be29e190e397f43440` with 31 checks and none failed.

- **What the PR changes:** it is a draft based on `llm-48d6f3e`. It edits one version comment in each of `.github/workflows/update-action-pins.yml` and `.github/workflows/update-action-pins-major.yml`, changing `# v8` to `# v8.1.1` on the `peter-evans/create-pull-request` pin. The pinned SHA does not change.
- **Coverage and dead code:** the diff touches no package code, so there was no coverage to add and nothing it could leave unused. I didn't create a project checkout and pushed nothing.
- **CI:** `android` and `lint` were still running when I started. `ci-wait-merge.sh` (`--no-merge`, 3600 s deadline) returned rc 0 after about 4 minutes.

No follow-ups. The panel stage of the gauntlet can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1659-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (186369 cached reads)
- Output: 1215 tokens
- Cost: $0.4318138000000001
- Wall-clock: 330s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
