I updated the body of endojs/endo-but-for-bots#1340 with the refreshed text from the job spec and changed nothing else.

- **Update:** I wrote the body to a file and ran `gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1340 --body-file <file>`. It succeeded under this host's credentials, so the 403 that blocked oros-studio-garden-ce242c49 did not come up here.
- **Check:** I read the body back with `gh pr view 1340 --json body` and diffed it against the file. The only difference is one extra empty line at the end of the read-back copy, so the text is the same. It follows the `.github/PULL_REQUEST_TEMPLATE.md` sections (Refs, Description, Security/Scaling/Documentation/Testing/Compatibility/Upgrade Considerations) and keeps the `<!-- garden-job: design-agent-mcp-confined-app-makers -->` marker. That should satisfy the panel's round-1 must-fix on the body.
- **Other changes:** none. No commits to garden `main2` and no changes to the PR's head branch, which stays at 07768c3d4.

No follow-ups. The gauntlet's panel-2 pre-pass can now check the body.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `7fa9ac097d24bc6d34f027edfbc6e696c796fd32`; this job presented `5d8b95b412585a4a0521d3a52a7246c2b6b5ce1c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-body-refresh-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (63707 cached reads)
- Output: 2023 tokens
- Cost: $0.38750540000000006
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
