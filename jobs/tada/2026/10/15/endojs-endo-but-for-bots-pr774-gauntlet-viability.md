Viability verdict for endojs/endo-but-for-bots PR #774: **proceed**.

The PR is still open and still a draft. Its current title is "feat(parcel): add the first-wins Parcel shim and open API", the head is `98a09fa5`, and the base is the frozen `llm-7ff30af`.

Deciding question: Is #774 still the live layer-1 implementation of the SturdyRef/Parcel stack the maintainer asked for, with no newer PR or design that replaces it?

Evidence:
- **The maintainer still wants this work.** kriskowal asked for the bottom-up layered stack on #695, comment 5903472512. Their latest review on design PR #1389 (2026-10-09, changes requested) asks for a revision: "enliven receives the reference and the locator". That steers the design rather than dropping it.
- **The PR has been kept up to date with the current design.** On 2026-10-14 it was reworked in place (heads `cde7fe5556` and then `f198a0fd66`). It renamed `@endo/sturdyref` to `@endo/parcel`, added `new Parcel(location, open)`, `Parcel.open`/`locate`/`isParcel` and `E.open`, and made `@endo/init` install the shim before lockdown. This matches the contract in #1389 (now "design(parcel): layer 1 Parcel shim contract and authority split") and the rename design #1460.
- **Nothing has replaced it.** A search of the repo for "sturdyref" shows sibling PRs only for layers 2 to 8: #1391, #1392, #1393, #1394, #1396, #1397, #1398 and #1399. All were updated around 2026-10-15T00:44–00:49Z and are stacked on this layer. The closed PRs #737 and #541 were older reference drafts. No other PR implements the layer-1 shim.
- **One open item:** the governing designs #1389 and #1460 are still open drafts and not yet approved. The previous gauntlet for this PR (`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet`) stopped as halted after round 2. The reworked head says "normal gauntlet expected", so a fresh run on the Parcel head is warranted. The PR should stay draft until #1389 settles, and the un-draft stage should check that.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no changes or commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr774-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163845 cached reads)
- Output: 1977 tokens
- Cost: $0.431365
- Wall-clock: 53s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
