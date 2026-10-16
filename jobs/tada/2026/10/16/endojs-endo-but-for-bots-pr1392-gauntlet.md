---
pr: https://github.com/endojs/endo-but-for-bots/pull/1392
repo: endojs/endo-but-for-bots
pr_number: 1392
build_job: parcel-pivot-stack-20261014
kind: probe
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 2
max_stage_retries: 2
created_by: gardener
created_at: 2026-10-15T00:26:43Z
arc: 
current_child: endojs-endo-but-for-bots-pr1392-gauntlet-panel-6
state: halted
orchestration-status: halted
gauntlet-status: halted
halted_at: 2026-10-16T03:47:15Z
---
# gauntlet endojs-endo-but-for-bots-pr1392-gauntlet — HALTED

stage 'endojs-endo-but-for-bots-pr1392-gauntlet-panel-6' (panel) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: panel stage reported panel-error (seat/decider error or interruption — a sensor failure, not a review verdict)

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 6/6 · cost so far: $19.07
Trend: r1 raised 20; r2 n/a; r3 n/a; r4 n/a; r5 n/a; r6 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r6] breaker: must-fix: identical shared substructure now costs exponential time to rank-compare. packages/marshal/src/rankOrd...
[new, since r6] breaker: should-fix: a Parcel still escapes rank ordering through an identical container at top level. The compareParts ...
[new, since r6] breaker: comment-only: brand-check answers can change over time. packages/pass-style/src/parcel.js says the passStyleOf...
[new, since r6] breaker: comment-only: forging inside a compartment is mitigated as documented. An impostor global can supply its own froz...
[new, since r6] integrator: should-fix: the commit series doesn't hold together for a rebase-merge reader. rule: AGENTS.md § Pull requests ...
[new, since r6] integrator: git log origin/build/sturdyref-ses-accommodation-a10a201..HEAD has 48 commits.
[new, since r6] integrator: About 20 of them name a concept the final diff no longer contains. Examples: ed9c45c8d feat(pass-style): recognize a...
[new, since r6] integrator: The series then re-lands the feature as 9626ab9b4 feat(pass-style): recognize Parcel passables, followed by about ...
[new, since r6] integrator: The tree-wide rename sweep is clean: no SturdyRefObject, isSturdyRef or sturdyRef remains in the touched packag...
[new, since r6] integrator: Fix: reset and regroup into a few logical commits, each with its own chore: Update yarn.lock commit where needed:
[new, since r6] integrator: feat(pass-style)
[new, since r6] integrator: fix(marshal)
… and 8 more
```
