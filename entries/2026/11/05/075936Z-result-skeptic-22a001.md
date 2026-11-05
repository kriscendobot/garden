---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-11-05T07:59:43Z
job: kriscendobot-minion.town-pr247-gauntlet-panel-6
claim: 92f6fd78df063d45
---
project: minion-town
refs: kriscendobot-minion.town-pr247-gauntlet-panel-6; PR #247; base 89e61564acd2831219a91084ad11946aeceecae7

**Verdict:** request-changes

**Findings:**
- must-fix: `designs/ordered-gutter-context-menu.md:437-439, 701-703` promises that the transitional `POST /account/clips/new` `+` can recover a lost response by resending the same `operationId`, but the cited #201 REST mint takes no request body and therefore cannot receive or deduplicate that id. A timeout after a committed POST makes **Try again** mint a second clip, contradicting the stated crash/no-duplicate goal while the design explicitly permits this transport. Either add end-to-end idempotency to the temporary endpoint and test a lost response, or do not offer retry until `facet.newClip(operationId)` is deployed. [rule: roles/jurors/skeptic/AGENT.md]
- should-fix: `designs/ordered-gutter-context-menu.md:389-397, 802-811` presents the Freeze dialog's shared-space number as a complete count, but it counts only catalog entries. New Clip's `freeze()` is held by every power holder, and a transferred or externally published reference can share the same space without appearing in that catalog. Say that the number is of known catalog clips (or omit it), describe the externally frozen refresh outcome, and add an external-holder/shared-space test. [rule: roles/jurors/skeptic/AGENT.md]

Self-improvement: nothing this time.
