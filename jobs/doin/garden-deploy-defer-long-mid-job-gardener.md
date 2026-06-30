# deploy-garden: stop a single long mid-job gardener from aborting (and fleet-pausing) every deploy

**Garden-infra reliability issue (recurring).** `deploy-garden.sh`'s DRAIN step
waits for **every** busy gardener to quiesce (`busy_count == 0`) before it merges,
bounded by `GARDEN_DEPLOY_DRAIN_TIMEOUT` (600s). When a single gardener runs a job
longer than 600s — the **ymax0 chain-state repros** and **scholar LangChain/LangGraph
ingests** both exceed it — the deploy **aborts**, so the upgrade never lands. Worse:
each doomed attempt **engages the drain for the full 600s**, pausing the whole fleet
(no new claims) before aborting, and a naive retry loop repeats that 600s fleet-pause.
Observed twice on 2026-06-30 (gardener-88 chain-state repro; gardener-30 scholar
ingest). The earlier concurrent-restart fix (`4a564169d`) did not touch this path.

**Goal:** a deploy should not pause the fleet for 10 minutes on a doomed attempt, and
a single long-running job should not indefinitely block upgrades — **without** ever
letting a gardener run half-old / half-new code.

**Options to weigh (pick the safest that removes the fleet-pause thrash):**
1. **Fast pre-check, no doomed drain.** Before engaging the drain, sample
   `busy_count`; if it won't plausibly quiesce within a short bound, **bail
   immediately without engaging the drain** (so the fleet is never paused on a
   doomed attempt) and let a later trigger retry. Cheapest; stops the thrash even if
   it doesn't make the long-job deploy land sooner.
2. **Deploy only when idle (trigger side).** Have the upgrade signal / liaison only
   attempt the deploy when the fleet is at/near idle, so the merge consistently hits
   a quiesced fleet.
3. **Adaptive / configurable drain deadline** rather than a flat 600s.
4. **Deferred-deploy mode** — quiesce+restart only the idle units, let a long gardener
   re-exec on completion. **CAUTION / assess first:** the root ff-merge advances the
   code under a still-running gardener. Determine whether an in-flight gardener is
   isolated enough (it runs in its own `scratch/gardener-wt-*` worktree, but invokes
   role/skill scripts from the **root** checkout) to tolerate the root changing
   mid-job. If not safe, do NOT pursue this option.

**Deliverable:** eliminate the repeated 600s fleet-pause on long-job deploys (at
minimum option 1 or 2), with a test under `scripts/jobs/test/` (extend
`deploy-garden-test.sh` / `mock-systemctl.sh`) proving a long mid-job gardener no
longer pauses the fleet on a doomed attempt and never causes a half-migrated run.
Land on `main2` via an **isolated worktree off origin/main2** (commit explicit
pathspecs, push `HEAD:main2`). Touch only the deploy path:
`scripts/jobs/deploy-garden.sh` (+ its helpers / the upgrade-monitor trigger if you
take option 2).

---
claim:
  host: endolinbot2
  gardener: 25
  claimed_at: 2026-06-30T03:39:29Z
