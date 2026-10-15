**Gauntlet viability for endojs/endo-but-for-bots PR #1394: proceed.** The PR has not been superseded, and the need behind it still holds.

PR #1394 is open, unmerged and not a draft. Title: "feat(captp,ocapn): carry Parcel inline and preserve the OCapN wire tag". Head is `6d089a6`. Base is `build/parcel-marshal-representation-d4f9539`, which is layer 4 (#1393) frozen at its current head `d4f9539`.

Deciding question: Is #1394 still the live layer 5 (CapTP and OCapN wire) of the current Parcel stack, still sitting on its predecessor's current head, with the work not yet on `llm` by another route?

Evidence:
- **Recently updated:** On 2026-10-15 at 00:13Z the author pivoted the PR from SturdyRef to Parcel, following the updated Parcel design (#1389, with the rename in #1460). The title and diff now carry Parcel. The PR body still describes the older SturdyRef version.
- **Stack is in step:** Its base matches #1393's current head. The next layer, #1396 (base `build/parcel-captp-wire-6d089a6`), is frozen on this PR's current head. Every layer was updated in the last few hours: #774, #1391–#1393 and #1396–#1399 are all open.
- **Not on `llm` yet:** `llm` has no `parcel` or `sturdyref` package, and a code search for Parcel under `packages/captp` returns nothing. No other implementation of this layer has displaced it.
- **History:** Earlier gauntlets ran on the old SturdyRef head `7516782` and halted for pipeline reasons (a doom-parked panel, and an undraft stage that handed off), not because of what the code does. The new Parcel head `6d089a6` has not been reviewed yet, so a fresh gauntlet is warranted.

Nothing changed in the garden repository; this check only read GitHub.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162205 cached reads)
- Output: 1885 tokens
- Cost: $0.40622100000000005
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
