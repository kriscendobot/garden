PR #1391 is still viable: it should go into the gauntlet.

**PR facts:** endojs/endo-but-for-bots#1391 is OPEN, a draft and not merged. Title: "feat(ses): derive shared Parcel without location authority". Head branch `build/sturdyref-ses-accommodation` at `0f9d0cdb4e`, base branch `build/parcel-shim-first-wins-98a09fa`.

**Deciding question:** Is #1391 still the current SES layer of the nine-layer Parcel stack, with no newer PR or design taking its place?

**Answer:** Yes.

**Evidence:**
- **It was reworked to the current design yesterday rather than replaced.** On 2026-10-14 two comments were posted: "Parcel pivot" (head `8d2926ca13`) and "Parcel restack" (head `c64abaf40c`). They replaced the old universal-`SturdyRef` approach with `%InitialParcel%`/`%SharedParcel%`, citing design #1389. The current diff matches that design: `tame-parcel-constructor.js`, changes to the `permits`, `intrinsics` and `lockdown` files, the `parcel-*` tests, and the `ses-permit-parcel` changeset.
- **The current designs call for exactly this layer.** The newest design PRs, #1460 (updated 2026-10-15) and #1389, are both open. Both say SES derives `%SharedParcel%` from `%InitialParcel%`, like `%SharedURL%`, and withholds `locate` from child compartments. That is what this PR does.
- **No competing PR exists.** Searching "parcel" and "sturdyref" finds no other SES-layer PR. The older stack PRs that conflicted with this approach (#737, #541) are closed.
- **The rest of the stack is built on it.** Layer 1 (#774) is its base. Layer 3 (#1392, "recognize Parcel as passable") is based on `build/parcel-ses-accommodation-0f9d0cd`, which is #1391's current head. Layers #1393–#1399 were all updated 2026-10-15. The maintainer directive behind the stack (#695 comment 5903472512) is still cited by #1460.
- **History:** three earlier gauntlet runs on this PR ended halted or at the review budget. All of them reviewed the old SturdyRef version, which was based on `ef4662f`. The Parcel version has not been through the panel yet.

**For the gauntlet:** the PR description is out of date. It still describes the old "shim installs `SturdyRef` before lockdown" behavior and a `.changeset/ses-permit-sturdyref.md` file. The current diff and changeset are about Parcel. The panel's PR-body checks will probably flag this, and the first fix round should rewrite the description.

No files were changed and nothing was committed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (236389 cached reads)
- Output: 2216 tokens
- Cost: $0.5512298
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
