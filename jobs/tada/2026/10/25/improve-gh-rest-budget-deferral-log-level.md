The REST budget deferral now logs at info severity instead of warning, so the healthy once-per-reset skip no longer lands in the mentor failure digest. The fix is pushed to `main2` as 5af7b73f927.

**What changed**
- `scripts/jobs/common.sh` (`gh_rest_budget_defer`): I removed the `WARN:` prefix from the deferral log line. `log()` decides syslog severity from the message text, so the line now goes out with `<6>` (info). `journalctl -p warning`, which `mentor.sh` reads for its digest, only shows `<0>`–`<4>`, so the line is excluded. It still prints only once per host per quota window, and later deferrals in the same window stay silent. I updated the function's header comment to match.
- `scripts/jobs/test/gh-rest-budget-test.sh` (subtest 3): the test now checks that the first deferral line starts with `<6>`, has no `<0>`–`<4>` prefix, and contains no `WARN`.

**Tests**
- `gh-rest-budget-test.sh`: 33 passed, 0 failed, including the new severity check.
- `log-syslog-prefix-test.sh`: 6 passed, 0 failed.

**Follow-ups:** none. Nothing else in `scripts/`, `designs/`, `context/` or `skills/` matches on the old deferral `WARN` text.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gh-rest-budget-deferral-log-level.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (479343 cached reads)
- Output: 2960 tokens
- Cost: $0.5517246
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
