---
orchestration-failed: true
---
orchestration-failed — the clean stage for endojs/endo-but-for-bots PR #1397 ended with CI RED (ci-wait-merge rc=3). I pushed no changes.

**Coverage pass (nothing needed):**
- The change only touches `openParcelDetails` in `packages/ocapn/src/client/parcels.js`, one typedef in `types.js`, and the test helper `_util.js`.
- I read `packages/ocapn/test/parcel-open.test.js` against that diff, and it reaches every branch: string secrets, empty bytes, ASCII-range bytes that become strings, non-ASCII bytes that pass through as raw bytes, and an unknown non-ASCII secret rejecting without revealing it. The CI `cover (22.x, ubuntu-latest)` job passed.
- I did not run coverage locally.
- The change adds code and deletes nothing, so no dead code was orphaned.

**CI on head `9fda212be` — 3 red checks, none caused by this PR's diff:**
1. **`lint` = FAILURE (inherited).** Prettier fails on `packages/pass-style/test/parcel-gated-global.test.js` and `packages/patterns/test/rankCover.test.js`, files this PR doesn't touch. The base `build/parcel-captp-construct-3202ecd` (`3202ecdd9`) fails lint the same way, while `llm` (`7031f33b0`) passes. The problem comes from lower commits in the sturdyref/Parcel stack:
   - `baa3a4b17`, first in #1392 (`build/sturdyref-pass-style-recognition`)
   - `d4f9539f4`, first in #1393 (`build/sturdyref-marshal-representation`)
   
   The fix belongs in those PRs (run `prettier --write` on the two files), and #1394, #1396, #1397, #1398 and #1399 then need a restack. Patching it on this head would only hide it.
2. **`test (22.x, macos-15)` = FAILURE (likely a flake).** `@endo/hosted-agent` › `provider-listener-runtime › controlled PID replacement during procfs reads refuses admission` hit the test timeout. It's unrelated to ocapn, and the same job passed on the base commit.
3. **`test-thixotrope-ironhorse` = CANCELLED.**

**Rerun blocked:** I tried `gh run rerun 38664584915 --failed` and the bot token was refused ("Resource not accessible by personal access token"). Someone with Actions write access will need to rerun the macOS job after the lint fix lands.

**Follow-ups:**
- Fix prettier in #1392 and #1393, restack the stack, then re-run the gauntlet from the clean stage for #1397.
- Rerun macOS 22.x with credentials that have Actions write access.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (702079 cached reads)
- Output: 5681 tokens
- Cost: $0.6766118000000001
- Wall-clock: 307s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
