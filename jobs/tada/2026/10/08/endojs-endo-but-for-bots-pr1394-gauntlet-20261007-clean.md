Clean stage report for endojs/endo-but-for-bots PR #1394 (`build/sturdyref-captp-wire`, head `751678257`).

**Result:** no-op. The PR already passes the stage's idempotence check, so I pushed nothing.

- **Coverage:** the PR already has a coverage commit, `1362a1cb9 test(captp,ocapn): cover SturdyRef wire refusal paths`. Later fix commits added more tests in `packages/captp/test/sturdyref.test.js` and `packages/ocapn/test/sturdyref.test.js`. The `cover` CI jobs passed on both 22.x and 24.x at the current head. I did not run a local coverage pass.
- **Dead code:** none. I checked the new and changed functions in `packages/ocapn/src/client/sturdyrefs.js` and `packages/captp/src/captp.js` in an isolated checkout. Every one is still called or exported: `enlivenUnbound`, `makeBoundSturdyRef`, `makeSturdyRef`, `enlivenSturdyRefDetails`, `enlivenSturdyRef`, `makeSturdyRefTracker` and `makeSturdyRefForSlot`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (33 checks, 0 failed, CI GREEN). The PR is open and not a draft.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (277376 cached reads)
- Output: 2075 tokens
- Cost: $0.4528952
- Wall-clock: 57s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
