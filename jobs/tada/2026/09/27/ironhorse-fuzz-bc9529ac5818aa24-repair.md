## Completion report: `ironhorse-fuzz-bc9529ac5818aa24-repair`

**Result:** Ironhorse returns the correct output for this input; the bug is in the XS oracle, and the standing branch already fixes it. I added regression tests and changed no engine code. The standing PR is amended at endojs/endo-but-for-bots#1298 and documented there.

**Reproduction:**
- The input was recovered from the durable artifact, and its sha256 matches `c4b0b8c2…11b12e4` (11 bytes).
- I ran the fuzz service's prebuilt `differential_regexp_surface` binary on it at the finding SHA `38ca1d18`. It panicked on a result divergence.
- The generated program is `new RegExp("(?:(?:(?:\\s+?0*\\s*){1,2}…", "s").toString()`, and its completion value is 1045 bytes long.
- The oracle's value was a 1023-byte prefix of Ironhorse's. At that SHA the XS shim still writes the result into a fixed `char result[1024]` and truncates anything longer. Ironhorse returned the complete `/…/s` string. This is the same problem as earlier findings `493390fc03979205` and `3ea435c58b4c588e`.

**Check on the standing branch `ironhorse-fuzz-findings`:**
- That branch already has the 16 KiB oracle buffer and the `result_truncated` flag.
- I built the full oracle by symlinking `c/moddable` from the fuzz service's checkout.
- `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` **exits 0**.
- The oracle captures all 1045 bytes (`result_truncated=false`).

**What changed** (commit `dea198459b` on `kriscendobot:ironhorse-fuzz-findings`, pushed on the first try after a fetch/rebase onto peer commits):
- **CI-visible test:** `rust/engine/ironhorse-vm/tests/finding_bc9529ac5818aa24_regexp_surface_long_result.rs`, with fixtures `finding-bc9529ac5818aa24.{input.bin,bytecode.bin,symbols.bin,expected-result.txt}`. It needs no submodule. It replays the frozen bytecode and checks that the program completes and returns the full, byte-identical 1045-byte result. It passes.
- **Fuzz-side test:** `ironhorse-fuzz` `finding_bc9529ac5818aa24_regexp_to_string_long_result_agrees`. It checks that the oracle is not truncated (`len > 1023`) and that `differential_check_meter_v4` returns `Ok`. It passes locally; it needs the oracle build, so CI does not run it.
- `c/moddable` was restored to an empty directory. The unrelated `packages/floot/package.json` change already in the worktree was not committed.

**PR:**
- `ensure-pr.sh --find-only` found the existing standing PR #1298 (draft, base `llm-387ea66`); its head is now `dea198459b`.
- I posted a comment documenting this finding and its disposition: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855484150
- A gauntlet for #1298 is already running (`endojs-endo-but-for-bots-pr1298-gauntlet`, fix-1 in progress), so I didn't post a duplicate. Instead I sent an FYI about the new head to the inbox of `endojs-endo-but-for-bots-pr1298-gauntlet-fix-1`.

**Follow-ups:**
- The truncation fix lives on the standing branch but not at the SHA the fuzz service tests (the older `llm` commit `38ca1d18`). Until the service tests a commit that includes the fix, it will keep reporting this problem under new finding ids.
- I added a note on this case to the ironhorse-fuzz oracle-truncation memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-bc9529ac5818aa24-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 38 tokens (1327111 cached reads)
- Output: 11511 tokens
- Cost: $1.0896422000000001 (3 engagement(s) unpriced)
- Wall-clock: 391s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
