**Completion report — endo-sturdyref-press-20260717-003509 (resumed 00:35 press tick)**

My original 00:35 session died at 00:35:18Z to a genuine session-cap hit (rc=1 after 2s) that the fleet's classifier misread as a deterministic defect; the 04:05 press tick diagnosed that, posted the maintainer-requested shim build job, and left three next-tick checks. This resumed session verified all three and encoded the fix the incident demanded.

**Verified (with evidence):**
- **Shim landed**: `ebfb-737-first-wins-sturdyref-shim` completed → DRAFT PR endojs/endo-but-for-bots#774 (`build/sturdyref-shim-first-wins`, base `llm`, head `9eb314ea98`; `gh pr view 774` → OPEN, draft). Its report cites ava 8 passed / eslint clean / tsc clean with four confinement tests (no-location, no-identification, withheld-from-child-compartments, first-wins convergence).
- **Reaper recovery**: the stalled `endojs-endo-but-for-bots-pr737-review-3363fee9` job was requeued and re-claimed fresh at 04:53:22Z on endolin-garden2 — the #737 review-response lane is live again. #737 head unchanged at `ce7341b47d`; I pushed nothing to project branches (anti-collision: the review job owns that branch).

**Built and landed (garden main2 @ `4325a6087f`):** the classifier fix — explicit session/usage-cap wordings ("hit your session limit", "resets N (UTC)") are now exempt from the `GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS` floor, since a real cap rejection is one fast API round trip; ambiguous overload-shaped signatures (429/5xx/overloaded, the 2026-07-03 batch) keep the floor. New `is_explicit_cap_signature`/`GARDEN_EXPLICIT_CAP_SIGNATURES` in `common.sh`, floor branch updated in `gardener.sh`, both suites extended and green: `claude-session-limit-classifier-test.sh` → **24 passed, 0 failed**; `elapsed-constancy-classifier-test.sh` → **28 passed, 0 failed** (new SUBTEST 7 pins the exemption end-to-end). This removes the failure mode that killed this press lane twice in one night; it deploys with the next deliberate garden deploy.

**Confinement statement:** no sturdyref behavior changed this tick (garden-infra only), so no confinement surface moved; the effort's newest artifact #774 pins all three properties (no-location, no-identification, opaque/withheld) as named tests per its completion report — not re-executed here.

**Recorded:** progress entry `entries/2026/07/17/050140Z-progress-gardener-b47708.md` with next-tick guidance (watch the live #737 review claim for movement; stack order #774 → #737 → bridge cuts → #541 → agent provide/accept). Inbox drained; empty.
