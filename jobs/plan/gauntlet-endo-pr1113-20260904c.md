---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
failure_classification: deterministic
requeue_cycles: 1
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-04T21:05:14Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-04T21:05:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Run the gauntlet (clean -> panel review -> fix-loop -> un-draft) on
https://github.com/endojs/endo-but-for-bots/pull/1113
(head feat/ironhorse-test262-compliance-ratchet, base llm), per
skills/pr-creation-flow/SKILL.md. The PR is the completed round-2
Fable-supervised Ironhorse test262 compliance ratchet.

STATE AS OF 2026-09-04T20:07Z (re-verify, don't trust): the weave/rebase is
ALREADY DONE. #1113 head is a958ef66ad85d86eed3399903037333504536cc6,
mergeable=MERGEABLE, mergeStateStatus=UNSTABLE (no conflict; the DIRTY/
CONFLICTING state the two prior reweave orchestrations were clearing is
resolved). This job is DELIBERATELY STANDALONE (not orchestrated behind a
weave): the prior two reweave-regauntlet orchestrations
(ironhorse-1113-reweave-regauntlet-20260904 and -20260904b) BOTH halted on
their weave child's 2400s handler-timeout even though the weave had already
pushed a mergeable head each time — the slow ironhorse rebase+build legitimately
exceeds the orchestration timeout. Do NOT re-post a weave-gated orchestration;
the head is already rebased and conflict-free.

PRECONDITION: before starting, re-verify the head is still not CONFLICTING
(gh pr view 1113 --json mergeable,mergeStateStatus). If llm has moved and it is
DIRTY/CONFLICTING again, rebase the head onto current llm yourself as the first
step (you are the supervising gardener; do the rebase in-worktree rather than
posting a separate weave job that would re-trip the orchestration timeout),
preserving the ratchet's engine-fix waves and the refresh-20260901 ratchet-floor
snapshot (net intent unchanged), then proceed.

KNOWN RED CI TO FIX (real, rebase-inherited regressions on the current head):
- test-ironhorse: ironhorse-vm/tests/typed_array_source_length.rs — 4 tests
  FAIL because `new Uint8Array(<array-like>)` halts with
  Unsupported("native-call:TypedArray:from-array-like"). This test file arrived
  on llm after #1113's original merge base; the TypedArray-from-array-like
  construction path (element read + valueOf coercion ordering, over-long-source
  length refusal reported as bad-length) is not yet implemented in this branch's
  engine. Implement it so these 4 tests pass:
  a_dense_array_and_a_source_view_still_copy,
  a_sparse_source_within_bounds_reads_its_holes_as_undefined,
  the_array_snapshot_precedes_element_coercion (snapshot must precede coercion),
  an_over_long_source_is_refused_before_it_is_materialized (must report length as
  the reason: Unsupported("native-call:TypedArray:bad-length")).
- test-ironhorse-oracle and test-xs also RED — triage from their logs; likely
  the same array-like construction gap or a downstream ratchet-floor delta.
- The weaver already repaired three other inherited ratchet-floor regressions
  (commit f34b7d993); these four typed-array tests remain.

Local gates to run before pushing: cargo test --release -p ironhorse-vm
-p ironhorse-compile -p ironhorse-262 -p ironhorse-snapshot; hardened262 baseline
delta confined to xs/sesXs agents (local xst version artifact - do not bless;
CI's pinned xst adjudicates); the endo ironhorse_store_worker gate needs CI's
generated xsnap bundles (not runnable in a bare worktree). Do not un-draft or
bless the floor until CI (test-ironhorse, test-ironhorse-oracle, test-xs) is
green.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5463542954
submitter: kriscendobot
----- END ISSUE NOTE -----
