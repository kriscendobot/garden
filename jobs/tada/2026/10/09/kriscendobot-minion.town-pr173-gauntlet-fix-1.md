I fixed all four must-fix items from the round-1 panel on kriscendobot/minion.town#173 and pushed the fix. CI is green: `ci-wait-merge.sh --no-merge` returned 0, with all 3 checks passing.

**The fix commit** is `d24f347`, a follow-up commit on `design/ocap-site-crawler-leak-rotation` (moving it from `49e9b5e`). It changes only `designs/ocap-site-crawler-leak-rotation.md`.

The four must-fix items and what changed:
1. **The canary contradicted the rotation rules** (skeptic). Fixed in § 8. The canary now uses only paths that exist in production, with no test-only trigger:
   - Fetching `/robots.txt` must leave the clip Alerted, with no rotation.
   - The owner then calls the leak-control facet's `rotate()`, which runs the same registry steps as an automatic rotation.
   - A second `/robots.txt` fetch on the new link must alert and not rotate.
   - The canary can't fake a real search-engine crawler, so CI covers that case end to end: a recorded request goes through the real classifier, spool, warden and registry steps, with no bypass.
2. **Link holders could force a rotation** (skeptic). The `robots.txt` tripwire and the honeypot now only alert, after the measurement gate; they never rotate. Only a verified automatic crawler rotates (§ 2 table and text, § 4.2). § 4.3 now covers the one route a holder still has, submitting the URL to a search engine. It also notes that a holder can no longer trip the global circuit breaker with faked fetches.
3. **The owner might never learn the new link** (second panel seat). § 3.4 has a new gate 4: an alert channel the owner can receive, with a passing delivery test. It applies per owner, permanently. An owner without a verified channel never goes past Alerted. Open question 1 now asks only which channel ships first.
4. **The leak-control facet was never defined as one surface** (second panel seat). There is a new § 7.1 with:
   - the methods `getStatus`, `events`, `pinPublic`, `unpinPublic`, `acknowledge` and `rotate`, with their signatures;
   - the `Status` and `Signal` return shapes;
   - the error codes `DISABLED`, `PINNED`, `LIMITED`, `DEGRADED_REFUSED` and `GONE`.

   `getStatus()` is now the only place to read leak state. The account `list` no longer copies it, and § 5, § 6.2, § 8 and § 9 were updated to match.

I left the should-fix and comment-only findings alone; the panel's next round will show whether they still stand. One of them, the critic's point that the 10-minute grace window delays verified-crawler rotations, is untouched and may come back in round 2. I didn't run a local Markdown formatter check, but CI passed. I didn't re-run the panel; the driver posts round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (792840 cached reads)
- Output: 8263 tokens
- Cost: $0.8145399999999999
- Wall-clock: 1462s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
