---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T04:11:09Z
---
SturdyRef press tick (04:05 dispatch, endo-sturdyref-press-20260717-040505) — STALL DECLARED on the #737 review-response lane; the maintainer-requested first-wins-shim build job is now POSTED.

Applied the 03:05 tick's armed stall criterion and every leg held (all from live output this tick, 04:06–04:10Z):
- Liveness ping 20260717T030939Z-704afb still in inbox/endojs-endo-but-for-bots-pr737-review-3363fee9/unread/.
- #737 head unchanged at ce7341b47d (updatedAt 00:42:12Z = the review itself); zero review-thread replies since the review (only kriskowal's own r3599652108 at 00:40:26Z); no issue comments; no shim job anywhere on the board; claim 3.5h old.

Root cause found (decisive, local — the peer claim is on this host): gardener-10's handler for endojs-endo-but-for-bots-pr737-review-3363fee9 FAILED at 00:43:48Z, rc=1 after 2s. Captured output blob ac1a1d97f4: "You've hit your session limit · resets 2am (UTC)". A usage-cap hit misclassified as a deterministic defect because it died under the 5s plausible-overrun floor. The cap reset at 02:00Z; the job was NEVER worked. Same signature for the orphaned 00:35 press claim (blob e6fe0633). gardener-10 has been idle-polling "no jobs in todo" ever since — not slow, dead.

Actions this tick:
1. Posted the maintainer-requested build job `ebfb-737-first-wins-sturdyref-shim` (directive identity endojs/endo-but-for-bots#737:comment:3599652108, so a re-post by the requeued review job dedups). Body carries the full review spec: first-wins global SturdyRef/fromLocation/toLocation, locator RECORDS (objects, no URL/URN coupling), globally-retained closely-held WeakMap, no SES permits, withheld from child compartments, @endo/harden + post-lockdown init, ponyfill-importable for eval twins, closely-held namespace + per-CapTP enliveners, and four load-bearing confinement tests (child compartment cannot see the global; guest cannot read a locator; first-wins convergence; hardened post-lockdown).
2. NO hand-requeue of the dead review claim: GARDEN_CLAIM_TTL=14400s makes it reapable at 04:43:28Z (the 00:35 press claim at 04:35:18Z) and garden-reaper.timer fires ~10-minutely, so the reaper requeues both by ~04:53Z with session continuity. Hand-moving would bypass the poison counters.
3. No project pushes — the shim is a full package build (delegated per charter); #737's branch stays untouched under the (dead, soon-reaped) peer claim.

Confinement statement: no code changed this tick, so no confinement surface moved; standing invariants as last verified on green ce7341b47d (swiss-num never a SturdyRef property; raw locator only in the closely-held session map). The posted job makes all three properties (no-location, no-identification, opaque/unforgeable) explicit acceptance bars with named tests.

Next tick: verify (a) the shim job got claimed and is moving; (b) the reaper requeued endojs-endo-but-for-bots-pr737-review-3363fee9 (and the 00:35 press claim) and a fresh claim is live — if the review job is STILL in doin/ unworked past ~05:00Z, the reaper is the anomaly: investigate garden-reaper.service logs and surface to the maintainer. (c) Watch for a handler-classification follow-up worth encoding: a sub-5s "session limit" death is transient-by-content even though it is fast — the GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS floor turned a quota blip into a false deterministic-defect escalation twice tonight.
