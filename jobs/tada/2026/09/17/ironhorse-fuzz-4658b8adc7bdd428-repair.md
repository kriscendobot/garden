All work is landed and verified. Here is my completion report.

---

## Completion report: finding `4658b8adc7bdd428` (`differential_source`)

**Disposition: no port fix needed — dtoa non-shortest-spelling class, already suppressed.** IronHorse is conformant; the divergence was decimal *spelling* only.

**Diagnosis.** The 7-byte minimized input (`7e 69 2d ed 7e ed b4`, sha256 `81ca826d…6945b`, verified) folds through `ironhorse_fuzz::gen_program` into an arithmetic program (reconstructed with a throwaway crate copying the generator verbatim):
```js
((((377487360 - 1056964608) * (true && 377487360)) * ((true && 377487360) && (1509949440 && true))) + (~((true * true) * (~1988100096))))
```
Its value is the exactly-representable double `-256494070539485184` (bits `0xc38c79fffc4c0000`, >2^53). XS's `fx_dtoa` prints the exact integer `-256494070539485184`; IronHorse prints the ECMA-262 §6.1.6.1.20 shortest round-tripping decimal `-256494070539485200` (matching V8/Node). Both parse to the identical f64. Same class as `d99d263fcf6ca7a7` / `7277b0fc4a72d8d6` / `7152c1a9960a0688`, already suppressed harness-side by `results_agree`'s numeric (f64) comparison.

**Verification (real execution).**
- Built the full oracle stack (symlinked `c/moddable` pin `23b4d6b0` from `.garden-state`, `CARGO_TARGET_DIR` under the worktree). `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` → **exits 0** on the standing branch.
- New CI-visible `ironhorse-vm` test: **1 passed** (`cargo test -p ironhorse-vm --test finding_4658b8adc7bdd428_large_integer_dtoa`).
- New fuzz-side `_agrees` lock: **1 passed** (`cargo test -p ironhorse-fuzz --lib finding_4658b8adc7bdd428`).

**Changes (commit `4e6a52e5` on `ironhorse-fuzz-findings`, amends PR #1298, base frozen `llm-387ea66`):**
- `rust/engine/ironhorse-vm/tests/finding_4658b8adc7bdd428_large_integer_dtoa.rs` — submodule-free, CI-visible; pins `number_to_ecma_string` to the shortest form.
- `rust/engine/ironhorse-fuzz/src/lib.rs` — `finding_4658b8adc7bdd428_large_integer_dtoa_agrees` oracle-linked lock.
- No engine/meter constant changed.

Fetch/rebase/CAS pushed clean (attempt 1); documenting comment posted (`#1298#issuecomment-5706992089`). Restored the `c/moddable` gitlink; did **not** commit the warm-cache `packages/floot/package.json` artifact.

**Follow-ups.** Did not stage a gauntlet (maintainer-triggered under the manual-gauntlet regime, matching sibling findings). The journal `ironhorse-fuzz/standing.md` generation-2 inconsistency noted in prior findings persists (live PR/branch is gen-1 `ironhorse-fuzz-findings`/#1298) — unchanged by this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-4658b8adc7bdd428-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (4 unmetered)
- Input: 116 tokens (5085404 cached reads)
- Output: 35021 tokens
- Cost: $4.580330000000002 (4 engagement(s) unpriced)
- Wall-clock: 932s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
