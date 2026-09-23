---
ts: 2026-06-15T06:52:33Z
kind: result
role: fixer
worktree: dispatches/fixer--e22b3b
repo: kriscendobot/agoric-sdk
project: agoric-sdk
---

Replaced the two `@typedef {any}` cycle-breaks on PR #5 (`mirror/12527-endo-sync-refresh`) with hand-written interface typedefs per kriskowal's "Continue." authorization on the bot's prior review-thread replies.

Changes:

- `packages/async-flow/src/log-store.js:278` now declares `@typedef {object} LogStore` enumerating the 14 consumer-side methods (matches `LogStoreI` at line 14).
- `packages/async-flow/src/bijection.js:215` now declares `@typedef {object} Bijection` enumerating the 7 consumer-side methods (matches `BijectionI` at line 14).

Both cycle-breaks are now structural: the typedefs have no `typeof prepareLogStore` / `typeof prepareBijection` reference, so the TS2456 chain (preparer body annotates `Ephemera<X, ...>`, `typeof prepareX` recursively references `X`) is broken at the typedef boundary while the `LogStoreI` / `BijectionI` interface guards continue to enforce shape at runtime.

Commit: f295e0d7ab. Force-with-lease pushed onto `mirror/12527-endo-sync-refresh` (lease anchor b0c0d727ee, the dispatch's pre-push state). Pre-push-gates probes ran clean (`--probes-only` mode; node_modules not available for `yarn format` / `yarn lint` / `yarn typecheck`).

Replies posted on both inline threads citing f295e0d7ab:

- log-store.js:278 (parent id 3409241261): https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411511868
- bijection.js:215 (parent id 3409243653): https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411512059

Top-level summary on PR #5: https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4705291415

Broader `@ts-expect-error` call-site narrowing across the PR (log-store.js:179/187/197 and analogous sites) remains explicitly scoped out as a separate Endo-upgrade hygiene follow-up, consistent with the bot's prior committal reply.

CI post-push (early observation, bounded): `lint`, `breakage`, `merge-strategy (chosen)`, `run-scripts-tests`, `wait-integration-pre-checks`, `up-to-date` pass; `build (node-new)`, `build (node-old)`, `flake-check`, `gotest`, `golangci-lint`, `test-dapp` still pending at observation window close. No red signals on the typecheck-equivalent path so far.

Self-improvement: nothing this time.
