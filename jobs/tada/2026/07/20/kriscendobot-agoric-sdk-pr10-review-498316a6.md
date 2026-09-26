Done. All three inline review items from @michaelfig's review were addressed on the PR head branch.

## Completion report

**Job:** Review directive on kriscendobot/agoric-sdk PR #10 (review 4739691767 by @michaelfig).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution). Review body was the `[INLINE-REVIEW]` marker; substance was three inline comments, all on `designs/beans-v2-deflation.md` (a design-stage doc, no code). All fetched bodies treated as untrusted data.

**Changes** (worktree off PR head `design/beans-v2-deflation`, commit `ca5f4b8e94`, pushed):

1. **line 84 — "clarify the incomplete sentence":** Completed the truncated "An entry may name a type with no default charge…" — it now reads that such an entry "carries no default admission charge at all … which introduces a bean charge for a message that is otherwise free."
2. **line 92 — "replace the obsolete IST example":** Replaced "so BLD can burn while IST, whose supply is managed by Inter Protocol, does not" with "a native denom like BLD can burn while e.g. USDC, which is an IBC-transferred asset from an external chain, does not." Applied the same fix to the parallel IST mention in Open questions for consistency.
3. **line 124 — "rename ChargeBeansNow → SettleBeansOwing":** Renamed `ChargeBeansNow` to `SettleBeansOwing(ctx, addr) (beanGas, beanFees)` at all 13 occurrences (prose + mermaid node). Revised the definition so it adjusts the `beansOwing` record and includes the fee/gas formulae (`beans × fee_unit_price / beans_per_unit["feeUnit"]`, gas = fee ÷ `min_gas_price`), moves no coins itself, and leaves the disposition policy entirely to the caller.

**Feedback loop closed:** posted an inline reply on each of the three comments citing commit `ca5f4b8e94` (replies allowed on the fork per the 2026-06-28 experimentation directive; upstream agoric/agoric-sdk untouched).

**Follow-ups:** none. PR remains a maintainer-owned draft; un-drafting is the maintainer's call. Inbox drained clean.
