PR #1393 (endojs/endo-but-for-bots) now has fixes for all four must-fix items from round 5, and CI is green at head `4445fbf937`. I pushed nothing in this run: an earlier claimant of this job had already pushed the fixes (`320edbbd8e` and `4445fbf937`, 12:14Z). It also posted the round-5 fix summary comment (issue comment 5969059528) and trimmed the PR description. I checked that diff against the panel review and it matches each finding:

- **typist:** `dot-membrane.js` no longer types the captured powers as `{ SturdyRef: any, enliven: Function }`. A new `SturdyRefPowers` typedef gives them real signatures: a constructor that returns a `SturdyRef`, and `enliven: (sturdyRef) => Promise<unknown>`.
- **prover:** the test "passes a synchronous enliven throw across" is removed, because it passed with or without the fix. No replacement test was added: the shim makes `globalThis.SturdyRef` non-writable and freezes its statics, so a test can't reassign them to show the capture-once behavior. The code comment explaining the `E.when` wrapping was updated.
- **corner-prober:** the smallcaps sturdyRef decoder now also requires the index to be a safe integer. Above `Number.MAX_SAFE_INTEGER`, two different digit strings decode to the same slot, so they are now rejected.
- **pruner:** the PR description no longer has the commit-SHA/build-cycle aside or the lint-status recital.

`ci-wait-merge.sh --no-merge` returned rc 0: all 33 checks passed, none failed.

Follow-ups deferred as should-fix (listed in the summary comment):
- tests for the new `sturdyRef` render branches in `spaces-util` (that package has no test directory yet);
- the fast-checker seat's property-test suggestions;
- the comment-only notes on `marshal-justin` not rejecting an `iface`, and on the wording of the TODO in `marshal.js`.

The driver posts panel-6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 56 tokens (1691825 cached reads)
- Output: 10630 tokens
- Cost: $1.500925
- Wall-clock: 1344s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
