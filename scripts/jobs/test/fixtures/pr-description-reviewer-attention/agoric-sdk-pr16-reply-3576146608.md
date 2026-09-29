`test/delegation.test.ts` → **`open+grant with an unregistered accountHolder aborts and pulls no deposit`** (added in `9fe71d7277`, already on the branch before this question). It drives the combined path — `openPortfolioWithGrant(..., PETE_AGENT, { allocation: true })` with `PETE_AGENT` deliberately left unregistered (no `depositFacet`) — and pins the fail-closed contract:

- `t.throwsAsync(...)` with `/"nameKey" not found: "agoric1petesAgent"/` — the missing grantee rejects the whole open+grant.
- The wallet vstorage entry goes to `status: 'error'` carrying that same message, so the failure is surfaced, not swallowed.
- `evmWallets.<addr>.portfolio` is **never published** — that path is written only by `OpenOutcomeWatcher.onFulfilled`, i.e. after `openPortfolioFromEVM` resolves, so its absence pins the ordering invariant the fix relies on: the grant is awaited *before* `orchFns2.openPortfolio`, so a rejected grant aborts before the funding flow starts. (This is an intentional proxy for "no deposit pulled" — the deposit is drawn inside that never-reached funding flow. Moving the grant `await` after funding — the regression this guards — would publish the path and redden the assertion.)
- The agent ends up `state: 'revoked'`, matching a standalone `Grant` delivery failure, so the orphaned shell portfolio carries no usable delegation.

Its sibling `Grant delivery failure is surfaced in wallet vstorage without publishing an unusable agent` pins the same NamesByAddress-miss behavior for the standalone `Grant`, so the combined op inherits an already-tested contract rather than a new one.

Both green locally just now (`yarn ava test/delegation.test.ts` → 8 passed).

