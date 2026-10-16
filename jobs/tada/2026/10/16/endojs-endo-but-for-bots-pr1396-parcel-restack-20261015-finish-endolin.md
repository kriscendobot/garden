---
handed-off: endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split
deliverable-complete: false
---
Decomposed the PR #1396 finish into a durable serial orchestration with three self-contained shepherd jobs:

- Move the PR to the frozen base and verify its one-commit diff.
- Trigger and drive CI to green, fixing failures if necessary.
- Verify the final state and post the required completion-summary comment.

All children are parked under the `orchestrated` gate, owned by `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split`, with host and execution-role metadata. The serial orchestration is recorded on `origin/journal2` with halt-on-failure policy. No garden source changes were needed.

Follow-up: the orchestration watcher will promote each child in order and preserve the summary stage until the base and CI stages succeed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2559s

<!-- garden-usage-end -->
