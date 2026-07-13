# fix — apply the panel must-fix items on kriscendobot/agoric-sdk#16

Run the **fixer** role. A panel review on this fork PR returned
disposition **changes requested**; apply the two must-fix items, re-run the
panel against the new head, and shepherd CI to green.

- **Repo:** `kriscendobot/agoric-sdk` (the garden's own fork — experimentation
  on this fork is authorized per the maintainer directive of 2026-06-28,
  kriskowal/garden#9; pushing to the PR head branch and posting the PR summary
  comment are authorized).
- **PR:** kriscendobot/agoric-sdk#16 — `feat(portfolio-contract): open
  portfolio and grant control in one signed message`
- **Base:** `master`  **Head branch:** `garden42-portfolio-open-with-grant`
- Origin issue: kriskowal/garden#42 (feature AGO-615).

## Must-fix (from the 8-seat panel, disposition: changes requested)

1. **The inline comment overstates atomicity.** In
   `packages/portfolio-contract/src/portfolio.contract.ts`,
   `makeNextPortfolioKit` mints and durably registers the portfolio kit (id
   counter advanced, delegation record published) *before* the awaited `grant`.
   A rejected grant therefore does not avoid "leaving a portfolio open" — it
   orphans a shell portfolio; only the funding flow (`orchFns2.openPortfolio`)
   is genuinely gated behind the grant. Soften the inline comment to state what
   is actually atomic (funding + delegation), not portfolio creation.

2. **Failure-mode change is untested and asymmetric with standalone Grant.** A
   grant *delivery* failure (e.g. an `accountHolder` not registered in
   NamesByAddress — caller-triggerable, and standalone Grant surfaces this
   non-fatally per an existing test) now aborts the whole
   `openPortfolioFromEVM` and leaves an orphaned registered portfolio. Both
   existing new tests are happy-path. Add a combined-flow failure test:
   `openPortfolioWithGrant` with an unregistered `accountHolder` → assert the
   operation errors, no deposit is pulled, and no active/funded portfolio
   results.

## Advisory (non-blocking — note the disposition, do not necessarily act)

- Griefing surface: no funds move on the grant-failure path, so an attacker can
  cheaply accrete orphaned portfolio kits / burn portfolio IDs. Validating cheap
  inputs (permissions shape, `accountHolder`) *before* `makeNextPortfolioKit`
  would close it. This is a design call (whether orphaned-portfolio-on-failed-grant
  is acceptable) — surface it, do not silently redesign.
- Structural gate: the grant fires on `'accountHolder' in data`, a field-presence
  discriminant. Consider an assertion or a one-line note of the wire invariant.
- Latency coupling: a slow grantee deposit facet can stall portfolio-open latency.

## Panel loop

This is the loop half of panel→fixer: after the must-fix commits land, re-run
the panel against the new head; continue until the panel surfaces no further
must-fix dispositions. Post the required top-level PR summary comment on
kriscendobot/agoric-sdk#16 (head SHA, items → addressing SHAs, anything declined
with its reason, verification status).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-42
issue_url: https://github.com/kriskowal/garden/issues/42#issuecomment-4959413513
submitter: dckc
----- END ISSUE NOTE -----

When the fix loop settles, leave a brief status comment on the origin issue
kriskowal/garden#42 (comment on the issue URL; never close it — the submitter
does that) summarizing the applied fixes and the new PR head.

<!-- garden-reaped: 1 -->
