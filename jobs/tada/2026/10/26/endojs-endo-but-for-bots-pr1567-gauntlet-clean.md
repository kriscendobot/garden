The clean stage for endojs/endo-but-for-bots PR #1567 ("test(floot): keep model routing check offline") had nothing to do: CI is already green at head `e8294ede88`.

- **PR state:** open, draft, based on frozen base `llm-d5ac419`.
- **What the PR changes:** one test file, `packages/floot/test/factory-system-prompt.test.js`. The colon-in-modelId test now stubs the provider lookup and `fetch`, and checks that no network request is made. No production code changed.
- **Coverage pass:** nothing to do. A change that only touches a test adds no new code paths to cover and leaves no dead code behind. I made no changes and pushed nothing.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1567 --no-merge` returned rc 0 (34 checks: 0 failed, 12 passed, 22 skipped).
- **Follow-ups:** none; the gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1567-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120673 cached reads)
- Output: 947 tokens
- Cost: $0.38706660000000004
- Wall-clock: 17s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
