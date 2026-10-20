---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-20T18:08:43Z
job: kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-panel-4
claim: 159b7b7393f88cbb
---
PR #201 assessor review

**Verdict:** request-changes

**Findings:**
- must-fix — `src/endo/gateway/new-clip.ts:263-270` classifies any directory with a readable `form` containing `blank` or `inventory` as an app, but an app must also have an `inventory` directory. A normal directory can acquire a text child named `form` through the UI; returning to its parent then labels it an app. Clicking it makes the page call `list` on its nonexistent inventory and render a fatal error. Classify it with the same complete shape used by `isApp` (or require the inventory directory before adding `app: 'new-clip'`). [rule: designs/new-clip.md § 1]

Self-improvement: nothing this time.
