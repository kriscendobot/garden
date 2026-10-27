PR #1543's gauntlet is running again. Its panel-6 round has restarted on this host and was claimed by monk-3 at 01:37Z. It hasn't finished yet, so there's no review verdict at the current head `81e5e47ae3` yet.

**Why panel-6 failed three times.** It never actually reviewed anything.
- **Attempts 1 and 2** ran on `oros-studio-garden-ce242c49`. That host's bot token gets a 403 from GitHub when posting a review on endojs ("Resource not accessible by personal access token (addPullRequestReview)"). Both runs went through all the reviewer seats and then couldn't post. Panel-2 and panel-5 on this PR failed the same way. This host has hit the same 403 on several other endojs PRs (#1515, #1520, #1283, #1304, #1514, #1517); those failures went to the maintainer inbox, but no fix was ever made.
- **Attempt 3** ran on a codex cleric here on `endolin-garden-ece02cb4`. The panel was killed about 90 seconds in, with 7 of 10 seats still pending. That looks like a one-off: clerics often claim panel stages, and I didn't confirm how those turn out.

**What I changed (garden main2, commit `cd7c50a575f`).**
- `gauntlet.sh --resume-from-stage` takes a new `--stage-requires TOKENS` option. It saves the value on the gauntlet record as `stage_requires:` and keeps it if the gauntlet halts again. Every stage job posted afterwards carries it as a `requires:` header, so the normal claim-time host check keeps those stages off hosts that don't match.
- It rejects values with whitespace or invalid tokens.
- I added 3 checks to `gauntlet-resume-test.sh`, which passes 18/18, and `gauntlet-test.sh` still passes 98/98. I also documented the option in `context/operations/systemd-units.md`.

**What I did to the gauntlet.** I resumed it at panel round 6 with `--stage-requires host=endolin-garden-ece02cb4`, using the new script from my worktree. The record now has `stage_requires`, the stage retry budget is reset to 0 of 2, and the review limit stays at 6 rounds. If panel-6 asks for changes, fix-6 runs and the gauntlet ends as "review budget reached", handing the decision to the maintainer without spending more rounds. Nothing on the PR itself changed.

**Follow-ups:**
- **Deploy lag:** until `cd7c50a575f` is deployed, the leader is still running the old `gauntlet.sh`. Any stage it posts or retries for this PR (fix-6, or a retry of panel-6) will be unpinned and could land on oros again.
- **The underlying 403:** I posted `fix-oros-endojs-review-403-panel-routing-20261027` to stop any host from claiming panel stages on a repo where its token can't post reviews. The real fix is for the maintainer to give the oros bot token pull-request read and write access on the endojs org; that job will flag this to them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-but-for-bots-pr1543-panel-failure-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5855309 cached reads)
- Output: 23691 tokens
- Cost: $2.6252017999999997
- Wall-clock: 697s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
