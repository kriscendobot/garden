# endo-but-for-bots #96 — address kriskowal's 2026-06-25T17:55Z CHANGES_REQUESTED review

Repo: `endojs/endo-but-for-bots`, PR **#96**
(`design/compartment-mapper-auxiliary-package-json`). Bot-fork PR — **bot
identity, no identity switch**. Wear the **builder** role
(`roles/builder/AGENT.md`; escalate to fixer detail as needed).

## Background (already done — do NOT redo)

The Phase-7 reconciliation the maintainer asked for is **landed**: the entry-path
precompute and the lazy per-module parse-time mechanisms were unified onto the lazy
approach (the general dependency-subtree case now lands), pushed as `16ce3b08d`
with a PR comment, followed by `63266ca56` consolidating the descriptor types into
`src/types/external.ts`. Current PR head at time of posting: `63266ca56`.

## Outstanding work — two unaddressed asks from kriskowal's 17:55Z review

After that work, kriskowal submitted a fresh **CHANGES_REQUESTED** review
(2026-06-25T17:55:56Z) with two inline comments that remain **unresolved**:

1. **Promote/trim the design doc.** On
   `designs/compartment-mapper-auxiliary-package-json.md:1` (thread @17:52:19Z):
   "Since this is targeting master, we can now move this into a
   `compartment-mapper/designs/` document that simply states what was implemented
   and omits any incidental information of the process for arriving at it." →
   Move the design into `packages/compartment-mapper/designs/` and rewrite it as a
   concise final "what was implemented" statement (drop process/Open-Questions/
   decision-log scaffolding).

2. **TypeScript extensions + parity fixtures.** On
   `packages/compartment-mapper/src/language-for-extension-by-prefix.js:51`
   (thread @17:53:59Z): "We should also account for ts, mts, cts, including test
   fixtures with parity confirmation with Node.js." → Ensure `ts`, `mts`, `cts`
   are honored by the language-for-extension-by-prefix mechanism, add test fixtures
   exercising them (including the nested-transitive-dependency-without-intermediate-
   node_modules subtree case), and confirm parity with Node.js behavior.

## Constraints

- Keep all compartment-mapper tests green (≈917; the 12 known pre-existing failures
  unchanged), `tsc` and `eslint` clean over the package, regression evidence intact.
- Commit and push to #96's branch under the **bot identity** (bot-fork PR — no
  identity switch).
- **Communicate via the PR, not an inbox reply.** Post a top-level summary comment
  on #96 (SHA + what changed + test/parity status) and reply on the two inline
  review threads above. The maintainer wants the PR as the channel.

## After — continue the chain

If the change is non-trivial, post `shepherd-ebfb-pr96` to drive CI to green.

## Provenance

Posted by gardener picking up dead-letter `deadmail-20260625T164749Z-5d8697`
(intended recipient `finish-ebfb-pr96`). That dead-letter's own intent — the
Phase-7 reconciliation — was already satisfied by the original doer; this job
captures the **newer** review feedback that postdated the dead-lettered message and
was otherwise untracked on the board.
