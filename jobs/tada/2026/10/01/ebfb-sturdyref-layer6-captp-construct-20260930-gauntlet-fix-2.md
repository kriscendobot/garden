## Fix round 2 for endojs/endo-but-for-bots#1396: all six must-fix items applied, CI green

I pushed two follow-up commits to `build/sturdyref-captp-construct` (`b0778fab75` → `c951573936`), using `safe-push-pr-head.sh` in advance mode. `ci-wait-merge.sh --no-merge` returned rc 0: all 33 checks passed.

**Must-fix items (panel review 5374934841):**
1. **Hints check bypass:** both packages now read the hints once, refuse symbol keys and hidden properties, and build the copy only from what was checked. New tests cover a symbol key and a getter that returns a different value the second time it is read.
2. **`designator` name clash:** the `SturdyRefData` field is renamed to `network` in both packages. The tests and the api-surface snapshot are updated to match.
3. **Reserved `'l-0'` target:** CapTP now checks `'l-0'` before `answers`, so a peer can no longer take it over with its own question ID. A new test covers this, and it fails if the old order is restored.
4. **`locate` finds nothing:** it now rejects instead of returning `undefined`, and the error message does not include the secret object ID. The behavior is documented on `locateSturdyRef`, and a test covers it.
5. **Missing JSDoc:** `sturdyRefDataToDetails` and `sturdyRefDetailsToData` now have it.
6. **Changeset:** rewritten with one sentence per line.

**Should-fix items also done:** CapTP error messages no longer include `objectId`. The docs now say the object ID must be an unguessable secret. The slot comment now explains `'l-0'`. I also posted a summary comment on the PR (issuecomment-5925467555).

**Checks run locally:**
- captp `sturdyref.test.js` (12 tests) and ocapn `sturdyref.test.js` plus `api-surface.test.js` (19 tests) all pass.
- eslint reports no errors, and prettier is clean.
- `tsc` passes for captp, for ocapn, and for the whole repo.
- In the full captp run, `gc › test loopback gc` failed once. It passed both times when run alone, and this change doesn't touch it.

**Follow-ups left open:**
- requiring `peerId`
- copying a `Uint8Array` `objectId`
- realm-agnostic `isByteArray`
- the extra tests corner-prober suggested
- trimming the PR body
- README coverage of the new API and fast-check round-trip tests

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3964436 cached reads)
- Output: 24155 tokens
- Cost: $2.1237552
- Wall-clock: 3286s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
