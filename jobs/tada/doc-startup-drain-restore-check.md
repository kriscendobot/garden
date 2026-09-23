Done. Job complete — writing the report.

## Completion report

**Job:** Revise the garden startup / re-start procedure so it detects and recovers a fleet left fully drained (the likely state after a deploy/upgrade whose draining marker outlives the upgrade).

**Root cause reflected in the docs:** `deploy-garden.sh` drains before merging. It lifts a drain *it engaged* on both success and its abort-belt paths — but a drain it did **not** engage (an operator `stand down`/`drain` it honored) or a hard kill before its lift leaves the draining marker behind. A gardener that starts under that marker logs `fleet draining; exiting cleanly` and exits, so every startup probe looks healthy (units installed, linger on, nothing failed, leader marker correct, scaler even logs `scaled to N`) while **0 gardeners actually run**.

**What changed** (3 files, docs/role-brief only on `main2`, direct push per CLAUDE.md § Conventions — commit `83bdb8899`):

1. **`context/operations/starting.md`**
   - New bring-up **step 5**: probe `drain-fleet.sh status`; on `DRAINING`, propose and (on yes) `drain-fleet.sh off` + `systemctl --user start garden-gardener-scaler.service`. Cross-references the deploy aftermath and points at the [restore] skill as the companion for reactivating stranded in-flight claims.
   - **Strengthened verify-after** from "empty `--state=failed`" to a *positive* liveness check: active `garden-gardener@*` units `> 0`, reconciled against the declared `hosts/$GARDEN` `gardeners:` value, with the explicit "scaler logged scaled-to-N but 0 active ⇒ suspect a stale drain" signature called out.

2. **`roles/liaison/AGENT.md`**
   - Stand-up contract: "standing up is not done until the drain is lifted and the pool is verified *positively* live," terse, with command-level detail delegated to `starting.md`.
   - Deploy-on-upgrade Monitor section: a **drain-aftermath** note plus the point-3 trade-off — we keep un-drain **operator-confirmed at re-start** rather than force-lifting in the deploy, because an unconditional auto-lift would silently resume a fleet an operator *intentionally* paused, undermining deliberate-deploy. Flagged as the maintainer's call to revisit.

3. **`context/operations/deploy.md`**
   - New "The drain can outlive the deploy" section making the residual-drain case discoverable from the deploy page, pointing at `starting.md` step 5.

**Recommendation surfaced (not silently applied), per the job's point 3:** deploy semantics are left unchanged; the safe default is the checked, operator-confirmed uncork at re-start. The trade-off is written into the liaison brief for the maintainer to decide.

**Verification:** rebased and pushed to `origin/main2` on first attempt (CAS clean). No executable changes were needed — the existing `drain-fleet.sh status`/`off` and scaler commands already provide the primitives. Inbox drained, empty.

**Follow-ups:** none required. Optional, if the maintainer wants it later: a tiny `scripts/jobs/` positive-liveness helper (wrapping the two `list-units` checks + the drain probe) so the re-start check is one command instead of three — deliberately not added here to keep the change docs-only as scoped.
