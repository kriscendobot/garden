---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 345
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 3032
created_at: 2026-05-22T01:45:37Z
last_appended_at: 2026-05-22T01:45:37Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#345

Created from the barrister code-panel verdict (26 seats, in-band fallback) on the `@endo/cancel` cancellation-primitive mirror PR (mirror of `endojs/endo#3032`). The PR introduces a new `@endo/cancel` package and adopts `makeCancelKit` in `@endo/daemon` and `@endo/cli`. Two follow-ups warrant revisit at merge time.

## Items

- [ ] **Parent-reason loss on synchronous cancel path.**
  **Source juror(s)**: breaker (primary), purist (secondary, family-consistency on the parent-propagation invariant).
  **Round**: 1.
  **Recommended action**: verify behavior against `endojs/endo#3032`'s final-merged shape. The synchronous-parent path at `packages/cancel/src/cancel-kit.js:67-69` constructs a fresh `Error('Cancelled')` when `parentIsCancelled()` returns true at child-creation, losing the parent's actual rejection reason. The async path (`:60-63`) propagates the real reason in a subsequent turn, so the child observes one cancellation but with two reasons over time. The DESIGN.md § "Parent Cancellation Propagation" states "all child tokens automatically cancel with the same reason", which is false on this path. Either (a) document the asymmetry in DESIGN.md and accept it, or (b) accept an optional `parentReason` parameter and use it on the sync path. If the upstream's final shape resolved this question, mirror the upstream's resolution; if not, open a follow-up PR with the documentation or the API extension.

- [ ] **README example uses console.log for diagnostic output.**
  **Source juror(s)**: archivist (primary surface), scribe (process axis).
  **Round**: 1.
  **Recommended action**: `packages/cancel/README.md:46` shows `cancelled.catch(error => console.log(error.message))` which lands diagnostic output on stdout. Project CLAUDE.md § "Diagnostic discipline" prescribes `console.error` for diagnostics. The README is example-level prose that the mirror tracks upstream; flag to the upstream's attention on the next push. If the upstream's master already addressed this, mirror; otherwise open a documentation follow-up PR (one-character change) on the upstream `endojs/endo#3032` branch or `endojs/endo` master, then mirror back.
