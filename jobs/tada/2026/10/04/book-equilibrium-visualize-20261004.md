All nine review-economics charts (E1–E9) are now SVGs, pushed to draft PR https://github.com/kriscendobot/garden-book/pull/12. The new head is `f4e89b070794639419bc096b8351f9ff33b965e7`: one commit on top of the accepted `6035935`, with nothing to rebase over. `npm test` passes 39/39. The browser check passes at 390×844 in both light and dark mode.

**The charts** (in `art/`):
- E1 `equilibrium-e1-pr-cost.svg`
- E2 `equilibrium-e2-list-vs-paid.svg`
- E3 `equilibrium-e3-weekly-throughput.svg`
- E4 `equilibrium-e4-review-latency.svg`
- E5 `equilibrium-e5-scrutiny-levels.svg`
- E6 `equilibrium-e6-gauntlet-ends.svg`
- E7 `equilibrium-e7-review-learning.svg`
- E8 `equilibrium-e8-marginal-crossing.svg`
- E9 `equilibrium-e9-machine-rounds.svg`

**How they're built:**
- **Generator:** `art/generate-equilibrium-charts.mjs` rebuilds all nine byte for byte from the committed `aggregates.json` and `scenario.json`. It also exports a draft caption per chart for the integration stage. The only hard-coded values are the E2 study point ($66.67 flat fee, ≈8.7×), which the spec quotes but the data files don't contain.
- **Kinds:** observed marks are solid and derived marks are hatched or open. Scenario lines are dashed under a visible "SCENARIO · illustrative model" banner, and losses are told apart by dash pattern and marker shape as well as labels.
- **Log axes:** E1, E2 and E4 keep their log axes.
- **The four charts the brief called out:**
  - E8 marks each minimum with a gold dot and a drop line to the x-axis (13, 41, 70 min). Its $1,600 curve is clipped at the $400 ceiling with an arrow labelled "$1,311.19 at 0 min". A $400 panel shows human cost rising as residual loss falls.
  - E9 shows both cost and best human minutes flattening, with the gauntlet cap marked at k = 6.
  - E4 brackets the gap between the panel-stage median and the first-human-review median as "over two orders of magnitude".
  - E7's required caveat sits in a box attached to the before/after evidence.
- **Dark mode and safety:** text uses `currentColor`. A new stylesheet snippet, `art/equilibrium-charts.css-snippet`, switches outlines and gridlines to warm sand in dark mode; it needs copying into the book stylesheet at integration. The SVGs contain no inline styles, scripts, `foreignObject` or external references.
- **Manifest:** `art/MANIFEST.md` has a new section mapping E1–E9 to files, placement anchors, kinds and data sources.

**Verification:**
- **Tests:** the new `test/equilibrium-charts.test.mjs` checks:
  - byte-for-byte reproduction
  - the spec's exact numbers and labels in each chart
  - the spec's tables and lists against the committed data
  - that the scenario curves plot the committed values at the right coordinates
  - inline safety, palette-only colors, and 12 px minimum font size
  - IDs unique across these charts and the existing illustrations
  - the E1–E9 mapping to spec and manifest
- **Browser:** `tools/equilibrium/chart-check.mjs` renders all nine in headless Chromium in a 353 px column with the book's CSS. Each chart is exactly 353 px wide, with no overflow, clipped text or overlapping labels, and the smallest label is 12 px. The fallback font here was DejaVu Sans, a wide face, so this is a conservative test. I also looked at every chart in both schemes and fixed the problems I saw.
- **Evidence:** measurements and per-chart notes are committed in `art/equilibrium-charts-evidence.md`, with a summary posted on the PR. Screenshots are not committed (about 2.5 MB); the check script reproduces them.

**Points for the supervisor** (all also sent to `book-equilibrium-data-supervisor-20261004`):
- **No spec-vs-data discrepancies.** There is one quirk inside `scenario.json`: for the $400 loss at k = 3, one series puts the minimum at 41 minutes and the other at 42. Both total $132.03, a tie at two decimals. The spec quotes each source correctly, so E8 labels 41 and E9 plots 42; a reader comparing the two charts may notice.
- **E5 has five measures but asks for four panels.** I drew the four comparable measures as panels and put the garden-only repair-job proxy as a labelled note beneath them.
- **Left for later stages:** the charts are not placed in the book yet, and the spec's exact-value HTML tables still need adding at integration. Ornament and final typography belong to the styling stage.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-visualize-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (7558526 cached reads)
- Output: 98993 tokens
- Cost: $5.193589200000001
- Wall-clock: 983s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
