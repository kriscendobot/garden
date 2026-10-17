I applied the round-7 must-fix to kriscendobot/minion.town#192 as one follow-up commit and pushed it to the PR head. CI is green: the gate script returned rc=0 and all 3 checks passed.

**Changes** (commit `e33f970`, pushed with `safe-push-pr-head.sh` from `b672cdb` to `e33f970`):
- **Must-fix (archivist):** `DEPLOYMENT.md` claimed every deploy touching `/usr/local` calls `reclaim_usr_local`. I narrowed it to the app box, which is the only host that ever unpacked Node into `/usr/local` (all the scripts that call `reclaim_usr_local` target that one instance). It now also says the `ci.minion.town` runner host never installed Node, so its `/usr/local` was never owned by a build uid and its bootstrap, which writes `/usr/local/sbin/ci-runner-controller`, doesn't need the reclaim.
- **Should-fix (stylist):** in `deploy/aws/scripts/lib/system-path.sh` I renamed `reclaim_usr_local`'s `dir` to `directory`. The review cited line 105, but the variable is defined at line 46.

**Checks:**
- `bash -n` passes on `system-path.sh`.
- A temp-directory smoke test of `reclaim_usr_local` deleted the old Node files and kept the unrelated ones.
- `test/install-node22.test.ts`: 37 of 37 pass.

**Left for a later round:**
- The other should-fix items: the assessor's point that the first deploy removes `/usr/local/bin/node` while not-yet-redeployed units still use it, and the decomplector's three points (the `sudo()` wrapper, defining the PATH once, and reclaiming once per box instead of every deploy). They are design changes, not small edits, so I didn't make them in this one round.
- Prettier flags `DEPLOYMENT.md`, but it flagged the file before my change too, and the repo doesn't run Prettier on it.

**CI:** my first CI-wait run was cut off by the background time limit, so I polled the checks in the foreground for about 45 minutes. The arm64 harness job waited a long time for a runner. When it passed I re-ran the gate script, which returned rc=0.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1288749 cached reads)
- Output: 6359 tokens
- Cost: $0.8324018000000002
- Wall-clock: 2649s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
