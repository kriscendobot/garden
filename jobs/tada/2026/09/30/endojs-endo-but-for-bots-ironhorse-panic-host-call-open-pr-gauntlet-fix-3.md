Round-3 fixes for PR #1379 are pushed, but CI is not green yet. One leg, `test (22.x, macos-15)`, failed on the first run and is still pending on its rerun. So this stage ends as still-pending, and the driver should re-post it.

**What changed:** one follow-up commit, `42d86c65e6`, pushed to `endojs/endo-but-for-bots` `llm-ironhorse-panic-host-call` with `safe-push-pr-head.sh` (it moved the head forward from `3747b81cdd`). All changes are in `rust/endo/slot-machine-transcript`, plus a rename in `rust/endo/tests/ironhorse_embargo_coverage.rs`:
- **breaker (must-fix):** a `Pure` callback that reports opening or closing a handle is now refused with the new `HostCallError::Misclassified`. Before, only a `debug_assert!` caught it, which release builds strip.
- **breaker (should-fix):** the docs on `clear_barrier` and `ReplayStop::Barrier` now say to rebuild `host_replay()` after clearing a barrier. The `host_call_by_crank` index is now `UNIQUE (crank_id, call_ordinal)`. That is safe because crank ids auto-increment.
- **saboteur:** `read_blob` refuses any name that isn't 64 lowercase hex digits before using it as a path. `recovery_gate` now documents that it says nothing about barriers in the crank still running.
- **engine-realist:** new `TranscriptLimits::{max_host_calls, max_host_bytes}` limits, defaulting to 4096 calls and 16 MiB. Host calls past them (except pure ones) are refused with `Backpressure`, like outbound frames. The claim that NTFS makes the rename durable is gone from `sync_directory`.
- **stylist:** `CasStore` is renamed `ContentAddressedStore`, `cb` is now `callback`/`callbacks`, and the SQL aliases `req`/`rep` are now `request`/`reply`.
- **assessor (comment-only):** the barrier's write before its effect runs now reports a new `Operation::HostBarrier` instead of `Operation::Commit`.
- **scribe:** posted a status comment mapping each round's items to their commits: https://github.com/endojs/endo-but-for-bots/pull/1379#issuecomment-5904195740

**Tests:** I added tests for the misclassification refusal, the host-call limits, and blob-name validation. Locally, `cargo test` and `cargo clippy --all-targets` pass for `slot-machine-transcript`. I couldn't build `rust/endo/tests/ironhorse_embargo_coverage.rs` locally because the `xsnap` build script fails in this checkout. Its diff is only the type rename, but CI is the first real check of it.

**CI:** the first run finished with 34 of 35 checks passing (`ci-wait-merge` rc 3).
- The one failure was `@endo/daemon` on macOS: `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This commit changes only Rust, so I judged it a timing flake and not something my change caused.
- I reran just that job (run 36670088257). The second wait timed out after 2700s (rc 4), and the leg was still pending at 06:27Z, so I stopped close to this job's two-hour time limit.
- If that leg fails again, treat it as a recurring macOS daemon flake to look into separately; it doesn't touch this diff.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4429871 cached reads)
- Output: 21201 tokens
- Cost: $2.1413062000000003
- Wall-clock: 6441s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
