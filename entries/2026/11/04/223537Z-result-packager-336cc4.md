---
kind: result
role: packager
host: endolin-garden-ece02cb4
at: 2026-11-04T22:35:39Z
job: endojs-endo-but-for-bots-pr1648-gauntlet-panel-1
claim: 679569178422cd45
---
**Verdict:** request-changes

**Findings:**

- **must-fix** — Commit `a46a836e92` adds bare public exports at `packages/hosted-agent/package.json:57-59` for a root-private implementation. In this diff, `agent-factory.js` and `agent-guest-powers.js` are consumed only internally and by their package test, while `agent-factory-module.js` is loaded only by the daemon restart test through a file URL (`packages/daemon/test/agent-factory-restart.test.js:89`). The README likewise labels the factory root-private (`packages/hosted-agent/README.md:197-206`). Remove these public exports or mark them as test/internal exports, then revise `.changeset/hosted-agent-agent-factory.md:5`, which presently promises the public `@endo/hosted-agent/agent-factory.js` path. [rule: roles/jurors/packager/AGENT.md]

**Notes:**

- Scope: requested packager review of `endojs/endo-but-for-bots` PR #1648, limited to `0b8d24a114e1f7f20b766eeee9f056b0dcc4b6bc...HEAD`. The feature and lint commits are cleanly separated; no lockfile change is present.

Self-improvement: nothing this time.
