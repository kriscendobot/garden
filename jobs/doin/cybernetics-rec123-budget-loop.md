---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendations 1, 2, and 3 of `designs/cybernetics-audit.md` § 7
(landed 2026-09-01). They are grouped into ONE job because all three touch
`scripts/jobs/usage-meter.sh` and `scripts/jobs/budget-level.sh`; land them as
THREE ordered commits in this sequence so no concurrent editors fight over the
same files. Work per `skills/self-improvement/SKILL.md`.

**Commit 1 — rec 1 [wrong sensor]: make spend-sensor blindness hold, not
maximize.** Distinguish "no signal" from "measured zero": `usage-meter.sh:196`
(a log directory with no in-window files) and `usage-meter.sh:302` (an existing
but empty journal `usage/` directory) both print a confident `0` when the
sensor may simply be blind (fresh host, relocated `$HOME`, wrong
`GARDEN_CCUSAGE_LOGDIR`, restored mtimes). Return the existing failure rc — the
safe skip path `budget-level.sh:118-121` already handles it — unless a positive
liveness marker says the host genuinely idled. Evidence: audit § 2.2 — today a
blind sensor reads 0, which drives `budget-level.sh:129-139` to headroom 1 and
the band maximum (4 workers): the failure direction is inverted, maximum
workers on a blind sensor. The audit calls this the smallest correct change in
the fleet relative to harm avoided.

**Commit 2 — rec 3 [correct but couples badly]: give budget-level the
restraint its design already claims.** Four bounded corrections to the existing
controller, no new loop: (a) a per-tick step clamp — move at most one count per
tick, implementing `designs/live-budget-admission.md:296-298` ("only ever
narrows the gap"); (b) a dwell/deadband copied from
`backend_effective_count`'s confirm-before-move hysteresis
(`common.sh:1348-1352`, the house pattern the audit says to copy); (c) skip
leveling while `fleet_draining` (today budget-level writes counts and raises
alerts on a drained host); (d) read the active kind via
`anthropic_active_kind` instead of the hardcoded `gardeners:` awk
(`budget-level.sh:147`) — on a cut-over host the loop currently steers a line
nothing reads. Evidence: audit § 4.1 (five writers, one count line), § 5.1
(memoryless proportional controller, single-tick 1↔4 jumps, sensor up to 45
min stale).

**Commit 3 — rec 2 [wrong sensor]: do not actuate on setpoints the config
disclaims.** Give `config/budget-pools` rows a provenance field
(calibrated-from, date) and make `budget-level.sh` treat an uncalibrated or
placeholder-marked cap as config-absent: level nothing, alert once. Then
implement the ALREADY-DESIGNED calibration — `designs/recurring-budget-calibration.md`
(`weekly-capacity-calibration.sh` does not yet exist) and
`designs/live-budget-admission.md` open question 1. Implement THOSE designs,
not a fresh redesign. Evidence: audit § 2.3 — the leader sat in permanent
backoff for days against the 5M placeholder cap whose own header says
"PLACEHOLDER CAPS — NOT CALIBRATED" (`budget-pools-placeholder.tsv:1`); the
2026-09-01 `config/budget-pools` header does this provenance by hand in prose.

Out of scope (audit "Not recommended, deliberately"): do NOT loosen the
cap-consistency guard (`usage-meter.sh:329-332`, § 4.3 — the stall is bounded
and the guard is the safety property). The meter-vs-`/usage` divergence root
cause belongs to job `diagnose-budget-meter-overreport-ece02cb4`; read its
tada report if landed before changing meter semantics beyond the above.

Verify each commit with `skills/local-verify/SKILL.md` +
`skills/pre-push-gates/SKILL.md` (the tests under `tests/` covering
usage-meter/budget-level must pass). Land bare on `main2` per CLAUDE.md
§ Conventions; if a change surfaces a genuine open maintainer question, use the
design-with-open-questions PR carve-out instead of landing that part bare.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T00:32:16Z
