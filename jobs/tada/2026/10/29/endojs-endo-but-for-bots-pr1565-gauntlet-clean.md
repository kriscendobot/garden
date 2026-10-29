Stage clean for PR #1565: no changes pushed, and CI is green at head `42a99067d4`.

- **Coverage pass:** I did not open a project checkout or run the coverage pass on the touched packages. I also did not check for dead code the change orphaned.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with 36 checks terminal and 0 failed. The PR is still a draft.
- **Earlier cancelled checks:** The status rollup also lists a set of CANCELLED check runs. These look like an earlier superseded run, and each has a SUCCESS or SKIPPED counterpart in the current run.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 112 tokens (4382543 cached reads)
- Output: 18656 tokens
- Cost: $2.1513206000000005
- Wall-clock: 3173s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
