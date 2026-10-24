PR #1542 (endojs/endo-but-for-bots), "fix(sandbox): make bwrap tests pass on Ubuntu 26.04 and kill the sandbox init on cancel", is now out of draft and ready for review at the head the panel passed.

**Head check and un-draft:**
- Just before the change, the PR was OPEN and still a draft. Its head was exactly `43998e611f3a923208b5a6d9f83b0e602e014d4d`, the commit the panel passed.
- I ran `gh pr ready`.
- Re-checking afterwards: `isDraft=false` and the head is still `43998e611f3a923208b5a6d9f83b0e602e014d4d`.

**Advisory appellate pass:** a light `claude -p` (sonnet) review of the 846-line diff. It did not block the un-draft. The points worth a reviewer's attention:
- **Signal to a reused pid:** `pinSandboxInit` sends SIGSTOP straight to the launcher pid, without the guard that `killProcessGroup` uses. If the launcher exits in the tiny gap before the signal, a recycled pid could get stopped and never resumed.
- **Launcher left stopped:** if `pinSandboxInit` fails after the SIGSTOP, or `signalSlice` takes its early branch, the launcher may never get its SIGCONT.
- **`/proc` restrictions:** where `/proc` is masked or mounted with `hidepid`, the kill of the sandbox init silently doesn't happen, so the original bug comes back with nothing logged.
- **The `--info-fd` pipe:** fd 3 may be inherited by the sandboxed command. The pipe is never destroyed after use and its report buffer grows without limit. Very old bwrap versions that lack `--info-fd` would fail outright rather than fall back.
- **Timing-sensitive tests:** the real-bwrap test has a 3s deadline for surviving processes and a "<1900ms" grace assertion, both of which could fail on a loaded CI machine.

No garden-repo changes were made. The appellate points could become a follow-up fix job if the maintainer wants them addressed.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175574 cached reads)
- Output: 1501 tokens
- Cost: $0.41594280000000006
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
