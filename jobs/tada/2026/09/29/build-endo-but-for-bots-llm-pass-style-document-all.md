## Completion report: build-endo-but-for-bots-llm-pass-style-document-all

I ported the pass-style `document.all` fix from the fork's `master` onto `llm` and opened draft PR **endojs/endo-but-for-bots#1365**. It stays draft.

**The PR**
- **Base and head:** base is the frozen `llm-3aa902d` (the current `llm` tip); head branch is `llm-pass-style-document-all`, one commit, `cdaf8c45c6`.
- **Package affected:** `@endo/pass-style`, with a patch changeset.
- **Files:** `src/passStyle-helpers.js` (`isPrimitive`), `src/passStyleOf.js` (the type check in `passStyleOfInternal`), `test/passStyleOf.test.js`, `test/document-all.html` and `.changeset/pass-style-document-all.md`.
- **Cherry-pick:** `eecc68394` applied cleanly. llm's `byteArray` rework doesn't touch the changed lines.

**Differences from #69**
- I left out the 410 KB `document-all-result.png`, because no test uses it.
- I renamed `isPrimitive`'s parameter from `val` to `value`. The pre-push spell-out-identifiers check fails on the abbreviation on changed lines, and that check can't be skipped.

**Verification**
- `yarn test` in `packages/pass-style`: 76 passed.
- Removing the new `case 'null':` makes `passStyleOf basic success cases` fail in every test configuration, so the test catches that part of the fix.
- Pre-push gates pass. One non-blocking warning about the 3-line comment on `isPrimitive`; I kept it because it explains the `document.all` case.

**Follow-ups (not done)**
- Node can't create a real `document.all`-like value, so no test fails if only the `isPrimitive` change is reverted. V8's `--allow-natives-syntax` `%GetUndetectable()` could supply a real one in a child-process test.
- Three other copies of `isPrimitive` still use the old check: `packages/ses/src/commons.js`, `packages/eventual-send/src/local.js` and `packages/promise-kit/src/memo-race.js`. #69 didn't change them either; the PR body notes them for a separate decision.
- The open PR endojs/endo-but-for-bots#759 reconstructs #69 against the `master-2708cac` base, not `llm`, so it doesn't duplicate this PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-llm-pass-style-document-all.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1395757 cached reads)
- Output: 7236 tokens
- Cost: $1.0040073999999999
- Wall-clock: 1028s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
