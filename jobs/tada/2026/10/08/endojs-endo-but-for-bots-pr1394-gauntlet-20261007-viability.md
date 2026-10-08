**Viability gate for endojs/endo-but-for-bots PR #1394: proceed**

I spent no budget on clean, panel, fix, CI-wait or un-draft.

**PR facts:** The PR is open, not merged, and not a draft (an earlier gauntlet already un-drafted it). The title is "feat(captp,ocapn): layer 5 — CapTP mints SturdyRefs and carries them over the wire". The head is `7516782577`, on the frozen base `build/sturdyref-marshal-representation-36c4f40` (base commit `36c4f40bcd`). It is layer 5 of the 9-layer SturdyRef stack under arc kriscendobot/garden#47.

**Deciding question:** Does `llm`, or any newer PR, already provide the realm SturdyRef that CapTP mints and carries over the wire, together with OCapN's subsumption of its tagged `ocapn-sturdyref`? And has the maintainer dropped the layered SturdyRef plan that motivates this PR? **Answer: no to both.**

**Evidence:**
- **Not on `llm`.** As of `llm` tip `7d2eb307a2` (2026-10-07), `packages/ocapn/src/client/sturdyrefs.js` still mints `makeTagged('ocapn-sturdyref', undefined)` and types `SturdyRef` as `CopyTagged<'ocapn-sturdyref', undefined>`. There is no `packages/sturdyref` on `llm`. No commits have touched `packages/captp/src/captp.js` or `packages/ocapn/src` on `llm` since 2026-09-25. Nothing newer has displaced this PR.
- **The stack below and above it is intact.** Layers #774, #1391, #1392 and #1393 are all open drafts, and so are the layer 6–9 successors #1396, #1397, #1398 and #1399. No competing newer SturdyRef implementation exists. The older bridge-cut PRs #698 and #700 are earlier prior art that this PR mined, not successors.
- **The premise still holds.** kriskowal's 2026-09-30 comment on #695 asked for exactly this layering (shim, then SES, pass-style, marshal, CapTP and so on). Arc kriscendobot/garden#47 is still OPEN. No later maintainer comment walks the plan back.
- **Prior gauntlet history:** the latest panels passed (round 3 at `7516782577`, and round 2 of the other gauntlet on 10-05), and CI was green at that head. Both earlier gauntlets halted on machinery faults, not on any problem with the PR: a panel stage was doom-parked as `requeue-exhausted`, and the un-draft stage returned an unexpected `handed-off`.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (233725 cached reads)
- Output: 2515 tokens
- Cost: $0.48747700000000005
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
