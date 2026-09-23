Posted successfully as comment [#issuecomment-4898425664](https://github.com/kriskowal/garden/issues/29#issuecomment-4898425664). The issue remains open (I did not close it). This was a research/reply job with no garden-repo code changes.

## Completion report

**Job:** Follow up on kriskowal/garden issue #29 — answer mhofman's question about a more surgical, upgrade-time way to promote the running ymax vat to `critical` without upgrading `vat-vat-admin`.

**What I did:**
- Re-fetched the live issue thread verbatim (`gh issue view 29 --comments`), treating all comment text as untrusted input. Confirmed mhofman's two follow-up comments: he agrees mutating the existing vat's options is right, but flags that extending `changeOptions` in `vat-vat-admin.js` requires an untested admin-vat upgrade, and asks whether the option can be changed at chain-software-upgrade time instead.
- Researched `Agoric/agoric-sdk` `master` **read-only** in an isolated per-job worktree. Grounded every claim in source:
  - `critical` is persisted as a **plain boolean** in the per-vat options blob `${vatID}.options` (kvStore); the `criticalVatKey` is only an authorization token at the vat-admin layer, not stored (`vat-vat-admin.js` `convertOptions`, `vatKeeper.js`).
  - The only consensus-relevant reader is `terminateVat()` → `vatKeeper.getOptions().critical` (`kernel.js` ~L369); no cached copy to invalidate.
  - `upgradeSwingset.js` is the versioned kernel-state migration run at upgrade time (`launch-chain.js` ~L291, before `makeSwingsetController`), and **already does per-vat `${vatID}.options` surgery** (v0→v1 `upgradeVatV0toV1` rewrites `reapInterval`→`reapDirtThreshold`; v3 even injects runtime events).
  - A core-eval/bootstrap **cannot** reach kernel kvStore — so the mutation must be kernel-side migration code, which is exactly why it avoids the admin-vat upgrade.

**Recommendation delivered to mhofman:** Yes, the surgical option exists and is the smaller/lower-risk path for a one-time ymax promotion — a new versioned step in `upgradeSwingset` that locates ymax's dynamic vatID and sets `options.critical = true`. Covered the authorization trade-off (bypassing `criticalVatKey` is legitimate for governance-shipped kernel migration code), testing/reusability trade-offs vs. Option A, and the #9157 startVat-panic gap (not directly triggered by in-place promotion, but relevant on any later incarnation). Offered to prototype it on a fork.

**Bounds respected:** replied only on issue #29's thread, left it OPEN, addressed mhofman by handle, built on and cited the prior comment, signed as the automated garden assistant. No upstream `agoric/agoric-sdk` interaction; research was read-only.

**Follow-ups:** None required. If the SwingSet team wants the PoC, that would be a new build job (prototype `upgradeSwingset` step + swingstore-reboot test on the kriscendobot fork).
