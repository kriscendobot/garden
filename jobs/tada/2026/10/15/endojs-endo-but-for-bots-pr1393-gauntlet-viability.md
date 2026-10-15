**Viability report: endojs/endo-but-for-bots PR #1393** (`feat(marshal): encode Parcel locations inline`)

The gauntlet can begin.

**Deciding question:** Is #1393 still the only live implementation of layer 4 (marshal representation) in the Parcel stack, and does the current Parcel design still need generic marshal to carry a Parcel inline?

**Answer:** Yes.

**Evidence:**
- **State:** The PR is open, unmerged and still a draft. Its head is `build/sturdyref-marshal-representation` and its base is the frozen layer-3 branch `build/parcel-pass-style-recognition-283927a`. The head is 25 commits ahead of that base and 0 behind, touching 19 files.
- **Not superseded:** No other PR implements layer 4.
  - The stack was renamed from SturdyRef to Parcel by design PR #1460 (opened 2026-10-14). This PR was updated to match: its 2026-10-15T00:00Z comment says it now uses inline CapData `{@qclass:'parcel', location}` and Smallcaps `'`+location, with no slot, and transport-owned encode/decode callbacks.
  - Layer 5 (#1394) is based on `build/parcel-marshal-representation-d4f9539`, which is identical to this PR's current head (0 ahead, 0 behind). So the next layer is built on this PR's work and does not replace it.
- **Premise still holds:**
  - `designs/parcel.md` on `design/parcel` (§ Marshal, lines 179–205) still requires a marshal that holds `locate` to represent a Parcel as inline `{"@qclass":"parcel","location":…}` data, with no slot.
  - The default branch `llm` has no Parcel or SturdyRef handling in `packages/marshal/src/encodeToCapData.js`, so nothing upstream has made this work unnecessary.
  - Layers 1 (#1389) and 3 (#1392) are still open drafts, so the stack itself is still active.
- **Note for the clean and panel stages:** The PR description is out of date. It still describes the old SturdyRef design: the `"@qclass":"sturdyRef"` slot kind, the shared slot table, `encodeSturdyRef`, and similar. It needs rewriting to match the Parcel pivot. The last full gauntlet (`ebfb-sturdyref-layer4-marshal-20260930-gauntlet`) stopped at its review budget after 6 rounds, with CI green on the old head `d427cb91b6`. The head has changed since then because of the pivot.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1393-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (266768 cached reads)
- Output: 2618 tokens
- Cost: $0.4480416000000001
- Wall-clock: 96s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
