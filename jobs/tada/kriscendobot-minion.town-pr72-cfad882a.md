Investigated and reproduced the production-pinned `@main` compatibility failure on current `main` (`e9b99f02`): `evaluateRegister` propagated `Error: Invalid pet name @main` before guest evaluation.

Opened issue https://github.com/kriscendobot/minion.town/issues/74 with evidence, impact, proposed fallback, regression-test guidance, and the required production end-to-end follow-up. Reported the disposition on PR #72 in comment `5491501172`.

Verification: the diagnostic fix branch’s targeted suite passed all 18 tests. No repository code changed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr72-cfad882a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1208s

<!-- garden-usage-end -->
