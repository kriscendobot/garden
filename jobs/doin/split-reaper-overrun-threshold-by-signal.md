---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

# Split reaper overrun thresholds by signal

`GARDEN_REAP_OVERRUN_THRESHOLD` is still 1 in `scripts/jobs/reaper.sh`, but one counter represents two different signals. Preserve one-observation doom for a genuine handler wall hit (`rc=124` at the applied handler budget). Require two confirming elapsed-constancy observations before doom-parking the fast-failure path.

Current evidence (2026-08-14): 33 `jobs/plan/` records have `doom_signature: deadline-overrun`; journal commit reasons identify 17 as handler wall-clock overruns, 9 as elapsed-constancy, and 7 older than the reason-tagging window. All 9 identified elapsed-constancy records were parked with `deadline_overruns: 1` and remain parked. This is the over-parking risk: a noisy or correlated fast failure gets no second observation, while another `rc=124` run would only waste a full handler budget.

Implement a reason-preserving marker/counter or equivalent split so the reaper can apply distinct thresholds without weakening the wall-hit path. Keep productive-cycle and outage/quota exemptions intact. Update stale comments that still alternately describe threshold 1 and 2. Add hermetic tests proving: wall hit parks after one nonproductive observation; elapsed constancy requeues after its first confirmation and parks only after the second; productive/outage cycles do not accrue either path; promotion/parking strips all new cycle markers. Run the focused reaper, elapsed-constancy, handler-budget, productive-cycle, outage, and promotion suites.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T05:55:59Z
