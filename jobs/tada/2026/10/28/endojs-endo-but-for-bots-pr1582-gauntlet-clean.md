Clean stage for endojs/endo-but-for-bots PR #1582 is done: nothing needed changing, nothing was pushed, and CI is green at the current head.

- **PR:** "ci: run Browser Tests on any base and pin runners to Ubuntu 24.04". It is a draft from the in-repo branch `ci/browser-tests-any-base-ubuntu-24.04`, targeting base `master-ebc7904`, at head `55f7733e83`.
- **No coverage pass:** the PR only touches `.github/workflows/browser-test.yml` and `.github/workflows/depcheck.yml`. It changes no package code, so the coverage-driven-testing pass doesn't apply.
- **No dead code:** I read the diff. It removes the `master`-only `pull_request` branch filter and pins both jobs' runners to `ubuntu-24.04`, each with a comment explaining why. It leaves nothing unused behind.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 5 minutes. All 15 checks finished with 0 failures; the two macOS-15 test legs were the last to finish.

There are no follow-ups. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1582-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177498 cached reads)
- Output: 1191 tokens
- Cost: $0.41339159999999997
- Wall-clock: 385s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
