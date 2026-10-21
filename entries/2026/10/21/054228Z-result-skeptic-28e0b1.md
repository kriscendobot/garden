---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-21T05:42:29Z
job: endojs-endo-but-for-bots-pr1517-gauntlet-panel-1
claim: 5abfaff45aed1eba
---
PR: endojs/endo-but-for-bots#1517
Dispatch: endojs-endo-but-for-bots-pr1517-gauntlet-panel-1

**Verdict:** request-changes

**Findings:**
- (must-fix) `designs/invitation-enclosures.md:148-160` promises all-or-nothing creation, but does not specify a transaction or compensating rollback for the inviter's correspondent slot and graph edges if formula persistence fails. The current seam executes invitation deferred tasks before `formulate` (`packages/daemon/src/manager.js:5301-5328`), so merely adding pins does not establish that guarantee. Define the commit order and rollback for every post-resolution failure, and add injected failures for formula persistence, edge installation, and deferred pet-store writes. [rule: roles/jurors/skeptic/AGENT.md § Operating norms]
- (must-fix) The minion.town path at `designs/invitation-enclosures.md:312-317` requires redeeming `coupon` before acceptance, while `:295-301` says enclosures supply neither route hints nor daemon `provide` and only work if their consumer already has a route or resolver. A fresh visitor has not yet accepted the invitation, so the design leaves the bootstrap's ability to resolve the identifier unstated. Specify the bootstrap-side resolver or route establishment and test the fresh-visitor path without preconfigured Endo peer state. [rule: roles/jurors/skeptic/AGENT.md § Operating norms]

Self-improvement: nothing this time.
