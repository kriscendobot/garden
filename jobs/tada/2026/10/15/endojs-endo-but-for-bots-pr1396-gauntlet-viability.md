The gate's answer is **proceed**: PR #1396 is not superseded, and the need behind it still holds.

**PR facts:** The PR is open, unmerged and still a draft. It is titled "feat(captp,ocapn): construct and forward Parcels from locations". The head is `3202ecdd9e`, pushed 2026-10-15T01:14Z. The base is the frozen `build/parcel-captp-wire-6d089a6`, whose commit `6d089a6` is the current head of layer 5 (#1394), so the base is not stale.

**Deciding question:** Does the current Parcel design still give PR #1396 a layer-6 job that no newer PR has taken over?

**Evidence:**
- **The current design names this PR.** The canonical Parcel design is `designs/parcel.md`, in design PR #1460, which is open and was updated 2026-10-14. Its layer map assigns layer 6 to #1396: "construct from received location data with the connection's open hook, and remove the private minting-connection serialization restriction."
- **The design gives the reason.** Its § locate says the initial-only `Parcel.locate` "is what lets a trusted forwarder carry a parcel that it did not mint." That is the cross-instance forwarding this PR now tests.
- **The old work was replaced inside this PR.** The original "SturdyRef-from-data" version was overtaken by the Parcel redesign. The PR was then moved onto the new design on 2026-10-15 (comment at 00:14Z: "Pivoted this layer to the updated Parcel design…").
- **The current diff matches the design.** It adds an `@endo/ocapn` test that forwards one instance's Parcel through another instance's codec, plus a changeset (+28/−0 across 2 files).
- **The rest of the stack still builds on it.** Layers 1, 5, 7, 8 and 9 (#1389, #1394, #1397, #1398, #1399) are all open on the Parcel design. Layer 7 (#1397) is based on `build/parcel-captp-construct-3202ecd`, which is this PR's current head.
- **No newer PR overlaps it.** A scan of recent PRs found nothing else doing layer 6.

**For the clean stage:** the PR body is stale. It still describes the old `makeSturdyRefFromData` / `getSturdyRefData` / `l`-locator API, which the pivot removed. It needs rewriting for the Parcel forwarding scope. The earlier panel rounds (1–6) and the two halted gauntlets reviewed that old content, not the current diff.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (331020 cached reads)
- Output: 3239 tokens
- Cost: $0.5089440000000001
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
