---
kind: result
role: purist
host: endolin-garden-ece02cb4
at: 2026-11-17T00:38:30Z
---
PR: endojs/endo-but-for-bots#1591

**Verdict:** request-changes

**Findings:**
- must-fix: `packages/sandbox/src/drivers/bwrap.js:910-915` catches and discards every failure from the post-exit group kill, then resolves `wait()` as though containment succeeded. `ESRCH` is the only harmless outcome. A permission or other failure leaves a process group that may still contain the sandboxed command, which violates the cleanup invariant this new sweep is intended to establish. Preserve and report non-`ESRCH` errors (or centralize this post-exit, still-owned-group case in a helper with the same behavior). [rule: packages/sandbox/src/drivers/child-process.js]

Self-improvement: nothing this time.
