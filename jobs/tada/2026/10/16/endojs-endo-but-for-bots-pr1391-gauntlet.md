---
pr: https://github.com/endojs/endo-but-for-bots/pull/1391
repo: endojs/endo-but-for-bots
pr_number: 1391
build_job: parcel-pivot-stack-20261014
kind: probe
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 2
max_stage_retries: 2
created_by: gardener
created_at: 2026-10-15T00:26:39Z
arc: 
current_child: endojs-endo-but-for-bots-pr1391-gauntlet-panel-4
state: halted
orchestration-status: halted
gauntlet-status: halted
halted_at: 2026-10-16T02:26:03Z
---
# gauntlet endojs-endo-but-for-bots-pr1391-gauntlet — HALTED

stage 'endojs-endo-but-for-bots-pr1391-gauntlet-panel-4' (panel) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: panel stage reported panel-error (seat/decider error or interruption — a sensor failure, not a review verdict)

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 4/6 · cost so far: $12.60
Trend: r1 n/a; r2 n/a; r3 n/a; r4 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r4] archivist: (.changeset/ses-permit-parcel.md:6) must-fix — .changeset/ses-permit-parcel.md:6: the Breaking line says lockdown throws "for any other own gl...
[new, since r4] archivist: should-fix — packages/ses/src/global-object.js, defineFirstWinsGlobals JSDoc: it says that on the start glo...
[new, since r4] archivist: comment-only — packages/ses/src/tame-parcel-constructor.js, the function JSDoc: "Both constructors use the in...
[new, since r4] archivist: comment-only — packages/ses/README.md: the shape rule lists "a constructible function with a locked prototyp...
[new, since r4] breaker: should-fix: a child compartment can register a parcel whose prototype it chooses. Location: packages/ses/src/tam...
[new, since r4] breaker: This diff is what puts the attack within a child compartment's reach.
[new, since r4] breaker: Fix: subclassing is already refused, so SharedParcel should throw unless new.target === SharedParcel and call co...
[new, since r4] breaker: The shim's double read of prototype in packages/parcel/src/parcel-shim.js deserves the same hardening upstream.
[new, since r4] breaker: proposed-rule: a powered-to-shared constructor wrapper must not forward an attacker-supplied new.target; pin it to...
[new, since r4] breaker: comment-only: a child can mint parcels with any location string, so locate proves nothing about who made one. L...
[new, since r4] breaker: comment-only, mitigated: a Proxy constructor whose get trap swaps open for locate. Location: packages/se...
[new, since r4] breaker: comment-only, mitigated: re-pointing the start binding after sampling. Location: packages/ses/src/global-object....
… and 8 more
```
