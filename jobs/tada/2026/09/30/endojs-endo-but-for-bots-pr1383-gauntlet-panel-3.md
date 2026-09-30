Panel round 3 on endojs/endo-but-for-bots PR #1383 ("docs(designs): daemon lifecycle idempotency") came back **must-fix**, and I posted the verdict to the PR.

- **Checkout:** isolated project checkout of the PR head `endojs/endo-but-for-bots:design/daemon-lifecycle-idempotency` at `db7c336883`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1383 7ff30afbce…`. I passed the PR's `baseRefOid` (`llm-7ff30af`) so the panel reviewed only the design diff: `designs/daemon-lifecycle-idempotency.md` and `designs/README.md`, +395 lines.
- **Seats:** all 10 returned ok.
  - Request changes: critic, decomplector, ergonomist, pedant.
  - Comment only: copyeditor, novice, skeptic.
  - Approve: orthographer, pruner, thesaurus.
- **Outcome:** the run ended normally with the line `panel #1383: design-panel single-round — must-fix`. I ran it detached, so I didn't capture the exit code directly. That line is only printed just before the script's `exit 0`, and the error paths don't print it.
- **Review:** posted the aggregate as a `gh pr review --comment` at 2026-09-30T02:52:51Z, headed "Garden panel — round 3 … **must-fix**". It had to be a comment because GitHub won't allow request-changes on the bot's own PR; rounds 1 and 2 were posted the same way.
- **Main should-fix points for the fixer:**
  - Critic: the design never says what `start` does when the bounded wait runs out while the daemon is still `booting`, although the exit-code table reserves 75 for that case and the phased test plan names a "`start` while booting" test.
  - Critic: it doesn't cover the upgrade window, when a daemon started by the old binary has no claim marker.
  - Skeptic (comment only): the design says to reuse the `socket-lock.js` primitives, but those still check liveness by bare pid, which is the recycled-pid hazard the design itself names.

As instructed, I didn't fix or un-draft anything; the next fix-loop stage owns that. No garden repo changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (670501 cached reads)
- Output: 3416 tokens
- Cost: $0.6162842
- Wall-clock: 278s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
