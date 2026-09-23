---
handed-off: build-opus55-tier
deliverable-complete: false
---
All deliverables complete. The build job `build-opus55-tier` is already on the board (claimed into `doin/`). Let me write the completion report.

Completion report:

**Job: mentat-opus55-tier-open-questions-20260923** — resolved all three open questions in `designs/opus55-tier.md` with empirical data.

## What I did

**Empirical canary (bounded, ~$0.57 total spend).** Existing telemetry (`journal/budget/manual-checkpoints`, the usage ledger) has no per-model breakdown and — critically — zero Opus 5.5 data, since Opus 5.5 has never been in the fleet inventory. So I ran a controlled A/B directly: three representative fleet-style tasks (a bash race/quoting fix, a design-risk analysis, a 5-item PR-title classification) via `claude -p --model … --output-format json`, on **Opus 5.5 at `--effort medium`** (its default; I confirmed the monk handler sets no effort flag, so this is what the fleet would run) vs **Opus 4.8 at default**. Per-run figures came from each run's own `modelUsage` block; billable = input+output+cache_creation per `usage-meter.sh`. All 6 runs completed (`is_error=false`).

Aggregate result: Opus 5.5 @ medium used **−3.9% billable quota**, **−35% generation tokens** (output+thinking), **−46% thinking tokens**, and **−28% list cost/job**. The design's central worry (always-on thinking inflating quota) was refuted — at medium, Opus 5.5 thinks *less*, not more.

## Answers (all three open questions resolved)
1. **Ceiling + effort → Option B at `medium`.** Register Opus 5.5 at mentor (before Opus 5), remove the anthropic mentor downshift, retire the reaper ceiling-suppression exception. Effort = `medium` = the model default, so no handler effort plumbing needed. Option C stays rejected.
2. **Opus 5 stays registered** (selectable via explicit pin) but **not the default**. Confirmed the design's recommendation.
3. **Pricing current** — rechecked against the bundled `claude-api` catalog: Opus 5.5 $4/$20 (cache read $0.20), Opus 5 & Opus 4.8 $5/$25. Unchanged.

## What changed
- **`designs/opus55-tier.md`** on `main2` (commit `27928ae3d5`, rebase-CAS pushed, tip-confirmed): replaced `## Open questions` with `## Resolved decisions`, added the canary method + figures table, the rechecked-pricing note, and reflected Option B in the "Automatic-work cost ceiling" section. Status row updated to "Resolved."
- **PR #108 reply** posted as a threaded reply on review comment `4084935637` (`https://github.com/kriscendobot/garden/pull/108#discussion_r4085531532`), summarizing the empirical result + chosen option, citing the landed SHA and the build job, and noting the PR can be closed. Body verified (backticks/inline-code preserved).
- **Follow-up build posted:** `build-opus55-tier` (the design's "Exact changes" section — inventory row, routing patterns, ceiling removal, reaper exception retirement, tests, doc updates). It has already been race-claimed into `jobs/doin/`.

## Follow-ups / notes
- **Follow-up build named:** `build-opus55-tier` (live on the board).
- **PR #108 should be closed** — its answer-surface purpose is served now that the questions are resolved on `main2`. I recommended closure in the reply but left the actual close to the maintainer/liaison (I did not close it).
- **Live-effect caveat** (recorded in the design and reply): a separate choke-point policy has kept automatic fleet work off Claude since 2026-07-29, so Option B's effect is latent until automatic work routes to an anthropic worker again; B is still the correct target state.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-opus55-tier-open-questions-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (3112513 cached reads)
- Output: 29350 tokens
- Cost: $3.5992364999999995
- Wall-clock: 524s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
