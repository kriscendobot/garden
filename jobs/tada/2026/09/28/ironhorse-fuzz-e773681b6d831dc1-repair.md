The crash reproduced at the finding SHA, but it was not an engine bug and needed no code fix. I added two regression tests for it, pushed them to the standing branch, and wrote up the finding on PR #1298.

**What the finding was**
- I recovered the 4-byte input from the journal finding's `input_base64` and its sha256 matched `e920afda…495f`. The durable artifact is on garden2's disk and isn't reachable from this host.
- At `38ca1d18` the fuzz target panicked on `computrons: oracle=37 ironhorse=38`. The generated program reads `.source` from a RegExp built from an alternation of `a{1,3}`, `c{1,3}`, `\s*` and `.*`. Ironhorse finished with a result identical to XS; only the step count differed by one.
- At the tip of `ironhorse-fuzz-findings` the same input exits 0. Earlier commit `de16989204` made fuzz acceptance treat a gap in XS step counts as advisory, while still requiring the two engines to complete and return the same result. This is the same kind of finding as sibling `d5413146a257bc30`.

**What changed** (commit `2a78694570`, pushed to `kriscendobot:ironhorse-fuzz-findings`)
- **`ironhorse-vm/tests/finding_e773681b6d831dc1_regexp_source_meter.rs`**: replays saved XS bytecode and symbols for the exact input without needing the `c/moddable` submodule. It pins the exact `.source` text, not the step count.
- **Fixtures** in `ironhorse-vm/tests/fixtures/finding-e773681b6d831dc1.*`: the input, bytecode, symbols and expected result.
- **`ironhorse-fuzz/tests/finding_e773681b6d831dc1_regexp_source.rs`**: checks the exact input still generates this `RegExp.source` case and passes the current fuzz comparison against XS.
- Both tests pass locally and `cargo fmt --check` is clean.

**PR #1298**
- `ensure-pr.sh` found and reused the standing PR, which is still a draft.
- The comment documenting this finding and its resolution is at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5865690775.
- I didn't start a new gauntlet because one is already running on #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet-fix-3` is in `doin/`). This commit only adds tests, so that run will pick it up.

**Follow-ups**
- `packages/floot/package.json` in the project checkout has an uncommitted edit I didn't make; I left it alone and didn't commit it.
- The inbox read at the start failed because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-e773681b6d831dc1-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 3 host(s) (4 unmetered)
- Input: 46 tokens (1511930 cached reads)
- Output: 10456 tokens
- Cost: $1.0814580000000003 (4 engagement(s) unpriced)
- Wall-clock: 884s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
