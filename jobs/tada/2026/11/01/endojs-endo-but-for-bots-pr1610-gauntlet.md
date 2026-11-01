gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1610
# gauntlet endojs-endo-but-for-bots-pr1610-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1610 the only open change fixing the global object's prototype (CORE-4) on `llm`? No. #1609 was opened earlier and covers the same fix, rows and shards, with a stronger version of the name-lookup change. Option: close as superseded.

## Viability report

I checked PR #1610 against the board and found a duplicate: PR #1609 was opened 21 minutes earlier and makes the same fix.

- **PR facts:** #1610 is open, draft and unmerged. Its base is the frozen `llm-9a14ddf` (`9a14ddf660`), and that base is still level with live `llm`. It has no comments and no reviews.
- **What it does:** It links the default global and every Compartment global to `%Object.prototype%`, which fixes architecture-review finding CORE-4 / PROP-7. It also changes the `GET_VARIABLE`/`SET_VARIABLE` name lookup, restamps the boot heap, and moves 18 test262 rows from fail to pass across 10 shards.
- **The duplicate:** #1609 ("fix(ironhorse-vm): the global object inherits from %Object.prototype%", job slice 9 of the same ratchet) is open and draft. It was created at 2026-11-01T10:16:47Z, before #1610 at 10:37:43Z, on the same base. It touches the same 10 whole-tree expectation shards, with the same 18 rows going from fail to pass and the same strict-mode `15.2.3.6-4-625gs.js` row becoming a skip. It makes the same edits in `boot.rs`, `realm.rs` and the name-lookup code.
- **#1609 goes further:** Its `Interp::global_inherits` follows whatever prototype the global actually has, so a replaced or `null` prototype resolves the same way as XS. It also adds three tests that check agreement with XS.
- **Why #1610 missed it:** #1610's description says it confirmed the subtree was unclaimed by citing #1606 and #1608. It never mentions #1609, so that claim check missed a claim already in flight.

Deciding question: Is #1610 the only open change fixing the global object's prototype (CORE-4) on `llm`? No. #1609 was opened earlier and covers the same fix, rows and shards, with a stronger version of the name-lookup change.

Evidence: Both PRs are open drafts on base `llm-9a14ddf` and change the same 10 expectation shards, flipping the same 18 rows from fail to pass. #1609 was created about 21 minutes before #1610, and #1610's description doesn't mention it. The problem itself is still real: `llm` has no commits since base 9a14ddf. But #1609 already fixes it, so landing #1610 too would only add a conflicting duplicate boot-heap restamp.

Option: close as superseded

Follow-up: The ratchet's check for unclaimed work should also look at open PRs on the same arc, not only the sibling slices it already knows about. #1610 shows that check can miss a slice that is already in flight.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1610-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (186318 cached reads)
- Output: 2051 tokens
- Cost: $0.4908356
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
