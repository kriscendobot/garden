---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr714-shepherd-conduct-4995011322
priority: normal
role: conductor
posted_by: producer
posted_at: 2026-07-16T17:59:53Z
---

# conduct (merge) endojs/endo-but-for-bots PR #714

Merge PR #714 once CI is green (runs after the shepherd child succeeds).

- PR: https://github.com/endojs/endo-but-for-bots/pull/714
- Head: feat/platform-range-and-tree-reads  →  base: llm

Task: use the conductor role to verify the PR is mergeable and CI is green, then
merge it per repo convention. If a panel review is still in flight or approval is
missing, block and surface rather than force-merging.

Routed from the "shepherd and conduct" attention directive by kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/714#issuecomment-4995011322
