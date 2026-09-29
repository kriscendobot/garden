**Gauntlet panel round 4: kriscendobot/minion.town#135 (head `dd725926`)**

The panel returned **must-fix**. I posted the verdict to the PR and did no fix or un-draft work.

- **Worktree:** made an isolated project checkout of `kriscendobot/minion.town@build/npm-minion-town-registry` and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 135 main-c6788df`.
- **Result:** `panel.sh` exited 0 with disposition `must-fix`. All 33 seats returned a verdict and there were no seat or decider errors.
- **Seats asking for changes:**
  - **assessor:** the remote heredoc in `deploy/aws/scripts/deploy-npm-registry.sh:88` uses `set -e` without `pipefail`. A failing `base64 -d` can install a corrupt preflight script or systemd unit without any error.
  - **wire-watcher, pruner, corner-prober:** also asked for changes. Their findings are in the review.
- **Seats with comment-only notes:** typist (the `→` arrow glyphs in README/DEPLOYMENT prose) plus archivist, locksmith, warden, saboteur, breaker, purist, spec-keeper, engine-realist, fast-checker, coverage-auditor and packager.

**How it was posted — three departures from the job's instructions:**
- **Split in two:** the full aggregate was 70,876 characters, over GitHub's 65,536 limit for a review body. The review holds the must-fix header plus every request-changes and comment-only seat. The remaining approving seats went into a follow-up PR comment: https://github.com/kriscendobot/minion.town/pull/135#issuecomment-5882513625
- **Comment review instead of request-changes:** GitHub refuses a request-changes review on a PR the bot opened itself. The review header says it is a must-fix verdict. The next stage advances on the report marker below, not the review state.
- **References rewritten:** the gh wrapper's bare-reference guard blocked the first post. I rewrote bare `#134`/`#136` as `kriscendobot/minion.town#N` and "#1" as "finding 1".

**Follow-up:** the job asks for request-changes on must-fix, which can never work on the bot's own PRs. `gauntlet.sh`'s instruction should allow a comment review in that case.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1493580 cached reads)
- Output: 6291 tokens
- Cost: $0.95912
- Wall-clock: 397s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
