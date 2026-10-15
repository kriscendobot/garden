---
pr: https://github.com/endojs/endo-but-for-bots/pull/1442
repo: endojs/endo-but-for-bots
pr_number: 1442
build_job: 
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 2
max_stage_retries: 2
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-13T17:54:04Z
arc: 
current_child: endojs-endo-but-for-bots-pr1442-gauntlet-panel-3
state: halted
orchestration-status: halted
gauntlet-status: halted
halted_at: 2026-10-15T00:38:02Z
---
# gauntlet endojs-endo-but-for-bots-pr1442-gauntlet — HALTED

stage 'endojs-endo-but-for-bots-pr1442-gauntlet-panel-3' (panel) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: panel stage reported panel-error (seat/decider error or interruption — a sensor failure, not a review verdict)

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 3/6 · cost so far: $7.31
Trend: r1 n/a; r2 n/a; r3 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r3] archivist: (packages/ses/src/cauterize-property.js:7) should-fix: packages/ses/src/cauterize-property.js:7-26. The JSDoc summary of cauterizeProperty enumerates th...
[new, since r3] archivist: (packages/ses/src/cauterize-property.js:68) comment-only: packages/ses/src/cauterize-property.js:68-70 and .changeset/frozen-null-pills.md:6-7. Both stat...
[new, since r3] archivist: (.changeset/frozen-null-pills.md:5) comment-only: .changeset/frozen-null-pills.md:5-6. The claim "This matches how it already tolerates an undeleta...
[new, since r3] breaker: should-fix: the "a frozen null is inert" invariant is false on V8 for sloppy-mode functions. The new comment at...
[new, since r3] breaker: Attack: a vetted shim, or a polyfill written in sloppy mode, replaces an intrinsic before lockdown(). My repro:...
[new, since r3] breaker: Before this PR: delete throws and lockdown fails closed.
[new, since r3] breaker: With this PR: lockdown succeeds with a warning. After lockdown, Array.isArray.arguments returns the live argume...
[new, since r3] breaker: Result: the PR silently widens what lockdown accepts, beyond the Web IDL builtins it targets.
[new, since r3] breaker: Fix: narrow the shape, for example by requiring that the function never had an own prototype (Web IDL operation...
[new, since r3] breaker: comment-only: the descriptor check holds up against Proxy-based lying. If a function intrinsic is a Proxy, its g...
[new, since r3] breaker: (permits-intrinsics.js:275) comment-only: no siblings were missed. Both paths into cauterizeProperty (permits-intrinsics.js:275 and intr...
[new, since r3] breaker: comment-only: the negative tests are sound but incomplete. frozen-zero and writable-null pin the value and wr...
… and 8 more
```
