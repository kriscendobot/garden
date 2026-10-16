**Viability report: endojs/endo-but-for-bots PR #1477**

PR #1477, "feat(ocapn): key .np location IDs on network and designator", is open, a draft and unmerged. It was opened at 2026-10-16T18:49:32Z with head `7f52fa6ee9` on frozen base `llm-61cd656`. It is the M4 build increment of `designs/ocapn-network-transport-separation.md` (Migration Plan step 4). It has no comments or reviews yet.

Deciding question: Does current `llm` still lack a hint-independent `(network, designator)` location ID for `.np` peers, while the design that calls for one is still active and not displaced?

Answer: yes.

Evidence:
- **The design is still active.** On current `llm`, `designs/ocapn-network-transport-separation.md` has status "In Progress". It still says the `.np` session-routing identity is `(network, designator)`, and step 4 still calls for changing the `.np` session key so that publishing hints never splits a session.
- **The change is not on the base yet.** On `llm`, `packages/ocapn/src/client/util.js` has no `locationNetworkId`, and `locationToLocationId` is unchanged. The last commit to touch that file was #475 on 2026-08-30. `llm` is 0 commits ahead of the frozen base `61cd656`, so nothing newer has landed.
- **Nothing replaces it.** A PR search turned up no other open or merged PR doing this. Related OCapN PRs either cover other topics (#1396 and #1393 on Parcels, #1388 on Cloudflare RPC) or are the merged designs this PR builds on (#886 multi-transport listeners, #1071 one hint per transport).

No clean, panel, fix or CI budget was spent, and nothing was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (154098 cached reads)
- Output: 1502 tokens
- Cost: $0.3589796
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
