All bars reproduced green at the tip. Work complete.

---

## Stage 6 whole-stage verify — completion report

**Verified tip:** `ed547e721dc3b2561c00f83dda8a9b7c711d4866` (branch `xs2rust-endor`, PR #600, still DRAFT — untouched). Oracle pinned to moddable **8.3.1** (`23b4d6b0a65f`). Every number below measured from a fresh sync, each run captured to a file with `$?` checked directly. My only mutation was the README ledger (doc-only), committed on top as `2208ba8ad`.

### The checklist — every number

**1. Workspace** — `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**, all 26 `test result:` lines `0 failed` (0 failed on every line; grep for `[1-9]* failed` → NONE).

**2. Snapshot bars** (all green in the workspace run, named individually):
- Child 2 round-trip: `atoms_round_trip_in_order`, `empty_container_round_trips`, `arena_graph_round_trips`, `empty_machine_round_trips_byte_equal`, `string_and_symbol_tables_round_trip`, `every_payload_arm_round_trips`, `version_round_trips`, `nan_payload_round_trips_byte_exact_but_not_parteq` — all `ok`.
- Child 3 suspend/resume + meter: `suspend_resume_equals_uninterrupted`, `armed_meter_state_survives_suspend`, `suspend_to_cas_and_resume_round_trips_through_the_store`, `suspend_resume_is_transparent_over_arithmetic_cranks` — all `ok`.
- Child 4 malformed/property-loop: `malformed_{string,u32,heap_free,heap_slot,stack}_count_does_not_over_allocate`, `mutation_corpus_reaches_the_atom_decoders` — all `ok`.
- `#![forbid(unsafe_code)]` at line 1 of every engine crate root — `endor-vm`, `endor-262`, `endor-fuzz`, `endor-regexp`, `endor-compile`, **and `endor-snapshot`**; `endor-oracle` the sole audited FFI exception (explicit `// NOT #![forbid(unsafe_code)]`).

**3. Seam flip holds** (child 1): `Compiler` derives `Default` with `#[default]` on the `Endor` variant, so `Compiler::default() == Compiler::Endor`. All `endor_oracle::` call sites are differential-harness / reference-only paths (`dual_run_with`, `compile_diff.rs`, `corpus_to_262.rs`, tests) — none on the default execution path.

**4. Stage-5 bars HOLD at the tip:**
- Curated `compile-diff` (no arg): **EXIT=0, total=1711 identical=1711 divergent=0 oracle-rejected=0 endor-rejected=0 accept-disagree=0** (SYMB atom byte-identity also MET).
- **Complete 121-run `language/` enumeration** (120 subtrees: 26 top-level whole + 67 `expressions/` + 27 `statements/` subtrees, plus loose `expressions/tco-pos.js` via a temp subtree; built binary invoked directly, no `--`): **121 runs, 0 nonzero exits**, summed **total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0 accept-disagree=0** — matches the s19 anchor at `69ec87becb` **exactly**; every rejection agreed.
- Stage-4 `endor-xst` spot-checks, EXIT=0, all skips named (no panic/crash markers): `built-ins/Object` **182 covered / 0 failed** (of 3127; 2945 named skips), `built-ins/Function` **43 / 0** (of 511; 468 skips), `built-ins/Array` **487 / 0** (of 2625; 2138 skips) — all ≥ the job thresholds (≥182 / ≥43 / ≥487).

**5. README ledger** updated (`rust/engine/README.md`): added `endor-compile` + `endor-snapshot` rows to the crates table and a new `## Stage 6` section documenting the landed snapshot surface (children 1–6) and this verify's measured bars. Committed as its own small commit `2208ba8ad` and pushed to `xs2rust-endor` (PR stays DRAFT). `c/moddable` never staged.

**6. Supervisor-integration child (5)** LANDED as a real integration test, not a probe — `supervisor_suspend_resume_preserves_result_and_meter`, `supervisor_suspend_writes_content_addressed_blob`, `supervisor_suspends_multiple_workers_independently` all pass in the workspace run. No gap map to restate.

### Deviations
**None.** Every bar met. Notably the stage-4 covered-counts (182/43/487) recovered *above* the README's prior fix6-verify 8.3.1 figures (175/40/435) as the tip advanced — an improvement, not a regression. Zero divergence tree-wide, no unsafe outside the audited seam, the stage-5 byte-identity bar holds unmoved.

Follow-up: none required. Stage 6 bars are green at the tip.
