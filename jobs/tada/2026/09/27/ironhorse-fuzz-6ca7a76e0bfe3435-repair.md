## Completion report: `ironhorse-fuzz-6ca7a76e0bfe3435-repair`

**Result:** The engine port has no bug here, so nothing in the port changed. Finding `6ca7a76e0bfe3435` is a difference in computron counts only, which the meter-v4 harness treats as advisory. I added two regression tests to the standing PR endojs/endo-but-for-bots#1298, explained the finding in a comment there, and did not stage a gauntlet.

**Reproduction**
- I copied the input file from the leader-host artifact path. Its sha256 matches `9123812342a6…a55b` (6 bytes).
- At the fuzzed SHA `38ca1d18` (using the service's prebuilt binary) it panics: `regexp-surface differential divergence … computrons: oracle=179 ironhorse=180`.
- The generated program is `var m = new RegExp("(?:\\b.{1,3}(?:…\\B\\s*?\\B…)|\\B\\s*?\\B", "m").exec("b"); m ? m.length : 0`.
- XS and Ironhorse both return `"0"`, and Node gives the same answer. That is correct: every alternative needs `\B` at a position that is a word boundary.
- On the standing branch `ironhorse-fuzz-findings`, with the full XS oracle built (`c/moddable` symlinked from `.garden-state/ironhorse-fuzz/project`), `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` **exits 0**.

**Why there is no fix:** Under meter-v4, `differential_check_meter_v4` counts a computron gap against XS as advisory, not a failure. This is the same class as sibling findings `1cb63ec6f8e6fc22`, `c6c71d428a37088c` and `1cd4ddc72d5801c4`. Changing a meter constant to match XS would rewrite a sha256-pinned release digest, so I left them alone.

**Changes** (commit `c38242a058`, pushed to `kriscendobot:ironhorse-fuzz-findings` on the first attempt; the tip moved from `1219e436fe` to `c38242a058`):
- `rust/engine/ironhorse-vm/tests/finding_6ca7a76e0bfe3435_regexp_surface_meter.rs` plus fixtures `finding-6ca7a76e0bfe3435.{input.bin,bytecode.bin,symbols.bin,expected-result.txt}`.
  - It doesn't need the `c/moddable` submodule, so CI can run it. It replays the exact bytes as frozen bytecode and symbols, then checks that the program completes and the result is byte-for-byte the same.
  - It deliberately does not check the computron count. The test passes.
- `ironhorse-fuzz/src/lib.rs`: a new test, `finding_6ca7a76e0bfe3435_regexp_exec_cost_gap_is_advisory`. It runs the exact input through the XS oracle and Ironhorse and requires they agree. It passes locally, but CI excludes crates that need the oracle, so it only runs on a machine with the submodule.

**PR:** `ensure-pr.sh --find-only` found the existing draft #1298 (base frozen at `llm-387ea66`), and its head is now `c38242a058`. The explanation is in comment https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854966667.

**Notes and follow-ups**
- **Gauntlet:** I didn't stage one. Under the manual-gauntlet regime a gauntlet only runs when the maintainer triggers it, which is also what earlier finding repairs on #1298 did.
- **Inbox:** My inbox couldn't be read because the journal clone timed out, so I may have missed a message.
- **Stray change:** The warm worktree has an uncommitted change to `packages/floot/package.json`. It isn't mine and was never committed.
- **Cleanup:** I restored `c/moddable` to an empty directory and deleted my scratch build directories. I also added this finding to the fuzz-class memory note.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-6ca7a76e0bfe3435-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (4 unmetered)
- Input: 44 tokens (1538403 cached reads)
- Output: 12879 tokens
- Cost: $1.1684686 (4 engagement(s) unpriced)
- Wall-clock: 1016s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
