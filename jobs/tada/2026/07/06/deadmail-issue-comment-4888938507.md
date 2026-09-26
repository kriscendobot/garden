Comment posted. The job is a design-discussion follow-up, not a code change, so there's nothing to commit to the garden repo. Inbox was empty; issue left open (submitter closes).

## Completion report

**Job:** Dead-lettered message pickup — a new maintainer comment (dckc) on kriskowal/garden issue #26 whose intended recipient `issue-kriskowal-garden-26` had already completed.

**What I did:**
- Read the full issue #26 thread (a scholar design-memo exchange on OpenCollective ⟷ ERTP/Zoe integration for an off-chain, no-blockchain bounty market).
- Fetched dckc's referenced `dckc/vattr97:packages/ertp-ledgerguise/src/escrow-ertp.ts` to ground the reply — a pure-ERTP, no-Zoe/no-`E`/no-vat two-party escrow (the classic escrow2013 shape).
- Folded dckc's three points into a substantive design reply and posted it as an issue comment (never closed the issue): https://github.com/kriskowal/garden/issues/26#issuecomment-4888960540

**Substance of the reply:**
1. *"OC is the source of truth; `E(purse).getCurrentAmount()` routed through the OC API"* — reframed the purse as a **read-through `ledgerguise` facade** (matching the package name), which dissolves the prior memo's mint/backing/reconciliation-by-poll scaffolding. Flagged two honest consequences: the purse API becomes remote/async (hence `E(purse)`), and read-through gives observation but escrow also needs real **write-through custody** into OC's held state or offer-safety is only advisory.
2. *"Not clear how much of Zoe"* — agreed; `escrow-ertp.ts` proves offer-safety is achievable with pure ERTP + Promises, so Zoe's contract host/invitations/reallocation can likely be dropped.
3. *Escrow shape* — mapped `escrow-ertp.ts` one-to-one onto OC's PENDING→APPROVED→PAID lifecycle, and identified the one non-free spot: the escrow's atomic `Promise.all` two-sided payout can half-complete against a real ledger, so settlement must be **staged + idempotent** (APPROVED reservation before PAID commit, per-payout ids). Tied the provisional/final tension from vattr97#3 to the APPROVED phase.
- Closed with a revised, smaller first-spike proposal and an offer to take a specific slice further.

**Changed:** nothing in the repo — a design consideration only. No garden `main2` commit needed.

**Follow-ups:** none required; the reply offers two concrete next slices (a ledgerguise `Purse` adapter over OC GraphQL, or the staged/idempotent settlement protocol) that a maintainer can request as new work.
