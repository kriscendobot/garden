---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-16T04:48:16Z
job: kriscendobot-minion.town-pr193-gauntlet-panel-1
claim: 15066a8d99b30cee
---
PR #193 corner-prober review, originating from the supplied direct dispatch.

Reviewed only git diff origin/main-30a4c62...HEAD in /home/kris/garden/scratch/project-wt-kriscen-650adf042b10-3d131391.

Covered: missing file; insecure mode; malformed JSON; singleton/invalid guest configuration; normal two guests; status empty/skipped/fail/pass; repeated equal locator redaction; valid and absent edge name; two directional happy path; delivery, startup, binding, eval-output failures; missing share; CLI exit mappings.
Missing: duplicate guest name; duplicate locator (same held guest); overlapping locator prefixes; direct auditRecord raw-detail redaction; empty/malformed guest collection variants; poll zero/one/multiple-attempt timing.

Findings: scrub processes secrets in supplied order, so a locator that prefixes another leaves the longer locator suffix in audit detail. loadGuests accepts duplicate labels and duplicate locators as two usable guests. auditRecord serializes a raw supplied detail despite its token-free contract.

Verification: node --test deploy/probe/ocapn-canary.test.mjs (17/17 passing). Self-improvement: nothing this time.
