---
kind: result
role: novice
host: endolin-garden-ece02cb4
at: 2026-10-15T11:14:46Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-3
claim: f48c641507033de5
---
Refs: originating dispatch for kriscendobot/minion.town PR #189.

**Verdict:** request-changes

**Findings:**

- **must-fix** `designs/clip-shell-framework.md:154-204` introduces CORP and COEP only as header names, then asks the reader to accept the load-bearing conclusion that neither blocks embedding. A new reader has no model for which policy belongs to the shell, which belongs to the clip, or how a nested navigation relates to either; the citations do not supply that bridge. Add a short before-and-after request-path explanation before the specification detail, then state why the unchanged headers lead to the proposed result. [proposed-rule: A design's central cross-origin-policy conclusion must first give new readers a minimal model of the participating documents, their policies, and the request being evaluated.]

- **must-fix** `designs/clip-shell-framework.md:3-11,111-117,449-462` establishes that this is a design-only revision and that no code ships, but open question 2 still says "this PR lands that header" and describes it as the current change. This leaves a reader unable to tell whether the anti-framing header is an earlier implemented fact or part of the pending proposal. Recast that passage to name it as an already-landed static-surface change (and, if useful, identify its prior change), reserving this revision for the live-embedding contract. [proposed-rule: When a design revision distinguishes shipped behavior from a proposed increment, every "this PR" reference must unambiguously identify which side of that boundary it describes.]

Self-improvement: nothing this time.
