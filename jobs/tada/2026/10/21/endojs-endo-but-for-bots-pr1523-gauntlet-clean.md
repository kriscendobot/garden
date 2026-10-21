## Gauntlet CLEAN stage: endojs/endo-but-for-bots#1523, done with CI green

**What I did**
- PR #1523 (`feat(endor): debug-flag control verb`, draft) touches `rust/endo/src/endo.rs`, `rust/endo/src/supervisor.rs` and one design doc.
- **Coverage pass:** the PR already had a unit test for the new `Supervisor::set_debug_flag`/`take_debug_flag` methods. Nothing tested the new `"debug-flag"` branch in `handle_control_message`, and `endo.rs` had no test module.
- I added `endo::tests::debug_flag_verb_marks_target_for_next_resume`. It sends a well-formed `{"handle": n}` payload through `handle_control_message` and checks that the target is flagged for exactly one resume. It also checks that a malformed payload flags nothing.
- **Dead code:** the change orphaned nothing, so nothing was removed.
- **Local check:** `cargo test -p endo --lib -- debug_flag` runs 2 tests, both pass. The added block is rustfmt-clean. The rest of `endo.rs` already had rustfmt differences before this change, and I left them alone.
- Commit `71c299ee0` ("test(endor): cover the debug-flag control verb dispatch") was pushed to `daemon-debug-worker-restart-phase-1` with `safe-push-pr-head.sh`. It fast-forwarded from `38f0e94d8`.

**CI**
- On its first run, `ci-wait-merge.sh` reported GREEN after only 7 of the checks had attached; the main `CI` workflow was still pending at that point. I polled the Actions runs for the new head until every workflow finished (all succeeded), then re-ran `ci-wait-merge.sh`. Result: 35 checks, 0 failed (17 success, 18 skipped), CI GREEN.

**Follow-ups and notes for operators**
- `ci-wait-merge.sh` can report GREEN too early, before slower workflows attach to a just-pushed head. Here it stopped at 7 checks while the main `CI` run was still pending. It probably needs to wait for the expected workflow set, or for the rollup to stop changing, before calling a result terminal.
- Building endor locally on this host needed three things the worktree setup doesn't provide: a private `CARGO_TARGET_DIR` (the shared target dir gave a `can't find crate for bstr` error), `git submodule update --init c/moddable`, and `yarn workspace @endo/thixotrope run build:xs-bundles`.
- The project checkout also needed `GARDEN_REPO_GIT_TIMEOUT=900`, as the existing memory note says.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1523-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (2682842 cached reads)
- Output: 12399 tokens
- Cost: $1.3681564000000006
- Wall-clock: 3235s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
