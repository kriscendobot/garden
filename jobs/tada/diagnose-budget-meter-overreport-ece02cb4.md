Root cause: the 120M reading was a correct sum of local logs but combined two entitlement epochs. At 17:55:34Z Claude rejected usage at the seven-day limit; credentials refreshed at 18:17:22Z, usage succeeded at 18:17:54Z, and `/usage` then showed a fresh 0% despite the unchanged Sep 5 reset. Account identifiers in auth status and telemetry matched, ruling out an account switch.

Evidence:

- Independent aggregation of `~/.claude/projects/**/*.jsonl` matched the 18:45 journal snapshot exactly: 45,412 input + 15,753,751 output + 104,280,051 cache-creation = 120,079,214.
- Cache-read counting was not enabled in the environment. The excluded cache-read total was 1,447,321,215; enabling it produced 1,567,400,429.
- The old 04:00Z anchor did trim history, but was one hour late versus `/usage`’s 03:00Z reset and omitted 5,061,818 tokens—an undercount, not the over-report’s cause.
- Relevant evidence paths include `budget/live/endolin-garden-ece02cb4`, `.claude/projects/.../5f7954e3-3d58-535e-a3a4-11eac1ee2a46.jsonl`, and `.claude/telemetry/1p_failed_events.851aa336-...json`.

Changes landed:

- `main2` commits `75af103e01` and `6647a1173e` align the reset to Friday 20:00 Pacific and detect a midweek seven-day rejection followed by successful usage as a new entitlement/account epoch. On this host the corrected effective cutoff is 1788286674; verification measured 1,180,212 current-epoch tokens.
- Added regression coverage. Returning the old anchor made the test fail with `entitlement boundary total was 1000, expected 100`; restored code passes all 18 live-budget tests.
- Restored `config/budget-pools` on `journal2` commit `6d59b22ea4` from the temporary 385M unblock to the real simultaneous sample calibration: 74,531,754 / 50% = 149,063,508, rounded to 149M.
- Relevant budget, snapshot, campaign, and quota-panel tests pass. The broader suite recorded 378 passes and one unrelated existing issue-inbox failure caused by bad GitHub credentials.
- The deployed root will acquire the code fix through the normal deliberate-deploy path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/diagnose-budget-meter-overreport-ece02cb4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1064s

<!-- garden-usage-end -->
