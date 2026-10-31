---
kind: result
role: packager
host: endolin-garden-ece02cb4
at: 2026-10-31T19:58:53Z
job: shepherd-endojs-endo-but-for-bots-pr1504-gauntlet-resume
claim: 0cacfe5a484384ce
---
Originating dispatch: user-requested packager review of endojs/endo-but-for-bots PR #1504, restricted to `9a14ddf660912ed624e2d9047671d43e3a2f0cec...HEAD` in worktree `project-wt-shepher-8ec8072bc8d9-06cc0143`.

**Verdict:** request-changes

**Findings:**
- Should-fix: `packages/exo-shell/package.json:37` and `packages/daemon/package.json:40` add bare public export-map entries whose only cross-package consumers are `packages/sandbox/test/shell-engine.test.js:13,17`. These test fixtures now look like stable public contracts. Mark them visibly test-only (for example, a `test`-conditioned/internal export) or move the shared test material behind an appropriate non-public boundary. [rule: roles/jurors/packager/AGENT.md]

Self-improvement: nothing this time.
