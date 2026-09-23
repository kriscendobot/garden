The follow-on job has already been claimed and completed (it's in `tada/`). Everything is done and landed. Writing the completion report.

---

**COMPLETION REPORT — garden-deliberate-deploy-no-shared-tree-development**

All deliverables landed on `origin/main2` (my commit `fe2d9f296`; a peer has since refined `deploy-restart.sh` in `f94b54713`). Built in an isolated worktree off `origin/main2`, explicit-pathspec commit, pushed via a rebase-CAS loop. The root `/home/kris` tree was never edited.

**What I built**
- **`designs/deliberate-deploy.md`** — the design pass: branch model, the hard worktree rule, the deploy process, the upgrade monitor, state layout, follow-on work.
- **`deploy-garden.sh`** — the deterministic drained deploy: DRAIN (engage marker) → QUIESCE (wait for gardener busy-markers to clear, bounded by `GARDEN_DEPLOY_DRAIN_TIMEOUT`) → MERGE (ff-only to `origin/main2`, aborts without clobbering on a dirty/diverged root) → record deployed sha → LIFT drain → RESTART the long-running fleet. Aborts restore the pre-deploy drain state (lift only if we engaged it).
- **`deploy-restart.sh`** — sourceable restart library, factored from the retired `deploy-sync.sh` (the single home for "which long-running units re-exec onto new code").
- **`upgrade-monitor.sh`** + **`garden-upgrade-monitor.{service,timer}`** — deterministic, no-LLM, no-tree-side-effects detector: writes/clears `$GARDEN_STATE/deploy/upgrade-ready` exactly when `origin/main2` is ahead of the deployed sha; silent and self-clearing otherwise. Units follow the peer's new convention (`/bin/bash`-exec, `OnCalendar`+`Persistent`); no self-heal wrapper, honoring the no-LLM requirement.
- **`common.sh`** — deploy host-standing-state config + `deployed_sha`/`record_deployed_sha` helpers; `GARDEN_MAIN_BRANCH` centralized.

**Retired the continuous-ff path**
- Removed `deploy-sync.sh`, its test, and `garden-deploy-sync.{service,timer}`; added the units to `install-units.sh` `RETIRED_UNITS` (already-installed hosts disable them).
- `watchman.sh`: `GARDEN_AGGRESSIVE_CHECKOUT` now defaults **off**; keeps only its broadcast, which becomes a post-deploy reread signal (local tree HEAD now changes only at deploy).

**Worktree hard rule + Monitor wiring (docs)**
- `roles/COMMON.md` § Per-subagent worktrees (the hard rule), gardener + watchman role briefs, `roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor, `CLAUDE.md` bring-up step 7 + § Deliberate deploy.

**Tests** (standalone suites, matching the removed `deploy-sync-test.sh` pattern): `deploy-garden-test.sh` (35 cases — clean deploy, no-op, quiesce-wait, quiesce-timeout-abort, dirty/diverged abort, pre-drained lift/preserve) and `upgrade-monitor-test.sh` (16 — up-to-date silence, ahead signal, stale-clear, bootstrap HEAD fallback). Both green; `wedge-resolve-test`/`enable-services-test` regressions confirmed still green after my changes.

**Follow-ups**
1. **Branch naming NOT confirmed by the maintainer** — I messaged the question (keep `main2` as dev / what the root tracks as "deployed") and proceeded on the documented default (dev = `main2`, root advanced only by `deploy-garden.sh`, deployed-sha in `$GARDEN_STATE/deploy/`). Everything is parameterized via `GARDEN_MAIN_BRANCH`, so a consolidation onto `main` is a one-variable change. **This still needs a maintainer answer.**
2. **Mechanical worktree enforcement** in the gardener `claude -p` launch path (cwd = a fresh per-job worktree, reconciled with the deterministic-session-id resume) was decomposed into follow-on job `garden-enforce-per-subagent-worktree` — now already completed (in `tada/`). The hard rule ships here as the documented norm; that job adds the physical guard.

Self-improvement: nothing this time — the existing `feedback_garden_infra_jobs_use_isolated_worktree` norm already covered the worktree discipline I followed, and this change codifies it into the library.
