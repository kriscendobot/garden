Rebased PR #877 onto live `llm` tip `cbe605e09` and force-with-lease pushed head `c48a7d83d`. Resolved conflicts by preserving the base’s dependency-edge, shared-endowment, and bundle-documentation changes alongside the PR’s self-reference and text-codec work.

Verification: Endo 210/210 tests passed; xsnap 121/121 passed; targeted compartment-mapper 12/12 passed; changed-file Prettier and ESLint checks passed. PR is now mergeable and 25 CI checks are queued. Posted the completion summary on the PR.

Follow-up: CI must finish. Repository-wide `cargo fmt --all -- --check` still reports broad formatting drift across the live base.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr877-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 723s

<!-- garden-usage-end -->
