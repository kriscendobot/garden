The diff is the single design file (212 lines). The job is complete.

## Completion report

**Job:** `design-cpu-back-pressure-job-dispatch-20260918` (designer). Clean re-run after a cross-host reaper requeue — no prior work was committed or in the journal, so I re-derived from scratch.

**What I did:**
- Gathered grounding on the existing claim gate (`claim-job.sh`: `fleet_draining` → `pool_admits`), the budget hysteresis (`budget-level.sh` dwell/confirm + `usage-meter.sh` 0.85 mark), the fail-closed budget carve-out (`credit-controls-fail-closed-pools`), `watchdog-notice.sh` coalescing, and the busy-marker scale-defer. Confirmed there is **no** existing CPU/PSI/loadavg awareness anywhere in `scripts/`.
- Wrote `designs/cpu-back-pressure-job-dispatch.md` (~1.5 screens) covering all six required points:
  1. **Signal:** PSI `/proc/pressure/cpu` `some avg10` chosen (contention stall time, not run-queue length), `loadavg1/nproc` fallback.
  2. **Hysteresis:** two water lines (PSI 50/25, loadavg 1.5/1.0 defaults) via a host-local throttle marker — same asymmetric intent as `budget-level`, realized as water lines because the claim edge is event-driven.
  3. **Fail open** — stated explicitly as the deliberate opposite of the fail-closed budget gate.
  4. **Admission only, no preempt** — drain shape, composes with the busy-marker scale-defer.
  5. **Observability** — one coalesced `watchdog-notice.sh` per host per episode, keyed `load-gate-<GARDEN>`, edge-triggered on marker create/clear.
  6. **Claim-edge only**, production left alone; production-damping deferred as future work.
  - Plus alternatives, a test plan, an inline state-ownership note (single-component → no formal ownership map owed), and a real `## Open questions` section (threshold calibration, kind-awareness, PSI availability, escalation).
- Validated the mermaid state diagram with the real parser (`OK stateDiagram`, rc=0).

**What changed / where it landed:**
- Design landed on `main2` (commit `f7feb280cc`), diff = the one design file (212 lines).
- Because it carries a non-empty `## Open questions`, opened it as a review PR per the garden-repo carve-out: frozen base `main2-024f3a0`, head `design/cpu-back-pressure-job-dispatch`, non-draft, marked `<!-- garden-design-open-questions -->` (answer surface, exempt from gauntlet-staging) — **kriscendobot/garden#103**.

**Follow-ups (not this job):** the upstream `packages/daemon` daemon-teardown leak (to be filed against `endojs/endo-but-for-bots`) and the ~100 stale `scratch/project-wt-*` worktrees are both noted as out of scope. No implementation was done (design-only, as specified); the maintainer answers the open questions on #103.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-cpu-back-pressure-job-dispatch-20260918.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 46 tokens (1562046 cached reads)
- Output: 25173 tokens
- Cost: $3.24010325 (1 engagement(s) unpriced)
- Wall-clock: 623s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
