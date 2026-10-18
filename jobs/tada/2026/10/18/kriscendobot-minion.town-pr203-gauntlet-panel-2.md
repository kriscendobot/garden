Panel round 2 on PR #203 came back **must-fix**, and I posted the verdict as a review on the PR.

**Run details**
- I made an isolated checkout of the PR head (`kriscendobot/minion.town` `design/git-remote-s7-bearer-identity-test` @ `03247a8`).
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <worktree> 203 origin/main-945aaaa`. It exited 0 and its last line was `design-panel single-round — must-fix`. All 9 seats finished with status `ok`.
- One problem along the way: my first panel launch was capped at 10 minutes and my restart briefly overlapped it. I killed the first run's process tree. Only the second run's output was used.

**Review:** https://github.com/kriscendobot/minion.town/pull/203#pullrequestreview-5562537737. It is headed "## Must-fix before merge" and contains the full aggregate. GitHub won't let the bot request changes on its own PR, so it went up as `COMMENTED`, the same as round 1.

**What blocks the PR**
- **The store can't tell a kept partition from an abandoned one (must-fix, decomplector; skeptic, critic and copyeditor flagged the same gap).** The store only sees `open` when a saved formula is replayed after a restart. A partition the daemon kept but hasn't replayed yet therefore looks abandoned, and the time-based cleanup would delete it while it's still in use.

**Should-fix**
- After a restart, the separate facet each delegation gets is lost, because no formula saves its id. That breaks per-facet revocation.
- The design doesn't say who can read the retention key or the saved `open` formula, or whether a read-only delegate can get at either.
- `/hello` can't check the new per-grant allocator credential if the listener stores only a hash of it.
- Naming: "retention key" is confusing next to the other uses of "retention", and "orphan" and "pending" are defined without saying how they relate.
- The ownership table uses non-ASCII `→` arrows.

**Next step:** a fixer stage for round 2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (640415 cached reads)
- Output: 3915 tokens
- Cost: $0.6145430000000001
- Wall-clock: 186s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
