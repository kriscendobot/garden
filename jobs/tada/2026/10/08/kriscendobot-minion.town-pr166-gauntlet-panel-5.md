## Gauntlet panel round 5: kriscendobot/minion.town PR #166

Round 5 of the panel ran and returned **must-fix**. `panel.sh` exited 0 and all 34 seats returned ok. The verdict is posted on the PR.

**What I did**
- Made an isolated project checkout of `kriscendobot/minion.town` `feat/prod-objectives-probe` at head `a06e631a`, at `scratch/project-wt-kriscen-8b72d41e64eb-e051010f`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_YARN=npm scripts/jobs/gardening/panel.sh` detached against the base commit `d750b09` (`main-d750b09`).
- The run was saved as `panel-runs/kriscendobot-minion.town-166/a72ce75557d5.md`.
- Posted the aggregate as a review: https://github.com/kriscendobot/minion.town/pull/166#pullrequestreview-5450296820. It is a COMMENTED review because GitHub refuses request-changes on the bot's own PR, which is how rounds 1–4 were posted too. It carries the marker `<!-- garden-panel: kriscendobot-minion.town-pr166-gauntlet round=5 disposition=must-fix -->`.

**Verdict:** 6 seats requested changes, 14 approved, and the rest were comment-only. The round-4 must-fix (the bare `#58` reference) is resolved.

**Must-fix items:**
1. **decomplector:** remove the shared MCP session cache (`closeSession` and `resettingSession`) and use a scoped `withSession` instead. The pre-pass found that the same mechanism drew must-fix findings in the two previous rounds.
2. **integrator:** the production run in the PR's Evidence section is older than the switch to the SDK client. Re-run `--strict` at the head commit and update the Evidence section.
3. **stylist:** rename `prm` to `protectedResourceMetadata`.
4. **stylist:** spell out the bare `CC` in the new `MINION_PROBE_CC_*` secret names.

The main should-fix items:
- The cleanup DELETE has no timeout. If production stops answering, the job is cancelled and no tracking issue is opened.
- The "durable guest" check writes and reads in the same session, so it doesn't prove durability.
- Failure reasons echo raw header values, which contradicts the "never response text" claim.
- The probe's Actions secret grants the full `mcp/guest` tool set.

**Notes**
- I removed `#` from the pruner's numbered bullets ("Bullets #2…") so the gh wrapper's bare-reference guard would accept the post. That edit also turned "garden#58" into "garden58" in one quoted pruner sentence, a small cosmetic flaw in the posted review.
- To stay under GitHub's character limit, the review omits the 14 approve seats' text and the fast-checker seat's comment-only text.
- No garden code changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1250910 cached reads)
- Output: 7591 tokens
- Cost: $0.9692020000000001
- Wall-clock: 732s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
