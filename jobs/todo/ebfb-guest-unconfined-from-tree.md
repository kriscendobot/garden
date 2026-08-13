---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: builder
repo: endojs/endo-but-for-bots (fork worktree; base branch `llm`)

Security report from the maintainer: guests on minion.town appear to be able to
reach a `makeUnconfinedFromTree` method. That method runs code outside a
compartment on the daemon's host, so guest reachability would be arbitrary code
execution by an untrusted party. It is meant to be a HOST-only capability.

Task:

1. Confirm or refute the report first, with a test rather than by reading alone.
   Write a test that takes a guest facet and attempts `makeUnconfinedFromTree`
   (and, while you are there, the neighbouring unconfined/endowment-bearing
   methods) and observe what actually happens. `packages/daemon/src/guest.js`,
   `packages/daemon/src/host.js`, `packages/daemon/src/interfaces.js`, and
   `packages/daemon/src/types.d.ts` are the surfaces that define the split;
   `packages/daemon/test/endo.test.js` has the existing coverage. If the guest
   facet turns out not to expose it, say so plainly in the PR description with
   the evidence, and check whether some other path (a delegated host facet, a
   petname lookup, an interface guard that is wider than the implementation,
   the CLI, or a mounted/registry capability) makes it reachable in the deployed
   configuration.

2. If reachable, restrict it to hosts: the guest interface guard and the guest
   facet must both refuse it, and the refusal must not depend on the caller
   being well-behaved. Prefer removing the capability from the guest surface
   over adding a runtime check where the object model can enforce it.

3. Add a regression test that asserts a guest cannot reach it, so this cannot
   silently come back.

4. Audit the rest of the guest surface the same way in the same PR: compare
   what the guest interface guard admits against what the host facet exposes,
   and report any other host-only capability a guest can reach. Fix the clear
   ones; list anything ambiguous under Follow-ups rather than deciding alone.

Notes:

- Treat this as security-sensitive. Do not post details of a confirmed
  exploitable path to any upstream or public issue tracker; the PR on the fork
  is the place for it.
- minion.town runs a deployed instance of this daemon, so record in the PR
  description whether a deploy is needed to close the exposure, and put that
  under Follow-ups.
- Report back to the maintainer via the inbox once you know whether the report
  is confirmed, before the full fix lands, since the answer changes how urgent
  the deploy is.

<!-- garden-reaped: 1 -->
