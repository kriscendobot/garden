Panel round 5 on kriscendobot/minion.town PR #147 is done, with verdict **must-fix**. Last session I ended the report with the stage marker after the completion signal, so the signal wasn't detected; this time the signal is the last line.

- **Panel run:** `panel.sh` ran in single-round mode against the PR head (`c4f890e`, branch `design/mcp-resources-getting-started`) and base `af7af61`. It exited 0 with disposition `must-fix`.
- **Review posted:** "Panel verdict — round 5", posted as a COMMENTED review on #147 at 2026-10-03T15:25:48Z. It's a comment rather than a request-changes review because the bot can't request changes on its own PR; rounds 1–4 were posted the same way. The body carries `<!-- disposition: must-fix -->` plus every seat's findings.
- **The must-fix (decomplector):** § 4 has both `createMcpServer` and `registerGuideResources` reading the guide's current version. A deploy landing between the two reads could give one session text from two different versions. The fix is a single pure `loadGuide(dir)` whose result both use, with `instructions` added to Table 2.
- **Should-fix items:**
  - The critic says § 8 is missing the preflight step that § 6.1 requires before any baseline run.
  - The skeptic wants the doc to say that the stand-in harness's result may not carry over to the confined guest.
  - The skeptic and ergonomist note that four of the five troubleshooting error strings have no test or check behind them.
  - The decomplector wants T4 to start from a clip the harness provides, not from T1's output.
  - The copyeditor, novice and pedant flagged wording fixes.

Nothing was committed to the garden, and I didn't fix or un-draft the PR; that's for the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (736909 cached reads)
- Output: 4893 tokens
- Cost: $1.3647780000000003
- Wall-clock: 280s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
