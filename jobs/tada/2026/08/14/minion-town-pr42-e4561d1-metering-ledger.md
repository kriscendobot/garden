Implemented increment 1 and opened draft PR https://github.com/kriscendobot/minion.town/pull/45.

- Added provider-neutral in-memory and DynamoDB resource ledgers with root/subaccounts, issuance, transfer, reserve, settle, release, refund, idempotent receipts, and atomic double-entry events.
- Added pure event-history statistics projection with late-settlement, pricing-version, and annotation-revision attribution.
- Added generated conservation/retry tests, last-credit concurrency coverage, duplicate-measure coverage, and before/after crash tests for every DynamoDB balance boundary.
- Left live pricing, debit/publish wiring, gateway/daemon integration, ERTP, subscriptions, and statistics UI untouched. The PR documents the policy questions the schema leaves open.
- Verification: `npm test` passed 236 tests with 3 environment-gated skips; typecheck, all pre-push probes, local verification, and GitHub CI passed.
- Follow-up: increment 2 remains deferred until this lands; no follow-up job was posted.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr42-e4561d1-metering-ledger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1172s

<!-- garden-usage-end -->
