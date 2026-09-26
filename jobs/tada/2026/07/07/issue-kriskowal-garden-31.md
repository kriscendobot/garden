Inbox empty. The job is complete.

## Completion report

**Issue kriskowal/garden#31 (dckc): "finish exo surface of portfolio-contract"** — fill in interface guards for the exos in `Agoric/agoric-sdk` `packages/portfolio-contract` that still had `undefined` guards, taking extra care with compatibility.

**What I did**
- Worked on the `kriscendobot/agoric-sdk` fork (per the standing scope directive: fork experimentation permitted, upstream `agoric/agoric-sdk` untouched).
- Found the four unguarded exos (via `interfaceTODO` / "interface TODO" / "XXX should have interface guard" markers) and filled them all in; the other four exos in the module graph (`PortfolioAdmin`, `Planner`, `Resolver`, `messageHandler`) were already guarded and left alone.

**Exos guarded**
- `PortfolioPub` public facet (`portfolio.contract.ts`)
- `Position` exoClass (`pos.exo.ts`)
- `OperationOutcomeHandlers` watcher kit (`evm-wallet-handler.exo.ts`)
- `Portfolio` exoClassKit — all 14 facets (`portfolio.exo.ts`)

**Approach:** compatibility-first, respecting the Foo/FooExt evolution convention — loose guards (`M.any`/`M.record`/`VowShape`) for evolving structured payloads, precise guards for stable scalars; extensible `M.string()` for pool keys / yield protocols; optional trailing args for watchers, upcalls, and offer handlers; and a `Vow`-or-`Promise` guard on `reader.getStoragePath` (which the flows tests exposed as a real over-strictness — exactly the compatibility hazard dckc flagged).

**Verification:** `yarn ava` for the package is green (308 passing, incl. every exo/contract/flows/rebalance/evm-wallet-handler/planner/resolver suite that instantiates these exos); zero interface-guard rejections in the run. The one non-passing test file fails only on an unbuilt workspace dep (`@agoric/client-utils/dist`) in the sandbox, not on a guard. Scoped `tsc` shows no new type errors from the change (remaining errors are environment build-gaps, present in untouched files too).

**Where the work is:** fork branch `kriscendobot/agoric-sdk:garden31-portfolio-exo-guards`, commit `ab7950945`. Not opened as a PR and not ferried (no upstream action taken); ready for review/ferry when the maintainer wants it upstream.

**Reply:** posted a summary comment on kriskowal/garden#31 (issue left open for the submitter to close). No upstream `agoric/agoric-sdk` interaction or cross-links.

**Follow-ups:** if desired, a maintainer can authorize a ferry of the branch upstream; the fork branch is otherwise self-contained.
