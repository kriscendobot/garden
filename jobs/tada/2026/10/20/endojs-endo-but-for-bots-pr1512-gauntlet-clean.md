Clean stage for endojs/endo-but-for-bots PR #1512 was a no-op: there was nothing to clean and CI is already green at the current head.

- **What the PR changes:** it is a draft that touches only `designs/ocapn-noise-session-reconnect-protocol.md`, a design document. There is no package code, so there are no touched packages to run a coverage pass on and no dead code the change could have orphaned.
- **CI:** I read the Actions runs for head `75a361e7ed03bec9c19b65dbfff64cba2049a180`. All five completed successfully: CI, OCapN Guile interop, IronHorse oracle sanitizers, Test project mutual dependency versions, and Workflow security audit. I took this from the Actions API and did not run `ci-wait-merge.sh`.
- **Changes:** I made no project checkout, commits or pushes.
- **Follow-ups:** none for this stage. The gauntlet can move on to panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1512-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (56908 cached reads)
- Output: 800 tokens
- Cost: $0.30149360000000003
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
