The round-6 panel on minion.town PR #147 came back **must-fix**, and the verdict is posted as a review on the PR.

**How it ran**
- **Checkout:** I made an isolated checkout of `kriscendobot/minion.town` branch `design/mcp-resources-getting-started` at head `8bed1aa`.
- **Panel:** I ran `panel.sh` in single-round mode with `GARDEN_YARN=npm`, comparing against the PR's base commit `af7af61` (`main-af7af61`). It ran from 17:05 to 17:11Z.
- **Infrastructure:** none of the nine seats errored and the decider's error output is empty. The last line was `design-panel single-round — must-fix`. I launched the panel detached, so I didn't capture its exit code, but every seat finished cleanly and it printed a real disposition. That is why I'm reporting must-fix rather than panel-error.
- **Seat votes:** critic and decomplector requested changes. Skeptic, ergonomist, copyeditor, pedant and novice left comments only. Orthographer and thesaurus approved.

**Review:** https://github.com/kriscendobot/minion.town/pull/147#pullrequestreview-5401813239
- It has the same `## Panel verdict — round 6 … must-fix` header and `<!-- disposition: must-fix -->` marker as rounds 4 and 5.
- It went up as COMMENTED, not request-changes, because GitHub doesn't let the bot request changes on its own PR. Earlier rounds were posted the same way.

**What still needs fixing (for the next fix round)**
1. **critic:** the design's strictest pass bar (§ 6.4) covers tasks T2 and T3 but not the T1 `powers` leak, which is its headline safety concern. Add T1 or explain why it's excluded.
2. **decomplector:** the guide and the app are deployed separately, so a mismatched pair can serve a guide that describes tools the running server doesn't have. Either record a minimum app version and refuse or warn on a mismatch, or state that the mismatch is accepted and bounded.
3. **skeptic:** the "inert `powers`" test only checks which object visitors receive. It should also check that the object has nothing a remote caller can use to change state.
4. **novice:**
   - § 1 uses the MCP terms resources, prompts and instructions before defining them; define them there or point ahead to § 3.1.
   - § 3.2 says the mount rule "mirrors the tool rule" without saying what that rule is.
5. **ergonomist:** `guide/evaluate` is a verb among topic nouns; rename it to a topic noun.

The comment-only findings are in each seat's section of the review. Per the job, I didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 26 tokens (690733 cached reads)
- Output: 4083 tokens
- Cost: $0.6796866
- Wall-clock: 379s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
