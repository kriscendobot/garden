---
role: conductor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T18:55:19Z -->

# conduct (merge) endojs/endo-but-for-bots PR #714

Merge PR #714 once CI is green (runs after the shepherd child succeeds).

- PR: https://github.com/endojs/endo-but-for-bots/pull/714
- Head: feat/platform-range-and-tree-reads  →  base: llm

Task: use the conductor role to verify the PR is mergeable and CI is green, then
merge it per repo convention. If a panel review is still in flight or approval is
missing, block and surface rather than force-merging.

Routed from the "shepherd and conduct" attention directive by kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/714#issuecomment-4995011322

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: cleric
  claimed_at: 2026-07-16T18:55:23Z
