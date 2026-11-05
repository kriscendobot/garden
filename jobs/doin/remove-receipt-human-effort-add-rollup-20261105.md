---
posted_at: 2026-11-05T04:40:41Z
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Remove the human-effort estimates from PR completion receipts and replace them with a measurement rollup for postmortem analysis** (maintainer request, kriskowal, 2026-11-05). Garden's own repo: land direct to `main2`.

**Context.** `scripts/jobs/pr-receipt.sh` (design `designs/pr-completion-receipts.md`; constants in `scripts/jobs/receipt-defaults.sh`, `reputation/rate-card.md`, `scripts/jobs/rate-card-defaults.md`; `cost-by-pr.sh --base-map` supplies the pricing join) currently prints a per-PR "maintainer review effort" (MRE): minutes, dollars, and a ratio to machine cost, derived from fixed constants (`a`, `b`, `r`, `H` = `maintainer-hourly-usd`). The maintainer has established that tokens cost far less than human review, and that the human-dollar heuristic is exaggerated, inaccurate or fabricated from thin air. **Stop estimating human effort.** No human minutes, no human dollars, no ratio, no hourly-rate config.

**Remove:** the MRE minutes/dollars/ratio computation and rendering in `pr-receipt.sh`; the hourly-rate and a/b/r constants and their `receipt_config` plumbing (`maintainer-hourly-usd`, `GARDEN_RECEIPT_HOURLY_USD`) and docs; wording in the design, skills, tests and any dashboards or reports that quote them (grep `scripts/ skills/ designs/ context/ roles/ reputation/`). Keep the per-engagement table if it is still useful, but make sure nothing in the receipt asserts a human cost.

**Record instead, per PR (a compact rollup, in the PR comment and the journal archive `receipts/<repo-slug>/<YYYY>/<MM>/pr<N>.md`):**
1. **Aggregate approximated token cost, in dollars** (the existing calibrated/true-cost figure; keep stating the basis, and the notional figure only if it adds information).
2. **Wall-clock time:** first claim of any job for the PR to merge/close.
3. **Job duration:** the sum of engagement/job run durations (distinct from wall-clock; report both, plus the count of engagements and jobs).
4. **Words of human feedback:** the number of WORDS (not characters) in comments, review bodies and inline review comments authored by human contributors, split by author where practical (maintainer vs other humans). Reuse the existing deterministic human-author filter (drops the fleet bot, fork-owner logins, Copilot, `[bot]`). Plain code only: count words, never have an LLM read a comment body; this widens no monitoring surface.
5. **Postmortem fields**, so a later analysis can estimate the marginal reduction in human cost for marginal token spend at a fixed quality bar: the **target repo and its quality-bar class** — `endojs/endo` (highest bar) > `endojs/endo-but-for-bots` > `kriscendobot/garden` and `kriscendobot/minion.town` (lowest) — as an explicit ordered field in a config table (e.g. journal `config/quality-bar` or a tracked defaults file) that the maintainer can edit, defaulting to those tiers and `unknown` for any other repo; plus the raw counts that bear on it: human review rounds/threads (counts only), review verdict sequence (CHANGES_REQUESTED/APPROVED counts), number of gauntlet/panel rounds and fix rounds, and tokens by tier/model. Record raw numbers; do NOT compute a quality score or any human-dollar figure.

**Machine-readable too:** emit the same rollup as one JSON line per PR to a journal file the analysis can read in bulk (e.g. `receipts/rollup.jsonl`, append-only, one row per receipt with a `schema` version), with the same fields as above.

**History:** do not silently rewrite old archived receipts. Add a way to backfill the NEW rollup fields for already-archived receipts (`--force` regeneration or a small backfill mode), run it for the existing archive if cheap, and note in the design that older receipts carry the retired MRE section. Preserve idempotency (the three guards in the script header).

**Tests/docs:** update `designs/pr-completion-receipts.md` (state that human-effort estimation was retired and why, one short paragraph), the script tests (add one that asserts no `MRE`/human-dollar text appears and that the word count and quality-bar class are right on a fixture), and shellcheck. Run the relevant script tests before pushing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-05T05:05:19Z
