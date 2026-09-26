Everything is complete. Final report:

---

## Completion report — `design-reset-time-detection`

**What I did.** Designed and implemented a deterministic, no-LLM way to detect and interpolate quota **reset times** from the fleet's checkpoint data, per kriskowal 2026-09-03. First checked the sibling `design-manual-quota-calibration` (landed on `main2`, PR #80) and composed cleanly on top of its infrastructure — same `budget/manual-checkpoints/` input, same measure/actuate boundary, mirrored append-helper shape — rather than duplicating it.

**Landed bare on `main2`** (garden repo is push-direct):
- `scripts/jobs/detect-quota-resets.sh` — the detector. The dashboard `weekly_percent` is the ground-truth sensor (it only grows between resets, so any real drop beyond the ±0.5% rounding band is a crossing); a `weekly_resets_at` advance is the definitive signal; the meter's oscillating `window_start_epoch` is only corroborating. It separates a real reset from the two confounds — the +50% boost (a proportional above-floor drop) and the anchor-oscillation artifact (an anchor move with **no** percent drop) — and interpolates the crossing via the meter token-spend rate (constant-burn assumption stated, error bounded), falling back to the percent rate then the bracket midpoint. Grades each finding `confirmed|likely|suspected|refuted`. It **measures**; `--append`/`--notify` are opt-in so a scheduled run never actuates by surprise.
- `scripts/jobs/append-reset-event.sh` — the idempotent CAS ingestion path for the reset-events log (scope item 4), sibling to `append-quota-checkpoint.sh`.
- `scripts/jobs/test/detect-quota-resets-test.sh` — 10 assertions, all passing.

**Design** `designs/reset-time-detection.md`, deciding all four scope items: (1) the bracket rule + interpolation model; (2) the settled cross-validation rule (an anchor transition corroborates only when the dashboard percent also dropped, else it's the artifact); (3) a detected reset feeds the fleet as a **coalesced maintainer notice** via `watchdog-notice.sh`, never a silent `config/budget-pools` write, naming the safe follow-ups (clear a stale weekly quota-backoff hold, take a fresh calibration checkpoint); (4) the append helper.

**Honest validation.** Mermaid diagram parses (flowchart-v2). Test suite 10/10. Against the **real** `endolin-garden-ece02cb4` seed (10 checkpoints, all inside one weekly window): **0 false resets** and it **reproduces both hand-recorded anchor-artifact rows** — the backward reversion and the forward jump — arriving independently at the humans' "unknown/refuted" judgment.

**Review surface.** Because the design carries a non-empty `## Open questions` section, it took the open-questions-PR carve-out: **PR kriscendobot/garden#83** (draft, base = frozen `main2-317a0f3`, diff = the design file only), body carrying `<!-- garden-job: ... -->` and `<!-- garden-design-open-questions -->` so no design panel is staged. Left draft as required.

**Follow-ups (in the design's Open questions, for the maintainer):** the 2026-09-01 genuine-reset-vs-credential-artifact ambiguity (formally held — it predates the checkpoint log and is out of the detector's reach); whether a `confirmed` `weekly_resets_at`-advance should auto-release a weekly quota-backoff hold; whether an off-cycle reset shifts the scheduled Friday cadence; whether unmetered `endolin-garden2` needs detection at all. The recurring `set-schedule.sh` wiring is reserved, not armed, pending those calls.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-reset-time-detection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 114 tokens (6226109 cached reads)
- Output: 56879 tokens
- Cost: $5.4668307500000015
- Wall-clock: 982s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
