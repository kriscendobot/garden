I ran panel round 4 on kriscendobot/minion.town PR #179 at head `090fb13`, and the verdict is **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a seat or decider failure.

**What I did**
- Got an isolated checkout of the PR head (`kriscendobot/minion.town`, branch `gutter-clip-labels`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `c7bdf20` (`main-c7bdf20`). All 34 seats ran: 11 approve, 19 comment-only, 4 request-changes (assessor, saboteur, breaker, decomplector).
- The full seat output is about 84 KB, which is over GitHub's limit for one review body. I posted it as two PR comments, the same way round 3 did (issuecomment-6113050593 and issuecomment-6113050761).
- Posted the verdict as review 5484705663, headed "Panel round 4: must-fix", with a `garden-panel … round=4 disposition=must-fix` marker. GitHub refuses a request-changes review from the PR's own author, so it went up as a comment review. Rounds 1–3 were posted the same way.

**What is still open**
1. **Leaked connection:** in `src/endo/gateway/site-registry.ts`, a daemon connection that opens after its deadline is never closed, so each slow connect leaves a socket open. Four seats found this. The fix is to close the connection in the `timedOut` branch and add a test where `connect` resolves late.
2. **Title lookup is too big for the job:** the decomplector says the 373-line lookup in `clip-title.ts` should be replaced by recording the clip name once at publish time. If the author keeps the current design, the PR body and the design doc need to say why publish-time capture isn't enough.

The review also lists 10 smaller should-fix items. They include logging the origin of silently swallowed errors, a blank-looking braille character that passes the visibility check, the `Cf` character replacement splitting words at ZWNJ, and hardcoded test ports. The scribe also flagged that round 3's fix push (`090fb13`) has no summary comment on the PR.

I changed nothing in the garden repo and pushed nothing to the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (964081 cached reads)
- Output: 5783 tokens
- Cost: $0.8969482000000001
- Wall-clock: 304s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
