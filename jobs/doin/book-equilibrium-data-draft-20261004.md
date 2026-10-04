---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---

# Draft the review-economics/equilibrium chapter from real garden data

Repository: `kriscendobot/garden-book`. This is DATA + DRAFT, stage 1 of the review-economics production supervised by `book-equilibrium-data-supervisor-20261004`.

Work in an isolated project checkout created with:

```sh
/home/kris/garden/scripts/jobs/ensure-project-worktree.sh book-equilibrium-data-draft-20261004 kriscendobot/garden-book book-equilibrium-data
```

Open or adopt the draft PR only with:

```sh
/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh book-equilibrium-data-draft-20261004 kriscendobot/garden-book book-equilibrium-data main --title T --body-file F
```

Do not merge or publish. Push the chapter/section and chart specification to the same draft PR and report its URL and exact head SHA to the supervisor with:

```sh
/home/kris/garden/scripts/jobs/inbox-send.sh book-equilibrium-data-supervisor-20261004
```

## Read first

- `build/README.md`, the current chapter list, and the current five-part structure. Decide whether this belongs as a substantial section in chapter 8 or as a new chapter; preserve the book's architecture and voice.
- The now-merged illumination production: `art/MANIFEST.md` and `art/chapter-illustrations-brief.md`. The later chart artists must use the established 13-color palette and illuminated-manuscript gardening aesthetic rather than creating a second visual language. Capture the exact palette/style constraints and manifest references in the chart spec.
- The garden design corpus: `designs/cybernetics-economic-resilience.md`, `designs/token-cost-ledger.md`, `designs/qwen-pr-cost-analysis.md`, `designs/subscription-budget-model.md`, `designs/recurring-budget-calibration.md`, `designs/issue-cost-and-triple-evaluation.md`, `designs/budgeted-campaign-dispatch.md`, `designs/live-budget-admission.md`, and `designs/session-budget-pace.md`.

## Use real data, with reproducible provenance

Primary sources are the garden's fresh `origin/journal2`, not a possibly stale deployed `journal/` checkout:

- `reputation/events/*.md`: `agentic_dollars`, `human_dollars`, `estimated_dollars`, `work_class`, `target`, `duration_secs`, `accepted`; regular gauntlet panel/fix-stage basenames expose stage costs and round counts.
- `usage/*.jsonl`: per-job `elapsed_s` and `outcome` for throughput and latency.

Fetch `journal2` in your garden job worktree and analyze the committed remote tree. Do not invent numbers or hand-select flattering examples. Preserve the query/aggregation logic, cutoff timestamp, sample counts, missingness/censoring rules, units, and target-classification rules in the chart spec so another worker can reproduce every figure. State where fields are proxies or unavailable. Distinguish machine-price estimates from subscription allocation: prior work found human review roughly 50–190x median machine cost and a flat subscription ledger can overstate true notional cost by about 8.7x. Reconcile your results with those findings; explain differences rather than silently contradicting them.

Compare three genuinely different scrutiny regimes instead of pooling them:

1. garden-on-itself (`main2`): no PR workflow, liaison-reviewed or unreviewed;
2. `endo-but-for-bots`: full gauntlet with panel, fix-loop, and human merge decision;
3. upstream `endo` proper: ferried work, highest merge bar.

If the records do not support a clean comparison or causal claim, say so. These must be presented as tentative order-of-magnitude observations from one fleet's operational history, not a controlled study.

## Argument and analysis

Make the case that review earns its cost twice: confidence in what merges, and feedback data that can improve later agent engagements. Test, rather than assume, the second claim. Look for repeat work in the same area and real gauntlet convergence evidence (fix-round counts, review duration, later rounds or engagements). If attribution or sample sizes are weak, describe the signal as suggestive and name what instrumentation would be needed to measure learning properly.

Frame the core idea as an equilibrium between human review cost and agentic/automation cost. Show how total cost changes as the split shifts and identify the conceptual marginal crossing where another unit of human review no longer buys a sufficient reduction in expected total cost/risk. Do not manufacture an empirically identified optimum if the event corpus only supports an illustrative scenario. Clearly separate:

- observed historical series;
- derived estimates with formulas;
- scenario/sensitivity curves used to explain the equilibrium.

Cover latency, throughput, review duration, tokens/cost spent on engagements, gauntlet panel and fix rounds, cost per accepted/merged outcome where supportable, and the different scrutiny levels. Use careful language around `accepted` versus GitHub merge state.

## Deliverables

1. Markdown manuscript text integrated into the appropriate chapter or a new chapter, with sources/limitations explained in readable prose.
2. `art/equilibrium-data-spec.md` (or a comparably clear path), containing for every proposed chart:
   - the reader question it answers;
   - actual tentative numbers/series, labels, units, sample sizes and time cutoff;
   - whether each value is observed, derived, or scenario-based;
   - source paths and reproducible aggregation/formula notes;
   - accessibility/alt-text intent and phone-width layout constraints;
   - the established illumination palette/style constraints without asking the artist to alter the data.
3. Any small analysis script/data snapshot needed to make the calculations auditable, committed under an appropriate project path. Do not copy sensitive raw journal content into the public book; aggregate and redact as necessary.

Run the repository's tests and build. Check the rendered manuscript at phone width and in dark mode in an actual browser, recording concrete evidence in the PR/body or committed evidence. The charts themselves are not part of this stage. Keep the PR draft for the visualization/styling stages.

If you genuinely finish but cannot achieve the gated deliverable (for example the data cannot support a defensible manuscript/spec), emit the exact lines below at the end of your report:

```text
<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>
```

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-04T06:53:10Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-04T06:53:43Z
