---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-09T00:44:17Z
---
role: jurors/benchmarker (panel seat, round 6)
dispatch: pr1227-gauntlet-panel-6
pr: endojs/endo-but-for-bots#1227 "docs: design guest bot incarnation on mailbox delivery"
diff: designs/daemon-guest-bot-incarnation.md (+874), designs/README.md (+1). Design-only.
surfaces walked: PR body (Scaling Considerations), 6 commit subjects, the added design doc. Zero review threads on the PR (`pulls/1227/comments` and `issues/1227/comments` both empty), so the body, commit messages and the design document are the whole primary surface.

Optimization claims found and closure state:

1. Lazy restart recovery ("avoiding a restart stampede across every provisioned bot", line 394; Alternatives "Start every bound bot at daemon startup ... makes restart cost proportional to provisioned guests", lines 841-843). OPEN. The scan still walks every reachable bot-bound guest and reads each mailbox store index at every daemon start, and lines 397-402 concede a history-retaining mailbox always matches the "at least one numeric message entry" predicate. For the retain-history population this design targets, the predicate admits every guest, so restart fan-out is proportional to provisioned guests after all. No measurement, no bound, no "not pursuing" note, and no Test Plan item for it. Disposition: must-fix-loop. [rule: roles/jurors/benchmarker/AGENT.md § Operating norms]

2. Backoff and breaker constants (1s base, doubling, 5-minute cap; eight failures in a fifteen-minute window; the "about sixty seconds" flapping illustration, lines 407-429). OPEN. Presented as tuned values with no derivation, no measurement, and no note that they are provisional. Test 5 verifies the mechanism under a controllable clock, not the thresholds. Disposition: summary-fix. [rule: roles/jurors/benchmarker/AGENT.md § Operating norms]

3. "keeps worker cost proportional to active guests" / one incarnation per guest (line 139). CLOSED by "not pursuing" rationale: lines 141-144 explicitly put shared-incarnation co-tenancy out of scope for this increment and name the three properties a sharing design would have to rework.

4. Delivery does not await bot startup (lines 321-322, 336-344). CLOSED: categorical claim, verified structurally by Test Plan item 3 (delivery returns after durable commit while startup is blocked).

5. "Verify an empty bot-bound guest starts no worker" (Test 4) closes the categorical half of the laziness claim. It does not close the fleet-scale half in finding 1.

6. Rejected alternative "Reuse followMessages() for the wake" (lines 836-840). CLOSED by decline with a cost rationale.

7. Deferred `followBotStatus()` subscription and `listBots()` catalog. CLOSED by explicit deferral in § First Increment and Deferred Work.

verdict: request-changes (one must-fix-loop, one summary-fix).

Self-improvement: this seat's default disposition table assumes a code PR where a benchmark is runnable. On a design-only PR no measurement can exist yet, so the useful closure is a stated measurement obligation on the implementing increment or an explicit provisional-constant note. Worth proposing that the brief name that third closure form for design-only diffs, so the seat does not either over-demand a benchmark that cannot be run or wave every design claim through.
