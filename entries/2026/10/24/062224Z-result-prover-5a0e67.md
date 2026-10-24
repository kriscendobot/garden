---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-24T06:22:26Z
job: endojs-endo-but-for-bots-pr1542-gauntlet-panel-3
claim: a96a4917fac14f3b
---
Originating dispatch: `endojs-endo-but-for-bots-pr1542-gauntlet-panel-3`.
PR #1542, `endojs/endo-but-for-bots`.

**Verdict:** request-changes

**Findings:**

- **must-fix** `packages/sandbox/test/bwrap.test.js:1162-1189` does not pin the
  setup-window regression.  The test passed after reverting the added
  `--info-fd` plumbing and direct-init kill path in
  `packages/sandbox/src/drivers/bwrap.js:888-982` in an isolated checkout.
  Its post-spawn 0-7 ms delays do not reliably force cancellation before bwrap
  arms `--die-with-parent`.  Make that ordering deterministic, then show that
  the test fails with the old group-only kill implementation. [rule:
  skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
