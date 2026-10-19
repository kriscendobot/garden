**PR #1507 viability check: proceed.** The PR is open, unmerged and still a draft. It was opened 2026-10-19 by the build job `build-ocapn-network-transport-separation-next-phase`, and nothing newer has replaced it.

Deciding question: Does `llm` still lack the split between registering a transport and listening on it, with no other PR or commit having delivered it, while the merged design still calls for that split?

Answer: Yes.

Evidence:
- **Base is current.** The PR's frozen base is `llm-92b91a7`, and `compare 92b91a7...llm` shows `llm` is 0 commits ahead. So no newer base history could have overtaken it.
- **`llm` still has the old behavior.** In `packages/ocapn-noise/src/network.js` on `llm`, `addTransport` still calls `transport.listen(stream => handleIncoming(stream))` as soon as a transport is added (around line 1305). There is no separate `network.listen(transport, options)`. The last change to that file on `llm` was 2026-10-01 and was unrelated settlement/shutdown fixes.
- **The design still wants it.** `designs/ocapn-network-transport-separation.md` on `llm` is marked "In Progress". Its migration step 3 is exactly this change: `listen(handler)` becomes `listen(options, accept)` and `addTransport` becomes registration only.
- **No competing PR.** A title search (open and closed PRs) turns up only #1507. The related open PRs are complementary: #1477 is about `.np` identity in `@endo/ocapn`, #1430 is the identity-exchange design and #1475 is a crypto review. The PR body says it is independent of #1477. Its motivating design PR, #886, is merged (closed) and its design file is on `llm`.
- **Nothing to override the evidence.** The PR has no comments or reviews yet.

No changes made; I spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1507-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178425 cached reads)
- Output: 1472 tokens
- Cost: $0.42618100000000003
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
