Clean stage for endojs/endo-but-for-bots#250 — nothing to do: CI is green at the current head and nothing was pushed.

- **PR:** "ci: disable npm lifecycle scripts in workflows (master-base mirror of #126)". It is open and not a draft. The head is `endojs:ci/no-npm-lifecycle-master` at `6029ba736a8e` and the base is `master-46d4edf`.
- **Idempotence check:** The PR touches only 8 files, all under `.github/workflows/*.yml`. No package source is touched, so the coverage pass had nothing to cover and the change left no dead code to remove. I didn't create a project checkout.
- **CI:** Every check in the status rollup for the current head passed (20 checks), including the test matrix (22.x and 24.x on ubuntu and macos), test262, cover, lint, the browser tests, xs, hermes and the ocapn interop jobs. `ci-wait-merge.sh endojs/endo-but-for-bots 250 --no-merge` returned rc 0 and reported 19 total, 0 failed, CI GREEN.
- **Follow-ups:** None.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (112552 cached reads)
- Output: 955 tokens
- Cost: $0.35249839999999993
- Wall-clock: 14s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
