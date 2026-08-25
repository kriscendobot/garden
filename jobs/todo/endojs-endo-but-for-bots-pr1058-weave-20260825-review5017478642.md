---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-25T09:55:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Rebase and resolve conflicts for https://github.com/endojs/endo-but-for-bots/pull/1058.

The 2026-08-25 shepherd observed head 840bd481be6ffa4be1c657ec79bf4233609dd37b is 3 commits behind llm and GitHub reports mergeable=false, mergeable_state=dirty. Rebase the PR-owned head branch design/hardener-indexed-cardinality onto current llm, resolve conflicts according to the weaver role, run the required local gates, and push only with force-with-lease against the observed head.

<!-- garden-reaped: 1 -->
