---
role: designer
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Produce a design document under
`designs/` and land it on main2 (no PR — CLAUDE.md § Conventions). Status: Proposed;
change no runtime behavior in this job.

# Design: fleet telemetry, metric surfacing, and autonomous anomaly response

**Maintainer directive (kriskowal, 2026-08-04):** add telemetry to all garden
automation, and design how metrics are surfaced and how the garden observes and
reacts to its own anomalies.

## Ground this in real failures, not hypotheticals

The garden has a rich substrate already and STILL went blind repeatedly. Every item
below is an observed 2026-08-01/04 incident. Treat this list as the design's
acceptance criteria: *would the proposed system have caught this, and how fast?*

1. **Silent throughput collapse.** 2026-08-01 11:00–13:00Z: 41 Claude usage-cap
   handler deaths, **0 completions, ~20 jobs doomed**, across BOTH hosts (one shared
   subscription). Nothing alerted. Found only by a human asking. The signal was
   trivially available: completions-per-hour went to zero while claims continued.
2. **Claim/handler contradiction.** Gardeners could *claim* `tier: mentor` jobs but
   the Claude handler refused to *run* them, so the whole board was claimable and
   unrunnable. Diagnosed by hand from logs. A **claim→completion conversion rate**
   near zero would have named it immediately.
3. **A lying failure signature.** Jobs that die in 1–2 s to a cap rejection are
   parked with signature `deadline-overrun` and a notice asserting
   "elapsed≈GARDEN_HANDLER_TIMEOUT=2400s" — even for jobs declaring 7200. The
   metric that disambiguates (actual elapsed vs actual budget in force) is not
   recorded anywhere.
4. **A stalled deploy nobody escalated.** The leader's deployed root fell from 3 to
   **27 commits** behind `main2` over ~3 days, blocked by uncommitted files in the
   deployed tree. `garden-root-repo-guard` reported "root repo healthy" every 30
   minutes throughout, because worktree cleanliness is not one of its invariants.
5. **A correctness bug in the review system itself.** `gardening/panel.sh` named
   seats only "PR #<n>", so **~9 of 28 juror seats resolved that number against the
   ambient garden repo instead of the project** — a third of every panel reviewing
   the wrong repository, for an unknown period, with no signal.
6. **A host that died quietly.** `ps23` went silent for **3+ days**: its sysop never
   logged, 8 host-ops sat unconsumed, and the board still credited it 9 gardeners.
   No liveness metric exists.
7. **Duplicated human-facing discovery.** The wedged root-repo `gc.log` was
   independently rediscovered and reported by **8 different gardeners**, each
   spending a run to report the same fact, because there is no shared
   "known open incidents" surface for a worker to consult before escalating.
8. **A dead backend nobody noticed.** The Fireworks account was suspended and the
   scaler logged `probe fail streak 1855` (~31 h) before a human looked.
9. **Cost-ineffective automation at scale.** 85 auto-generated retrospective jobs
   (44% of the parked board) with an ~85% historical dismissal rate. Nothing
   measured "this job family's yield does not justify its spend."
10. **A production outage found by luck.** A `*.minion.town` wildcard TLS change took
    GitHub-login and SIWE down; the DoD for the change passed 5/5 because it only
    tested what the change was *supposed* to do. Found by a follow-up job, not a
    synthetic check.

## What already exists — reconcile, do not duplicate

Inventory before designing. The garden is NOT starting from zero:

- `usage/*.jsonl` (463 files) — per-run cost/model/host records. Already the closest
  thing to a metrics fact table.
- `reputation/` (2145) — per-arm outcome records.
- `panel-runs/` (71), `review-misses/` (267) — review-process outcomes.
- `sysop-log/` (175), `cursors/` (34), `entries/` (7961).
- Detectors: `watchdog-notice.sh` (coalesced, deduped, notice_count), `usage-meter.sh`,
  `root-repo-guard.sh`, `identity-drift-guard.sh`, `requirements-watch.sh`,
  `upgrade-monitor.sh`, plus the per-repo watchers.
- Surfacing: `docs/bulletin/` — an existing GitHub Pages app that already reads the
  journal without auth.

A design that invents a parallel metrics store while these drift is a failure. State
explicitly which of the above become the substrate and which are superseded.

## Constraints that are NOT negotiable

- **`journal2` is a PUBLIC repository.** Metrics are published the moment they land.
  No credentials, no account identity, no raw email. (Precedent set 2026-08-02: the
  per-host subscription identity is published as a **SHA-256 digest** with the
  pseudonymity limitation recorded — see `subscriptions/`.) Say explicitly what a
  hostile reader learns from the metric set, and design for that.
- **Detection must be deterministic and LLM-free.** Follow the `sysop.sh` precedent:
  plain code, closed vocabulary, no `claude -p` in the detection path. An anomaly
  detector that costs a model call per tick is itself an anomaly.
- **Do not create a new inbox flood.** On 2026-08-04 the board was consolidated
  108→84 precisely because auto-generated per-event jobs had swamped it. Any
  auto-response must coalesce like `watchdog-notice.sh` (one updating notice with a
  `notice_count`, not N messages), and must have an explicit escalation *ceiling*.
- **Leader/follower correctness.** Say which parts are leader-only singletons and
  which run per-host. Two collectors double-count; two responders double-act.
- **Drain-safe.** Say what the system does while a host is drained. Note that
  `gardener.sh` exits on the drain check BEFORE its bus read, so a drained host's
  workers observe nothing.

## Questions the design must answer

1. **What are the fleet's vital signs?** Propose a small, defensible set — completion
   rate, claim→completion conversion, doom rate by signature, elapsed-vs-budget
   distribution, deploy lag per host, host liveness, backend probe streaks, board
   depth by gate, spend per unit of landed work. Justify each by naming which incident
   above it catches. Resist a large dashboard nobody reads.
2. **Where do metrics live, and at what cadence and retention?** The journal is
   public, append-only-ish, and already large (7961 entries). Continuous per-tick
   metric writes will bloat it and every host pays that on every sync. Consider
   host-local collection with periodic aggregate publication.
3. **How are they surfaced?** Extend `docs/bulletin/` or add a companion? The
   bulletin already renders journal state without auth.
4. **What does the garden DO about an anomaly?** Define the ladder — record, coalesce
   into a notice, post a job, page the maintainer — and the threshold for each rung.
   The `host/<GARDEN>` sysop channel is the existing mechanism for a host-directed
   corrective action; consider whether anomaly response should drive it, and what
   stays permanently manual.
5. **What must NOT be automated?** Argue the boundary. Some of today's incidents
   (production TLS, the deployed root's uncommitted work) are exactly where an
   autonomous responder would have done damage.
6. **How is a detector itself verified?** A silent detector is indistinguishable from
   a healthy fleet — the failure mode that let #4 report "healthy" for three days.
   Propose heartbeats or synthetic anomalies.

## Output

A design doc in `designs/` with a Decision section, the metric set with per-metric
justification, the storage/cadence/retention model, the surfacing plan, the response
ladder with thresholds, and an explicit non-goals section. Name what you considered
and rejected. If the work is larger than one design, say so and propose the split
rather than producing something too thin to implement.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-04T05:50:16Z
