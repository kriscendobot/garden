orchestration-failed: true

**Clean stage for PR #1604 failed: CI is RED at head `5d9d93ad2ed1`.** I made no changes and pushed nothing.

`ci-wait-merge.sh` returned rc 3. The PR is a draft and the other 36 of 38 checks passed. The two failing checks are:
- `test-ironhorse-oracle`
- `ironhorse-oracle-sanitizers`

Both fail on the same test, `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage`, with 2 of 1711 cases failing:
- `stage3-math/054.js` fails on `SameValue(1.300820426840647, 1.3008204268406467)`.
- `stage3-math/055.js` fails on `SameValue(1.475044781241425, 1.4750447812414251)`.

These are last-digit floating-point differences on Math cases. The PR's diff touches none of those files. It changes the hardened262 baselines, whole-tree expectations, the iterator-tag tests, and fuzz seeds. This matches the stage3-math 054/055 red recorded in memory as pre-existing. I did not check the base branch's CI to confirm that.

I did not run the coverage pass, because the stage fails on CI regardless.

**Follow-up:** the maintainer needs to fix this pre-existing red, or decide to waive the two Math cases, before the gauntlet can pass. I did not post a successor job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1604-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 84 tokens (3161351 cached reads)
- Output: 11715 tokens
- Cost: $1.6908946999999999
- Wall-clock: 3891s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
