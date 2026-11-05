The human-effort estimate is gone from PR completion receipts, and each receipt now records a rollup of raw measurements instead. The change is pushed to `main2` as `6025f283bb7`. The new `pr-receipt-test.sh` passes 10/10, the existing `receipt-watcher-test.sh` passes 20/20, and shellcheck reports no warnings (only informational notes, as before). The existing 209 archived receipts have **not** been backfilled yet; I posted a separate job for that.

**Removed**
- All human-effort figures in `scripts/jobs/pr-receipt.sh`: estimated minutes, dollars, the ratio to machine cost, the total cost that added them together, and the constants line printed in the receipt.
- The `a`/`b`/`r` constants, the hourly rate (`GARDEN_RECEIPT_HOURLY_USD`) and the `receipt_config` override reader in `receipt-defaults.sh`.
- The matching archive fields (`maintainer_review_*`, `maintainer_dominance_ratio`, `total_usd`).

**Added, per PR** (in the comment, the archive frontmatter, and one JSON row appended to `receipts/rollup.jsonl` with `schema: 1`):
- **Token cost:** calibrated dollars with the basis stated, plus the notional figure, billable tokens and tokens by model. Usage rows don't record a tier, so the model stands in for it.
- **Wall-clock:** from the earliest job start for the PR (end time minus run time on its first recorded run) to merge or close.
- **Job duration:** the sum of all run times, with the job and engagement counts reported separately.
- **Words of human feedback:** counted in plain code, never read by a model. Split into maintainer (people on the journal's `maintainers/allowlist`) and other humans, and also per author.
- **Review counts:** number of reviews, inline threads and comments, plus counts of each verdict and the order of CHANGES_REQUESTED/APPROVED.
- **Gauntlet counts:** panel runs, panel rounds and fix rounds.
- **Quality-bar class and rank:** from the new `scripts/jobs/quality-bar-defaults.tsv` (`endojs/endo` 1 highest, `endojs/endo-but-for-bots` 2 high, garden and minion.town 3 low). A journal `config/quality-bar` file in the same format overrides it, and any other repo is `unknown`.

No quality score and no human-dollar figure is computed.

**Backfill and history**
- A new `--backfill-rollup` flag adds only the rollup row for a receipt that is already archived. It never rewrites the archive or posts a comment, and it skips a PR that already has a row.
- `--force` regeneration also appends a new row, so anything reading `rollup.jsonl` should take the latest row per repo and PR. The design doc says so.
- Running the backfill now wasn't cheap: 209 receipts means three paginated GitHub reads and one journal push each. It's posted as job **`backfill-receipt-rollup-20261105`**, with instructions to compute the cost join once and pace the GitHub reads.

**Bug fixed along the way:** the filter that drops bot authors never worked. It stripped newlines from the list of bot logins, so every login ran together on one line and no bot was ever excluded. That means `kriscendobot` and Copilot comments were counted as human feedback in every older receipt. The new test caught it.

**Docs and tests**
- `designs/pr-completion-receipts.md`: the old formula section is replaced by a short "Human-effort estimation retired" paragraph saying why, and noting that older receipts keep their retired section. The rollup, the JSON file and the example receipt are documented, and the open questions about the old constants are closed.
- The two Qwen cost-analysis designs now carry a note that their human-minute and dollar figures came from the retired estimate.
- The new test checks the receipt contains no human-effort or human-dollar wording, and checks the word counts (11 total, 6 maintainer and 5 other, with bots and Copilot dropped). It also checks the quality-bar class, the JSON row's fields, that backfill doesn't duplicate rows or touch the archive, and that the journal quality-bar file overrides the default.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/remove-receipt-human-effort-add-rollup-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2268884 cached reads)
- Output: 25182 tokens
- Cost: $1.7476488
- Wall-clock: 321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
