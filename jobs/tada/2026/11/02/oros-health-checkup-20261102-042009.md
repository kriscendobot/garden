**Verdict: degraded (disk).** The garden mount is at 85% with 72G free, down from 74G at 03:55Z. Everything else on oros is healthy, and the health note is on `journal2:projects/garden/oros-health-log.md`.

**Snapshot (about 05:14Z)**
- **Load and memory:** load is 3.48/3.85/3.83, with 12 GiB of 15 GiB available. Swap is full (192 KiB free), but with that much memory available it isn't causing pressure yet.
- **Disk:** inodes are at 2% and the overlay at 7%. I didn't find the source of the 2G drop, because `du` timed out on the two active project worktrees and `tmpexec`. The sample is also too short to project from.
- **Uptime:** 31d12h, no reboot.
- **Deploy:** root HEAD is `11fe1c6`, which matches the origin/main2 tip. `roll_status` is `deployed`, with 0 of 290 units failing. The roll deferred behind monk 4 from 04:07Z to 04:16Z and landed at 04:26Z, so nothing is blocking it.
- **Workers:** `garden-monk@1..4` are running, the worker-leveling row is `4 0`, and there are 0 failed units. I saw no drain or derotation markers, and I didn't change any.
- **Budget heartbeat:** the last push was at 05:03:58Z, and the six pushes since 03:49Z were all ok at about 15-minute intervals. Spend is 12.86M of 180M.
- **Journal clones:** there are 43 clones. The largest is unblock at 50 packs, which is at the threshold but not over it. There are no `gc.log` files, temp packs or `.git` locks older than 30 minutes. A full-tree lock `find` was too slow and got stopped, so that result comes from a per-clone check that finished.
- **Timeouts (3h):** the only rc=124 is the 7200s wall on `weave-endojs-endo-but-for-bots-pr1476-llm-20261102` at 02:40Z, already logged last run. There were no rc=137 kills and no `Failed with result` entries.

**What changed**
- **Leaked test dirs:** I removed seven from the garden root (3 `.garden-auto-gc-test.*`, 4 `.garden-deadline-nudge-test.*`), about 37.5k entries. They were left by killed test runs, whose EXIT traps never fired. The newest file dated from 10-12, and nothing was using them. `df` didn't visibly move.
- **Code:** no change. No new dirs have leaked since 10-12, so a sweeper fix isn't worth it, and this commit left main2 untouched.

**Also noticed (no action taken)**
- **Watchman warning:** `cannot resolve deployed HEAD` appeared 12 times in 24 hours, but it never reached the third attempt. The 05:24 tick skipped because `root-repo-guard` held the root lock. It isn't in the health note because I found it after writing that.
- **Slow I/O on the garden mount:** removing those dirs took a few minutes, and a journal edit took about 9 minutes to land, mostly slow git operations in the producer clone. `du` and `find` across `.garden-state` didn't finish within 100s.
- **My mistake:** a `pkill` pattern matched its own shell and killed that command, along with my two stuck background scans. It only hit my own processes, and I reran the checks.

**Needs a person at the Mac:** find what is using the shared disk. About 300G of the used space is outside the garden tree and can't be seen from inside the container. This is the same request as last run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-042009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1079574 cached reads)
- Output: 15317 tokens
- Cost: $1.0921188
- Wall-clock: 1577s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
