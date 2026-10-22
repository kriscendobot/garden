---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Successor to build-daemon-xs-worker-snapshot-supervisor-round-trip-test, on endojs/endo-but-for-bots PR #1527 (https://github.com/endojs/endo-but-for-bots/pull/1527, head branch build-daemon-xs-worker-snapshot-supervisor-round-trip-test, base llm-54d3d2a). Work on that PR's head branch.

The test `supervisor_suspend_resume_round_trip` in rust/endo/src/endo.rs is `#[ignore]`d. Run it with `cargo test --lib supervisor_suspend_resume_round_trip -- --ignored --nocapture` from rust/endo. Setup: init the c/moddable submodule with `--reference /home/kris/garden/worktrees/kriscendobot-moddable.git`, and stub the generated xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap,archive_text_endowments}.js, or build the real ones. What happens: the in-process worker (spawn_inproc_xs_peer + run_xs_program with a tiny ping-counter bundle) SIGSEGVs right after its first handleCommand returns from sendRawFrame, before the pong reaches the tester. The crash is probably in the main-loop crank after dispatch (run_promise_jobs_metered / metering), or the stub SES may be the cause. No in-process worker main-loop test existed before this one.

Find the segfault and fix it (in production code if it is a real bug, or in the test setup if it is not). Un-ignore the test and get it green: it covers suspend via the control verb, the CAS blob plus SHA-256, the GC root pinned and then released, and resume that keeps the JS count. Also fix the race noted in the design: the suspended worker thread's exit-path `unregister` can clobber a handle that was suspended or resumed after it, and then the test's 200 ms sleep can go. Update the Phase 2 status in designs/daemon-xs-worker-snapshot.md, then push to the PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T02:06:43Z
