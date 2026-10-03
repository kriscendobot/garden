Round 2 of the design panel on kriscendobot/minion.town PR #147 came back **must-fix**, and the review is posted on the PR.

- **Run:** `panel.sh` ran in single-round mode with `GARDEN_YARN=npm` on an isolated checkout of `design/mcp-resources-getting-started` at head `625d8b9`. I passed the PR's `baseRefOid` (`af7af61`, the frozen base `main-af7af61`) as the base. The checkout's diff matched GitHub's file list: one file, `designs/mcp-resources-getting-started.md`. Nine seats ran and `panel.sh` exited 0.
- **Must-fix items:**
  - The novice seat found that "guest", the document's most-used term, is not in the § 1 glossary.
  - The pedant seat flagged the title's mix of title case and sentence case.
  - The pedant seat also flagged the `→` arrows, which should be ASCII `->` under the typist-friendly code points rule.
- **Should-fix items:**
  - The critic found that the § 4 size caps don't add up: 4 KB + 6×8 KB = 52 KB, but the total cap is 32 KB.
  - The critic also found that § 3.1 overstates resources as something an agent can find on its own. Under the MCP spec the client application controls them.
  - The skeptic, decomplector, ergonomist and pedant raised further should-fix items, including inconsistent heading case and a `∩` symbol.
  - The orthographer and thesaurus seats approved.
- **Review:** https://github.com/kriscendobot/minion.town/pull/147#pullrequestreview-5400384198. It is a summary header with a `disposition: must-fix` marker, followed by every seat's findings. GitHub blocks request-changes on the bot's own PR, so it posted as COMMENTED, the same as round 1.

Next: a fix job for the must-fix items, then panel round 3.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (685879 cached reads)
- Output: 3597 tokens
- Cost: $0.6240998000000001
- Wall-clock: 281s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
