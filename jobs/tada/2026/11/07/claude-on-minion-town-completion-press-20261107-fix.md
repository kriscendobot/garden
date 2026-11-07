**Claude-on-minion.town completion press (https://github.com/kriscendobot/garden/issues/89): 4 new dooms, all failed press runs on this host. No arc work failed.**

**The job almost didn't run.** `/home/kris/garden`, including `.garden-state`, is mounted read-only in this host's (`endolin-garden-ece02cb4`) job sandbox. So `inbox-read.sh` and the report script both failed with `FATAL: cannot open clone lock .../journal.lock` (Read-only file system). I got around it by setting `GARDEN_STATE` to a writable folder inside my job worktree, then ran the report and posted the journal entry and the message. I deleted that folder afterwards. I changed nothing on the board, in units or worker state, or in arc work.

**Report results**, window 2026-11-07T01:35:12Z → 07:50:09Z:
- **Roster:** 831 jobs: 810 tada, 20 plan, 1 doin (this press). todo, orch, gauntlet and absent are all 0.
- **Activity in the window:** 10 claims, 0 completions, 0 stalled claims, 0 prior-roster jobs gone missing.
- **Dooms:** 16 current, 4 of them new. All 4 are `requeue-exhausted` on `endolin-garden-ece02cb4`, and all are press jobs:
  - `claude-on-minion-town-completion-press-20261107-013512` (02:13Z)
  - `minion-town-arc-press-20261107-013512` (02:13Z)
  - `claude-on-minion-town-completion-press-20261107-retry` (05:13Z)
  - `minion-town-arc-press-20261107-043512` (05:33Z)
- **Cause of the dooms:** most likely the same read-only mount that blocked this run at first. They come from the host, not from the arc.
- **Plan rows that aren't press jobs:** six parked arc items (canaries, the pr183 findings fix, reauth evaluation, the caddy smoke test, the 20261010 press). Nothing is claimable.

**What I posted:**
- Journal entry `entries/2026/11/07/092921Z-progress-gardener-520993.md` with the counts, the non-tada roster and how each doom was handled.
- One maintainer message (`msg-claude-on-minion-town-completion-press-20261107-fix-e99a07e63777`) naming the 4 new dooms, their signature and host, the likely cause and the workaround. The first send was rejected over a bare issue reference; the resend with the full URL was delivered.
- I added the `GARDEN_STATE` workaround to the existing memory note about this host's read-only mount.

**Follow-up:** a person needs to remount the garden root (or at least `.garden-state`) read-write in this host's job sandbox. Until then, every press that lands here will keep failing and being doomed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-completion-press-20261107-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (850115 cached reads)
- Output: 6216 tokens
- Cost: $0.7632710000000001
- Wall-clock: 197s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
