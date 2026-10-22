I found and fixed the segfault, which was a real bug in production code, not the test setup. I also fixed the exit-path `unregister` race and dropped the 200 ms sleep. `supervisor_suspend_resume_round_trip` is no longer ignored and passes, and both commits are pushed to the PR #1527 head branch (`45e00d3dcb..0d9ffb4f33`). CI on the PR shows 4 checks passing and 3 skipped.

**The segfault.** Tracing put the crash after the promise-job pump, at the end of the crank. There the worker loop runs `machine.eval("__shouldTerminate()")`. `Machine::eval` has no catch frame, so a bundle that doesn't define `__shouldTerminate` (like the test's ping-counter bundle) throws a ReferenceError. That throw longjmps through a NULL `firstJump` and SIGSEGVs the whole process. It would do the same for any real bundle that lacks `__shouldTerminate` or whose check throws. The fix, in `rust/endo/xsnap/src/lib.rs` (commit `e103d3fae4`), replaces that call with a `SHOULD_TERMINATE_CHECK` expression that uses `try`/`typeof` and returns false instead of throwing.

**The exit-path race** (commit `0d9ffb4f33`):
- **Registration generations:** in `supervisor.rs`, each registration now gets a generation number (`register_tracked`, `registration`). `unregister_registration(h, gen)` removes a handle only if that generation is still the current one, and `mark_suspended` ends the current generation.
- **Exit paths updated:** the in-process spawn (`inproc.rs`), the in-process resume thread (`endo.rs`) and the child-process wait task (`proc.rs`) all unregister through the guarded call. A late exit after a suspend no longer drops the parent link kept for resume, and a late exit after a resume no longer drops the new inbox.
- **Tests:** removed the `#[ignore]` and the 200 ms sleep from the round-trip test. Added a unit test, `stale_exit_unregister_spares_suspend_and_resume`, that covers the guard.
- **Design doc:** Phase 2 in `designs/daemon-xs-worker-snapshot.md` is now marked done, with items 15 (the round-trip test and the crash it found) and 16 (the race fix).

**Verification:**
- `cargo test --lib` in `rust/endo` passed, 370 of 370, before I added the new unit test; I then ran that test on its own and it passed.
- The round-trip test passed 5 times in a row (about 0.02 s each).
- `cargo check -p xsnap --tests` builds cleanly.

**Notes:**
- I ran everything locally with stub generated JS files (`ses_boot.js` defines only `harden` and `lockdown`; the others are empty), not the real built bundles. They are gitignored and not committed.
- I did not run the full xsnap test suite.
- I left the existing rustfmt drift in `supervisor.rs` alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-xs-worker-snapshot-round-trip-segfault.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4076722 cached reads)
- Output: 21124 tokens
- Cost: $2.0660324
- Wall-clock: 524s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
