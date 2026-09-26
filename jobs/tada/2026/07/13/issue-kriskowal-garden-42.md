Inbox empty; garden worktree clean (all work was in the fork, committed and pushed). Job complete.

## Completion report

**Issue:** kriskowal/garden#42 (dckc, AGO-615) — ymax should support opening a portfolio and delegating control to an agent in one signature instead of two.

**What I did**

Mapped the ymax portfolio contract (`Agoric/agoric-sdk`, `packages/portfolio-{contract,api}`) and found the two-step flow is two EIP-712 EVM operations: `OpenPortfolio` (permit2-wrapped, carries the deposit) and a standalone `Grant` (`accountHolder` + `permissions`). Added a single operation that does both.

Changes (on the `kriscendobot/agoric-sdk` fork, per the garden's fork-experimentation rule):
- **portfolio-api** — new `OpenPortfolioWithGrant` EIP-712 operation type (`allocations` + `accountHolder` + `permissions`), permit2-wrapped like `OpenPortfolio`.
- **portfolio-contract** — `openPortfolioFromEVM` performs the grant when `accountHolder` is present, reusing the standalone `Grant`'s exact auth/validation (`sourceAccountId` set on the EVM-opened kit; `grant` enforces `allocation === true`). Grant runs before the open flow kicks off, so a rejected grant fails the whole message. EVM dispatcher routes the new op as an "open".
- **test tools** — `openPortfolioWithGrant` trader helper.
- **tests** — unit (handler dispatch/payload) + integration (real contract: one message → portfolio created → delegation delivered, redeemed, and used to rebalance).

Noted that `OpenPortfolioWithAutoFeatures` already combined create + delegate-to-the-*planner*; this new op covers the remaining case — delegating allocation control to an arbitrary agent address.

**Verification (executed, not just inspected)**
- `yarn ava` in `packages/portfolio-contract`: **25 tests pass**, including my new integration test that drives the real `openPortfolioFromEVM` grant branch end-to-end (delivery + `.agents` vstorage record + a functional delegated rebalance) and the unit dispatch test.
- `tsgo` type-check: clean for all changed files (only remaining error is a pre-existing unbuilt-dep `@agoric/client-utils` import, unchanged from HEAD).
- Sandbox note: the full monorepo won't build here (native better-sqlite3/xsnap disabled by `enableScripts: false`), but the exo/contract tests run under ava's `ts-blank-space` loader after I built `cosmic-proto`'s `dist` with esbuild.

**Artifacts**
- Branch `garden42-portfolio-open-with-grant` on `kriscendobot/agoric-sdk`, commit `b28640ba8f` (pushed).
- Reply posted on issue #42 (issue left **open** for the submitter to close, per issue-inbox discipline). No upstream Agoric interaction or PR (upstream stays comment-and-link-free).

**Scope / follow-ups:** Contract-only, as the issue requested. EMS/UI work to construct and sign the combined message is out of scope. A fork-internal PR can be opened on request.
