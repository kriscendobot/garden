---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: gardener
split_source_handler_timeout: 2400
split_orchestration: backfill-receipt-rollup-20261105-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-05T06:03:28Z
---

# Deliberate overrun decomposition for `backfill-receipt-rollup-20261105`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by backfill-receipt-rollup-20261105-split`, then record `backfill-receipt-rollup-20261105-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by backfill-receipt-rollup-20261105-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS backfill-receipt-rollup-20261105-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: backfill-receipt-rollup-20261105-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-11-05T05:10:57Z
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Backfill the receipt rollup for the existing journal archive** (follow-up of `remove-receipt-human-effort-add-rollup-20261105`, main2 6025f283bb7).

For every archived receipt `receipts/<slug>/<YYYY>/<MM>/pr<N>.md` on `journal2` (~209 files; read `repo:`/`pr:` from the frontmatter), run `scripts/jobs/pr-receipt.sh <repo> <N> --backfill-rollup --dir <a private journal clone>`. It appends one `schema: 1` row to `receipts/rollup.jsonl` per PR, is idempotent (skips a PR that already has a row), never rewrites the archive markdown and never posts. To avoid re-pricing the whole ledger per PR, compute `scripts/jobs/cost-by-pr.sh --base-map` ONCE into a file and export `GARDEN_RECEIPT_BASEMAP=<file>`. Pace the GitHub reads (3 paginated endpoints per PR) to stay off the primary rate limit; skip and list PRs that fail. Report row count before/after and any skipped PRs. Old archives keep their retired MRE section by design.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T06:04:40Z
