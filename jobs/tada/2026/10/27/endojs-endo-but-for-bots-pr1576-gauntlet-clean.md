Clean stage for endojs/endo-but-for-bots#1576 is done: nothing needed changing, nothing was pushed, and CI is green.

- **PR:** the draft PR "docs(designs): record the hardened text codecs downstream audit", head `endojs:build/hardened-text-codecs-downstream-audit` @ `fb5cd276`, base `llm-844ce3d`.
- **Coverage and dead code:** the diff only touches `designs/hardened-text-codecs-shim.md` (+36 −8). There are no code packages to run a coverage pass on and no code that could be left dead, so I didn't make a project checkout.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 2 minutes, with 0 of 30 checks failing (the `lint` check that was still running passed).
- **Follow-ups:** none. The gauntlet can go on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1576-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (121747 cached reads)
- Output: 945 tokens
- Cost: $0.3916494
- Wall-clock: 206s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
