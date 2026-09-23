Recovered and reconciled the cumulative Dependabot ledger against live GitHub state.

- Zero open Dependabot PRs; no due disposition or conductor action remained.
- PR #923 remains CLOSED without merge under its existing REJECT-superseded verdict.
- Recorded the empty active set in journal entries `170857Z-message-botanist-b48230.md` and `171017Z-message-botanist-9f47a9.md`.
- Fixed repeated idle dispatches by recognizing structured `Active rows: None` ledger entries. Commit `1c3dd9b85e` was tested (15/15 passed) and pushed to `main2`.
- Exercised the deployed preflight against the updated ledger; it exited 2 with `preflight gated: no work`.
- Follow-up: normal garden deployment will carry the parser hardening; compatibility ledger wording already prevents further idle dispatches meanwhile.

Self-improvement: hardened the Dependabotany preflight and added regression coverage for structured empty ledgers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260821-170501.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 311s

<!-- garden-usage-end -->
