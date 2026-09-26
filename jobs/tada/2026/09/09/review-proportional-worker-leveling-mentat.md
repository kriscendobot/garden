**Verdict: approved with corrections — the design proceeds to build against the amended doc (commit `c9eb1fc368` on `main2`).**

## What I reviewed

`designs/proportional-worker-leveling.md` (landed at `e329ce97a0`), checked against `scripts/jobs/budget-level.sh`, `designs/cybernetics-audit.md` (§ 2.2, 2.3, 4.1, 5.1), `designs/session-budget-pace.md`, the live `config/budget-pools` (143M / 64M, both calibrated), the `openai-codex-shared` manual-checkpoint log, and the current per-host count files.

## Answers to the five review questions

1. **Composes with the dwell logic — yes.** § 1.3 explicitly keeps the whole controller (headroom fraction, half-up rounding, direction streak, UP/DOWN confirm, one-step clamp, existing actuator path) and changes only the ceiling `hi` → per-host `U_h`. This matches the cybernetics-audit § 5.1 remedy already in the code; nothing is bypassed.
2. **Cleric rule is genuinely different — yes.** § 2 sizes the cleric fleet from claimable demand and splits by per-job host eligibility (`1/|E_j|` fractions), with a separately configured envelope `K_max` — no fabricated per-host Codex sub-budget. The shared-account premise is confirmed verbatim by the `openai-codex-shared` checkpoint notes ("one codex subscription shared by both").
3. **Session-budget-pace interaction — correctly handled, not ignored.** § 3 declares independence, defines composition as `T = min(T_weekly, T_session)` over the same `[L, U_h]` range, and forbids putting session caps in the apportionment denominator. Consistent with what `session-budget-pace.md` itself specifies.
4. **Safety properties — preserved, with one real regression found and fixed** (below). Provenance gate strengthened to fleet-wide, drain skip kept (invariant 2), missing spend stays isolated and is never read as zero.
5. **Concrete and testable — yes.** Exact formulas, a worked example on the live caps, and a 13-case acceptance list. Arithmetic verified (including the cap-recalibration case where a host's quota exceeds `P_h=4` and re-apportionment hands the slot to the other host).

## Corrections applied (all contained, committed as `c9eb1fc368`)

- **§ 1.4 exhaustion-floor carve-out (the one real safety regression).** As written, one uncalibrated pool froze *every* host — including a calibrated host burning past its own high-water mark, which today's per-row code would throttle down. Since `H=0 ⇒ T=L` for any ceiling (denominator-free), I amended the freeze to still permit the *downward* move toward the floor for a calibrated, over-high-water host; raising stays absolutely frozen. Not hypothetical: garden2's pool sat uncalibrated ~a day on 2026-09-04/05.
- **§ 2.3 physical-capacity clamp.** `sum(T_cleric)=K` was unsatisfiable when `K_max` exceeds fleet physical cleric capacity (the monk section has this preflight; cleric didn't). Now clamps to capacity and warns.
- **§ 2.3 dwell keying.** `budget-level.sh`'s `_dwell_file` is keyed by host alone; reusing it verbatim would let monk and cleric direction streaks reset each other. The design now requires keying by host + worker kind.
- **§ 2.1 operator arbitration.** Noted `K_max` (or drain) is the throttle lever — the allocator is the designated writer and will revert raw `set-workers.sh` edits (the 2026-09-02 codex shutdown maneuver becomes `K_max=0`).
- **§ 5 configuration surface settled** (the design explicitly asked the review to): envelopes and physical caps are journal-backed `config/` state, env vars as overrides — foreman-brake precedent, since leader-only singleton state must follow the `leader` marker across a handoff.
- **§ 1.2 arithmetic presentation fix** (`U = 1 + 3 = 4` conflated the floor step with the leftover slot; final 4/2 answer was correct).
- Safety invariants 3 and 9 and the acceptance-case list updated to match the amendments.

## Follow-ups

None blocking; no maintainer decision needed. The parked `build-proportional-worker-leveling` job should build against the amended doc and include the three new acceptance cases. Note the design job's own tada report had not yet synced to this host's journal at review time (still in `doin/` locally) — the landed doc itself was the review artifact, so nothing was lost.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-proportional-worker-leveling-mentat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1490783 cached reads)
- Output: 22728 tokens
- Cost: $4.252183
- Wall-clock: 305s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
