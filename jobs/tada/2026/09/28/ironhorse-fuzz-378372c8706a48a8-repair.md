I reproduced finding `378372c8706a48a8`: the fuzzed code was already correct, so no fix was needed. I added the two regression tests to the standing branch and documented the case on the standing PR, endojs/endo-but-for-bots#1298.

**Reproduction**
- I recovered the 4-byte input from the durable artifact; its sha256 matches the expected `9e4628f9…2ebc`.
- **At the fuzzed SHA `38ca1d18`:** it crashes as reported. The only difference is the metered cost, reported as `computrons: oracle=108 ironhorse=109`. The program's result is the same in both engines.
- **At the standing-branch tip:** `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` exits 0.
- **The generated program:** `var m = new RegExp("c?(\\sc?(\\sc?(\\s\\2?[a-c]?){1,2})){1,2}", "").exec("c\nc"); m ? m.index : -1`. The pattern needs three whitespace characters and the subject has one, so it can't match. XS, Ironhorse and Node (V8) all return `-1`.

**Why no fix was made**
Under the current metering rules, a computron gap against XS is only advisory; the program's completion and result must still agree, and here they do. This matches sibling findings `e773681b6d831dc1` and `6ca7a76e0bfe3435`. Changing a meter constant would rewrite a pinned release digest, so I left them alone.

**Regression tests (commit `a00c20a0ad` on `kriscendobot:ironhorse-fuzz-findings`)**
- `rust/engine/ironhorse-vm/tests/finding_378372c8706a48a8_regexp_exec_meter.rs` runs in CI and doesn't need the XS submodule. It replays the XS-compiled program saved as fixtures (input, bytecode, symbols, expected result). It checks the input's sha256, that the program completes, and that the result is `-1`. It deliberately does not pin a computron count.
- `rust/engine/ironhorse-fuzz/tests/finding_378372c8706a48a8_regexp_exec.rs` needs the XS submodule, so it runs locally only. It checks that the exact input still produces this `exec` case and that `differential_check_meter_v4` reports no divergence.
- Both tests pass locally.
- I pushed with a fetch/rebase/push loop; it went through on the first attempt, moving the tip from `b60c602f9d` to `a00c20a0ad`.

**PR**
- `ensure-pr.sh --find-only` found the existing standing PR #1298 (draft, frozen base `llm-387ea66`) and created nothing new. Its head is now `a00c20a0ad`.
- I posted a comment on #1298 describing this finding and how it was handled: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5866298716

**Follow-ups**
- I did not start a gauntlet for #1298. Gauntlets run only when the maintainer asks for one ("run the gauntlet #1298"), as with the earlier findings on this PR.
- The project checkout still has a local change to `packages/floot/package.json` that isn't mine. I didn't commit it.
- I restored the empty `c/moddable` directory, and removed the temporary base-SHA worktree and the scratch build directories.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `a00c20a0ad982a191289dad54b6f136f52a44f9b`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-378372c8706a48a8-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 3 host(s) (8 unmetered)
- Input: 36 tokens (1222210 cached reads)
- Output: 10475 tokens
- Cost: $1.0680779999999999 (8 engagement(s) unpriced)
- Wall-clock: 1293s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
