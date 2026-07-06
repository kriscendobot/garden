Comment is live and rendered; inbox is empty. This was a design-memo reply task with no garden `main2` change required, so there is nothing to commit or push.

---

**Completion report**

**Job:** attention directive from dckc's @-mention on kriskowal/garden #26 (issue-comment, VERIFIED-TRUSTED sender).

**What I found:** Issue #26 is dckc's request for a scholar consideration of an OpenCollective⟷ERTP integration. A scholar had already posted a detailed design memo (2026-07-05) that leaned heavily on an **on-chain** framing — on-chain gimix, IST, a fiat↔crypto bridge. dckc's new comment is a substantive correction to that framing: **no blockchain, no consensus** — ERTP/Zoe run off-chain, and OpenCollective accounts should be modeled *as ERTP purses* to move real money through smart contracts.

**Preflight:** `pr-feedback-preflight.sh kriskowal/garden 26 4888913059 dckc` → exit 0 (no peer had resolved it), so I proceeded.

**What I did:**
- Acknowledged the comment with a 👀 reactji.
- Posted a **revised design consideration** as a reply comment (https://github.com/kriskowal/garden/issues/26#issuecomment-4888930018) that reframes the memo under dckc's correction: ERTP/Zoe as off-chain ocap libraries; OpenCollective account ⟷ ERTP purse as the load-bearing primitive (Brand = currency-at-fiscal-host, Mint = connector minting on verified contribution / burning on paid expense, Payment = bearer right to a Wise/PayPal withdrawal); a fully off-chain Zoe-escrow rework of the bounty example; an honest accounting of which frictions **dissolve** (no-crypto-payout, bridging/FX) versus which **remain** (the #3 provisional-vs-final tension → OpenCollective's PENDING/APPROVED/PAID lifecycle; GraphQL-poll reconciliation over unreliable webhooks; a new custody invariant that minted supply ≤ fiscal-host balance replaces what consensus would have watched); and a revised, off-chain first spike.

**Changed:** nothing in the garden repo — issue-scoped design reply only; comms via comment per the issue/PR-scoped norm. My worktree is clean; no `main2` push.

**Follow-ups:** None required. The reply offers dckc a next concrete artifact (GraphQL mutation/payout shapes, the Mint reconciliation loop, or a Zoe contract sketch) on request; if he picks one, that would be a fresh scholar/designer job.
