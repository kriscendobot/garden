All work is complete and validated. Let me write the completion report.

## Completion report — `ironhorse-fuzz-3a6aab9d9d140c2c-repair`

**Finding:** `differential_regexp_surface` finding `3a6aab9d9d140c2c` (8-byte input `11 01 00 00 2c df 6d 6d`), which folds into
`var m = new RegExp("a*(?:a+a*|a+a*|\w+a*)(\n+a{1,3})", "s").exec("aa"); m ? m[0] : null`. The `\n+` tail can't match `"aa"`, so both engines complete with `null` — the only disagreement was the computron count.

**Reproduced & root-caused (against the pre-refactor standing tip):** ironhorse metered **274** vs the XS pin **273**. By instrumenting XS itself (`xsre.c`/`xsMemory.c`) I proved regexp *compile* (13cc, size 892) and *match* (225 steps) were bit-identical on both sides; the gap was a fixed **+72 raw 16.16 units** in `REGEXP_CTOR_FRAME_METERING` — the port used `180296`, whereas XS's true `fx_RegExp`/`fxInitializeRegExp` frame residual is **`180224`** (creation total 226392 = 4 `fxNewSlot`s + parse meter + two `fxNewChunk`s of adjusted size 24/64 + frame). That 72-raw residual is sub-computron and normally invisible, but this program's total straddled a `>>16` boundary (`17_956_792` pin < `274<<16 = 17_956_864` ≤ `17_956_872` port), tipping one computron.

**Key discovery mid-task:** the `ironhorse-fuzz-findings` standing branch had been rebased onto a **large engine refactor** — `interp.rs` split into modules, metering moved into a new **`ironhorse-meter` crate with an append-only, sha256-pinned release ledger**, and the surface differential (`differential_check_meter_v4` → `compare_observations`) now treats an **XS-computron gap as advisory, never a conformance failure** ("release vectors pin IronHorse's own costs"). I verified the fuzz target now runs this exact input **cleanly, no crash**. So this computron-only finding is **obsolete/superseded by design** — a cost-table change to match XS would rewrite a pinned release digest and contradict the refactor. This matches how the identical sibling finding `2cc2ac67ba7e9b9f` was disposed.

**Delivered on standing PR endojs/endo-but-for-bots#1298** (two commits, CAS-pushed to `kriscendobot:ironhorse-fuzz-findings`, rebased over concurrent peer commits):
- `rust/engine/ironhorse-vm/tests/finding_3a6aab9d9d140c2c_regexp_ctor_frame.rs` + frozen input/bytecode/symbols/expected-result fixtures — **CI-visible, submodule-free**; pins completion + byte-identical `null` result (computron count deliberately not pinned, per convention).
- `ironhorse-fuzz` differential lock `finding_3a6aab9d9d140c2c_regexp_ctor_frame_cost_gap_is_advisory` — the exact input checks clean through `differential_check_meter_v4`.
- A PR comment documenting the input, root cause (with the 180224 measurement), and the advisory disposition.

**Validation:** both new tests pass; the CI-path suite (`cargo test -p ironhorse-vm -p ironhorse-snapshot`) is green except one pre-existing, unrelated `math_determinism` `acosh(f64::MAX)` platform-`libm` failure (confirmed failing identically on the pristine pre-work tip). Worktree clean; local HEAD matches the pushed remote tip.

**Follow-up / note for the maintainer:** finding `3a6aab9d9d140c2c` was recorded against a pre-`meter-v4` `llm`; the fuzz service's stale pre-refactor computron-only findings are now advisory by design and warrant no port fix. The genuine XS-parity bug (+72 ctor frame) is documented for the record should XS-parity ever be re-armed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-3a6aab9d9d140c2c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 338 tokens (33900820 cached reads)
- Output: 185455 tokens
- Cost: $24.991229 (2 engagement(s) unpriced)
- Wall-clock: 3614s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
