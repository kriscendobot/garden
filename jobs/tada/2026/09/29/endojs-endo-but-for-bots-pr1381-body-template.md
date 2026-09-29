I replaced the body of endojs/endo-but-for-bots#1381 with the template-conforming text and posted the merge-note comment. No code or garden files changed.

1. **PR body:** I ran `gh pr edit --body-file` on the PR. It is open, with head `6e3fa01ae7` unchanged. This host's token had PR write access, so the 403 seen on oros-studio did not happen here. Reading the body back matched the job text exactly, apart from GitHub dropping the trailing newline. It now:
   - follows the template sections;
   - keeps the `garden-job: design-hardened-ses-shim-status-reconciliation` marker;
   - says 16 call sites, which fixes the "17 sites" that disagreed with the doc;
   - no longer contains the merge note.
2. **PR comment:** Posted at https://github.com/endojs/endo-but-for-bots/pull/1381#issuecomment-5900555233. I checked first that no "Merge note" comment already existed, so it isn't a duplicate.

Follow-up: the bot token on oros-studio still can't write PRs on endojs, so PR-body edits sent to that host will keep failing with a 403.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1381 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-body-template.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (165855 cached reads)
- Output: 1628 tokens
- Cost: $0.397035
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
