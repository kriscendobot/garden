---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-16T04:44:41Z
job: kriscendobot-minion.town-pr193-gauntlet-panel-1
claim: 15066a8d99b30cee
---
project: minion-town
refs:
  - jobs/todo/kriscendobot-minion.town-pr193-gauntlet-panel-1.md
---

PR #193 regression-evidence review

**Verdict:** request-changes

**Findings:**
- must-fix: `deploy/probe/ocapn-canary.test.mjs:162` claims the guest without a share has its capability leg skipped, but asserts only the aggregate `incomplete` status. I changed `deploy/probe/ocapn-canary.mjs:231` to test `to.share` instead of `from.share`; the test still passed because the reverse-direction leg was skipped. Assert that `capability:alice->bob` is skipped and that its capability send is absent, so the test pins the claimed source-guest behavior. [rule: skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
