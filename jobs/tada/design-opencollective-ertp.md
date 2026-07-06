Inbox is clear and the deliverable is posted. Final report:

Designer job `design-opencollective-ertp` complete.

**What I did.** Read the full kriskowal/garden#26 thread (dckc's corrections plus the scholar's superseded memos), the `escrow-ertp.ts` prior art and its surrounding `ertp-ledgerguise` package (`purse.ts`, `sealer.ts`, `settlement.ts`), and the bounty-market context issues dckc/vattr97 #11/#4/#3. Formalized the settled frame into a single design-of-record comment, posted as kriscendobot in the thread's house style:

**Comment URL:** https://github.com/kriskowal/garden/issues/26#issuecomment-4896489088

**What the design covers.** Problem/goal (real money through off-chain smart contracts, fiscal host as trust anchor, no consensus); the read-through purse façade as a second `ertp-ledgerguise` ledger backend over OC GraphQL v2 (`getCurrentAmount` → balance read, `withdraw` → `createExpense`+`processExpense`, deposit → observed settled transaction), with the three-facet authority split; the single-sided oracle-gated escrow adapted from `makeErtpEscrow` (attestation promise replaces party B's leg); the custody invariant ("every escrowed amount is backed by an actual OC hold") with three hold representations, recommending an earmarked OC Project sub-account; the polling reconciliation loop (webhooks as hint only, citing opencollective#7892); the staged idempotent APPROVED→PAID settlement keyed by payout id, with the #3 provisional phase living in OC's expense lifecycle; a mermaid sequence diagram of fund → oracle-attest → settle; and a smallest-demonstrable-spike plan.

**Follow-ups dckc must choose between** (all explicit as open questions in the comment):
1. How much Zoe — the design answers "none" with a recommendation; dckc confirms or names the multi-party flow that changes it.
2. Where the persistent design file lives — `designs/opencollective-ertp.md` in dckc/vattr97 via an authorized PR, or the comment as record. No branch was pushed and no PR opened anywhere, per the project note.
3. Hold representation — recommended OC Project sub-account, or expense-lifecycle holds.
4. Spike deployment particulars (collective, fiscal host, token scopes).

Nothing changed in the garden tree; the deliverable is the comment. Issue left open for dckc.

Self-improvement: nothing this time.
