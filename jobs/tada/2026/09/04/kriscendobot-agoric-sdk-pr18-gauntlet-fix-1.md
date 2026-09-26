---
orchestration-failed: true
---
All substantive work is complete and verified (fix commit `8e4a8d3e8e` is the PR head; CI terminal RED on only the unrelated `test-quick (node-old)` xsnap `pack and install` inactivity-timeout flake). The repeated requeues are because I previously placed the `gauntlet-stage-result` marker *after* the `<<<GARDEN-JOB-COMPLETE>>>` line, so the signal was not the literal last line. Re-emitting with correct ordering — marker first, completion signal dead last.

## Gauntlet FIX round 1 — kriscendobot/agoric-sdk PR #18 — report

**Done.** Applied the panel's round-1 must-fix + should-fix items to the sole diff file `packages/portfolio-contract/docs-design/erc4626-vault-registry.md` and pushed as a review-feedback follow-up to PR head `design-erc4626-vault-registry` (head `8e4a8d3e8e`, commit +158/−21, single file).

**Changes (all from the panel verdict):**
- MF1 — §3.4 `assertKnownPlace` takes a `src`/`dest` role; withdrawals skip the status gate so retired/probationary instruments can be unwound (R8).
- MF2 — added the `status`-field TOCTOU/replay-safety table + fix-at-acceptance/journal-the-decision invariant.
- MF3 — added "Reconciliation with PR #15" (dckc's guard-replaces-mustMatch vs. dynamic registry).
- SF4 — ERC-4626 inflation/donation attack added to the R5 attestation checklist.
- SF5 — `status` pinned to a closed `M.or(...)` enum.
- SF6 — `lookupVault` uses `contracts[chainName]?.[poolKey]`.
- SF7 — two-phase activation + capability split stated as requirements.
- SF8 — corrected misquoted TS types (`` `0x${string}` ``, `` `@${AxelarChain}` ``), ASCII ellipses.
- Corner findings — regex rejects underscore vault-name segments (example); EIP-55 normalization for re-add idempotency.

**CI:** Terminal RED. 65 SUCCESS / 11 SKIPPED / 1 FAILURE. Sole failure `test-quick (node-old)` → `install › pack and install xsnap` inactivity timeout, confirmed across the original run + two `--failed` reruns (node-new cleared, node-old persistently times out). A node-old runner-capacity flake in `packages/xsnap`, unrelated to a docs-only change.

**Follow-up:** Panel's substantive items all addressed and pushed; the red is a spurious xsnap pack/install timeout that a maintainer may treat as such or which may clear under lighter runner load. Per the fix-stage rule, terminal RED → orchestration-failed.

<!-- gauntlet-stage-result: fix=still-pending -->

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-agoric-sdk-pr18-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 122 tokens (4608429 cached reads)
- Output: 37441 tokens
- Cost: $11.21336825
- Wall-clock: 4242s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
