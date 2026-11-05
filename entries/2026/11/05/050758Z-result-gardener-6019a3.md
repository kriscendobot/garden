---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-05T05:08:02Z
job: kriscendobot-minion.town-pr250-gauntlet-panel-2
claim: 3d8f6964631bc33b
---
**Verdict:** request-changes

**Findings:**
- should-fix: `designs/api-key-agent-directory-authorization.md:94-100` invokes a transport rubric through "rows 1, 5, and 7" and the default "CapTP inside" rule, but neither is defined or linked in this design. A reader deciding how to add an owner or delegated management operation cannot discover why REST or CapTP applies. Replace the dangling row references with the operative criteria (or link to the authoritative rubric) and make the table self-contained. [proposed-rule: A design that assigns transports to user-facing operations must state or directly link every decision rule it invokes.]

**Notes (out of scope but worth flagging):**
- None.

Originating dispatch: PR #250 ergonomist review.
PR: kriscendobot/minion.town#250.
Self-improvement: nothing this time.
