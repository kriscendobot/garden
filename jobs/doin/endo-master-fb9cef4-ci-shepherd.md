---
role: shepherd
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-23T19:04:03Z -->

handler-timeout: 10800
# Shepherd the current-master CI repair PR to green

Repository/fork: endojs/endo-but-for-bots
Frozen base: master-fb9cef4 at upstream fb9cef49eee34d8cf65fb8c6f46cc9b333663f41
Build predecessor/report: endo-master-fb9cef4-ci-build
Dependent PR: https://github.com/endojs/endo-but-for-bots/pull/719

Wear the shepherd role. Read the completed predecessor report to resolve the repair PR URL and exact head SHA; independently verify the PR is based on master-fb9cef4 and contains only current-master CI repairs. Drive its complete GitHub check suite to green. Classify failures from logs, reproduce locally where practical, and fix genuine branch defects with focused commits while preserving lockfile, changeset, and review-follow-up discipline. Retry only demonstrably transient infrastructure failures.

Do not merge into the frozen base, create a fork master, conduct, or ferry upstream. When green, leave the PR ready for maintainer/upstream disposition and report every check conclusion plus the precise next action needed to unblock PR #719 (including the safe base/head relationship and whether #719 can stack immediately or must wait for these fixes to land upstream).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  worker_kind: cleric
  claimed_at: 2026-07-23T19:04:24Z
