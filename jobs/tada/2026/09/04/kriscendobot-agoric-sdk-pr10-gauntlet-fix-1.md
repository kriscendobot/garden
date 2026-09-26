CI is GREEN (rc 0, 77 checks, 0 failures) via the prescribed tool. The fix stage is complete.

---

## Completion report — FIX round 1, kriscendobot/agoric-sdk PR #10

**Deliverable:** Applied the design-panel round-1 must-fix items to `designs/beans-v2-deflation.md` (the only file in this design-only PR), pushed as a review-feedback follow-up commit to the PR head, and drove CI to green.

**What I did**
- Resolved head to the fork branch `kriscendobot:design/beans-v2-deflation`, took an isolated project worktree, and read the latest panel verdict (7 design seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).
- Grounded the substantive fixes against the cited code: `ante/ante.go` (DeductFee runs before SigVerification, Admission last), `app/app.go` (`vbank/reserve` has nil permission, no swingset macc), `expected_keepers.go` (BankKeeper lacks `BurnCoins`/`SendCoinsFromModuleToModule`), and the exemption paths.

**Must-fix items addressed**
- **Fee mechanism (critic/skeptic):** rewrote `BeanFeeDecorator` to remove the builtin `DeductFeeDecorator` and perform the whole deduction itself (deduct declared fee once, split into beanFees + remainder). The tx is never mutated, so signature verification and mempool priority see the original signed fee. No synthetic-tx / sig-break.
- **"Behaves exactly as today" (critic/skeptic/decomplector):** made `min_gas_price` the master switch — unset (default) keeps the legacy account-balance threshold-debit path verbatim; setting it opts into the ante-folded model. Fixes the funding-source change and zero-fee rejection, and gives the dual-role knob a coherent default.
- **Burn app-wiring (critic):** added a *Software-upgrade prerequisites* section naming the swingset Burner module account and the expanded BankKeeper interface; bounded requirement 1 to the shipped capability.
- **Debtor identity vs fee payer (skeptic/decomplector/ergonomist):** `AddBeansOwing`/`SettleBeansOwing` now key the same address; the fee payer funds every debtor the tx charges (feegrant-aware).
- **Simulate sentinel (decomplector/ergonomist):** explicit `simulate bool`, not nil-Coins.
- **Arg naming (ergonomist):** `amount` → `count`.
- **Exemptions (skeptic/critic):** corrected — neither `privilegedProvisioningCoins` (PowerFlagFees, out of scope) nor `IsHighPriority` (inbound queue size) waives bean charges.
- **Overclaim + dust (critic/skeptic):** softened "formula becomes a param" to per-message-type coefficients; stated the feeUnit dust bound; added a Parameter validation section.
- **Novice:** explained "deflationary" in Problem; stated the beans→fee-units→coins→gas chain up front.
- **Copyeditor/pedant style:** labeled frontmatter, typist-friendly code points (removed `× → − ≥ ÷`), removed all 18 em dashes, "Cosmos SDK" spelling, parallel Requirements, fixed appositive, fixed mermaid labels (`<br/>`, quoted, traceable terminal branches). Mermaid validated `flowchart-v2 OK`; glyph scan clean.

**Pushed:** commit `8c31ccb13a` via `safe-push-pr-head.sh` (advanced `5c8c53efa0 → 8c31ccb13a`), confirmed live on the PR head.

**CI:** GREEN — `ci-wait-merge.sh … --no-merge` rc 0, 77 checks (66 success, 11 skipped), 0 failures.

**Note/follow-up:** the panel's should-fix on file placement (`designs/` vs a `packages/<pkg>/docs-design/` convention) was left in place deliberately — moving would orphan michaelfig's existing inline review threads, and the design is chain-layer (golang/cosmos) with no matching package docs-design dir. Not a must-fix. Per the gauntlet contract I stopped here without re-running the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-agoric-sdk-pr10-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 92 tokens (3989434 cached reads)
- Output: 42717 tokens
- Cost: $5.678119499999999
- Wall-clock: 1302s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
