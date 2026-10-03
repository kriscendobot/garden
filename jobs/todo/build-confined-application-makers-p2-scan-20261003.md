---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T05:31:06Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2a: capture `node-modules-with-map` and `node-modules-scan` layouts

Implement only the capture portion of Phase 2 of the landed design
`designs/agent-confined-application-makers.md` in `endojs/endo-but-for-bots`.
Read that design in full, with particular attention to its Phase 2 and Test plan,
before changing code.

Work in an isolated project checkout created with:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh build-confined-application-makers-p2-scan-20261003 endojs/endo-but-for-bots llm-confined-application-makers-p2`.
The delivery branch is `llm-confined-application-makers-p2`. It is the shared
serial Phase-2 branch: if it does not yet exist, create it from the current head
of `llm-confined-application-makers-p1` (PR #1417); if that PR has merged, use
its merged commit/current appropriate `llm` ancestry instead. Do not open a PR in
this child; push the branch so the next child can continue it.

Implement `node-modules-with-map` and `node-modules-scan` tree capture exactly as
the design specifies, including their intended compartment-map and source-layout
semantics. Keep the change confined to this capture surface; do not add the mount
canonical hook or `EndoHost.makeFromTree` API here.

Add focused automated tests that independently cover both layouts and their
expected captured result. Run the focused tests and the relevant package checks
available in the checkout. Commit the implementation and tests, then push the
shared Phase-2 branch. Report the branch head SHA, changed paths, and commands
actually run with results. If the design or predecessor state makes this boundary
impossible, report the evidence and emit the orchestrated-failure signal rather
than expanding scope.
