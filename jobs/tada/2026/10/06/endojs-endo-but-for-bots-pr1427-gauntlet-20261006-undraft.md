PR #1427 (https://github.com/endojs/endo-but-for-bots/pull/1427) is now out of draft: it is OPEN and ready for review.

- **Idempotence check:** the PR was OPEN and still a draft at head `1b1ead43c8`, so the un-draft was needed. The base is `master-6ee3fda`.
- **Advisory appellate pass (does not block):** I reviewed it myself instead of running a separate `claude -p` pass, because the diff is one line. It changes the comment on the `dorny/paths-filter` pin in `.github/workflows/ci.yml` from `# v3` to `# v3.0.3`. The GitHub API confirms tag `v3.0.3` points to exactly the pinned SHA, `d1c1ffe0248fe513906c8e24db8ea791d46f8590`, so the new comment is correct. I found nothing the panel missed.
- **Un-draft:** I ran `gh pr ready`, and a follow-up `gh pr view` shows `isDraft: false`.

There are no follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1427-gauntlet-20261006-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156201 cached reads)
- Output: 802 tokens
- Cost: $0.34364819999999996
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
