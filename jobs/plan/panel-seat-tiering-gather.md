---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-08-01T11:53:04Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-01T11:53:04Z
---

---
role: assayer
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T08:52:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Panel seat tiering — 1/3: GATHER the evidence

First of three children of orchestration `panel-seat-tiering`. Produce an
**evidence file**, not a recommendation — child 2 assesses, child 3 acts. Land
your output at `journal/reports/panel-seat-tiering/evidence.md` (create the dir)
via the producer clone + CAS, and summarise it in your `tada/` report.

Repository for any code reading: this garden checkout. Do **NOT** run git in
`$GARDEN_ROOT`; use your per-job worktree.

## Why this exists

`scripts/jobs/gardening/panel.sh` shells `claude -p` **with no `--model`** in all
three decision hooks — `seat_review` (~line 181), `decide_disposition` (~200),
`appellate_pass` (~216). Every juror seat therefore rides the ambient CLI default
and has **no tier binding at all**. The weekly `model-tier-effectiveness-review`
(see `jobs/tada/model-tier-effectiveness-review-20260729-172004.md`) is
model-centric and has no row for any seat, so this dimension is unmeasured.

The panel is also the dominant cost shape: ~30 model invocations per round (28
code seats + foreperson + appellate) against 1 for an entire builder job.

## What to measure

Sources: `journal/panel-runs/**` (54 records at time of writing),
`journal/review-misses/**` (172 records), `journal/reputation/{events,arms}/`,
`journal/usage/*.jsonl`, and the seat briefs under `roles/jurors/<seat>/AGENT.md`.

1. **Per-seat yield.** For each of the 28 code seats and 7 design seats
   (`GARDEN_CODE_SEATS` / `GARDEN_DESIGN_SEATS`, panel.sh ~line 80): rounds sat,
   verdict distribution, and must-fix items actually attributed to that seat.
   **Parse the finding bullets properly** — a prior pass matched only
   `- <seat>: **must-fix**` and undercounted, missing `should-fix` and bare
   `- <seat>: <text>` forms. Report the parse rule you used.
2. **Per-seat quality.** Cross-reference `missed_by:` in `review-misses/`. Note
   that 134 of 172 are `category: new-direction` and 128 are `severity: minor`,
   so state the size of the usable signal rather than quoting 172.
3. **Per-seat cost.** Attribute panel spend per seat as best the data allows.
   State plainly where it cannot be attributed rather than estimating silently.
4. **The error confound.** 31 of 54 runs terminated `seat-error` / `error` /
   `decider-error` — only 5 passed. Quantify what share of panel spend buys no
   verdict, and classify causes (quota/provider vs seat-output vs budget). This
   confounds every cost-per-finding number, so it must be measured, not assumed.
5. **Design panel has zero observed runs** (52 of 54 are `panel_kind: code`).
   Record that as an evidence gap; do not infer design-seat quality from briefs.
6. **Deterministic-gate feasibility.** For each seat, does a rule already exist
   as a skill or gate (`skills/changeset-discipline`, `typist-friendly-code-points`,
   `em-dash-style`, `no-latin-shorthand`, `no-comment-banners`,
   `scripts/jobs/gardening/seat-gate-coverage-auditor.sh`)? A deterministic
   pre-pass costs ~0 and beats a cheaper model wherever it applies.

## Standing hypothesis to test, NOT to assume

A liaison pass proposed 8 lowering candidates on weak evidence — benchmarker,
surfacer, transplanter, gateway, releaser, changeset-auditor, scribe, typist —
all "mechanical, no miss ever attributed". **Zero misses attributed is weak in
one direction**: it may mean the seat works, or that nobody attributes to it.
Test it; report if it does not hold.

Keep-high candidates from the same pass, also to be tested: stylist (7 misses,
the most-missed seat despite the highest must-fix yield), spec-keeper (5),
purist (3), saboteur (2), prover (2), warden (1), breaker, corner-prober.

## Definition of done

`journal/reports/panel-seat-tiering/evidence.md` exists, landed on `journal2`,
with a per-seat table, the error-rate analysis, an explicit confidence grade per
claim, and a clearly-marked list of questions the data CANNOT answer. Recommend
nothing here.
