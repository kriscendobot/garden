**Verdict: healthy.** oros is deployed at the main2 tip and needed no deploy help. I made one small cleanup in `/tmp` and found one new minion.town test defect.

**Snapshot** (full note landed on `journal2:projects/garden/oros-health-log.md`):
- **Load and memory:** load is about 3 and 11 GiB of 15 GiB is available. Swap is still full, unchanged.
- **Disk:** 40.9 GiB free (92%), down from 47.8 GiB at 04:47Z but inside today's range. I didn't trace what used it. Inodes are at 3%.
- **Uptime:** 33 days, no reboot.
- **Deploy:** `746d220507c`, `roll_status: deployed`, 0 of 289 units failing. The gate rejected this sha once at 06:46Z (`triager-pacing-test.sh` rc=124), matching the known timeouts under load. It then deferred behind long jobs and completed on its own at 08:18Z.
- **Workers:** not draining, no derotate marker, and `garden-monk@1..3` running.
- **Budget meter:** the last 8 pushes were all ok, with a largest gap of 17 minutes. Spend is 16% of the window.
- **Timeouts:** in the last 6h there was one true wall hit (03:38Z, already logged), the gate hit above, and some rc=124 notice deferrals. The journal contention storm notice reads recovered at 08:14Z.
- **Daemon-reload flag from the last run:** it has not come back. It is clear on all 289 units and there were no "changed on disk" warnings in 3h, even across the deploy. The original trigger is still unknown.

**Changed:** I removed 64 `/tmp/deploy-www-*` directories over 24h old, using `sudo rm` because some contents weren't owned by `dom`. A `/proc` cwd check and `lsof` showed no process using them. It freed only a small part of their 42M, and 223 newer ones remain. No code landed, and drains, leveling, markers, pools and schedules are untouched.

**For the minion.town owner (no job posted, no code changed):**
- **The defect:** two build worktrees issued about 1100 real root `sudo` calls each in 6h on this host, including `mkdir` and `chown` under `/var/lib/endo-daemon/probe` and `systemd-run` on PID 1. The `mv` and `rm -rf` calls stayed under `/tmp/deploy-www-*`.
- **Likely source:** `test/deploy-www-staging.test.ts` writes a pass-through `sudo` stub, so it is apparently being bypassed. I suspect the PATH prelude in `deploy/aws/scripts/lib/system-path.sh`, but haven't confirmed that or that this test issues every call.
- **Harm here:** small. The only stray outside `/tmp` I found is the empty `/var/lib/endo-daemon/probe/run`, which I left in place. On a machine that really has those paths, the same test would change them as root.
- **Side effects:** 30 failed transient units in 6h (`/etc/minion-mcp/account.env` is absent here) and root-owned leftovers in `/tmp`, which probably explains the residue.

**Still open for the maintainer:**
- The `set-workers monk=3` from endolin at 00:06Z still has no recorded reason, so monk 4 stays stopped while the cap is 4.
- `scratch/tmpexec` is growing, 1457 entries against 1110 at 04:47Z. The sweeper's 7-day idle limit is working, so this should level off once that window fills. Its size is unknown because `du` didn't finish in 45s.

**Gaps in the checks:**
- The `*.lock` search of `$GARDEN_STATE` hit its 40s limit with no match, so it is partial.
- The log note says "no temp packs" flatly, but I only saw temp-pack and `gc.log` results for the 8 clones with the most packs.
- I didn't recheck the minion.town MCP self-heal probe this run.

Nothing needs a person at the machine.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261104-062010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (729920 cached reads)
- Output: 18918 tokens
- Cost: $1.1521600000000003
- Wall-clock: 477s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
