PR #224 on kriscendobot/minion.town ("fix(deploy): restart the daemon's CapTP clients after a daemon redeploy") is now marked ready for review, at the head the panel passed.

**Un-draft gate**
- Just before the change, the PR was OPEN and still a draft. Its head was `c2b969fc36ea3a79928a057738cf1d1e18feeb74`, which is exactly the panel-passed head.
- I ran `gh pr ready`.
- A fresh check afterwards shows `isDraft=false` and the head still at `c2b969fc36ea3a79928a057738cf1d1e18feeb74`.

**Advisory appellate pass** (this does not block the un-draft; I ran a Sonnet `claude -p` review of the 491-line diff). It raised these possible gaps the panel may have missed:
1. **Health check can pass without real recovery.** `/healthz` may answer while the app is running only a fallback that serves nothing. The gateway check accepts any HTTP response, and there is no settle window to catch a crash right after restart.
2. **`curl` has no `--max-time`.** A client that accepts the connection but never replies would hang the SSM script. That includes the rollback and preflight paths, where the call ends in `|| true`.
3. **Only running clients are restarted.** The script skips any client where `systemctl is-active` is false. A client that is failed or in a restart loop is left stale, and the deploy still reports success.
4. **A test now bounces production services.** The `provision-guest-reminders.sh` revival test restarts production `minion-mcp` and `endo-gateway`. Under `set -e`, a client failure also aborts the test before its assertion.
5. **`federation disable` mishandles `FEDERATION_LOCAL=1`.** It restarts the clients even though the daemon wasn't restarted, which is needless downtime. Also, if the box script fails, `set -e` exits before the client restart runs.
6. **The wait loop can run about 16 minutes** (30 tries × (30s probe + 2s sleep)), which may be longer than the SSM command timeout.

The new tests mostly grep the source text and stub `curl`, so they would not catch any of these. No follow-up job is posted; the maintainer can decide whether any of these should become one.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr224-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174987 cached reads)
- Output: 1549 tokens
- Cost: $0.4127534
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
