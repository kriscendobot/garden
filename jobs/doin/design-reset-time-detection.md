---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design (garden's own repo) a deterministic way to detect and interpolate quota **reset times** from the checkpoint/meter data the fleet already collects, per kriskowal 2026-09-03: *"We should of course also be tracking quota reset times. We may have to extrapolate because quota necessarily intercepts 0 at some time between a high quota usage measurement and a low quota usage measurement. In general, we can infer the exact time of the Friday 8pm Pacific reset, but Anthropic occasionally resets mid-week, as they did on Tuesday this week."*

**First — check whether `design-manual-quota-calibration` (posted the same day, likely landed or in-flight by the time you read this) already covers part of this.** That job scopes the tokens-per-percent *ratio*-fitting problem; this one scopes reset-*time* detection. They're related (both consume the same checkpoint data, `journal/budget/manual-checkpoints/`) but distinct asks — don't duplicate work, do cross-reference and compose cleanly with whatever landed.

## What already exists

- `journal/budget/manual-checkpoints/<host>.jsonl` — human-verified (dashboard %, meter spend) pairs over time.
- `journal/budget/reset-events/<host>.jsonl` + `README.md` — a new sibling log, seeded by hand this session with the one exact reset timestamp we could pin precisely (2026-09-01T18:17:54Z, from the local meter's own `window_start_epoch` matching a pre-existing incident writeup to the second) plus the scheduled Friday-8pm-Pacific expectation. Read its README's "Open problem" section — it names the exact ambiguity this design needs to resolve or at least formally hold: whether the 2026-09-01 event was a genuine Anthropic-side reset or a local credential-refresh artifact that only looked like one (`config/budget-pools`'s own header argues the latter; kriskowal's framing this session argues the former).
- `journal/budget/live/<host>` already has a `window_start_epoch` field the local meter derives on its own — this session found it can itself be wrong (see the reset-events log's "unknown" row: it silently carried a stale/contaminated anchor for ~2 days, then self-corrected with no announcement). Any detector built here should treat `window_start_epoch` as one signal among several, not ground truth on its own.

## Scope

1. **The general detector.** Given the manual-checkpoint log's `(checked_at, weekly_percent)` pairs for a host, identify a bracket where usage necessarily crossed zero — not just "percent went down" (rounding noise can do that at nearly any two adjacent points near a peak) but a *drop large enough that no plausible spend-only trajectory explains it without a reset in between*. Interpolating the exact crossing time within that bracket needs a rate model; the simplest defensible one is linear interpolation using the *meter's* token-spend rate (not the percent, which is coarser) over the bracket, but say explicitly what assumption this makes (constant burn rate across the bracket) and how wrong it can be.
2. **Cross-validate against `window_start_epoch` transitions**, which are a second, independent signal for the same event when the meter's anchor genuinely moves — but per the "unknown" row already recorded, an anchor transition with roughly flat spend across it is evidence AGAINST a real reset, not for one. State the discriminating rule this design settles on.
3. **Decide how a detected reset feeds `config/budget-pools`.** A confirmed reset should probably at minimum reset any stale `status: backoff` and let a fresh calibration checkpoint happen sooner than waiting for the next scheduled Friday — but do not have this design silently override a human's stated reset expectation; surface a detected anomalous reset as a notice, the way `watchdog-provider-quota` already coalesces repeated occurrences of one condition.
4. **A durable way to record future detections** without a human hand-writing rows, mirroring whatever `append-quota-checkpoint.sh`-shaped helper the sibling ratio-fitting design lands (reuse it if it exists by the time you pick this up).

## References

- `journal/budget/reset-events/README.md` and its two seeded `.jsonl` files — read them fully, they carry the concrete evidence and the open ambiguity this design responds to.
- `journal/budget/manual-checkpoints/` — the sibling log this design's detector reads.
- `journal/config/budget-pools` header — the pre-existing, still-unresolved account of the 2026-09-01 event.
- `journal/jobs/` for `design-manual-quota-calibration`'s current state/outcome (check before drafting, per the note above).

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T05:53:35Z
