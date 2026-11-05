The stall watchdog is on `main2` as `a4d206f4d3f`, and hung `local-verify` steps now stop themselves and report an environment-parity failure. `local-verify-test.sh` passes 120 of 120 and `shellcheck` is clean. After that run I only re-wrapped one comment line, then syntax-checked the file with `bash -n`. I saw `ok` on the last line of `pre-push-gates-test.sh` but did not check its exit status or other results; that run predates the capture fix below, which only touches `local-verify.sh`.

**Limits (per command, or per workspace in a Yarn workspace tree):**
- **`GARDEN_LOCAL_VERIFY_STALL_SECONDS` (default 1200):** stops a command that produces no new output for this long.
- **`GARDEN_LOCAL_VERIFY_STEP_MAX_SECONDS` (default 7200):** stops a command at this total elapsed time, which catches a hang that keeps printing, such as a retry loop.
- **Values:** 0 disables a limit, and a malformed value makes the script exit 2.
- **Default choice:** these are my estimates, not measurements. A whole-repo `tsc` prints nothing until it finishes, so a slow host could trip the stall limit on healthy work. If that happens, raise the limit for that run.

**When a limit trips:**
- **Termination:** the command runs in its own process group, and `reap_process_tree` from `common.sh` kills the whole tree. The tests confirm this reaches children that ignore SIGTERM and helpers detached with `setsid`.
- **Report:** the usual `STEP <name> FAILED` block stays, with its blob. The tail shows the last line the command printed, and a new `ENVIRONMENT PARITY:` line follows it. The blob ends with a `local-verify watchdog:` line giving the reason and the command.
- **Verdict:** a stopped command always fails, even if it exits 0 on SIGTERM. Later steps and workspaces still run.

**Other behaviour changes:**
- **Signals:** steps no longer share the caller's process group, so the harness now traps TERM, INT and HUP and kills the running command itself.
- **Stdin:** steps now read from `/dev/null`, as on a CI runner.

**A second bug found while testing:** on the virtiofs scratch mount, blob capture sometimes failed with `detected dubious ownership` and the output was thrown away, in 6 of 48 runs in one parallel stress test. Capture now sets `safe.directory=*` for its own git call only, so step commands keep the hermetic git config. The same stress fixture then had 0 failures in 72 runs, and a new test forces the condition with `GIT_TEST_ASSUME_DIFFERENT_OWNER`.

The new tests are group 16 in `scripts/jobs/test/local-verify-test.sh`, and I updated `skills/local-verify/SKILL.md` and `field-notes.md`.

**Not covered (no jobs posted):**
- `prepare_xs_environment` (submodule init and Moddable provisioning) still runs outside the watchdog.
- The final `git status` dirty check still runs under the hermetic config. The same ownership glitch could make it see a clean tree and miss stale generated files. I reasoned this from the capture failure and did not observe it.
- `pre-push-gates.sh` was not changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-local-verify-stalled-test-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (2126942 cached reads)
- Output: 45811 tokens
- Cost: $2.3962963999999998
- Wall-clock: 1175s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
