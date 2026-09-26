Inbox empty. Work complete.

## Completion report

**Job:** Resolve @dckc review comment 3606557191 ("Take advantage of recent typed pattern support in endo") on kriscendobot/agoric-sdk PR #15, `packages/portfolio-contract/src/portfolio.exo.ts`.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution) → proceeded. Worked in an isolated project worktree keyed to this job's base.

**What I found (research):**
- The pinned dependency is `@endo/patterns@1.9.1`. Its `mustMatch`/`matches` still take a bare `Pattern` and do **not** narrow (`mustMatch: (specimen: any, patt: Pattern, ...) => void`; no `asserts specimen is T`). So the CONTRIBUTING.md caveat ("the `mustMatch` in @endo/patterns doesn't do TypedPattern yet") is **not stale** — I left it unchanged. What 1.9.1 *does* provide is the `CastedPattern<T>` cast on the pattern value (re-exported as `@agoric/internal`'s `TypedPattern`), which is what this change leans on.
- Prior commit 155830df3a already pinned the four offer handlers to `FlowKeyShape`. Five *more* methods return a `` `flow${number}` `` (`FlowKey`) to their caller but were still guarded `.returns(M.string())`: `delegationHelper.submitTargetAllocation`, `delegationHelper.submitRebalance`, and `evmHandler.{deposit,rebalance,withdraw}`.

**What I changed (commit c320d9340f):**
- Pinned all five to `.returns(FlowKeyShape)` — reusing the existing `TypedPattern<`flow${number}`>` — matching the offer handlers.
- Generalized the in-file design note to "every method that yields a flow-id key," and annotated the `delegationHelper` guard block.
- Left loose (unchanged, per design notes): settlement watchers + `tap` upcall, durable read-back values (account info, positions, published-status), and Vow-returning methods.

**Verification:** `FlowKeyShape` is `AnyString<…>()` = `M.string()` at runtime, so the change is a proven runtime no-op (only the documented static type tightens; `` `flow${flowId}` `` always matches). Typechecked with `tsgo` by borrowing an installed sibling worktree's toolchain read-only: baseline (unedited) and edited both produced exactly one identical error — a cross-tree `@agoric/zoe` Instance-identity artifact in `test/contract-setup.ts` from the borrow, **zero errors in `portfolio.exo.ts`**, delta zero. A full package test run was not meaningful under the cross-tree borrow and is unnecessary given runtime-equivalence; not performed.

**Pushed & replied:** Rebase-CAS push to `garden31-portfolio-exo-guards` (155830df3a..c320d9340f, bot identity); remote head confirmed `c320d9340f`. Threaded reply posted in reply to comment 3606557191 (discussion_r3606659524) citing the commit, what was tightened, what stays loose & why, and the `mustMatch`/1.9.1 verification.

**Scope:** Did not touch sibling review 4726532241 / comment 3606553507 (separate job). No follow-ups.
