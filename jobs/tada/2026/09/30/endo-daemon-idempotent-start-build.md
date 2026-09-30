## Completion report: `endo-daemon-idempotent-start-build`

**Summary:** Draft PR https://github.com/endojs/endo-but-for-bots/pull/1387 implements design §§ 1–2 (the job's phase 1), and the job's three required tests pass locally. A prior claimant had already opened the PR at b36b90d4b, so I reviewed it, fixed a bug, and pushed dc9f9a251. I could not update the PR body or post a comment from this host, so a small successor job does that. I did not wait for CI on dc9f9a251.

**What the PR does**
- **Idempotent `start()`:** it checks for a running daemon before cleaning. If a daemon is already serving, it prints "already running (pid N)" and succeeds without changing anything. If a daemon holds the state lock but isn't serving yet, `start` waits for it. A stale socket-lock marker with a live pid gets the same 4 × 125 ms window that `socket-lock.js` uses. If two starts race, the losing one waits for the winner. The engo path shares this code.
- **`clean()`** only removes the socket, lock markers, and `endo.pid` when their owner is dead. `endo start --force` and `endo clean --force` are added.
- **Early single-instance lock:** `manager-node.js` `main()` claims `<ephemeral>/endo.lock` (recording pid and start time) before it opens the database or kills workers. A second daemon exits 69 with `another Endo daemon (pid N) owns <state>`, and `run-daemon` passes the 69 on. `endo.pid` is written right after the claim, and the daemon no longer kills the previous pid.

**What I changed in dc9f9a251**
- **Bug fix:** `clean --force` also deleted the live owner's state lock. So `start --force` against a running daemon let a second daemon share its state, which is exactly what § 2 is meant to prevent. Now `clean` never touches a live lock owner's files, even with `--force`. The new daemon exits 69 and the first one keeps serving. `--force` still skips the socket check and ignores a live socket-lock owner.
- **Stuck `clean`:** a plain `clean` no longer refuses forever when a stale socket-lock marker holds a recycled pid.
- **New test:** `start --force` against a live daemon declines, and the first daemon keeps its pid file and keeps serving. It fails against b36b90d4b and passes now.
- **Lint:** fixed the Prettier formatting that failed the PR's lint job, updated the changeset text, and fixed one eslint error in the test.

**Verification (local):**
- `daemon-lifecycle-idempotency.test.js`: 5/5 pass (start twice, start while booting, concurrent starts, second run-daemon exits 69 and the first daemon's workers survive, and the new `--force` test).
- `socket-lifecycle.test.js` and `daemon-teardown.test.js` pass.
- Prettier is clean, eslint shows no errors on the changed files, and `tsc` passes for `@endo/daemon`.
- The full `pre-push-gates.sh` timed out after 25 minutes on this loaded host, so I ran the checks above instead.

**Handoff:** this host's PAT gets a 403 on PR edits and comments (a known limit). I posted `endo-daemon-idempotent-start-pr1387-body-refresh`, pinned to `endolin-garden-ece02cb4`. It replaces the PR body to match the new `--force` behavior and posts the follow-up summary comment. Until it runs, the PR body still says `--force` restores the old unconditional behavior.

**Follow-ups (not in this PR)**
- The Go `engo` side of the state-lock claim, and the Node-vs-engo contention test the design lists for phase 1.
- Start-time identity is Linux-only for now (it reads `/proc`). Other platforms record just the pid.
- Two claimants reclaiming the same stale lock at the same instant can race.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-idempotent-start-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 228 tokens (12390873 cached reads)
- Output: 68695 tokens
- Cost: $6.250730600000001 (1 engagement(s) unpriced)
- Wall-clock: 12474s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
