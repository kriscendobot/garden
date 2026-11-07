---
kind: result
role: novice
host: endolin-garden-ece02cb4
at: 2026-11-07T19:01:49Z
job: endojs-endo-but-for-bots-pr1653-gauntlet-panel-1
claim: 09d4de95890ecc6a
---
project: endo-but-for-bots
refs: jobs/doin/endojs-endo-but-for-bots-pr1653-gauntlet-panel-1.md
PR: #1653

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/ordered-directory-formula.md` § "Revisioned read and edit surface": the shared TypeScript-like interface declares `applyPatch` and `followPatches` before the document says whether natural directories expose either method. The later open question leaves a new reader unable to tell which API each proposed formula actually has, even though that distinction defines the proposal. State a provisional capability matrix, or make the declarations explicitly conditional, before introducing the methods. [rule: roles/jurors/novice/AGENT.md § Operating norms]

Self-improvement: nothing this time.
