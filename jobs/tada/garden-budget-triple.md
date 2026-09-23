Inbox empty. The job is complete — all work committed and pushed to `main2`, both test suites green.

## Completion report — `garden-budget-triple` (Budget 4/5)

**Landed on `main2` (`a7c9c8d11a`):** the human-review half of the issue-cost method, on top of Budget 3's machine-cost basis. Resumed cleanly after a shell-outage requeue — all uncommitted work survived in the worktree; I fixed the one unverified artifact (the review-rounds test), verified everything, and committed.

### What I built
- **`designs/issue-cost-and-triple-evaluation.md`** (the core deliverable) — the end-to-end method `Cost(issue) = MachineCost + HumanReviewCost`, the measurements, the two-triple comparison, the memory-axis gap, and a per-figure confidence table.
- **`scripts/jobs/review-rounds.sh`** — deterministic per-merged-PR **human** review-round counter (`gh`+`jq`+`awk`, no LLM). Counts human review submissions per bot PR, excludes bot/panel reviews, and leaves minutes/round and $/min as explicit caller parameters (never fabricated). + committed fake-gh stub symlinked into the test (sandbox-exec-safe, the fleet's established pattern) — **test 10/10 green**.
- **`scripts/jobs/cost-by-pr.sh`** (fix) — Budget 3's script trapped under `set -u` on the `--no-fetch` path (bash treats the empty declared assoc array `PRSTATE` as unset). Fixed the guard + added 2 regression cases — **cost-by-pr-test 11/11 green**. With the fix it reproduces Budget 3's headline exactly ($247.12 measured, 28.8% coverage, 68 merged, #882 $5.17…).

### Findings (defended in the doc, with confidence stated per figure)
- **Machine cost/merged PR** (true-cost basis, 68 joined merged PRs): mean **$0.59**, median **$0.16**, max **$5.17** — lower bounds at 29% join.
- **Human review rounds/merged PR** (direct GitHub count, 190 merged bot PRs on endo-but-for-bots): mean **1.75–2.41**, median **1.0**, p90 **4–5**; 88–91% get ≥1 human review.
- **Load-bearing conclusion:** human review dominates machine cost **~50–190× at the median**, robust across the entire plausible (min/round, $/min) range. **At ~$0.125/job the machine spend is noise against maintainer attention — optimize review rounds first, machine cost only as a tiebreaker.**
- **Two-triple comparison** (memory held constant): Triple A (anthropic/claude-default, gardener) vs Triple B (openai/gpt-5.6-terra, cleric) are **indistinguishable on the dominant axis** — 1.88 vs 1.96 human rounds/PR, n≈25 each. No defensible basis to prefer either.
- **Kimi (moonshot/kimi-k3, mystic)** has a 31% acceptance rate over 88 events (~3× rework before a PR forms) — clearly wastes machine work, but n=3 merged PRs is too thin to cost its review burden. Reported as an arm result, not a triple result.
- **Memory axis has ZERO data** — every event ran under the same journal-recall memory; stated as a hard gap, not fabricated.
- Confidence table: review-rounds mean & the dominance ratio HIGH; per-PR machine ranking MODERATE–HIGH; absolute lifetime total LOW (do **not** publish $247 as lifetime — the $517.70 reconciliation gap is named); model→review-rounds signal INSUFFICIENT beyond the two n>20 arms; memory NO DATA.

### Follow-ups (out of scope, noted in the doc)
- To make the memory axis measurable, engagements must record their memory mode and at least two modes be A/B'd — neither exists today.
- Budget the scarce input (review rounds), not a machine-token dollar ledger; the binding constraint is the flat subscription's rate limit (`usage-meter.sh`), not dollars.
- This is Budget 4/5; the liaison plans to deploy the capped reducer at the end of the chain (child 5 / deploy remains).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-triple.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (3778694 cached reads)
- Output: 17408 tokens
- Cost: $3.9236269999999998
- Wall-clock: 264s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
