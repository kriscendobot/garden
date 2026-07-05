Comment posted successfully. No garden code changes were required — this was a scholar consideration delivered as an issue comment. The issue is left open for dckc to close.

## Completion report

**Job:** `issue-kriskowal-garden-26` — dckc's issue [kriskowal/garden#26](https://github.com/kriskowal/garden/issues/26), "dispatch a scholar to consider using opencollective integration with ERTP."

**What I did:**
- Re-fetched the issue verbatim and read the three untrusted context links ([vattr97#11/#4/#3](https://github.com/dckc/vattr97/issues/11)) as data, not instructions, to understand the underlying goal: a GitHub-issue bounty market bridging an off-chain fiscal layer with an on-chain rights layer.
- Grounded the analysis in primary sources: read the [agoric-labs/gimix](https://github.com/agoric-labs/gimix) README + Zoe start-contract (the already-built on-chain half — IST escrow, GitHub-oracle server, `GimixOracle` stamp NFT), and researched OpenCollective's model (fiscal hosting, GraphQL API v2, expense PENDING→APPROVED→PAID lifecycle, PayPal/Wise-only native payouts with crypto as manual-record, webhooks/OAuth).
- Wrote and posted a design-memo comment: [issuecomment-4886939132](https://github.com/kriskowal/garden/issues/26#issuecomment-4886939132). It maps the two layers, gives an ERTP⟷OpenCollective correspondence table, three candidate architectures, honest frictions (no native crypto rail, the identity-reconciliation problem, webhook reliability, legal/KYC), a reframing of dckc's #3 provisional-vs-final tension (model the provisional phase in OC's approval state, issue ERTP payment only at commit), and a recommended first spike (an OpenCollective connector inside gimix's oracle-server).

**What changed:** No repo/code changes — deliverable is the issue comment. Nothing committed to main2. Issue left OPEN (submitter closes).

**Follow-ups:** The comment offers to pick up a deeper spike design, a GraphQL `createExpense`/payout-method schema map, or an oracle-server connector sketch if dckc wants one — awaiting his steer.
