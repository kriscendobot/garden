Completion report:

## Job `ironhorse-fuzz-7289e31013d074ec-repair` — complete

**Finding.** `differential_source` target, 4-byte input `d8 7f 33 ba` (sha256 `6abb2f…c736f`), which the structure-aware generator folds into:
```js
((~(~(1560281088 * true))) * ((~(1560281088 * true)) << ((~true) << (true << true))))
```
`1560281088 = 186·2^23`. In ToInt32 arithmetic the product is `1560281088 * -16777216 = -(93·2^48) = -26177172834091008`, an exactly-representable double whose magnitude overflows 2^53.

**Diagnosis — a known class, already fixed.** Built the pinned fuzz env (moddable `23b4d6b` submodule symlinked from the warm peer, `nightly-2026-08-15`, cargo-fuzz) and reproduced against the XS oracle. The divergence is a **dtoa spelling** difference, not a port bug:
| engine | completion string |
|---|---|
| XS `fx_dtoa` | `-26177172834091008` (17-digit exact integer) |
| ironhorse | `-26177172834091010` (shortest round-trip, byte-identical to Node/V8) |

Both parse to the identical IEEE-754 double; ironhorse is the spec-conformant one (ECMA-262 §6.1.6.1.20). Verified locally: `byte-equal=false`, `results_agree=true`. Same class as `d99d263fcf6ca7a7` / `5c29667cc15d6d93` — the branch's `results_agree` (by-value Number comparison, landed for d99d263) already suppresses it, which is why it does **not** crash at branch head. The crash at the fuzzed base `38ca1d189` (byte comparison, which lacks `results_agree`) was genuine. **No port or harness change needed.**

**What changed (regression-only, mirroring the established pattern):**
- `rust/engine/ironhorse-vm/tests/finding_7289e31013d074ec_large_integer_dtoa.rs` — CI-visible, submodule-free: reconstructs the value in ToInt32 arithmetic and pins `number_to_ecma_string(-(93·2^48)) == "-26177172834091010"`, so the port can never be "corrected" to XS's non-conformant exact-integer spelling.
- `rust/engine/ironhorse-fuzz/src/lib.rs` — `finding_7289e31013d074ec_large_integer_dtoa_agrees`: replays the exact bytes through `gen_program` + `differential_check` and asserts no divergence (oracle-verified).

**Verification.** `cargo test -p ironhorse-vm -p ironhorse-snapshot` (the CI set): 68 + snapshot green. Full `ironhorse-fuzz` suite: 40 green. Committed with explicit pathspecs (the moddable symlink was excluded), pushed to `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase CAS (`cd9c3251a..098f7ab01`).

**Standing PR.** Adopted #1088 (marker verified present, head/base correct) via ensure-pr; documented finding `7289e31013d074ec` as a PR comment. CI `test-ironhorse` = **SUCCESS**. PR remains draft (its intended standing-ledger state; prior amends kept it draft).

**Follow-ups:** none. This finding is a duplicate class fully covered by the existing `results_agree` fix; the two tests lock its reproducing value's rendering permanently.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-7289e31013d074ec-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 123 tokens (5085956 cached reads)
- Output: 38284 tokens
- Cost: $4.4959349999999985
- Wall-clock: 776s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
