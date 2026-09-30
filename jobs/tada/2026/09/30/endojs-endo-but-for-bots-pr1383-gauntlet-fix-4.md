# Gauntlet fix round 4: endojs/endo-but-for-bots#1383 (daemon lifecycle idempotency design)

I made all of the round-4 panel's fixes in one follow-up commit, `984880f7ad`, pushed on top of `5d546f3a71` without rewriting history. All 28 CI checks passed (`ci-wait-merge` returned 0). I did not re-run the panel; the driver posts panel-5.

**What changed in `designs/daemon-lifecycle-idempotency.md`:**
- **Lost start race on the Go path (critic):** the design no longer relies on a `declined` IPC message. `runEngo` has no IPC channel, so a daemon that loses the startup race now exits with code 69 on both the Node and `engo` paths. `start()` watches for the child's exit, and on 69 it checks the daemon's state again: exit 0 if the other daemon serves the requested socket, 69 if it serves a different one, 75 if it is still starting when the wait runs out. The Phase 1 race test now covers both paths.
- **One way to decide whether a daemon is running (decomplector 1–2):** the older `.lock` and `endo.pid` records are now read by the same state check every command uses, not only at the new daemon's startup. That stops `start`'s cleanup from deleting them before they are read. The two cases with no new lock file (old daemon already answering, old daemon still starting) are now listed with the five states.
- **Instance identity (decomplector 3):** a daemon instance is identified by its state directory, and the socket is just an attribute. This explains why `stop` treats a daemon serving a different socket differently from `start` and `clean`.
- **Naming and messages (ergonomist):** `start --force` is renamed `--force-clean` and prints a warning. Every command that exits 69 prints the same refusal message. The `state:` line from `endo status` now carries the pid and socket on the same line. Open Question 1 now says the command must explain why it is not auto-starting.
- **Skeptic and critic notes:**
  - The doc now states that the non-Linux start-time check is only accurate to the second. The remaining risk is a false refusal, never two daemons at once, and `--force-clean` recovers from it.
  - It explains why `flock` is not in Phase 1: Node has no `flock` binding without a native add-on.
  - It notes that detecting a service manager from environment variables gives false positives for interactive shells nested inside a systemd unit.
  - The `/proc/<pid>/cgroup` check for the port 8920 orphan now has an owner: minion.town's existing reaper should log it before killing the process.
  - New tests cover `clean` against a daemon that is still starting, and an old binary's daemon that is still starting.
- **Structure and prose (pedant, novice, copyeditor):**
  - Added a `## Prompt` section: kriskowal's approving review on kriscendobot/minion.town#130, "investigate ways to make the daemon controls more idempotent upstream."
  - Turned bold lead-ins into `####` headings and added a pointer to where section 2 defines the state check.
  - Deleted the paragraph that described the document's own structure, and split, reworded or regrammared the sentences the copyeditor flagged.
  - Changed "PID 1" to lowercase to match the rest of the doc, and added an Updated date.

**What changed in `designs/README.md` (critic, per `designs/AGENTS.md`):** a Milestone 3 table row, a `dlife --> ddock` node in the dependency graph (under Remote Access), a size estimate (M, 1–1.5 weeks), and a new Updated date on the summary row.

**Follow-ups:** none.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2239605 cached reads)
- Output: 16999 tokens
- Cost: $1.5892769999999998
- Wall-clock: 1202s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
