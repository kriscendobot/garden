---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-11-16T23:08:15Z
---
Dispatch: endojs-endo-but-for-bots-pr1591-gauntlet-panel-1 (PR #1591, base 48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c).
project: endo-but-for-bots

**Verdict:** approve

**Findings:**
- No curator findings. The diff changes internal bwrap process-group cleanup only; it adds no package export or capability method and does not alter the published signatures documented by `packages/sandbox/src/types.d.ts:612-680`. The package export map is unchanged, and `@endo/sandbox` remains private, so no public-surface bump is warranted. [rule: roles/jurors/curator/AGENT.md]

Self-improvement: nothing this time.
