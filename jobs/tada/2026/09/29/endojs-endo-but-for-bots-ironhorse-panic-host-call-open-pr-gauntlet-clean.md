I've finished my part of the clean stage, but CI isn't green yet. The two macOS jobs I reran are still queued on the head I pushed, `42b0564357`, so the result is still-pending.

**Coverage pass:** I added six tests to `rust/endo/slot-machine-transcript/tests/host.rs`. Line coverage of `host.rs` went from 82.9% to 91.1%.
- The biggest gap was that no test ever closed a handle. The new tests cover closing a handle, and they check that the closed handle is then refused in the same crank, after commit and after a restart.
- The others cover pure calls, replaying a committed outbound effect, the refusal paths of the recovery functions, and the `AdmissionError` messages.
- All 18 host tests pass, clippy is clean, and I found no code the change left unused.
- I pushed it to the PR head as a fast-forward from `5989fe4aa9`.

**CI on `42b0564357`:**
- **Still pending:** `test (22.x, macos-15)` and `test (24.x, macos-15)`. On their first run, both failed the same `@endo/daemon` test: `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This commit only changes a Rust test file, and the stack's parent branches passed CI. I reran both jobs (run 36614052790), but they were still waiting for a macOS runner when the 3600s wait timed out (rc 4).
- **Fixed by rerun:** `test-ocapn-guile-interop` failed on the previous head because the Guix package servers were slow. `test-ocapn-python` failed when `yarn install` crashed during dependency resolution. Both passed when rerun.
- Every other check passed.

**Follow-up:** the next attempt at this stage only needs to wait for those two macOS jobs. If `daemon-teardown` fails on macOS again, it needs its own fix job; this PR didn't cause it.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3255609 cached reads)
- Output: 15476 tokens
- Cost: $3.4090728000000006
- Wall-clock: 3952s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
