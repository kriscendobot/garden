Fix round 1 for kriscendobot/garden-book PR #12 (gauntlet `book-equilibrium-stylize-20261004-gauntlet`) is pushed. Another bot job then merged the PR into `main` at my head `c7ff0a85a0` (07:46:39Z). The repo has no CI workflows, so no checks ran; `ci-wait-merge.sh` returned rc 0 because the PR was already merged. The only verification is local: `npm test` passes 61/61 and `npm run build` succeeds.

**Must-fix items from the 07:31Z panel review:**
- **saboteur (gauntlet stages losing their PR):** a stage job that names no PR now inherits one from its parent job, else from a sibling stage. This is `familyPullRequests` in `rules.mjs`.
- **assessor (missing keys in chart data):** `tally()` now fills a fixed set of categories with zeros, so the four counts the charts read (panel dispositions, panel-stage counts, miss severity, cluster status) never have a missing key. A peer's commit added the same guard in the chart generator, and I kept both.
- **prover:** the integration test now pins allocated dollar values ($70 and $210 of a $280 month), the inherited stage, the OpenAI exclusion and the panel-run join. Two deliberate code breaks (dropping the inheritance, doubling the flat rate) each now fail a test.
- **fast-checker:** I added seeded property tests instead of a `fast-check` dependency. They found a real bug: `allocationFactor` returned Infinity for very small notional sums. It now returns null.
- **stylist:** renamed `fmt`, `esc` and `out` to `formatNumber`, `escapeText` and `outputDirectory`.
- **Smaller should-fixes:**
  - `scenario.mjs` checks `kFixed`, and both scenario figures use the same rule for picking the cheapest point.
  - A missing `pr` or `must_fix_total` reads as null, not NaN.
  - The journal snapshot is also deleted on Ctrl-C or SIGTERM.
  - The $30 flat round price is built from named constants.

**Data regeneration:** I reran the analysis at the same journal2 revision with a fresh GitHub fetch. With the old code the rerun matched the committed data exactly except the fetch time, so every changed number comes from the PR-inheritance rule:

| Figure | Before | After |
| --- | --- | --- |
| PRs with gauntlet stages | 161 | 173 |
| PRs at the six-round cap | 65 | 73 |
| Machine cost per PR, list price (median) | $10.71 | $11.05 |
| Human ÷ machine per PR | 38× | 36× |
| Best point at $400 loss | 42 min, $132.09 | 42 min, $132.10 |

I updated the data spec, chapter § 8.8, the SVGs and the value tables in `build/equilibrium-charts.mjs` to match. The spec-table test now rounds the way the charts do, which shows $0.29 where the old test would have expected $0.28. The reproduction recipe now says the journal2 clone must be full, not shallow: the garden's own repo is shallow, and that put every panel-run date at its cutoff.

**Pushes and coordination:**
- Commits `a02ef94` (code and tests) and `c7ff0a8` (data), pushed with `safe-push-pr-head.sh` after rebasing over four concurrent commits from the integrate job and the other gauntlet's fix job.
- Posted a summary comment on the PR (the scribe's request).
- Messaged `book-equilibrium-integrate-20261004` that the data and its value tables changed.

**Not done:** the `fast-check` dependency, the integrator's title and quick-reference items, content-hash provenance for the GitHub inputs, and the typist's character substitutions. These were all should-fix or comment-only.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-stylize-20261004-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 156 tokens (10982101 cached reads)
- Output: 47071 tokens
- Cost: $4.745008199999998
- Wall-clock: 851s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
