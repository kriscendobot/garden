Fixed XS parallel-test flakiness and opened draft PR #861.

- Cause: process-global pending-jobs flag let one XS machine clear another’s async-work signal.
- Changed promise pumping to use each `txMachine.promiseJobs`.
- Evidence: baseline failed run 5/5; post-fix 10 consecutive `cargo test -q -p endo --lib` runs passed (170 tests each).
- Follow-up: full `xsnap` suite remains blocked by unavailable generated bootstrap bundles.

Self-improvement: nothing this time.
