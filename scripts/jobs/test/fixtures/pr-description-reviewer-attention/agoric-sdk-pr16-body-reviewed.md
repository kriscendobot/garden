## Summary

Opening a ymax portfolio and delegating allocation control to an agent took **two** signatures — `OpenPortfolio` then a separate `Grant`. This adds one EVM op, `OpenPortfolioWithGrant`, that does both in a **single** signed, permit2-wrapped message (`allocations` + `accountHolder` + `permissions`).

Scope: the ymax contract only. EMS/UI changes to build and sign the message are out of scope. (issue kriskowal/garden#42 · AGO-615)

## What changed

- **`portfolio-api`** — new `OpenPortfolioWithGrant` EIP-712 op, permit2-wrapped like `OpenPortfolio`.
- **`portfolio-contract`** — when `accountHolder` is present, `openPortfolioFromEVM` performs the grant through the **exact** authorization/validation path of a standalone `Grant`. The grant runs **before** the open is kicked off, so a rejected grant fails the whole message rather than leaving a portfolio open without its delegation.
- **test tools** — an `openPortfolioWithGrant` trader helper.

`OpenPortfolioWithAutoFeatures` already combined create + delegate-to-the-**planner**; this covers the issue's other case: delegating **allocation** control to an arbitrary **agent address**, which previously required the separate `Grant`.

## Verification

`yarn ava` in `packages/portfolio-contract`: 25 tests pass (integration: one message → portfolio created → delegation redeemed → agent rebalances; unit: op dispatched as an open, forwards all three fields). `tsgo` clean.

