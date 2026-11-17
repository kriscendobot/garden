I made no new changes this session. An earlier claimant of this job had already fixed the PR's last must-fix. I confirmed the result on the PR itself.

**What I found on PR #1542** (head `20b8f852ec`, mergeable, not a draft):

- **The fix is in place.** Commit `971602df4d` (posted 2026-11-17 09:36Z) takes out the chain the decomplector flagged as unjustified. That chain found the sandbox init's process id through `--info-fd`, polled `/proc`, froze and resumed it with SIGSTOP/SIGCONT, and serialized the kill attempts.
- **What replaced it:** cleanup now uses the kernel's parent-death signal.
  - bwrap no longer gets `--new-session`, so its whole tree stays in the separate process group Node's detached spawn already creates.
  - A small Node supervisor runs under `setpriv --pdeathsig`. It sets up its handler and checks it still has the expected parent before it starts bwrap. If the daemon dies, or bwrap is killed by a signal, it kills the whole group.
  - This closes the startup gaps without storing a process id that could be reused.
- **Probe:** if `setpriv` doesn't support `--pdeathsig`, the backend now reports bwrap as unavailable.
- **Tests:** coverage includes a test that kills the real owner process and a deterministic test of the group cleanup. The earlier claimant also showed the test catches the bug it guards: making the handler kill only itself made the test fail.
- **Follow-up commits:** `e666f5b80a`, `99ea107822` and `20b8f852ec` changed only the tests, to remove timing flakes on CI's slower runners.
- **Code check:** at head `bwrap.js` uses `--pdeathsig`, explains in a comment why `--new-session` is left out, and contains none of the old `info-fd`, SIGSTOP or `pinSandboxInit` code.
- **CI at head:** 13 checks pass, 20 skip and 1 fails. The failure is the repository-wide zizmor audit. It flags mismatched version comments in two workflow files (`update-action-pins-major.yml`, `update-action-pins.yml`) that this PR doesn't touch, and the problem predates it.

**Follow-ups:**
- The PR needs a fresh panel or maintainer review of the new mechanism. The gauntlet halted on 2026-10-24 at 4 of 6 rounds; resume it with `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1542-gauntlet panel --iteration 4 --add-rounds 2`.
- The zizmor failure should be fixed separately at the repository level by correcting the action-pin comments to the exact tags.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1542-parent-death-primitive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 8 tokens (193687 cached reads)
- Output: 2058 tokens
- Cost: $0.49044940000000004 (1 engagement(s) unpriced)
- Wall-clock: 6062s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
