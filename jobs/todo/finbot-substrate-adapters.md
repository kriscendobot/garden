<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-26T09:39:59Z -->

# GOAL: executor signing adapters for real substrates (ymax Path A / Path C)

## Context
`packages/pipeline/rebalance.js` mirrors the ymax protocol (`computeTargetBalances`
+ `deriveSteps` solver) and each step carries `route: 'sim:single-venue'` as a
placeholder for real venue/route detail. The executor dry-runs against a paper
portfolio. `designs/ymax-integration.md` § Three integration paths is the map.

## Build (decompose further as needed)
- Path A (Agoric): consume `@agoric/portfolio-api` `computeTargetBalances` directly
  (decide: adopt vs keep the mirror), and a `--live` executor adapter that submits a
  `rebalanceTx` via a signing smart wallet (`makeSigningSmartWalletKit` shape).
- Path C (non-Agoric): EVM/Solana executor signing adapters; fill the step `route`
  with the real place/route identifiers.
- A substrate-selection layer so the planner's steps carry the target venue.

## Safety bounds (hard)
Design from PUBLIC ymax-planner / portfolio-contract shape only. Do NOT modify
agoric-sdk and do NOT require the internal ymax-web repo; flag where internal
detail would refine rather than fabricating it. Live signing stays gated behind
explicit per-job maintainer authorization — this job is design + dry-run-proven
adapters, NOT a live-enable.

## Done
At least one substrate adapter built behind the live gate with a dry-run proof
path; the route/place markers are real, not `sim:single-venue`; tests green.
