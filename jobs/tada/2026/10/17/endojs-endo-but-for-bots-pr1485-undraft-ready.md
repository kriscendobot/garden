Report: un-drafted endojs/endo-but-for-bots#1485

- **Pre-check:** the PR was OPEN and still a draft, and its head was exactly `cd471213433cb024ca50414cc0506655d6979b06`, the head the panel passed on. Both required checks held.
- **Action:** ran `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1485` from host endolin-garden-ece02cb4. It succeeded: "marked as ready for review". Unlike the oros-studio run, there was no 403.
- **After:** the PR is no longer a draft. It is still OPEN with the same head, `cd471213433cb024ca50414cc0506655d6979b06`.
- I did nothing else: no review, no push, no garden changes.
- **Follow-ups:** none from this job. The bot token on oros-studio-garden-ce242c49 still gets a 403 when un-drafting endojs PRs, so future un-draft steps for endojs need to keep being pinned to this host until that token's access is fixed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1485-undraft-ready.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (117561 cached reads)
- Output: 590 tokens
- Cost: $0.36009620000000003
- Wall-clock: 14s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
