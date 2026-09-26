The concurrent commits are meter-calibration fixes (reset-anchor alignment, midweek entitlement epochs) from the in-flight diagnose work; they shift line numbers but do not touch the no-signal-reads-as-zero paths my top finding cites, and the audit document explicitly pins its citations to commit `36360f0ab5`. The deliverable is landed. Completion report follows.

# Completion report — audit-garden-automation-cybernetics

**Deliverable landed:** `designs/cybernetics-audit.md` (581 lines) plus an index row in `designs/README.md`, committed as `ebbc6915a9` and pushed to `origin/main2` as `3fd0adce6a` (one rebase over concurrent meter-calibration commits `75af103e01`/`6647a1173e`; those change window anchoring, not the sensor-blindness paths the audit cites, and all citations are pinned to the audited checkout `36360f0ab5`). The design carries no unresolved maintainer-facing open questions — every decision its findings touch already has a home (existing Proposed designs and the three live diagnose jobs) — so per the CLAUDE.md carve-out it landed bare, no review PR.

**What the audit contains:**
- **Loop inventory** (§1): all four families — capacity (budget-level, scaler, backend probe, claim gate, foreman, drain, brake, budget-refresh), lifecycle (claim CAS, reaper, gauntlet, orchestrate, unblock, scheduler, deadline-nudge), producers, and keepers/guards — each with sensor, setpoint provenance, actuator, period, and failure posture, with file:line citations throughout.
- **Sensor validity** (§2): the spend proxy chain and the calibration incident as one class; the confirmed inversion where a blind spend sensor reads as zero and drives budget-level to maximum workers (`usage-meter.sh:196,302` at the audited commit); uncalibrated placeholder caps getting full actuator authority; the environment-validity class (noexec deploy gate, fixed by `3411c580d3` hours before the audit, with two named residuals); the 19% panel seat-error noise routed into the gauntlet's one non-retryable branch; the silent `tier: builder` budget loss traced to `job_tier`'s silent rc-1 plus write-side non-validation; and the silent-detector list.
- **Backpressure** (§3): exactly two producers bound output by downstream state (foreman, fuzz release serialization); the fuzz flood re-framed as missing triage plus an unread doom signal, not missing serialization; the maintainer inbox's one uncoalesced write path; the scheduler bypassing the fleet admission gate, drain, and occupancy dedup.
- **Loop interactions** (§4): five writers on one worker-count line with no arbitration and a kind-drift open-loop hazard; the inode sensor and inode actuator existing unwired in the same tree; the cap-consistency guard's bounded emergent stall judged correct-but-surprising (observed live: the stale 149M cap still in `budget/live/` an hour after the 385M raise); doom classification's single consumer edge; the human as controller in three loops.
- **Gain/delay/oscillation** (§5): budget-level as a memoryless full-step P controller on a sensor up to ~45 min stale, contrasted with the inner probe loop's hysteresis; the panel/fix loop's non-monotone plant.
- **Sound loops named as findings** (§6): reaper, sysop-under-drain, drain/brake truth table, alert coalescers, the `d28a2d5f76` retry direction, and others.
- **Ten ranked recommendations** (§7), each classed missing-loop / wrong-sensor / bad-coupling and tied to observed evidence; four explicitly not-recommended actions to protect existing safety properties.

**Evidence basis:** four parallel code surveys over `scripts/jobs/`, `scripts/systemd/`, and `designs/` (spot-checked load-bearing citations by hand), plus direct journal measurement on 2026-09-01: 77 fuzz repairs quarantined in `plan/`, 88 of 465 panel-run records `disposition: error` (18.9%), the live budget snapshots, and the `config/budget-pools` calibration narrative.

**Follow-ups:** none posted — the recommendations are maintainer-ranked options, and the causal investigations they defer to (`diagnose-budget-meter-overreport-ece02cb4`, `diagnose-panel-fix-loop-oscillation`, `diagnose-panel-seat-error-rate`) are already live on the board.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/audit-garden-automation-cybernetics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 21 tokens (1925083 cached reads)
- Output: 26737 tokens
- Cost: $21.52445150000001
- Wall-clock: 921s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
