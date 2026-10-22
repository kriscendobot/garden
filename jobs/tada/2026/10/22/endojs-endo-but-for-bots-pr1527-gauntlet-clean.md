The clean stage for endojs/endo-but-for-bots#1527 is done. I added one test, and CI is green on the new head (`610f15dfd9`): 35 checks, 0 failures, `ci-wait-merge` rc 0.

- **Coverage:** CI never runs the `endo` crate's supervisor or `endo::tests` unit tests; the `build-xsnap` lane is scoped to `ironhorse_engine::`. So I ran them locally. The PR's tests covered the generation-guarded exit unregister and the full suspend/resume round trip, but not the GC-root reference counting.
- **New test:** I added `gc_root_leases_are_reference_counted` in `rust/endo/src/supervisor.rs`. It checks that:
  - two workers suspended to the same snapshot share one root, which survives the first lease drop and is released with the second;
  - an empty-digest (store-backed) suspend or lease pins nothing;
  - releasing a digest that isn't pinned is a no-op rather than an underflow.
- **Local run:** `cargo test -p endo --lib -- supervisor:: endo::tests` passed 6 of 6, including `supervisor_suspend_resume_round_trip` and the new test.
- **Dead code:** I found none. `Supervisor::unregister` is still used by `socket.rs`, `iroh_net.rs`, the `endo.rs` resume-failure paths and the fallback in `proc.rs`. The new `registration`, `register_tracked` and `unregister_registration` are all called.
- **Push:** I committed as `610f15dfd` "test(endo): cover ephemeral GC-root reference counting" and pushed with `safe-push-pr-head.sh`, a fast-forward from `0d9ffb4f3`. Nobody else has pushed to the head since.

**Follow-up (not done here):** CI still doesn't run the supervisor or round-trip unit tests. The comment in `ci.yml` says the `build-xsnap` filter can widen once `xsnap::Machine::eval` gets a catch guard. This PR moves the crank-end `__shouldTerminate` check into a `try` block but doesn't change `eval` itself, so that blocker remains.

`supervisor.rs` already fails `rustfmt --check` in code this PR touched. I matched the surrounding style and did not reformat it.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1527-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2402020 cached reads)
- Output: 10046 tokens
- Cost: $1.26802
- Wall-clock: 3521s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
