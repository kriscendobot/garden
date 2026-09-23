Inbox empty. The work is complete. Let me write the completion report.

Budget 3/5 (`garden-budget-prs`) is done. I built the deterministic job→PR join and per-merged-PR true-cost aggregation, verified it, and landed it on `main2` (commit `c879177dd2`).

## What I did

**Read the prerequisites.** Child 1's `garden-budget-ratecard` tada and the landed rate card (`journal/reputation/rate-card.md`). Child 2's `garden-budget-ledger` code (`cost.sh`) is on `main2` at my base, though its tada report isn't filed yet — the ledger job is still in `jobs/doin/`. I proceeded on the landed code since the read side and the corrected rate card were both present.

**Key basis finding.** `cost.sh` sums the raw `total_cost_usd` from `usage/*.jsonl` — that is the **notional** figure (an Opus job reads $6.35), *not* the true cost the amendment implied. So I did **not** aggregate through `cost.sh`'s dollar column. Instead I priced on child 1's actual basis: each reputation event's **capped proxy wallclock × the journal rate card** (`rep_estimated_dollars`), over the full `reputation/events/` population (1910 events — far better coverage than the 456 usage rows, and it carries provider/model/duration for pricing).

**Built `scripts/jobs/cost-by-pr.sh`** (+ a 9-assert hermetic test). It:
- prices every reputation event on the true-cost (capped-proxy × rate-card) basis;
- joins base→PR via two deterministic edges: (1) `jobs/index` `identity: owner/repo#PR` → minted base (authoritative), and (2) a **PR-shaped** base-name token (`pr<N>`/`#<N>`/`pull-request-<N>`/slug-adjacent) **validated against the repo's real PR set from `gh`**;
- measures and always prints join coverage; buckets unmatched bases into an explicit **UNATTRIBUTED** bucket;
- reports openai + unmeasured arms in a **separate CEILING column** kept out of the measured total.

## Results (top merged PRs, the "escrow oracle")

- **Join coverage: 553 of 1910 priced bases (29.0%)** → 182 PRs (77 merged). The rest are genuinely garden-internal (scholar/press/watchdog/`main2` builds) or older jobs whose base never carried a validatable PR reference.
- **Measured-basis total $247** (anthropic/kimi/fireworks/local, all-time). Top merged PRs: ebfb #882 ($5.17), #713 ($5.07), #848 ($4.86), #723 ($3.02).
- **Ceiling total $3,929** (openai/unknown) — *not money*.
- **Unattributed: 1357 jobs, $138 measured + $1,961 ceiling.**

## Honesty caveats surfaced (per the brief)

1. **openai's cost is unknown, not $25k.** The ChatGPT plan meters $0; the rate card prices it at a deliberately-high ceiling. I kept it in a labelled CEILING column, out of the measured total. openai-heavy merged PRs (e.g. #824: measured $1.40, ceiling $52) show this plainly.
2. **Per-PR JOBS is a lower bound.** At 29% join coverage most contributing jobs of older PRs were never joined — labelled, not averaged, exactly as the brief demanded.
3. **Guarded a real false-join hazard:** the dense `endojs/endo` repo (2000+ PRs) made any stray digit "valid" — `xs2rust-endor-stage10-*` (garden-internal) was false-joining 47 jobs to endo#10. Tightened to PR-shaped tokens only; the test's regression case guards it.
4. **Amortization caveat:** child 1's anthropic $/s was calibrated on a 5-day window; applied all-time it drifts from the flat $13.33/day. Relative per-PR ranking is consistent; the absolute total carries this caveat.

## Also done / follow-ups

- **Fixed the tracked seed** `scripts/jobs/rate-card-defaults.md`: the notional per-model Anthropic rows (~75× too high on a flat plan) → one amortized pooled `0.000069` row, mirroring the landed journal card (fail-safe only; the journal card already wins at runtime).
- **Deploy-lag finding (follow-up):** the **deployed root** still runs the *pre-cap* `rep_wallclock_index` (pr661 span = 1,918,858 s / 22 days of reap idle), while `main2` has child 1's cap (7,008 s). So the **live reducer is still pricing on inflated, uncapped spans** until the next deliberate deploy — child 1's cap is landed but not deployed. My script sources the worktree's capped version, so its numbers are correct.
- Verified: 9/9 new tests pass; `auction-reputation-test` 71/2 (the 2 failures pre-exist on `main2`, confirmed by stash-revert); `token-cost-ledger-test` 5/5; shellcheck clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-prs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 179 tokens (12174534 cached reads)
- Output: 101927 tokens
- Cost: $10.438953
- Wall-clock: 1858s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
