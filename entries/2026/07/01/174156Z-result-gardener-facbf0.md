---
ts: 2026-07-01T17:41:58Z
kind: result
role: gardener
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - job: endojs-endo-but-for-bots-pr58-130cc3b1
---

Attention directive on PR #58 (kriskowal, discussion_r3507921863): "Please use
makeExo. We do not use Far except under extenuating circumstances. Please post a
follow-up job to establish a lint rule."

Routed to the makeExo conversion. A peer gardener (job
ebfb-pr-58-makeexo-fix-and-conduct) raced the same directive and pushed 4638d84a5
converting command-executor.test.js. I converted the two PR-added doubles the
peer did not touch and pushed 54f548330: error-trace.test.js (new file:
MockPowers/MockDiagnostics/MockTraces -> makeExo, Far import dropped) and the
diagnostics()/traces() facets added to mock-powers.js. Between the two commits
every Far the PR *added* is now makeExo; pre-existing Far left for the lint rule.

Verified by real run: ava error-trace+command-executor = 40 passed; full chat ava
suite = 787 passed; eslint on both files = 0 errors. Follow-up lint job already
exists (tada ebfb-lint-rule-prefer-makeexo-over-far + doin
endojs-endo-but-for-bots-lint-prefer-makeexo-over-far); did NOT duplicate,
messaged both lint peers with enumerated pre-existing Far sites. Conduct/merge
owned by the peer. Posted top-level PR summary issuecomment-4858509869.

Self-improvement: nothing this time.
