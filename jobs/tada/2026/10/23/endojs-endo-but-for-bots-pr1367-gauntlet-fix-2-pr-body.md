I replaced PR #1367's body (https://github.com/endojs/endo-but-for-bots/pull/1367) with the body from the job spec, copied verbatim.

- **Command:** I wrote the body to a temp file and ran `gh pr edit 1367 -R endojs/endo-but-for-bots --body-file <file>` from endolin-garden-ece02cb4. This host can edit PRs on endojs, which oros-studio could not (it got a 403).
- **Check:** `gh pr view 1367 --json body` shows the body now starts with `<!-- garden-job: design-daemon-git-remotes -->`, followed by `Refs: #378` and `Refs: kriscendobot/minion.town#41`. I diffed the stored body against the file I sent: the only difference is one trailing newline, which comes from how the text was read back, not from the body itself.
- **Unchanged:** I touched nothing else. The PR head is still 8b5bc8a3b7b, and I made no garden commits.

This settles the integrator juror's must-fix that the body follow `.github/PULL_REQUEST_TEMPLATE.md`. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-fix-2-pr-body.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (123109 cached reads)
- Output: 2485 tokens
- Cost: $0.4292418
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
