Implemented and pushed commit `e8fac604d5592d950776f2e5ec33928c49e5274b` to `main2`.

- Unmetered rows now count as engagements, increment `unmetered`, and contribute zero tokens.
- Malformed JSON, timestamps, token fields, and costs still fail loudly.
- Orchestration reports now expose `campaign-unmetered-engagements` and state that recorded spend excludes those engagements.
- Added dedicated regression coverage for unmetered, mixed, and malformed ledgers; updated orchestration integration coverage and design documentation.
- Verified: `campaign-spend-test.sh` passed 21/21; `orchestrate-test.sh` passed 43/43; repository check suite passed 12/12.
- Follow-ups: none. The Ironhorse relaunch can use the pushed commit.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-campaign-spend-unmetered-rows.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 358s

<!-- garden-usage-end -->
