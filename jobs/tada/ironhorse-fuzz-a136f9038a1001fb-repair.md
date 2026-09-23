My commit `cd9c3251a` is the head of the standing branch, cleanly rebased over the concurrent peer commit `a2733761a`. The job is complete.

## Completion report

**Finding `a136f9038a1001fb`** (target `differential_regexp_surface`, toolchain `nightly-2026-08-15`, base SHA `38ca1d189`) — repaired and locked.

**What I did**
- Recovered the 5-byte minimized input (`2c 2c 2c d4 88`) from the durable artifact; verified sha256 `d3bc6268…a5835c`.
- Set up the pinned fuzz env (symlinked `c/moddable` to the warm campaign submodule checkout, `nightly-2026-08-15`, cargo-fuzz, local `TMPDIR` around noexec `/tmp`).
- **Reproduced the crash at the fuzzed base `38ca1d189`**: the generator folds the bytes into `new RegExp(<pattern>, "m").source` whose `.source` completion value is **1955 bytes**. The pre-fix XS oracle truncated its reference to a 1023-byte prefix while the port produced the full 1955 bytes → false *result* divergence → panic.
- Diagnosed it as the **oracle result-truncation class** — a distinct minimized input of the same defect as findings `493390fc03979205` / `3ea435c58b4c588e` (those via `.toString()`; this one via the `.source` accessor). At the standing branch the fix already in place (grow `ENDOR_RESULT_MAX` to 16 KiB + honest `result_truncated` skip) makes both engines agree (result identical, computrons `345`==`345`, `result_truncated=false`). Confirmed clean at standing branch, crashing at base.

**What changed** (no engine/port/oracle code — the causal fix already covers this input; these are load-bearing regression locks since `fuzz/corpus`/`fuzz/artifacts` are gitignored):
- `ironhorse-fuzz` test `finding_a136f9038a1001fb_regexp_source_agrees`: replays the exact 5 bytes through the real `differential_check_with_symbols`, asserts no divergence.
- `ironhorse-vm` test `finding_a136f9038a1001fb_regexp_source` + frozen fixtures (bytecode/symbols/expected-result): replays the program with no oracle/submodule, asserts the port renders the whole 1955-byte `.source` untruncated. This is the check CI actually runs.
- Both pass; full `ironhorse-vm`/`ironhorse-fuzz` suites green, no regressions.

**Standing PR** — amended (not duplicated) the one standing PR **#1088** (`endojs/endo-but-for-bots`, head `kriscendobot:ironhorse-fuzz-findings`, base `llm`). Rebased cleanly over a concurrent peer commit (`5c29667cc15d6d93`), keeping both regression tests. Documented this finding as a PR comment (chose a comment over a body edit to avoid a lost-update race with concurrently-amending peers). CI **`test-ironhorse` passed** on the pushed head.

**Follow-ups** — none required. Remaining PR checks (browser-tests, test262, Node-24 cover/macos) are unrelated to this Rust engine change and carry pre-existing repo-wide Node-24 flakiness. The finding's causal class is already fully suppressed upstream; this commit only prevents silent regression of that fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-a136f9038a1001fb-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (8155063 cached reads)
- Output: 47057 tokens
- Cost: $6.6456565
- Wall-clock: 913s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
