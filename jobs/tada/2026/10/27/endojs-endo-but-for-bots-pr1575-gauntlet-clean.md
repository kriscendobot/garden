---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage, endojs/endo-but-for-bots #1575: CI red

The coverage pass is done and pushed, but CI is red at the new head `0a9119c7ea`. `ci-wait-merge.sh` returned rc 3 with one failing check, so this stage counts as failed and I'm not emitting `clean=done`.

**The failing check:** `Test project mutual dependency versions / build` → "Check for cycles": `scripts/graph.sh: line 32: tred: command not found` (exit 127). The PR's code doesn't cause this; the CI environment does:
- The `build` job only runs when a PR changes package dependencies. #1575 does, through `packages/hosted-agent/package.json` and `packages/lal/package.json`. Other PRs skip the job and show green.
- Whenever the job does run on the `ubuntu-26.04` runner image, `tred` is missing, even after `apt install graphviz` succeeds. It failed the same way on the base PR branch `feature/api-key-provider-registry` and on #1575 before my push.
- Fixes are already open upstream: endojs/endo-but-for-bots#1566 ("install graphviz-tools…") and #1546 ("restore dependency cycle checks"). Once #1566 lands on `llm` and this stack is rebased onto it, this check should go green. There is nothing to change in #1575 itself.

Every other check is green, including `lint`. My first push broke `lint` with a prettier formatting slip in the new tests; the second commit fixed it.

## Coverage pass (two commits pushed with `safe-push-pr-head.sh`, `2515a686ff` → `0a9119c7ea`)

- **`packages/lal/test/brokered-messages.test.js`:** five new tests.
  - Four cover `makeBrokeredMessagesStream`, the adapter Lal actually uses, which had no coverage: history translation with tools added and removed, a tool-use turn, a broker 401 reported as an error event, unsupported history refused before the broker is called, and an aborted turn.
  - One covers provider disposal: a pending request is cancelled and later turns are refused.
  - `brokered-messages.js` lines went from 62% to 98%. The rest are malformed-wire rejections, which belong to adversarial testing.
- **`packages/hosted-agent/test/anthropic-api-key-issuer.test.js`:** tests for issuer reuse, refusal when a provider's secret changes, revocation on `close()`, and the disposal hook on the module entry point `make()`. Lines went from 92% to 100%.
- **`packages/hosted-agent/test/inference-provider-registry.test.js`:** a test showing that switching the daily budget from dollars to tokens needs confirmation.
- **Dead code removed in `packages/fae/src/provider-owner.js`:** the brokered branch's `subscription` guard could never fire, because `assertBrokeredMessagesRecipe` already refuses every field except kind, inference, model and maxTokens.
- **Checks run locally:** eslint and prettier are clean, the repo-root `tsc -p tsconfig.json` is clean, and all affected test files pass.

## Notes
- The registry's remaining gaps are mostly two-line refusal guards, which are adversarial-test territory. `makeEndoSecretParticipant` is also uncovered, but this PR doesn't touch it.
- Locally, `hosted-agent` provider-worker tests fail only under c8 and pass without it. The Fae `inbox-durability` test failed locally, but this PR doesn't change it. Neither affects CI.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (5690190 cached reads)
- Output: 23384 tokens
- Cost: $2.4966539999999995
- Wall-clock: 1485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
