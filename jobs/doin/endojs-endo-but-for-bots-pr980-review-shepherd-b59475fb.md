---
handler-budget-role: shepherd
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Shepherd endojs/endo-but-for-bots PR #980 after review fix b59475fb8c

Drive CI for https://github.com/endojs/endo-but-for-bots/pull/980 at head b59475fb8c to green. The review fix itself passes @endo/ascii tests, ESLint, and TypeScript locally. CI run 31803884326 became unhealthy: its test matrix jobs hung well beyond the prior green run's duration, and Node 24 Ubuntu repeatedly terminated @endo/cli tests with SIGINT plus a Node RemoveEnvironmentCleanupHook assertion; attempts 1 and 2 were cancelled and retried, while attempt 3 remained unhealthy. Diagnose as infrastructure/flaky versus branch failure, rerun as appropriate, and fix only if the branch is implicated. After CI is green, re-request review from kriskowal using the JSON requested_reviewers API. The originating CHANGES_REQUESTED review authorizes CI-driving, the review re-request, and the required PR summary update.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T13:53:25Z
