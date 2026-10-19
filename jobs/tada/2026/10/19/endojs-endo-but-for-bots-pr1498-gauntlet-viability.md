**PR #1498 viability: proceed**

PR #1498 is still open, still a draft and not merged. It was opened at 2026-10-19T04:40Z by the build job `endo-daemon-locator-terminology-build`. The head is `build/daemon-locator-terminology` at `eb07f18`, and the base is the frozen branch `llm-ca5aaef`, which is level with the current `llm` tip (0 commits ahead).

**Deciding question:** Does `llm` still lack the remaining work of `designs/daemon-locator-terminology.md`, with no other landed or in-flight PR doing it instead?

**Answer:** Yes. The design is unfinished on `llm`, nothing has replaced this PR, and the reason it was opened still holds.

**Evidence:**
- On `llm`, `designs/daemon-locator-terminology.md` still says **Status: In Progress** and still has its old "Current State" section. The last change to it was `5bd2f09d69` (2026-06-25). This PR is the one that marks it Complete.
- `packages/daemon/src/locator.js` on `llm` still has the old error strings (`Invalid node identifier.`, `Missing formula number.`, `Invalid id.`), which this PR renames to `Invalid peer key.`, `Missing formula address.` and `Invalid formula address.`. The base has no change that already does this.
- The only related merged PR, #567 ("align locator hint terminology", June), covered the hint format. This PR builds on that and says so in its description; #567 does not replace it.
- The open design #1484 ("HTTPS fragment locators replacing endo://") is not merged and has no review decision. It could later change the `endo://` scheme, but it does not touch the terms this PR introduces (peer key, formula address, formula key, connection hint). An unlanded proposal does not overtake this PR.
- The other open locator PRs (#1404, #1410, #1124, #1360, #1013) cover different topics: guest identifier removal, the nonce locator, capability URLs and relative routing. None of them implements this design.
- The PR has no reviews or comments yet, so nothing in the discussion points to supersession.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1498-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156618 cached reads)
- Output: 1736 tokens
- Cost: $0.37470760000000003
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
