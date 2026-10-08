Panel round 3 on kriscendobot/minion.town#170 ended in **must-fix**. `panel.sh` exited 0 and I posted the verdict to the PR.

**Run:**
- Project checkout: `scratch/project-wt-kriscen-80370841b5c5-62a09fe6`, at head `c3bc2f4` of `feat/locator-fragment-scrub`.
- Command: `GARDEN_YARN=npm GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 170 76bb27628e90…`, run detached. The base is the PR's own base commit, not `origin/main-76bb276`.
- Code panel, 34 of 34 seats returned: 6 request-changes, 19 comment-only, 9 approve. The decomplector was seated because the same mechanism kept failing round after round.

**Posted:**
- A review on https://github.com/kriscendobot/minion.town/pull/170 with the header "disposition: must-fix", followed by 15 per-seat verdicts. It posted as COMMENTED because GitHub won't let the bot request changes on its own PR. The header is what the next-stage check reads.
- The 19 remaining seat verdicts went into a PR comment (issuecomment-6054274632), because the full aggregate (96 KB) is over GitHub's review size limit.

**Round 2's blockers are closed.** These were the switch prompt, the 401/503 split with reconnect, the atomic key creation and the rename sweep.

**New must-fix items:**
1. **saboteur:** a link whose guest identifier is well formed but is not a guest gets a 503, not a 401. It then stays in `pending-guest` for good, and every later visit fails before the stored guest is shown.
2. **prover:** the 503 test stubs out the socket service, so nothing actually tests the `open()` error mapping or the reconnect-after-close.
3. **integrator:** the PR description doesn't mention the 401→503 change, the switch prompt, or the parser and Playwright moves.
4. **corner-prober:** `#recover=1` only works as an exact match, and no test covers a fragment with extra parameters.

The non-blocking should-fix items are listed in the review header.

**Follow-ups:** none from this stage. I did no fixing and did not un-draft the PR. The next gauntlet stage (the fix loop) owns the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (979870 cached reads)
- Output: 7088 tokens
- Cost: $0.9217580000000001
- Wall-clock: 324s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
