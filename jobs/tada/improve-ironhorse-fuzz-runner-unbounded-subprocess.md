Cleanup done; inbox empty. All work complete and pushed to `main2`.

## Completion report

**Job:** `improve-ironhorse-fuzz-runner-unbounded-subprocess` — the `garden-ironhorse-fuzz.service` hit `TimeoutStartSec=3600` and then the `TimeoutStopSec` SIGKILL because the fuzz runner spawned subprocesses with no wall-clock bound of their own.

**What I changed** (committed `8b7f56d5f0`, pushed to `origin/main2`):

1. **`scripts/jobs/handlers/ironhorse-fuzz-run-gh.sh`** (the named target, load-bearing fix):
   - Wrapped every provisioning git op (clone / fetch / checkout / submodule-init, including the reclone-on-corruption retry path) in `timeout --foreground --signal=TERM --kill-after=…`, budgeted by a new `GARDEN_IRONHORSE_FUZZ_PROVISION_TIMEOUT_SECS` (default 900).
   - Wrapped the `cargo fuzz run` invocation in `timeout`, budgeted at the per-target run `secs` **plus** a fixed build-phase allowance (`GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS`, default 1200) — the fix for the specific gap that `-max_total_time` bounds only libFuzzer's *run*, never the ASAN *build*. A cargo timeout (rc 124/137) with no crash artifact is remapped to the target-specific rc=1 (with a diagnostic log) so the campaign proceeds to the next target instead of overrunning the unit budget.
   - Added a `run_bounded` helper + TERM/INT trap that forward SIGTERM into the timeout'd child's process group (`set -m` + group kill + a bounded KILL backstop), plus a `command -v timeout` guard and sanitization of all timing knobs.

2. **`scripts/jobs/ironhorse-fuzz.sh`** (the caller): its old TERM trap only removed `ART_ROOT` and, because the runner ran as a synchronous *foreground* call, the trap was deferred until that (now bounded-but-still-long) child returned — so a drain never reached the fuzz tree. Now it backgrounds each runner and, on TERM/INT, forwards the signal to it (`drain_forward`); the runner's own trap reaps its timeout'd git/cargo group. This closes the propagation chain self-heal-run.sh → ironhorse-fuzz.sh → runner → cargo so a drain is honored well inside `TimeoutStopSec`.

3. **`scripts/jobs/test/ironhorse-fuzz-test.sh`**: added **test P** — a stuck cargo build+run is bounded by `timeout` and remapped to rc=1 (self-terminates in ~2s vs a 120s hang).

**Verification:** full suite **50 passed / 0 failed**, rehearsal passed, `shellcheck -x` clean on both scripts (only the pre-existing `GARDEN_TAG` SC2034 and pre-existing test-file warnings remain — no new findings), `bash -n` clean.

**Follow-ups / caveats:**
- The end-to-end *graceful-drain* signal path could not be exercised by an automated test **in this sandbox**: this environment aborts (exit 144) any command in which a backgrounded child enables `set -m` (nested job control) — every technique tried (plain, `nohup`, `setsid`, PTY `script`). That path is instead verified by the production `gardener.sh` precedent (identical pattern), an isolated primitive test (`set -m` + `kill -- -$pgid` + `wait` → clean reap, rc 143, no orphan), and suite tests B–M (the caller's backgrounded-runner path for normal ticks). A dedicated drain test was drafted but removed because its presence made the whole suite unrunnable here; a maintainer/CI on a normal shell could re-add one (deliver `timeout --preserve-status --signal=TERM` to the foreground service against a hanging runner; assert rc=143 not 137).
- The sibling handlers `ironhorse-fuzz-reproduce-gh.sh` already bounds its cargo run; `ironhorse-fuzz-minimize-gh.sh` does not — bounding its `cargo fuzz tmin` similarly is a small optional follow-up, out of this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ironhorse-fuzz-runner-unbounded-subprocess.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (10579662 cached reads)
- Output: 107947 tokens
- Cost: $9.959361000000003
- Wall-clock: 1636s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
