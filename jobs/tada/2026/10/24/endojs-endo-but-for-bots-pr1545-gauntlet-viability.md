PR #1545 passes the viability gate. It is open, unmerged and a draft, nothing has displaced it, and the request behind it still stands, so the gauntlet can start. I spent no clean, panel, fix or CI budget.

Deciding question: Is #1545 still the only implementation of `@endo/exo-dynamodb`, does it sit on the current `llm` tip, and does the design it builds still stand with no rival implementation or maintainer rejection?
Answer: yes.

Evidence:
- **PR state:** open, draft, not merged. It was opened 2026-10-24T04:03Z as one commit (`95ff807a07`) that adds a new package, `packages/exo-dynamodb`, plus a changeset, composite tsconfig wiring and `yarn.lock` lines. It has no comments or reviews yet.
- **Base is current:** the PR's frozen base `llm-d5ac419` points at `d5ac41980a`, which is also the current `llm` tip (`llm` is 0 commits ahead). So no newer base history could have replaced it.
- **Not superseded:** `packages/exo-dynamodb` does not exist on `llm` (404). Searching PRs for "dynamodb" finds only design PRs and #689, which wires an AWS storage platform into a daemon flavour, not this capability package. None of them implements recursively attenuated DynamoDB facets.
- **The motivation still holds:**
  - The PR builds the design in kriscendobot/minion.town#221. That design is still open as a draft and has not been rejected. Its two bot panel reviews say the approach is sound and ask for gap fixes, not a different direction.
  - The design answers kriskowal's review on minion.town#144, which asked for a reusable way to recursively partition and attenuate DynamoDB authority before a confined caplet receives it. Nothing since has withdrawn that request.
  - The design keeps the generic Endo package and the minion.town integration as separate builds, and this PR is the Endo package.
- **One caveat for later stages:** the PR body says DynamoDB Local and isolated-IAM integration tests should be added before it is promoted for upstream review. That is not a viability problem, but the gauntlet should know about it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1545-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179277 cached reads)
- Output: 1684 tokens
- Cost: $0.43880739999999996
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
