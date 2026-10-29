Gauntlet undraft stage: [endojs/endo-but-for-bots#1431](https://github.com/endojs/endo-but-for-bots/pull/1431) is now ready for review.

- **Advisory review:** I read the diff myself; this was not a separate `claude -p` run. It changes one file, `designs/hardened-text-codecs-shim.md` (+119/−3). It adds a revision section on the older-Chromium `caller`/`arguments` lockdown fix (endojs/endo#3376), plus security notes, new test-plan items, rejected alternatives and one open question. I found nothing the panel missed. The review was advisory only and did not gate the un-draft.
- **Check before the change:** the PR was open and still a draft, at head `1286f427b576718fa6d25756ea662b07b8467552`, the exact head the panel passed.
- **Change:** I ran `gh pr ready` and it succeeded.
- **Check after the change:** `isDraft` is false and the head is still `1286f427b576718fa6d25756ea662b07b8467552`.
- **Follow-ups:** none. The PR's base is the frozen branch `llm-9a14ddf`.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178922 cached reads)
- Output: 986 tokens
- Cost: $0.4229684
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
