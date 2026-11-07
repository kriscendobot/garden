I applied all of panel round 3's fixes to PR #243 and pushed them, but CI had not finished after the one-hour wait, so this stage is still pending. Five of the seven checks pass. The two "Claude harness" jobs (amd64 and arm64) were still queued on the self-hosted runner when the hour ran out.

**What I changed** (commit `55ba82a`, pushed with `safe-push-pr-head.sh`, which never rewinds a peer's commits; head moved from `a84de64` to `55ba82a`):
- **Archivist must-fix and surfacer must-fix:** in `designs/mcp-resources-getting-started.md`:
  - The mounts paragraph now lists the two mounts the code still has, `clips` and `claudeAgents`, and says `submit` and the inviter mount were removed (see § 3.5).
  - The audit rows for `invite` and `cancelInvite` now say "Removed in #243".
  - The Table 1a row for `guide/invitations` now describes how a person redeems a locator on the web page.
- **Archivist should-fix:** the README collision example no longer claims a second facet collides on `cancel`.
- **Surfacer follow-ups:** I added a note to `designs/remote-guest-endo-cli.md` § 4 and to `designs/guest-coupons.md` that the MCP invite tools they build on were removed.
- **Pruner:**
  - The decision paragraph in the design no longer explains how `adopt` and `remove` work.
  - The changeset now says "Removed (breaking): …" in one line, and the "stays `minor`" reasoning is gone.
  - In `verify-web-accept.ts` I cut the comment's second clause, which the code below it already shows.
  - In the PR body I deleted the `tools/list` count section. The Proof section was already one sentence, so I left it.
- **Not done:** the PR body's Tests line still cites the earlier CI run (41768255035).

**How I worked around the sandbox:** `ensure-project-worktree.sh` failed with a read-only file system error. The fix for that (7fd074b62d5 / 3c7f9ce045e) has not been deployed to this host yet. I cloned the PR head into the job's temp directory instead and pointed the CI wait at it with `GARDEN_PR_WORKTREE`.

**A mistake I made and repaired:** my first clone attempt failed, and the commands after it ran in the garden worktree, which shares the root repo. They fetched a minion.town ref and moved my worktree's HEAD. I checked `origin` straight away and it is still the canonical `git@github.com:kriscendobot/garden.git`. I also deleted the stray `refs/remotes/origin/garden/mcp-invite-tool-removal` ref and reset my worktree to `origin/main2`. As far as I can tell, nothing else in the shared repo changed. The fetched minion.town objects may still be in the store as unreferenced objects, which is harmless.

**CI:** the runs were queued from 22:37 to about 23:07 behind another branch's run. When the wait ended at about 23:37, `changes`, `test` and the three browser gates had passed, and `ci-wait-merge.sh` returned rc 4.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr243-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2684641 cached reads)
- Output: 12438 tokens
- Cost: $1.4382002000000003
- Wall-clock: 3751s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
