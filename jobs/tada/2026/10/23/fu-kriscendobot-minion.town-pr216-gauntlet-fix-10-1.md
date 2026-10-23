Implemented and pushed commit `2af58666ece` to `main2`.

- Must-fix reviews now contain each request-changes seat’s complete multiline findings while omitting non-blocking seat prose.
- Classic fixer hooks receive the same full-text focused aggregate.
- Lossy compact must-fix records are no longer replayed; affected seats rerun instead.
- Added regression coverage for full-text handoff and resume behavior.
- Verification: affected panel tests passed, including 36 panel-run-record, 19 resume, 10 review-submission, and 16 parallel-fanout assertions. One unrelated existing HTTP-origin case in `panel-repo-slug-test.sh` remains failing.

Self-improvement: `skills/panel/SKILL.md`; documented full-text fixer handoffs and pass-only durable-record resume.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-kriscendobot-minion.town-pr216-gauntlet-fix-10-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 529s

<!-- garden-usage-end -->
