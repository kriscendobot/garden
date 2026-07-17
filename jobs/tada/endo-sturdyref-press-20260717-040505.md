All done and verified: the shim job landed on the board and was claimed by gardener-2 within a minute, the progress entry is on `origin/journal2`, and my inbox is empty. Final report:

## Completion report — SturdyRef press tick (2026-07-17T04:05 dispatch)

**Outcome: the stalled #737 review lane was diagnosed to root cause and unblocked — the maintainer-requested first-wins-shim build job is posted and already claimed by a live builder.**

**Stall criterion applied (armed by the 03:05 tick; every leg verified from live output 04:06–04:10Z):** the liveness ping `20260717T030939Z-704afb` was still unread in the peer's inbox; `gh pr view 737` showed the head unchanged at `ce7341b47d` (updatedAt 00:42:12Z, the review itself); `gh api pulls/737/comments` showed zero thread replies since the review; no shim job existed anywhere on the board; the peer claim was 3.5h old. Lane declared stalled.

**Root cause (decisive, local):** the "peer" was never working. `journalctl` on this host shows gardener-10's handler for `endojs-endo-but-for-bots-pr737-review-3363fee9` failed at 00:43:48Z, rc=1 after 2 seconds; the captured output blob (`ac1a1d97f4`) reads "You've hit your session limit · resets 2am (UTC)". A usage-cap hit was misclassified as a deterministic defect because it died under the 5s plausible-overrun floor, so the claim sat orphaned in `doin/` while gardener-10 idle-polled. The 00:35 press claim died the same way (blob `e6fe0633`).

**What I did:**
1. Posted `ebfb-737-first-wins-sturdyref-shim` (builder role) — the job kriskowal's inline review comment r3599652108 explicitly asked for — with directive identity `endojs/endo-but-for-bots#737:comment:3599652108` so a re-post by the requeued review job dedups. Body carries the full spec: first-wins global `SturdyRef`/`fromLocation`/`toLocation`, locator records as objects (no URL/URN coupling), globally-retained closely-held WeakMap, no SES permits, withheld from child compartments, `@endo/harden` + post-lockdown init, ponyfill-importable for eval twins, and four load-bearing confinement tests. Verified landed (`todo` commit `053453e7fc`) and **claimed by gardener-2 at 04:11** (`4ba0bf2136`).
2. Deliberately did NOT hand-requeue the dead review claim: `GARDEN_CLAIM_TTL=14400s` makes it reapable at 04:43:28Z and the reaper timer fires ~10-minutely, so it requeues by ~04:53Z with session continuity and intact poison accounting.
3. Pushed progress entry `entries/2026/07/17/041107Z-progress-gardener-eadac8.md` with the full diagnosis and next-tick criteria (shim job moving; review job requeued by ~05:00Z, else investigate the reaper).
4. No project pushes — the shim is a full package build, correctly delegated; #737's branch stays untouched under the soon-reaped claim.

**Not verified:** no test bars run — no project code changed this tick.

**Confinement statement:** no behavior changed, so no confinement surface moved; standing invariants as last verified on green `ce7341b47d` (swiss-num never a SturdyRef property — no-identification; raw locator only in the closely-held session map — no-location). The posted job makes all three properties explicit acceptance bars with named tests.

**Follow-ups:** next hourly tick verifies the shim build is moving and the reaper requeued the review + 00:35 press claims. Worth encoding separately: a sub-5s "session limit" death is transient-by-content — the `GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS` floor turned one quota blip into two false deterministic-defect escalations tonight.
