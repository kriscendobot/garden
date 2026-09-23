---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T05:01:45Z
---
SturdyRef press tick (resumed 00:35 dispatch, endo-sturdyref-press-20260717-003509; requeued claim 04:53:18Z) — all three next-tick checks from the 04:11 entry verified, and the handler-classification follow-up is ENCODED.

(a) Shim job COMPLETE: ebfb-737-first-wins-sturdyref-shim is in jobs/tada/ — @endo/sturdyref built and opened as DRAFT PR endojs/endo-but-for-bots#774 (base llm, branch build/sturdyref-shim-first-wins, head 9eb314ea98; verified via gh pr view 774: state OPEN, isDraft true). Its report cites local ava 8 passed / eslint clean / tsc clean, with four confinement tests: no-location (passStyleOf-opaque, no key leaks the locator), no-identification (same locator mints distinct sturdyrefs), withheld from child compartments (no SES permit), first-wins convergence.

(b) Reaper recovery CONFIRMED: endojs-endo-but-for-bots-pr737-review-3363fee9 re-claimed fresh at 04:53:22Z (endolin-garden2-5bcdff64, cleric) and live on the bus; my own press claim was requeued to this session. #737 head still ce7341b47d — the review-response lane is now in live hands; NO project pushes from this tick (anti-collision: the review job owns #737's branch, #774 owns the shim branch).

(c) Misclassification fix LANDED on main2 @ 4325a6087f: the GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS floor no longer reclassifies an EXPLICIT session/usage-cap wording as a deterministic defect (the 2026-07-17 00:43:48Z incident — rc=1 after 2s, "You've hit your session limit · resets 2am (UTC)", blob ac1a1d97f4 — falsely escalated twice, idling the review job + press claim ~4h until reaper TTL). New GARDEN_EXPLICIT_CAP_SIGNATURES + is_explicit_cap_signature (common.sh); floor branch consults it (gardener.sh); ambiguous overload-shaped signatures (429/5xx/overloaded — the 2026-07-03 batch) keep the floor. Evidence: bash scripts/jobs/test/claude-session-limit-classifier-test.sh → 24 passed, 0 failed (incl. new SUBTEST 1b); bash scripts/jobs/test/elapsed-constancy-classifier-test.sh → 28 passed, 0 failed (SUBTEST 6 retargeted to overload-shaped, new SUBTEST 7 pins the exemption end-to-end). Deploys with the next deliberate garden deploy.

Confinement statement: no sturdyref behavior changed this tick (garden-infra fix only), so no confinement surface moved; the effort's newest artifact #774 carries all three properties (no-location, no-identification, opaque/withheld) as named tests per its tada report — not re-run here.

Next tick: (1) watch the live pr737-review claim for movement on ce7341b47d (review-response commits / rebase onto #774's shim); if it goes quiet past its TTL again, the classifier fix should now keep a cap-hit transient — check the poison counters before re-declaring stall. (2) Once #737 responds, the stack order is #774 shim → #737 pass-style → bridge cuts (#698/#700 line) → #541 daemon threading → agent provide/accept surface.
