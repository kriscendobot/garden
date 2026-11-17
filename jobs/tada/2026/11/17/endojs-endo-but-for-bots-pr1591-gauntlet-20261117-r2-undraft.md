## Completion report: endojs/endo-but-for-bots#1591 un-draft (gauntlet r2, iteration 3)

PR #1591 ("fix(sandbox): sweep the bwrap process group when the leader exits") is now ready for review, at the same head the panel passed.

**Head check before un-drafting:** the PR was OPEN, still a draft, and its head was `8708f561946b89bc0258281c3acdba590786b04e`, the exact commit the passing panel covered. I ran `gh pr ready`.

**Check after:** `isDraft` is false and the head is still `8708f561946b89bc0258281c3acdba590786b04e`.

**Advisory appellate pass:** this is advisory only and did not block the un-draft. A light `claude -p` review of the 553-line diff raised these points:
- **Kill errors other than ESRCH:** if `processKill` fails with something like EPERM, `wait()` rejects without sweeping the group. The anchor keeps holding the pipes and the real exit status is lost.
- **Watchdog false positive:** the watchdog treats any failed read of `/proc/$parent_pid/stat` as "parent gone." A transient failure (fork failure, EMFILE) would then SIGKILL a healthy sandbox.
- **Daemon-crash cleanup:** bwrap's parent is now `/bin/sh`, so `--die-with-parent` no longer protects against the daemon dying. Cleanup after a crash relies only on the 1s polling watchdog. The comment about `--die-with-parent` is now stale.
- **Background processes:** anything the sandboxed command leaves running in the group is now SIGKILLed when the leader exits normally. The changeset doesn't say this behavior changed.
- **Exit status:** the `sh` wrapper reports a code of 128+N rather than a `signal`, so callers can't tell an external SIGKILL from a normal exit 137.
- **Smaller concerns:**
  - The pgid could in theory be reused between the exit-time sweep and a later teardown that signals it again.
  - `process.kill` is captured unbound.
  - No test covers the watchdog path or the pid-reuse branch.
  - The test timeouts were roughly doubled.

**Follow-ups:** none are required. The maintainer may want to look at the kill-error and watchdog points during human review.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (185897 cached reads)
- Output: 1682 tokens
- Cost: $0.4397314
- Wall-clock: 89s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
