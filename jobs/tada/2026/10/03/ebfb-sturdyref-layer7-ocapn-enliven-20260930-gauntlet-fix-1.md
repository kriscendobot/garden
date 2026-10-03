Panel round 1's fixes for PR #1397 are pushed, but CI is not done: `ci-wait-merge` hit its 3500s deadline (rc 4) with 31 of 33 checks passed and 2 still running. Nothing has failed so far. The two unfinished cells are `test (22.x, macos-15)` and `test (24.x, macos-15)`, and all the ubuntu test cells passed. The driver should re-post this stage to wait for them.

**What changed on the PR head** (`build/sturdyref-ocapn-enliven`, now `376a462af4`):

- **Commit subject (integrator, must-fix):** I rewrote the original commit's subject to `fix(ocapn): enliven a returning SturdyRef with a wire-decoded swiss number`, keeping its tree and body. This changed history, so I pushed with `safe-push-pr-head.sh --mode rewrite`, moving the head from `1eb434a3e8` to `376a462af4`. Everything else is one follow-up commit on top, `fix(ocapn): thaw home byte secrets and pin the ASCII boundary`.
- **Source, `packages/ocapn/src/client/sturdyrefs.js`** (breaker, engine-realist, archivist, saboteur):
  - `lookupSwissnum` is now `lookupSecretBytes(locator, secretBytes)`. It runs `thawedBytes` before decoding, and both the bootstrap `fetch` and the home path call it. Before, the home path skipped the thaw, which could mishandle the shim's frozen-bytes wrapper.
  - I added the missing `@returns`.
  - I replaced the thunk with a plain expression.
  - Comments now say that bytes in the ASCII range (0x00–0x7f) reach the locator as a string.
  - A comment now explains why the `try` has to stay around the decode: its error message names the offending byte.
- **Tests, `packages/ocapn/test/sturdyref-enliven.test.js`:**
  - A new test (corner-prober, must-fix) covers byte secrets minted at home that never touch the wire. ASCII bytes reach the locator as the string `'counter'`. The empty secret becomes `''`. `0x7f` still decodes as text, and `0x80` passes through as raw bytes.
  - It now reuses `enliven` from `@endo/sturdyref` instead of a local copy (procurer).
  - It imports `locationToLocationId` from the public `@endo/ocapn/client/util` export (integrator).
  - I added `@returns` on `startClient` and fixed `travelled` → `traveled`.
- **Changeset:** rewrapped to one sentence per line (changeset-auditor), plus a sentence about ASCII-range byte secrets.
- **PR title and body:**
  - The title now matches the new commit subject.
  - The body names the correct frozen base, `…-b0778fa` (the integrator's other must-fix).
  - The stack index moved into the Description, out of its own heading.
  - Per the pruner, I cut the Documentation Considerations section to a single line and removed the test tallies and lint notes.
  - Compatibility Considerations now states one behavior change. A byte secret minted here whose bytes are all ASCII now reaches the locator as a string. A locator keyed only by those bytes therefore misses it at home, as it already did remotely.

**Local verification:**
- **Tests:** the full `@endo/ocapn` ses-ava suite passed (573 tests in each config). The enliven test file has 7 passing tests, including the new one.
- **Types:** `tsc` is clean.
- **Lint:** eslint shows 0 errors and one warning (`safe-await-separator` in `enlivenSturdyRefDetails`), which was there before this change.

**Not done:** I didn't add the fast-checker's suggested property tests, because `@endo/ocapn` has no `fast-check` dev dependency and that seat marked it as a follow-up.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2617762 cached reads)
- Output: 15232 tokens
- Cost: $1.5544724
- Wall-clock: 3714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
