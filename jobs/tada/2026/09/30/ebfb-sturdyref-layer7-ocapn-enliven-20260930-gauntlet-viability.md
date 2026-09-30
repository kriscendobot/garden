**Viability verdict for endojs/endo-but-for-bots#1397 (SturdyRef layer 7: enliven through the bootstrap and nonce locator): proceed.**

- **PR state:** open, draft, not merged. Opened 2026-09-30T07:59Z. The head is `build/sturdyref-ocapn-enliven` @ `f2121918`. The base is the frozen layer-6 head `build/sturdyref-captp-construct-ef45f1d`. There are no reviews or comments yet.

Deciding question: Does `llm` (or any other open or merged PR) already make the home-path SturdyRef enliven use the same ASCII-decode-with-byte-fallback lookup as the bootstrap `fetch`, which would make this layer-7 fix and its two-party enliven tests redundant?

Answer: no.

Evidence:
- **The defect is still on `llm`.** On current `llm`, `enlivenSturdyRef` in `packages/ocapn/src/client/sturdyrefs.js` still calls `locator.get(secret)` with the raw secret on the home path. There is no shared `lookupSwissnum`. This is the "a ref that returned home misses a string-keyed locator" bug that the PR fixes.
- **Nothing newer has touched that file.** Its last commit on `llm` is 3acee4a566 (2026-08-30, #475). None of the 47 commits `llm` has gained since the stack forked changed it. The branch is 15 ahead and 47 behind `llm`.
- **No other PR does this work.** A search of SturdyRef PRs turns up the layered stack and older design and daemon work (#539, #541, #697, #703, #704, #737). None of them implements OCapN bootstrap/nonce-locator enliven or this fix. The older pass-style attempt (#521) is closed.
- **The motivation still holds.** The stack exists because of the layering request on #695 (arc kriscendobot/garden#47). #695 is still open. The layers below this one are all open, in order: #774, #1391, #1392, #1393, #1394, #1396. The on-demand-enlivenment design #539 is also open.

This only decides whether the gauntlet may start. No clean, panel, fix, CI-wait or un-draft budget was spent. This PR can only merge after layer 6 (#1396) and the layers below it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172322 cached reads)
- Output: 1807 tokens
- Cost: $0.43335640000000003
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
