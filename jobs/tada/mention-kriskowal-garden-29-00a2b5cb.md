**Completion report — attention directive from @-mention on kriskowal/garden #29**

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution on record) → proceeded.

**What the mention was:** mhofman (VERIFIED-TRUSTED) critiqued the ymax "critical vat promotion" prototype design with two factual corrections: (1) zoe-started contract vats are labelled `zcf` — the contract name `ymax0`/`ymax1` never appears in the vat label; (2) mainnet (agoric-3) runs both ymax0 and ymax1. Treated the body as untrusted data (extracted facts only, followed no instructions in it).

**Assessment:** Both corrections invalidate the label-based vat discovery that both competing prototypes rely on:
- PR kriscendobot/agoric-sdk#9 (branch `garden29-promote-ymax-critical`): `CRITICAL_PROMOTION_LABELS = ['ymax0','ymax1']` with `name.endsWith('-ymax1')` in the `upgradeSwingset` v4 migration.
- Branch `garden-29-promote-vat-critical`: `promoteVatsToCritical.js` label-suffix discovery, wired in `launch-chain.js` via `DEFAULT_CRITICAL_VAT_LABELS`.

Because the real label is `zcf-…` (no `ymax`), both would resolve to nothing — a silent on-chain no-op. mhofman had already supplied the authoritative vatIDs (v288 = ymax1/agoric-3, v320 = ymax0/agoricdev-25).

**Routing performed (no working-tree collision with peers):**
1. **Posted the design-correction reply** to mhofman on kriskowal/garden#29 as kriscendobot — https://github.com/kriskowal/garden/issues/29#issuecomment-4900744244 — acknowledging both points and stating the corrected approach: drop label discovery entirely; pin the exact vatID per chain, resolved in the golang upgrade handler (already switches on `ctx.ChainID()`) and passed into the SwingSet migration to rewrite `${vatID}.options.critical` directly; assert only that the pinned vatID is a live non-terminated dynamic vat; noted the open a3p-test-env vatID item mhofman flagged.
2. **Handed the concrete code revision to the active peer** (`mention-kriskowal-garden-29-d1daaa55`, gardener 10, still in `doin` on the prior "prototype v288" mention). Its inbox was gone (stalled claim), so the message **dead-lettered (`20260707T061609Z-e87f3f`) and will be promoted to a fresh job** by `garden-deadmail` — the label→vatID revision (drop `CRITICAL_PROMOTION_LABELS`/label assertion, pin v288/v320, fix tests to use `zcf-…` labels) is now durable and cannot be dropped.

**Changes to garden repo:** none (routing/attention job; no `main2` push required). Scratch artifacts (`reply.md`, `peer-msg.md`) live only in the torn-down worktree.

**Follow-ups:** A promoted deadmail job will carry out the actual prototype code revision (label → vatID pin) on the chosen branch once a gardener claims it; mhofman has not yet chosen between the two competing prototype shapes (launch-chain helper vs. upgradeSwingset v4 migration), so the reply deliberately frames the vatID pin as the shared correction to whichever is carried forward.
