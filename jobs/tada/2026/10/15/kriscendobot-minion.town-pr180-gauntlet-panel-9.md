Panel round 9 on PR #180 (`kriscendobot/minion.town`, head `design/git-remote-endo-binding`, base `main-c7bdf20`) returned **must-fix**. `panel.sh` exited 0 in single-round mode.

- **Review:** I posted the aggregate as a comment review. GitHub rejected a request-changes review because the bot authored the PR. The body opens with "verdict: must-fix" and is truncated to the first 60,000 of 89,796 bytes.
- **Seats:** The decomplector seat was added after the new-mechanism probe fired. I did not read the full set of findings. The one I did read, from the assessor, was a should-fix: the control-plane handlers in `src/endo/git-remote/control.ts` return 400 for every failure, including disk faults.
- **Not done:** No fix, no un-draft, no looping, as the job specified.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (412573 cached reads)
- Output: 1703 tokens
- Cost: $0.2675713
- Wall-clock: 136s

<!-- garden-usage-end -->
