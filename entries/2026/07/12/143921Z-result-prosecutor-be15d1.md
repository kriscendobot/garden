---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-12T14:39:23Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - jobs/tada/endojs-endo-but-for-bots-pr678-review-4d666bb1.md
  - jobs/tada/gauntlet-endo-glob-grep-stack.md
  - review-misses/misses/endojs-endo-but-for-bots-pr678-review-4d666bb1.md
  - review-misses/clusters/catch-all-error-swallow.md
---

# Review retrospective: endojs/endo-but-for-bots #678 (review 4680172450)

Second loop on kriskowal's CHANGES_REQUESTED review of #678 (the platform-search
layer P of the #127 glob/grep pushdown stack). The primary loop
(`…-pr678-review-4d666bb1`) already addressed the feedback in commit `6e30d55a6f`;
this loop judged whether the **review process** should have caught it.

**Verdict: miss** (`correctness-bug`), joined the existing
`catch-all-error-swallow` cluster.

The review's four inline comments on `packages/platform/src/fs/search.js`
resolved to one recordable miss and two dismissals:

- **Miss (comments 2 + 4):** `maybeRealPath` was a bare `catch { return undefined }`
  swallowing **every** error class — the maintainer's `RangeError` example — when
  only a missing referent should map to `undefined`; and the identical bare-catch
  block was **duplicated** in `provideSearch` (reviewed tree `0e92634`, lines 257
  and 619). Because the resolved path feeds the confinement check, a swallowed
  error also degrades a security-relevant decision. A five-reviewer design panel
  demonstrably ran on this exact diff in `gauntlet-endo-glob-grep-stack` yet let
  both catches through — the cluster's own diagnosis: the saboteur's Tight-try
  discipline fires on try-body *width*, not error-class *breadth*.
- **Dismissed (comment 1, drop conservative-regex):** the panel explicitly weighed
  the `isConservativeRegex` seam and recorded it resolved; the maintainer's
  "drop it" overrides a defensible judgment — new direction, not a missed check.
- **Dismissed (comment 3, factor `isWithin` to share with mounts):** cross-package
  code-organization direction across the platform/daemon seam — not a check the
  panel failed to run.

**Threshold: hold below the floor.** The join brings `catch-all-error-swallow` to
**count=2 across prs={653, 678}** — now two *distinct* PRs, but one short of the
K≥3 floor. Severity bypass does not apply: `severity: minor`, and no standing
rule bound on the failed axis (error-class breadth has no encoded check — the
cluster is a prevention-gap to be created, not a sense-and-correct failure). No
`review-improve-*` dispatched; `recurrence=0`, so no maintainer escalation. One
more panelled bare-catch swallow on any PR trips the floor.

Self-improvement: none warranted — the store writer, cluster join, and threshold
math behaved exactly as the skill prescribes; the discriminator had ample grounding
in the gauntlet report and the reviewed source, so no friction to encode.
