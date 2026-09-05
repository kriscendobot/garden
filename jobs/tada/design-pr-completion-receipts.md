All work is complete. Let me write the completion report.

## Completion report — `design-pr-completion-receipts`

**Deliverable:** `designs/pr-completion-receipts.md`, a composition design for automated PR completion receipts (merged **and** closed), landed on `main2` (commit `fdf80652`) and mirrored to review PR **kriscendobot/garden#86** for the open questions.

**What the design specifies**
- **Receipt schema** — per-engagement rows (`role / harness / model / tokens / notional $ / calibrated $`) grouped by base with per-base and PR-total subtotals, plus one per-PR maintainer-review figure. Concrete Markdown table example included, with `panel.sh`-style distillation for GitHub's ~65 KB limit.
- **Data-source map** — per-engagement rows from `usage/<base>.jsonl` (carries `role/model/provider/tokens/notional`); calibrated per-base cost from `reputation/events/<base>.md` (`estimated_dollars`/`aggregate_dollars`); base→PR join reuses `cost-by-pr.sh`. Harness = `provider→agent_bin` map (anthropic→claude, moonshot→kimi, etc.).
- **The MRE heuristic** — a defined, reproducible formula `M = S·a + C·b + L/r` over human-filtered `gh api` reviews/comments (sittings, count, char-length), dollars via journal-tunable `maintainer-hourly-usd`, reported as a ratio to machine cost. **Validated live against 3 real PRs** (endo#1075/#1109/#1151) → ~$20–68 of maintainer attention, 10–100× machine cost, consistent with the garden's "human review dominates ~50–190×" finding.
- **Trigger** — a new deterministic `receipt-watcher.sh` (no `claude -p`) modeled on `ci-watcher.sh`, armed on the same maintainer-cleared `comment-repos/` set (one `reconcile_set` line), injection-safe by construction, no monitoring-surface widening. Mints one `<slug>-pr<N>-receipt` job per completed PR.
- **Archive layout** — `receipts/<repo-slug>/<YYYY>/<MM>/pr<N>.md` (repository/date/PR-number), browsable by directory tree.
- **Idempotency** — journal-file marker + `<!-- garden-receipt: repo#N -->` PR-comment marker, watcher pre-check, and `post-job.sh` basename CAS.
- **Build task list** — 6 concrete steps for the follow-up, including extending `cost-by-pr.sh` to closed PRs and producing 10 example receipts.

**Landing** — carries a non-empty `## Open questions` section (MRE constants, maintainer hourly rate, whether fix iterations amplify the estimate), so per CLAUDE.md's garden-own-repo carve-out it landed on `main2` **and** opened review PR #86 against frozen base `main2-2256256` (diff = the design file only), draft, marked `<!-- garden-design-open-questions -->` (verified recognized by `is_open_questions_design_pr`, so the completion machinery will not demand a design-panel gauntlet). Mermaid diagram validated (parse-only).

**Follow-up** — build job `pr-completion-receipts-build` already exists on the board, parked `blocked_on: design-pr-completion-receipts`, pointing at this design; it unblocks when this job lands in `tada/`.

**Verified:** design on `main2` (pushed), PR #86 open with correct base/head/marker, build job parked and gated, inbox empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-pr-completion-receipts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3293862 cached reads)
- Output: 32216 tokens
- Cost: $3.552132
- Wall-clock: 515s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
