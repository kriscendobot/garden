# Finding `c781c9b9de456ab2` repaired: regression tests pushed to #1298

The engine port was already correct for this input, so no engine fix was needed. I added regression tests and pushed them to the standing PR. The one thing not done is the PR's review gauntlet: it's stuck waiting for a maintainer go-ahead, which I can't give.

**The finding**
- I checked the input against the durable copy (sha256 `1daa22f7…a29902`, 14 bytes).
- At `38ca1d18`, the pre-built fuzz binary reproduced the divergence. The input turns into the program `new RegExp("[abc](?:(?:\\S+\\S{2}){1,2}){2}…", "m").flags`.
- The only difference from XS was the cost count (`computrons: oracle=48 ironhorse=49`). Both engines completed and returned the same result, `"m"`.
- At the standing branch tip the check passes, because the current checker (`differential_check_meter_v4`) treats a cost-count gap as advisory. It still requires completion and result to match.
- This is the same kind of finding as sibling `89e303d17e33b117`, so there was no code defect to fix.

**What changed** (commit `a9c276a540` on `kriscendobot:ironhorse-fuzz-findings`, pushed with fetch/rebase/push)
- `rust/engine/ironhorse-vm/tests/finding_c781c9b9de456ab2_regexp_flags_meter.rs` replays the XS bytecode and symbols saved as fixtures. It needs no submodule, asserts that the program completes, and pins the result `"m"`. It deliberately doesn't pin a cost count.
- `rust/engine/ironhorse-fuzz/tests/finding_c781c9b9de456ab2_regexp_flags.rs` checks that the exact input still produces a `.flags` program and that it agrees with XS under the current checker.
- Fixtures under `ironhorse-vm/tests/fixtures/finding-c781c9b9de456ab2.*`: the input, bytecode, symbols and expected result.
- Both tests pass locally. Clippy reports nothing in the new files; the only clippy errors are existing `is_multiple_of` lints elsewhere.

**PR and follow-ups**
- `ensure-pr.sh` found the existing standing PR, endojs/endo-but-for-bots#1298, so no new PR was opened. I documented the finding in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864147738
- CI on the new head `a9c276a5` was still pending when I stopped. I didn't wait for it; the change adds only tests and fixtures.
- **Needs a maintainer go-ahead:** panel round 2 of the PR's gauntlet (`endojs-endo-but-for-bots-pr1298-gauntlet-panel-2`) failed repeatedly, was retired and is now parked on `gate: go-ahead`. Only the maintainer can release it, so the gauntlet hasn't reviewed this commit. I noted this in the PR comment.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `a9c276a540c7fa4b3838802dc92326a698af887c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-c781c9b9de456ab2-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 78 tokens (2702576 cached reads)
- Output: 14382 tokens
- Cost: $1.4449551999999999 (2 engagement(s) unpriced)
- Wall-clock: 692s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×2

<!-- garden-usage-end -->
