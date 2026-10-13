**Panel round 6 for kriscendobot/minion.town#181: must-fix**

I ran one single-round panel on PR head `b7bd43c` against base `main-c7bdf20`. `panel.sh` exited 0 with disposition **must-fix**. Of the 34 seats, 7 requested changes (assessor, typist, stylist, saboteur, breaker, benchmarker, corner-prober), 7 approved and 20 left comments only. The run is recorded at `panel-runs/kriscendobot-minion.town-181/bf27932f24d2.md`.

I posted the verdict as a COMMENT review, since GitHub won't let the bot request changes on its own PR. Prior rounds did the same. The full aggregate (about 89 KB) is over GitHub's 65,536-character limit for a review body. So the posted review has a summary, the seven request-changes seat reports in full, and a one-line verdict for each other seat; it points to the panel record for the rest.

**Must-fix:**
1. **Unpublish and purge can be delayed up to an hour.** When a partition's projection keeps failing, its retry backoff grows to 1 h, and both sweeps skip it until then. That breaks the promised bound of about 35 s. Flagged by assessor and breaker.
2. **Timer overflow.** The config accepts interval values above 2^31−1 ms, which Node clamps to 1 ms, so the sweeps would run as a busy loop. Flagged by saboteur and corner-prober.
3. **Abbreviated parameters.** The new `serveEntry` uses `req`/`res` instead of `request`/`response`. Flagged by stylist.
4. **Unmeasured cost figure.** The design's sweep-cost estimate has no measurement behind it. Flagged by benchmarker.

**Should-fix, selected:**
- `parseServedState` checks parsed JSON too shallowly before casting it to the full type.
- Pending markers never clear on two early returns, so the partition is re-queued forever.
- HTML rewriting has no overall time or size budget per projection, so it can block the service for minutes.
- The decomplector's is-it-needed question: the unpublish→destroy handshake has been patched in every round from 2 to 5. It suggests letting the service do the final delete, or justifying why the operator script deletes files the service owns.

No fixing or un-drafting was done, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (947163 cached reads)
- Output: 5313 tokens
- Cost: $0.8368445999999999
- Wall-clock: 202s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
