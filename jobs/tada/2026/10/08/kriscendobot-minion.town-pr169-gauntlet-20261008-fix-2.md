## Fix round 2: kriscendobot/minion.town PR #169

I fixed the panel's one must-fix item, pushed it, and CI is green on all 3 checks. The PR head moved from `ff76caa` to `fba9f08`.

**Must-fix (decomplector):** `deploy-app.sh` no longer re-implements systemd's env-file parsing with `grep | tail | regex`. The preflight now asks systemd to load the file and checks the key's length there:
`sudo systemd-run --wait --pipe --quiet --collect -p EnvironmentFile=/etc/minion-mcp/account.env /bin/sh -c '[ "$${#GUEST_RECOVERY_KEY}" -ge 32 ]'`
- A missing file makes the check fail, and the key value is never printed.
- The panel's suggested command needed one correction. systemd expands `${…}` on the command line itself, so the variable needed the `$$` escape. Without it the check failed for every key, including valid ones. I found this by testing with a real `systemd-run --user`.
- I rendered the real heredoc and ran its preflight against real systemd: a 32-character key passes, a 31-character key fails, and a missing file fails.
- In the test, I replaced the parser-case table with a `sudo systemd-run` stub. It checks how the command is called and undoes the `$$` escape the way systemd does. It covers a missing file and unset, empty, short and valid keys, and checks that the value is never logged. All 12 tests pass.

**Should-fix items I also did:**
- In `DEPLOYMENT.md`, the gate is now described as disabled when there is no `ACCOUNT_GATE_SHARED_SECRET` line, not when the file is absent.
- I trimmed the CD prerequisite paragraph to the steps an operator takes.
- I replaced `…` and `⇒` on the lines this PR rewrote.
- I reworded the writer guard's comment so it describes its own rule instead of claiming to mirror the preflight's regex.

**Not done:**
- **Commit regrouping:** the panel suggested regrouping into about three commits. It's non-blocking and would rewrite the PR's history, so I left it for whoever lands the PR.
- **Writer guard:** it keeps its stricter base64 character class. The panel said it could be loosened, but leaving it stricter is harmless.
- **Formatting:** Prettier flags `DEPLOYMENT.md` for style. I didn't confirm whether that was already true before this round. I left the file unformatted to keep the diff small.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1301315 cached reads)
- Output: 12809 tokens
- Cost: $1.0767949999999997
- Wall-clock: 442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
