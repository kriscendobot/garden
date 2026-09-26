Done. Audit complete and posted to the issue.

## Completion report

**Job:** issue-kriskowal-garden-21 — "dispatch a Fable agent to audit the YMax portfolio contract in Agoric SDK," using ocap/eventual-send foreknowledge from the research library.

**What I did:**
- Located the target: `packages/portfolio-contract` (aka YMax, a "proof-of-concept" cross-chain stablecoin-yield contract) on the `kriscendobot/agoric-sdk` fork. Read-only shallow clone at commit `37a4fa3`; ~9,660 LOC. Fork experimentation is within the standing agoric-sdk rules of engagement (no upstream contact was made — the reply went to the garden's own issue #21).
- Dispatched **three Fable agents** (`model: fable`) in parallel, each grounded in the garden's ocap research library (`capability-security`, `eventual-send`, `exo`, `hardened-javascript`, `patterns`, `async-flow` topics) and given a focused slice: (A) capability/facet surface, (B) cross-chain flows & eventual-send, (C) resolver trust, EVM wallet & input validation.
- **Hand-verified all five HIGH findings against the source** at the cited file:line before publishing (per the gardener "no unverified 'verified'" norm).
- Synthesized one ranked audit comment and posted it: https://github.com/kriskowal/garden/issues/21#issuecomment-4870412977

**Key findings:** 5 HIGH — exo kit shipped with interface guards disabled (`undefined`); a read-only facet leaks the fund-moving LocalAccount; unbounded holder-specified GMP fee drains the shared contract account; `verifiedSigner` skips signature verification (owner impersonation); resolver settlements trusted wholesale (no amount corroboration). Plus 4 MEDIUM (unscoped/unrevocable planner, unbounded flow arrays, unconstrained calldata builders) and several LOW/INFO. Positive controls noted (no ambient authority, correct eventual-send discipline, sound nonce replay protection, replay-safe settlement, determinism).

**Scope caveats stated in the comment:** static ocap review only — no test execution, no exploit PoC; the downstream `@agoric/portfolio-api` validators and the flow-layer calldata callers were not traced (flagged as the one HIGH-adjacent follow-up, M4). Many findings map to in-code `TODO`/`XXX` markers, consistent with the POC framing.

**Changes:** none to the garden repo — this job's deliverable is the issue comment, so no `main2` commit was needed. Scratch clone and draft cleaned up; inbox drained (empty).

**Follow-ups:** the maintainer may want a scoped follow-on audit of the flow-layer calldata callers (M4) to close the ERC-20 approval-amount / call-target question. The submitter closes the issue when satisfied.
