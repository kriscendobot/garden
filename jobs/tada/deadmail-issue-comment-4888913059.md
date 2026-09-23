Comment posted. This was a design consideration reply — no code changes to commit. Done.

## Completion report

**Job:** Dead-lettered issue-comment intent for `issue-kriskowal-garden-26` (kriskowal/garden issue #26, "opencollective connector, ERTP integration"). The original scholar doer had already completed, so I picked up the intent: fold dckc's new comment into the work and reply on the issue thread.

**Context:** A prior scholar memo surveyed OpenCollective⟷ERTP integration but assumed ERTP/Zoe run on the Agoric chain (IST, on-chain gimix escrow, fiat↔crypto bridging). dckc (maintainer) corrected the load-bearing assumption: *ERTP and Zoe don't have to be on a blockchain* — his goal is to move real money through smart contracts via OpenCollective, no consensus, modeling OC accounts as ERTP purses.

**What I did:** Posted a substantive reply (https://github.com/kriskowal/garden/issues/26#issuecomment-4888923255) that reframes the prior memo around the correction:
- ERTP/Zoe as plain hardened-JS libraries in a single trusted process (the fiscal host); the chain's only job — decentralized trust — is simply removed, nothing of value lost since the host is already a legal entity holding real money.
- A literal Brand/Mint/Purse/Payment ⟷ OpenCollective balance/host/collective/expense mapping ("OC accounts as ERTP purses").
- The one hard question the reframing surfaces: dual-ledger authority (OC-as-source-of-truth vs ERTP-as-source-of-truth), recommending OC authoritative + poll-don't-trust-webhooks.
- Repositioned what Zoe still buys off-chain (offer-safety/atomic escrow; provisional-vs-final #3 mapped onto OC's PENDING/APPROVED→PAID lifecycle) and how gimix's on-chain half collapses into a library inside the oracle-server.
- A revised first-spike proposal and an offer to take any slice further.

**Changed:** One issue comment on kriskowal/garden#26. No garden library or project-repo code changes; nothing to commit/push. Did not close the issue (submitter's prerogative).

**Follow-ups:** None required. Open offers left on the thread (reconciliation protocol sketch, `createExpense` GraphQL shapes, off-chain ERTP/Zoe bounty skeleton) will re-enter as new jobs if dckc requests one.
