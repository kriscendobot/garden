**Viability report: endojs/endo-but-for-bots PR #1397, "fix(ocapn): open returning Parcels through bootstrap and nonce"**

The PR is still needed and nothing newer has replaced it, so the gauntlet may begin. I spent nothing on the clean, panel, fix or CI-wait stages.

- **PR state:** open, draft, not merged. The head branch is `build/sturdyref-ocapn-enliven` at `9fda212b`. The base is the frozen `build/parcel-captp-construct-3202ecd`, which comes from layer 6 (#1396).
- **Deciding question:** After the SturdyRef→Parcel pivot, does the current design still give a layer 7 that opens returning Parcels through the peer bootstrap and the local nonce locator, with #1397 as the PR that implements it, and is that behavior missing from its base?
- **Evidence:**
  - **The design still names this PR.** The rename design (#1460, `designs/parcel.md`, updated 2026-10-14) has a layer map. Its line 300 lists layer 7 as "#1397 … open through bootstrap and nonce location; preserve `ocapn-sturdyref` on the wire." The layer-1 contract (#1389) is still open and is what the stack builds on.
  - **The PR was updated to match.** On 2026-10-15 it was reworked onto Parcel: a new title, a new frozen base, and a diff touching `packages/ocapn/src/client/parcels.js`, `types.js`, the test helper `_util.js`, `test/parcel-open.test.js` and a changeset. The whole stack (#1391–#1399) was reworked the same day.
  - **Nothing replaces it.** Searching the repo for "parcel" PRs finds no other ocapn open implementation. Layer 8 (#1398) is built directly on this PR's current head (its base is `build/parcel-ocapn-open-9fda212`), so it depends on this change.
  - **The behavior isn't in the base yet.** The changes to the ocapn client's `parcels.js` are additions on top of the layer-6 base. There are about 387 changed lines, including the end-to-end open tests.
- **History:** On 2026-10-03 an earlier six-round gauntlet ran on the old SturdyRef version and ended at its review budget (green CI at that time). That review covered code that has since been replaced, so a fresh gauntlet on the Parcel version is justified.

Nothing changed in the garden repo; no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (269922 cached reads)
- Output: 2374 tokens
- Cost: $0.46363240000000006
- Wall-clock: 76s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
