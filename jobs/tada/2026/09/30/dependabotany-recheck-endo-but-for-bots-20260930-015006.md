No embargo rows were due on `endojs/endo-but-for-bots`, so there were no verdicts to carry out and I didn't touch any PR.

- **Ledger:** the case-insensitive grep found 113 ledger entries. Every PR that ever had an embargo row is now merged or closed on GitHub. The grep also turned up a "#2286", but no such PR exists; it's a false match from other text.
- **Open Dependabot PRs:** none. The latest ones were already settled: #1350 was merged on 09-27, and #1351, #1353 and #1354 were closed on 09-29 because they need newer Node versions than the project supports.
- **Schedules:** there are no leftover one-off rechecks for single PRs. The daily recheck `dependabotany-recheck-endo-but-for-bots` is still installed. Its pre-check skips days with nothing to review, so I left it in place.
- **Ledger entry written:** `journal/entries/2026/09/30/015537Z-message-botanist-1da809.md`. It has a `project: endo-but-for-bots` line and a `# Dependabotany` heading, so the next sweep's grep will find it.

I didn't change any garden code, so there was nothing to commit to main2. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260930-015006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (715041 cached reads)
- Output: 3350 tokens
- Cost: $0.7257362000000002
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
