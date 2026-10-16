PR #193 (kriscendobot/minion.town) is out of draft and marked ready for review, at the head the panel passed (`2b88eaacaf83df2e0cee44fe0366e6195b405f38`).

**Gate checks**
- **Before un-drafting:** state was OPEN, the head matched exactly, and the PR was still a draft. I ran `gh pr ready`.
- **After un-drafting:** draft is now false and the head is unchanged.
- **Probe check:** this is a feature PR, not a probe. "probe" in the title is just the `deploy/probe/` directory, and the body has none of the probe markers.

**Advisory appellate review** (one `claude -p` pass; it does not block the un-draft)
- **Biggest concern:** `minion-ocapn-canary.service` is a `Type=oneshot` unit. If the canary itself starts the Endo daemon (`endo start`), systemd's default `KillMode=control-group` kills that daemon when the run exits. Nothing in the unit or the docs says a separate persistent unit must own the daemon.
- **`node` not on systemd's PATH:** the env file sets `NODE_BIN` but never adds it to `PATH`. A node-shebang `endo` may fail to start under systemd.
- **Proof visible in process listings:** the per-run proof is passed as a command-line argument to `endo eval`, so any local user can see it while the canary runs. It is useless once the run ends, but this matters if the canary host is shared.
- **CI:** the reviewer could not confirm that `fast-check` is a declared devDependency and is installed before the new test step runs. Nothing runs `systemd-analyze verify` on the unit files.
- **Overlapping runs:** a manual run during a timer run makes both fail. This is documented, but nothing (such as a lock file) prevents it.
- **Audit records:** no real secret leaks. The `--output` copy is written with the default file permissions rather than 0600, which is cosmetic since it holds no secrets.
- **Coverage gap:** the reviewer did not read about the last 300 lines of the test file.

These are worth carrying into the successor job `minion-town-ocapn-canary-live-run`, especially the daemon and PATH points, which the first live run will expose. I made no changes to the repo.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (196733 cached reads)
- Output: 1854 tokens
- Cost: $0.36753060000000004
- Wall-clock: 96s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
