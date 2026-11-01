## Viability report: endojs/endo-but-for-bots#1619

**Result: `viability=proceed`.** This stage spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is open, draft and unmerged. Its base is the frozen `llm-9a14ddf`, and upstream `llm` is still at `9a14ddf`, so nothing has landed on the base since the PR was cut. The head is `09c116c6`. There are no comments or reviews yet.

**Deciding question:** Does anything already on the base, or any viable newer PR, deliver the exec result-key fix, so that `indices-groups-object-undefined.js` no longer needs #1619?

**Evidence:**
- **The need still holds.** On `llm`, `built-ins/RegExp/match-indices/indices-groups-object-undefined.js` still records `fail: groups should be an own property` in both sloppy and strict modes. No base commit touches `regexp.rs` or that shard, because the base has not moved.
- **There is an overlap, but it has not displaced this PR.** #1621 (ratchet slice 16, opened at 15:51Z, two minutes after #1619) contains an almost identical `seed_regexp_result_ids` hunk in `natives/regexp.rs`. It flips the same match-indices row and also bundles an `Await`/`PromiseResolve` change in `suspend.rs`.
- **#1621 is not a viable replacement right now.** Its `test-ironhorse` job fails at `ironhorse-snapshot/tests/async_carry.rs:428`, in `computed_super_carries_a_primitive_receiver_through_collection_and_restore`: the expected value was `number:5:42` and it got `number:5:[object Promise]`. That is a regression from its await change, not from the regexp part. Because the run stopped there, #1621 has also not shown that it gets by without the snapshot golden restamps #1619 carries. Its description says the boot keys mint no slots, while #1619 says the goldens change, and I did not settle which is right.
- **#1619 is the narrower and earlier PR.** It has the regexp fix, the golden restamps, the `streaming-baseline.js` reorder and a dedicated test, and its `test-ironhorse` and `test-ironhorse-macos` jobs pass. Its failing `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` jobs match the known ubuntu-26.04 CI breakage on endo-but-for-bots, not this diff. The gauntlet's own checks should confirm that.

**Follow-up to coordinate:** #1619 and #1621 will conflict on `regexp.rs` and on the match-indices shard. Whichever lands second should drop its duplicate regexp hunk and shard edit; the natural fit is for #1621 to drop its RegExp portion and rebase onto #1619. I did not message #1621's owner. The fixer or panel on either gauntlet should handle this.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1619-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (685229 cached reads)
- Output: 4342 tokens
- Cost: $0.6093497999999999
- Wall-clock: 292s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
