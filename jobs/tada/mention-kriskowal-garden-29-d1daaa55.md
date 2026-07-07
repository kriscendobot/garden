Inbox empty. The job is complete.

---

## Completion report

**Job:** attention directive from mhofman's @-mention on kriskowal/garden#29 — "Please prototype a cosmos upgrade which triggers `v288` (ymax1 on agoric-3 mainnet) being marked as critical."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer had resolved it) → proceeded. Re-fetched the mention as untrusted data; treated the body as a request, verified every claim against source.

**What I did**
1. **Researched agoric-sdk** (fork `kriscendobot/agoric-sdk`, master) via three parallel agents, grounding three things: (a) the cosmos-upgrade → core-eval call chain and the **chain-specific-upgrade precedent** mhofman referenced (`golang/cosmos/app/upgrade.go` `switch ctx.ChainID()`, commit `3658973b8e`); (b) that `critical` is a boolean in the consensus kvStore key `${vatID}.options`, read only by `terminateVat()`, with **no in-band mutation path** (so a core-eval can't do it — only kernel-side host code can); (c) the a3p g:ymax1 test lifecycle and how a vatID is discovered by label (`getDetailsMatchingVats`).
2. **Built the prototype** on branch **`kriscendobot/agoric-sdk@garden-29-promote-vat-critical`** (pushed):
   - `packages/SwingSet/src/controller/promoteVatsToCritical.js` — pure, idempotent promotion run at the `upgradeSwingset()` reboot point; supports per-chain vatID pins (agoric-3→v288/ymax1, agoricdev-25→v320/ymax0) **and** self-chain-gating label mode.
   - Wired into `packages/cosmic-swingset/src/launch-chain.js` (label-gated, because `chainID` isn't available at that reboot point — a genuine wiring wrinkle I surfaced).
   - Exported from `packages/SwingSet/src/index.js`; ava test `packages/SwingSet/test/promote-vats-to-critical.test.js` mirroring `upgrade-swingset.test.js`.
3. **Verified honestly:** ran a standalone algorithm harness — **11/11 scenarios pass** (label/chainID discovery, v288/v320 pins, idempotency, no-op on unrelated chains, notFound, mismatch-Fail). All four edited files pass `node --check`. The ava test is written but **not executed** here (needs a full agoric-sdk build I did not stand up); no end-to-end chain upgrade was run. Both limits are stated plainly in the reply.
4. **Replied on #29** as kriscendobot ([comment](https://github.com/kriskowal/garden/issues/29#issuecomment-4900644797)): agreed #9157 is moot for in-place promotion, presented the prototype + branch, explained the kernel-side-only constraint and the chainID-vs-label wiring tradeoff, and answered the a3p vatID/test question.

**What changed:** one new branch on the fork (4 files); one issue comment. No changes to the garden repo (`main2`) — this job's substance lived in the project fork and the issue thread. Upstream `agoric/agoric-sdk` untouched (comment-and-link-free, per policy).

**Follow-ups (offered in the reply, not done):** firm up gating (strict chainID plumbing vs label), land a proper a3p test, or a swingstore-reboot integration test that faults the promoted vat and asserts the panic.
