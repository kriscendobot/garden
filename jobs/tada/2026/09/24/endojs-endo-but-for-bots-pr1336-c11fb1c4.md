I've queued the gauntlet kriskowal asked for on endojs/endo-but-for-bots#1336. It isn't running yet: it will start once the fixer job already working on the PR finishes.

**Why it waits.** A fixer job (`endojs-endo-but-for-bots-pr1336-fix-review-5307103246`) claimed this PR at 20:42Z and is still pushing fixes for review 5307103246. Starting the gauntlet now would review a head that is still changing, so I sequenced the gauntlet after it.

**Preflight.** `pr-feedback-preflight.sh` exited 2, but the only matching text was the bot's own "On it" reply (5822021933), not a resolution. The board had no gauntlet record for #1336 in `plan`, `todo`, `doin`, `tada` or `gauntlet-archived`, so I went ahead.

**What I posted:**
- **Plan job `endojs-endo-but-for-bots-pr1336-gauntlet-launch`** (gardener, minion tier), blocked on the fixer job. When the fixer reaches `tada/`, the unblock watcher promotes it. It then runs `scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr1336-gauntlet https://github.com/endojs/endo-but-for-bots/pull/1336` and comments on the PR.
- **PR comment** explaining the sequencing: https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5822043903
- **Inbox note** to the fixer job saying a gauntlet will follow it, so it should keep the PR draft and not start one itself.

No garden code changed and there was no commit.

**One gap:** `unblock.sh` releases a blocked job only when the predecessor lands in `tada/`. If the fixer job is doomed instead, the gauntlet-launch plan stays parked. The doomed fixer would still reach the maintainer through the usual doom/halt path, and fixing it means promoting the plan job by hand.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-c11fb1c4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (532041 cached reads)
- Output: 4953 tokens
- Cost: $0.5731721999999999
- Wall-clock: 78s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
