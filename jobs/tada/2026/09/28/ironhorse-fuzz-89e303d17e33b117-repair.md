## Finding 89e303d17e33b117 (`differential_regexp_surface`): locked as a regression; the engine needed no fix

The Ironhorse engine port was already correct for this input. The finding was a 1-computron cost difference, not a wrong result. I added regression tests and amended the standing PR, endojs/endo-but-for-bots#1298. The gauntlet was not run this attempt; see Follow-ups.

**Reproduction**
- I recovered the 4-byte input from the durable artifact and its sha256 matched `66308cfa…1226d`.
- **At the finding SHA `38ca1d18`:** it reproduced as a panic, `Divergence { … "computrons: oracle=37 ironhorse=38" }`. The input generates `new RegExp("a*(?: {1,3}|\\s*|.* {1,3})? {1,3}|\\s*|(?: {1,3})? {1,3}|\\s*", "").source`.
- **Results agree:** XS and Ironhorse both completed with the same `source` text, byte for byte.
- **At the standing tip:** `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` exits 0. The current meter-v4 check treats an XS computron gap as advisory and still requires matching completion and result.

**Fix:** none in the engine. I did not change any meter constant, since that would rewrite a pinned release digest. Earlier cost-gap findings such as c9eaa7b5 were handled the same way.

**Regression tests** (commit `c01688e627`, pushed to `ironhorse-fuzz-findings` with a fetch/rebase/push loop):
- `rust/engine/ironhorse-vm/tests/finding_89e303d17e33b117_regexp_source_meter.rs` replays frozen XS bytecode and symbols without needing the submodule. It checks that the program completes and pins the exact result, but not the computron count.
- `rust/engine/ironhorse-fuzz/tests/finding_89e303d17e33b117_regexp_source.rs` checks that the exact input still generates this `RegExp.source` case and agrees with XS.
- Fixtures added under `ironhorse-vm/tests/fixtures/finding-89e303d17e33b117.*`: the input, bytecode, symbols and expected result.
- Both tests pass locally and `cargo fmt --check` is clean.

**PR:** `ensure-pr.sh` found the existing #1298 (still a draft), now at head `c01688e627`. I documented the case and why no fix was needed in [comment 5863953852](https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5863953852).

**Follow-ups**
- **Gauntlet:** I did not run or re-post it. The existing stage, `plan/endojs-endo-but-for-bots-pr1298-gauntlet-panel-2`, is marked doomed and is parked waiting for a go-ahead. Under the manual-gauntlet rules, promoting it or running a fresh gauntlet on #1298 is the maintainer's call.
- **CI:** I did not wait for CI on the new head.
- **Inbox:** the journal clone timed out, so I couldn't read my inbox during the job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `c01688e62725500c95eeeeb9cfeb669821158b13`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-89e303d17e33b117-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (5 unmetered)
- Input: 50 tokens (1530222 cached reads)
- Output: 11564 tokens
- Cost: $1.0707803999999999 (5 engagement(s) unpriced)
- Wall-clock: 1057s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
