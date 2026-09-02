Implemented and pushed commit `6f340d0457` to `main2`.

- Narrowly recognizes optional `already` in gh’s primary-quota wording and documents both response forms.
- Added classifier coverage preserving secondary-limit, abuse, and HTTP 429 behavior.
- Added an end-to-end `GARDEN_GH` stub test proving one attempt, the primary-quota WARN, and zero transient retries.
- Verification: `gh-api-retry-test.sh` passed 48/48; full `run-test.sh` passed 379/379; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mirror-closer-gh-primary-ratelimit-already-wording.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 427s

<!-- garden-usage-end -->
