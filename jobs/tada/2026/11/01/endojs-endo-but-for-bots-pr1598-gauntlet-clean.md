---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet clean stage, endojs/endo-but-for-bots PR #1598: CI RED, but not because of this PR

I added coverage for the PR's new Rust code and pushed it. CI then finished red (`ci-wait-merge.sh` rc=3). The only failing check, `test-ironhorse-oracle`, is a known breakage on the CI runner and has nothing to do with this diff.

**Coverage pass**
- The PR touches the daemon's XS manager timer shim (`bus-manager-rust-xs.js`), test gating in `endo.test.js`, and the Rust xsnap code. The xsnap work adds the timed envelope receive (`TimedRecv` and `recv_raw_envelope_timeout`), the guest timer loop, fixed-length array buffers, and typed-array hardening.
- I found no dead code left behind by the change. The old `activeTimers` set was removed cleanly.
- The new Rust trait method had no tests. I pushed commit `840215a14`, "test(xsnap): cover the timed envelope receive", which adds two unit tests to `rust/endo/xsnap/src/worker_io.rs`:
  - `channel_timed_recv_reports_envelope_timeout_and_close` checks all three outcomes on `ChannelTransport`: timeout, envelope, and close.
  - `default_timed_recv_blocks_like_recv_raw_envelope` checks the trait's default on `PipeTransport`.
- Locally, `cargo test --lib -- worker_io::tests` passed 21 of 21 on Rust 1.91.1.
- I pushed with `safe-push-pr-head.sh`, which moved the head forward from `9380c2441` to `840215a14`.

**CI at head `840215a14`**
- 35 of 36 checks passed or were skipped. That includes `test` and `cover` on 22.x and 24.x, on both ubuntu and macOS.
- The one failure is **`test-ironhorse-oracle`**. The test `ironhorse-262` `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` panicked with "2 failure(s) (observable divergences or stale engine-versioned raw pins)".
  - This matches the base/runner breakage that started on 2026-10-22, when `ubuntu-latest` moved to 26.04. It has hit PRs #1534, #1535 and others the same way.
  - This PR changes nothing under `rust/engine/ironhorse-*`. The check also failed the same way at the previous head `9380c2441`.
- On the previous head, `cover (22.x)` failed on the sandbox test "bwrap timeout and repeated cancellation reap process groups". That test passed on this run, so it looks flaky.

**Follow-ups**
- The red check needs a fix on the base (re-pin the ironhorse corpus, or pin the runner image), then a weave of this PR onto the fixed base. It should not be chased inside this PR.
- Two separate `ci-wait-merge.sh` background waits were killed from outside the job (SIGTERM, rc=143). I finished by polling the check runs directly, then ran a short final `ci-wait-merge.sh`, which returned rc=3.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1598-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3018057 cached reads)
- Output: 12080 tokens
- Cost: $1.5140273999999994
- Wall-clock: 5987s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
