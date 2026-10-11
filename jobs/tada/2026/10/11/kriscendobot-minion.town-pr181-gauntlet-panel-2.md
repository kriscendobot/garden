Round 2 of the panel on kriscendobot/minion.town PR #181 came back **must-fix**. The verdict is posted on the PR, and nothing was fixed or un-drafted, as this stage requires.

**Run**
- I made an isolated checkout of `kriscendobot/minion.town@git-remote-served-clip` at head `a88c2ed5` and ran `panel.sh` in single-round mode against the PR's real base SHA `c7bdf201` (`main-c7bdf20`).
- `panel.sh` exited 0 with disposition `must-fix`. All 34 seats returned `ok` and the decider wrote nothing to stderr.

**Seats asking for changes (4 of 34):**
- **integrator:** the PR body says the work is `deliverable` while the design still requires a browser coherence run that hasn't been done. The fix is either to add that browser run, or to re-label the work `orchestrated-slice`, name who owns the browser run, and keep the PR draft.
- **saboteur:**
  - A purged root can still be served until the vhost cache entry expires. The `purge-root` and `unpublish` help and `DEPLOYMENT.md` should state the full worst-case delay.
  - `writeServedState` can re-create state for a partition that was destroyed while a projection was running. Its comment says this can't happen, but the code doesn't enforce it.
  - The in-flight push marker may leak if the git backend's spawn error path never calls `onComplete`.
- **archivist:** in the `git-remote-partition.sh` help text, the design reference is broken across two lines (`designs/git-remote-` / `served-clip.md § 6`).
- **pruner:** the PR body is too long. Drop the "What changed" section and one sentence in "Choices", and shorten one bullet in "Gaps".
- Comment-only seats also raised should-fix items:
  - **assessor:** an unparseable partition record can never be overwritten.
  - **typist:** the record type should be a union (snapshot record or partition record).

**Posted**
- GitHub won't let the bot request changes on its own PR, so I posted the verdict as a COMMENT review that states the must-fix disposition, matching round 1: https://github.com/kriscendobot/minion.town/pull/181#pullrequestreview-5484429117. It holds the four request-changes seats.
- The full aggregate is about 91 KB, over GitHub's 65,536-character limit for one review or comment. The other 30 seats are in two follow-on PR comments: #issuecomment-6112279137 and #issuecomment-6112279328.

**Follow-up:** the fix-loop stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (994368 cached reads)
- Output: 5572 tokens
- Cost: $0.8626336
- Wall-clock: 220s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
