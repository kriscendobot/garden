I checked PR #1396. It is still open and not superseded, so the gauntlet can proceed. I ran no clean, panel, fix, CI-wait or un-draft stage.

**PR facts:** The PR is open and unmerged, and still a draft. Its head is `build/sturdyref-captp-construct` at `7a341141ca`. Its base is `build/sturdyref-captp-wire-2d2a656` at `2d2a656b84`, which is the current head of layer 5 (#1394, still open). So the stack is consistent with no base drift. It has no reviews or comments yet; it was opened on 2026-09-30.

**Deciding question:** Is there anything on `llm` or in another open PR that already lets a CapTP or OCapN client construct a SturdyRef from its data (peer id, object id, network designator, connection hints)? Or has the maintainer withdrawn or changed layer 6 of the SturdyRef stack they asked for?
Answer: no.

**Evidence:**
- **The need still holds.** kriskowal's comment on #695 (https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512, 2026-09-30T03:28Z) lists this exact capability as item 6 of a 9-layer SturdyRef plan: "Each CapTP needs to provide a capability to construct a SturdyRef from its data (peer id, object id, network designator, connection hints)". The arc issue kriscendobot/garden#47 is still open, and its latest comments (07:49–08:39Z today) are stack-index updates that list #1396 as layer 6. Nothing reverses or changes the plan.
- **Nothing has displaced it.** Of the PRs with "sturdy" in the title, the only ones about this capability are #1389 and #1391–#1399, and they form this one stack: layers 7, 8 and 9 (#1397, #1398, #1399) are stacked on top of #1396. No competing implementation exists.
- **The base branch does not already have it.** The latest commits touching `packages/captp` on `llm` date from 2026-08-08 or earlier, and none are SturdyRef work. The 15 most recent `llm` commits (through 2026-09-30T07:21Z) are about ironhorse, thixotrope and npm-registry-server. A code search for `makeSturdyRefFromData` in the repo returns nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (160945 cached reads)
- Output: 1750 tokens
- Cost: $0.407421
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
