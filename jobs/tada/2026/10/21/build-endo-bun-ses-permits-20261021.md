---
handed-off: build-endo-bun-ses-permits-20261021-open-pr
deliverable-complete: false
---
# build-endo-bun-ses-permits-20261021: completion report

The investigation and code are done and pushed. The draft PR is **not open yet**: this host's bot token gets a 403 on `createPullRequest` for endojs. I posted successor job `build-endo-bun-ses-permits-20261021-open-pr` (pinned `requires: host=endolin-garden-ece02cb4`) to open it. That job carries the full PR body and will mark it as a successor on #1516.

**Branch:** `endojs/endo-but-for-bots` `bun-ses-permits`, tip `8b11aebbb`. It is stacked on the probe head `2b7550456` (#1516), with base `master-ebc7904`.

## Findings

1. **The second property is `URLSearchParams.prototype.toJSON`.** Both it and `length` are **Bun-only**:
   - Neither is in the WHATWG URL standard or in WebKit's `URLSearchParams.idl`.
   - Both are defined in Bun's own bindings file (`JSURLSearchParams.cpp`), not in JavaScriptCore.
   - In that file, `length` and `size` share one native getter, which returns the receiver's entry count.

2. **Other Bun gaps in SES lockdown.** Once `length` is permitted, lockdown completes. The only fatal gap was that `length` can't be deleted. Lockdown still removes some members cleanly, with warnings only:
   - `Iterator.prototype.{chunks,windows,includes,join}` and `%WrapForValidIteratorPrototype%[@@toStringTag]`. These are JavaScriptCore features; whether Safari ships them was not checked.
   - The `nodejs.util.inspect.custom` symbol on the URL prototypes. Node has these too, and SES removes them the same way.

3. **Security verdict: both properties pass the maintainer's test, so both are permitted.** I verified this under Bun after lockdown.
   - **`length`:**
     - It is a getter with no setter, and it can't be deleted or redefined.
     - It returns a number that only describes the receiver, the same as `size`. Calling it on any other object throws.
     - The getter is frozen. Trying to store state on it from one compartment throws, and another compartment sees nothing.
   - **`toJSON`:**
     - After lockdown it can't be replaced, and the function is frozen. It can't be called with `new`, and calling it on any other object throws.
     - Every call returns a new plain object, and changing that object doesn't affect the receiver or later calls.
     - It reveals nothing that `entries()` doesn't already.
   - Both permits sit in the SES permits table with a comment saying they are Bun-only. A new test in `packages/ses/test/url.test.js` fails on Bun without the permit and passes with it. On Node it passes trivially, because Node lacks both properties.

4. **New pass counts.** The probe started at 19/109 configurations, with 8 of 47 packages passing every configuration. After this PR it is **65/109**, with **27 of 47** packages fully green. A second run limited to those 27 passed 61/61. Two other fixes contributed to the gain:
   - **Launcher bug (biggest single gain, 28 → 57).** The shared AVA configs pass Node's `-C` flag, which Bun rejects, so those configurations never ran. The preload now rewrites it to `--conditions`. The probe's earlier 56/110 count used a different AVA mode that silently skipped this condition, so it wasn't comparable.
   - **AVA crash on JavaScriptCore stack frames.** This hid real failures. It is now patched in the preload, and is a candidate fix to send upstream to AVA.
   - **`@babel/traverse` import (a real Endo portability bug).** Bun resolves the default import differently from Node, which broke every Babel-based module transform. I fixed it in `@endo/module-source` and `@endo/parser-pipeline` using the idiom `evasive-transform` already uses. `ses` failures dropped from 144 to 24 and `compartment-mapper` from 874 to 31; `import-bundle` and `nat` went fully green.

   Remaining failures:
   - **Real bug:** pass-style rejects Error objects carrying JavaScriptCore's own `line`/`column`/`sourceURL` properties, plus Bun's `originalLine`/`originalColumn`. This would hit Safari too. It breaks pass-style, marshal, patterns and ocapn, and is the biggest next win.
   - **Engine differences, mostly in tests:**
     - Tests that check V8's exact error wording: memoize, common, exo, eventual-send, module-source, captp, ses.
     - Typed-array hardening behaves differently on JavaScriptCore: harden, and ses float-arrays.
     - Node-behaviour parity tests: compartment-mapper.
     - Stack line numbers: bundle-source.
   - **Bun quirks:** no global `gc` (promise-kit, captp, ocapn); a `worker_threads` difference (parser-pipeline); domains, HTML comments and V8-only CallSite tests in ses.
   - **Harness:** the `endo` binary isn't on the PATH the launcher uses (cli).
   - **AVA incompatibility:** the ses-ava `not` configuration.
   - **Cause unknown:** two-minute timeouts in stream-node and ocapn (about 12 minutes of the full run), and a `write EPIPE` at daemon startup.

5. **CI recommendation: gate the Bun job.** It is required on an explicit list of the 27 green packages, and the full matrix runs as a non-blocking step. This is implemented in `.github/workflows/ci.yml`. The reasons:
   - The green set held across two runs.
   - Requiring the full matrix would fail every PR for unrelated reasons.
   - Advisory-only would let regressions land unnoticed in packages that already work on Bun.

## Commits

| Commit | Change |
| --- | --- |
| `005d9df8b` | `fix(ses)`: the permits, the test, and a changeset |
| `63a200ebf` | `fix(module-source)`: the Babel import fix, also in `parser-pipeline`, with a changeset |
| `277ed90aa` | `test`: the two preload fixes |
| `8b11aebbb` | `ci`: the gated Bun lane |

## Checks

- Node `yarn test` passes for module-source and parser-pipeline, and the SES URL test passes under both Node and Bun.
- Eslint and prettier are clean on the changed files, and the garden's pre-push checks pass.
- `yarn lint:fix` fails, but that script (`yarn lint:eslint -- --fix`) is already broken on master and is not related to this change.
- The comment-length advisory flagged the new comment in `transform-analyze.js`. I kept it because it explains the non-obvious import difference.

## Follow-ups

- The successor job opens the draft PR and names it so the gauntlet is staged.
- Next fixes, in order of payoff: the pass-style Error-property bug, making tests check error types instead of V8 wording, and sending the AVA stack-frame fix upstream.
- I added today's date to the memory note about this host's token lacking PR write access on endojs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-bun-ses-permits-20261021.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (10367449 cached reads)
- Output: 53948 tokens
- Cost: $4.473409800000003
- Wall-clock: 7094s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
