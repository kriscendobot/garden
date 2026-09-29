## Completion report: improve-deadline-nudge-failure-diagnostics

When a deadline-nudge tick fails, the log now names the command that failed and where it was called from. The fix is pushed to `main2` as `65f0c2e4414`. The deadline-nudge test suite passes (49 passed, 0 failed). The script still always exits 0.

**Why failures were opaque.** The tick ran as `( … ) || tick_rc=$?`. Inside that form, bash turns off both `set -e` and the ERR trap, so adding an ERR trap there would have done nothing. Failures came from two places:
- **A helper exiting the script.** For example, `die` inside `clone_lock`, which is called outside a subshell in `sync_journal`. This most likely caused the rc=1 failures from 23:50 to 00:00. I couldn't check: this host isn't the leader, so their logs aren't here.
- **Push exhaustion.** Its `return 1` already logs its own stage error.

**What changed in `scripts/jobs/deadline-nudge.sh`**
- The tick subshell now runs as a plain command with `set -e` off on both sides. Error handling inside the tick behaves exactly as before, and the script still exits 0.
- Inside the subshell, an ERR trap keeps the last three failed commands that nothing handled, each with its return code, line number and call stack.
- On a non-zero exit, the EXIT trap logs one line with the exiting command, its call stack and those recent failures. It still releases the clone lock on every path. Example from the new test:
  `ERROR: deadline-nudge tick exited rc=7 during `exit 7` at git@environment < stage_due_messages@deadline-nudge.sh:306 < deadline_nudge_tick@deadline-nudge.sh:389 < main@deadline-nudge.sh:490; recent failed commands (oldest first): none recorded`
- The existing `WARN … failed locally (rc=N)` line is kept.

**What changed in `scripts/jobs/test/deadline-nudge-test.sh`**
- **Fixed an existing test bug.** It was already failing on unchanged `origin/main2`. After the test loads `common.sh`, looking up `git` returns the new `scripts/jobs/bin/git` lock wrapper instead of the real git binary. The test's fake git scripts then called the wrapper, which called them back, forever. The "fail-open" section hung and then aborted, with "cold clone retry" failing. The test now walks `PATH` by hand and skips the wrapper.
- **New test:** it injects an `exit 7` at the staging `git add`, through a `git` function passed in the environment. It checks that the script still exits 0, the board is unchanged, and the error line names the command and the full call stack.
- The push-exhaustion test now also checks for the new error line.

**Follow-ups**
- Bash can't report which `return N` fired. For a function that returns non-zero, the log names the `return` and its call site, not the exact line. The tick's only `return 1` (push exhaustion) already logs its own error, so this costs nothing today.
- Once this is deployed, the next failure on the leader (`endolin-garden-ece02cb4`) will name its cause. If it's the suspected `die` in `clone_lock`, it's worth a separate job to handle that inside the retrying stage.
- Unrelated, not investigated: during the test's budget sections, "garden repo lock: cleared dead-holder metadata" messages point at the host's real `.garden-state/repo-locks` rather than the test's own state directory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-failure-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (5649663 cached reads)
- Output: 39202 tokens
- Cost: $2.9198125999999993
- Wall-clock: 2231s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
