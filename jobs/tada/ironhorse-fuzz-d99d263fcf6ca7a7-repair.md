## Completion report — ironhorse fuzz finding `d99d263fcf6ca7a7` (target `differential_source`)

**Reproduced.** Recovered the 5-byte input `2d 57 27 48 86` (sha256 verified `749f2021…e09a4f9`), set up the pinned fuzz env (nightly-2026-08-15, cargo-fuzz, `c/moddable` symlinked from the warm peer to avoid a multi-GB fetch), and reproduced the crash: a **result divergence** `oracle="57632001481506816"` vs `ironhorse="57632001481506820"` — not a panic.

**Root cause (harness-side, port was correct).** The generated program `((729808896 && …) * ((… * (729808896 % 603979776)) % 729808896))` evaluates in IEEE-754 to `819·2^46` = the exactly-representable double `57632001481506816`. Both engines compute the **identical** double; they differ only in decimal rendering. XS's `fx_dtoa` prints the exact integer (17 digits); ironhorse prints the ECMA-262 §6.1.6.1.20 **shortest** round-tripping decimal `57632001481506820` (16 digits) — matching V8/Node, which I confirmed directly. ironhorse is spec-conformant; XS is the outlier. Same class as the two prior standing findings.

**Fix (minimal, harness-side).** Added a `results_agree` helper in `ironhorse-fuzz` that compares Number completions by their IEEE-754 `f64` (byte-equal or same parsed bits), wired into the result-comparison site of all three differential checks. Different doubles never share a parse, so genuine value divergences are still caught; only differently-spelled renderings of the same double are suppressed. Non-numeric results (booleans/strings/`Infinity`/`NaN`) fall through to byte comparison.

**Regressions.**
- `ironhorse-vm` `finding_d99d263fcf6ca7a7_large_integer_dtoa` — pins `number_to_ecma_string(819·2^46) == "57632001481506820"`; builds without the oracle/submodule and **is the crate CI runs** (`cargo test -p ironhorse-vm`). Passes on stable + nightly.
- `ironhorse-fuzz` — load-bearing replay of the exact 5 bytes through `differential_check` asserting no divergence, plus a `results_agree` boundary test.

**Verified.** Full `ironhorse-fuzz` suite green (36 passed); all `ironhorse-vm` test binaries compile on stable; the `cargo fuzz run differential_source` reproduction now executes the input cleanly (no crash).

**Landed.** Committed `4ae39593b` (excluding the local `c/moddable` symlink), rebased onto the fetched branch tip (CAS), pushed to `kriscendobot:ironhorse-fuzz-findings`. `ensure-pr.sh` adopted the standing PR **#1088** (nothing created; marker present); its head now points at the fix. Documented finding `d99d263fcf6ca7a7` as a new section in the PR body. PR stays draft, per the standing-fuzz-PR convention.

**Follow-ups (minor, non-blocking).** The prior finding `5d122a6fc10babd9` has a commit but no PR-body section (left by its repair job); and `differential_check` (unlike its two siblings) still lacks the `result_truncated` skip guard. Neither is in scope for this finding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-d99d263fcf6ca7a7-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (11014714 cached reads)
- Output: 72045 tokens
- Cost: $8.949202999999997
- Wall-clock: 1372s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
