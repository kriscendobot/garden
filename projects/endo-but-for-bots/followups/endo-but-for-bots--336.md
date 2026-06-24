---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 336
created_at: 2026-05-21T07:46:33Z
last_appended_at: 2026-05-21T07:46:33Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#336

Created from the code-panel round 1 verdict (23 seats, in-band fallback) on the issue #59 mirror PR (cyclic star-export with renaming reexport). Round 1 returned one must-fix-loop item (the cleaner's empirically-confirmed missing-reexport-becomes-undefined regression); two follow-up dispositions queued here for revisit at merge time. The summary-fix bundle waits until the round-N panel terminates without must-fix-loop items.

## Items

- [ ] **State-machine design note for the linker's wire-up.**
  **Source juror(s)**: integrator, decomplector-adjacent (cross-panel observation).
  **Round**: 1.
  **Recommended action**: write a one-page design note in `packages/ses/designs/` (or the SES corpus's equivalent) describing the wire-up state machine the deferred-notifier shape introduces: `notifier-undefined → deferred-installed → upstream-resolved → drained`. Three call sites in `packages/ses/src/module-instance.js` interact with the deferred path through a different state (lines 469-474 `reexportMap`, line 480 `candidateAll`, line 403 first-call). Extensions like top-level await and import-attributes will interact with the deferred path; a design note compounds the implementation's readability for those future changes. Actioning trigger: this PR merges, or its upstream mirror (when ferried; this PR is the mirror, so the upstream PR will land at endojs/endo via the boatman) merges. At that point, file as an issue on `endojs/endo` with the state-machine write-up, or open a follow-up PR if the design corpus's discipline asks for a design doc instead. This is a [proposed-rule] item the gardener may encode separately ("linker hot paths warrant a state-machine design note alongside the implementation").

- [ ] **Drain-order pin on the deferred-notifier queue.**
  **Source juror(s)**: prover, engine-realist.
  **Round**: 1.
  **Recommended action**: the new `cyclic star export with renaming reexport (issue #59)` test at `packages/ses/test/import-gauntlet.test.js:248-281` asserts the binding (`captured === 45`) and the namespace shape, but does not assert the *order* in which the deferred forwarder drains its queue at `module-instance.js:391-394`. If a future change to the candidate-all walk reverses the order of `update` calls, downstream observers of the live binding could observe transient values. Amend the test (or add a sibling test) with a sequence of updaters and assert the drain order pins the linker's contract. Actioning trigger: this PR merges or its upstream mirror merges. At that point, open a follow-up PR with the strengthened test.
