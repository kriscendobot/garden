Clean stage for endojs/endo-but-for-bots PR #1355: nothing needed doing, so this stage changed nothing.

- **PR shape:** The PR is open and out of draft. It only touches design documents (`designs/README.md` and `designs/hardened-url-shim.md`), with no package source. That means there is no code for the coverage pass to measure and no dead code it could have orphaned.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN) at head `3c06675b1be`: 28 checks finished, none failed. The checks that ran (lint, zizmor and the four "Detect CI changes" jobs) passed. The other checks were skipped because nothing they cover changed.
- **Changes:** I made no commits and pushed nothing to the PR head. I skipped the isolated project checkout because there was nothing to edit.
- **Follow-ups:** None. The gauntlet can go on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156853 cached reads)
- Output: 1056 tokens
- Cost: $0.35717860000000007
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
