**Gauntlet undraft for kriscendobot/minion.town#192 is done: the PR is now ready for review.**

**Steps:**
1. Right before un-drafting, I re-checked the PR: it was OPEN, still a draft, and its head was exactly `768b651e7ebd32868c15241de1b448dbe5193625`, the commit the panel passed.
2. I ran `gh pr ready` on it.
3. A second check after that showed `isDraft=false` with the same head commit.

**Advisory appellate pass:** a light `claude -p` (Sonnet) review of the full diff, recorded here only. It did not block the un-draft. Items worth a follow-up:
- **`aws` and other tools may break:** box-side scripts now run with `PATH=/usr/sbin:/usr/bin:/sbin:/bin`. Any bare call to a tool installed under `/usr/local` (such as `aws`, `caddy` or `jq`) would fail with "command not found".
- **Bare `node`/`npm`/`corepack` calls aren't checked:** the guard test only looks for literal `/usr/local/bin/...` paths. A bare `node` in a unit or `ExecStartPre` script would no longer resolve, and `provision-guest-reminders.sh` already had this bug.
- **Claude smoke test PATH:** it now runs with `PATH=/usr/bin:/bin`, which doesn't include `/opt/node/current/bin`. If `bin/claude` is a `#!/usr/bin/env node` wrapper, the smoke test fails and deploys abort. The same applies to any child process minion-mcp spawns that needs `node`. The reviewer couldn't see `cli-provider.ts` or `bin/claude` in the diff, so this is unconfirmed.
- **Deploy order is unclear:** units now require `/opt/node/current`, but only three deploy scripts install Node. The error messages disagree with each other and with DEPLOYMENT.md about which script to run first.
- **One shared `/opt/node/current` symlink:** a Node change in one deploy changes every service's runtime on its next restart. This isn't new (the old `/usr/local` install worked the same way). Old `/opt/node/<sha>` trees are also never cleaned up, roughly 200 MB each.
- **`reclaim-usr-local.sh`:** it runs a recursive root `chown` over files the build user may have touched, with a window where root runs possibly tampered binaries. It should say to stop services first or verify digests. `endo-ocapn-daemon.service` still runs as root off the old `/usr/local/bin/node`.
- **oauth2-proxy pin:** v7.15.5 is pinned with hard-coded digests that the reviewer couldn't check against upstream.

Nothing was committed to the garden repo for this job.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174030 cached reads)
- Output: 1769 tokens
- Cost: $0.41829800000000006
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
