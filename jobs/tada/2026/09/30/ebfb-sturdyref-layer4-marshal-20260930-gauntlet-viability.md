I'm clearing PR #1393 to enter the gauntlet. It's still open, nothing has replaced it, and the maintainer asked for exactly this layer earlier today.

**PR facts:** #1393 is "feat(marshal): layer 4 — represent a SturdyRef in each marshal encoding". It is OPEN and still a draft, not merged. Its head is `build/sturdyref-marshal-representation` at `f404dbca`, and its base is `build/sturdyref-pass-style-recognition-fa2edee` at `fa2edee3`, which is the frozen head of layer 3 (#1392). It was opened 2026-09-30T07:08Z and has no reviews or comments yet.

Deciding question: Is PR #1393 still the live, not-yet-landed version of layer 4 ("each marshal layer needs a representation for sturdy refs") in the SturdyRef layering the maintainer asked for, with no newer marshal-layer SturdyRef code on `llm` and no competing PR?

**Answer: yes.**

Evidence:
- **The motivating ask is current.** kriskowal's comment on #695 (issuecomment-5903472512, 2026-09-30T03:28Z) lists the layering, and its item 4 reads "Each marshal layer needs a representation for sturdy refs." This PR was opened about 3.5 hours later to fill that item. The arc is tracked in kriscendobot/garden#47.
- **The stack below it is live and open:** layer 1 shim #774 (with design #1389), layer 2 SES #1391, and layer 3 pass-style #1392 were all updated today. Layer 5 (CapTP) depends on this PR and has not been opened yet.
- **Nothing replaces it.** Searching PRs for "sturdyref marshal" finds no other layer-4 or marshal-encoding PR. The older SturdyRef PRs (#737 pass-style first-class sturdyref, #698 ocapn wire read, and #539/#541/#697/#701/#704 daemon/bridge) come before the new layering. If anything, they are the ones being overtaken, not this PR.
- **The work hasn't already landed.** No commit on `llm` since 2026-09-29 mentions SturdyRef.

One thing to keep in mind for the fix-loop and CI stages: this PR is stacked on #1392, which is not merged. The base branch is a frozen snapshot of #1392's head, so any change to layer 3 will need this PR rebased onto it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164495 cached reads)
- Output: 1738 tokens
- Cost: $0.40741900000000003
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
