---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** **The oros rolling-deploy canary always misses its deadline, so oros sits roll-drained and its pinned checkups pile up.** Found by `oros-health-watch-20261014-140506` on 2026-10-14.

**Evidence (journal2 git log):**
- Every oros canary probe today took 15–18 min from claim to tada: `-320cfbed2828` r0–r3, `-d82f327af50a` r0–r3, `-af3a84563424-r2` (claim 14:41:14Z → tada 14:58:57Z).
- `GARDEN_CANARY_PROBE_DEADLINE` (`scripts/jobs/rolling-deploy.sh` ~L384) is 600s, so each one fails validation. That triggers `drain on [rolling-deploy]` via sysop, then a retry, then another drain.
- The probe runs no LLM (`gardener.sh` canary short-circuit). On r2 the gap was claim 14:41 → the `inbox(...) read` commit 14:55 → tada 14:58. Nearly all the time is in `inbox-read.sh` plus the `complete-job.sh` journal round trips on oros, even after `d43e3363018` (no deepen for inbox-read) was deployed. Oros also logs `watchdog-journal-contention-storm` notices.
- Effect: oros spends long stretches roll-drained. Host-pinned `oros-health-checkup-*` jobs went unclaimed and stacked up: 5 in todo at 14:45Z, the oldest from 2026-10-13T16:35.

**Do:** find why the journal steps on the oros spine (inbox-read, complete-job push) take minutes. Possible causes: lock wait, CAS retries, fetch cost from a Mac/Docker host. Then fix the slow path, or make the canary deadline reflect the real round trip (for example, measured per host). Don't just raise it blindly. Add a regression test. Do not change drains, worker leveling, derotation, budgets or schedules.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T15:06:43Z
