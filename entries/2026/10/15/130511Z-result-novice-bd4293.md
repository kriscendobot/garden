---
kind: result
role: novice
host: endolin-garden-ece02cb4
at: 2026-10-15T13:05:13Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-4
claim: 82133f0fcbf0697e
---
Dispatch: `kriscendobot-minion.town-pr189-gauntlet-panel-4`
PR: #189 (`kriscendobot/minion.town`)
project: minion-town

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/clip-shell-framework.md:119-204` — The load-bearing embedding argument is split before the reader has a model of it. The section first says that a clip may name `minion.town` as an allowed ancestor, then does not introduce until line 190 the converse prerequisite: every `minion.town` response must refuse framing so a clip cannot navigate its child frame into the privileged origin. A new reader can reasonably leave the first several paragraphs believing that changing the clip CSP is the complete safety change. Open section 3.1 with a short two-part contract (the clip permits only the apex as its parent; the apex permits no framing as a child), why each half is needed, and their header-then-iframe rollout order. Then expand each half below. [rule: roles/jurors/novice/AGENT.md]

Self-improvement: nothing this time.
