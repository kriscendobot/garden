All bars green and pushed. Job complete.

---

## Completion report: xs2rust-endor-stage5-fix5 4/5 — regexp validation parity + module-goal fold audit

**Resumed job** — this was a reaped/overrun invocation. **Slice 1 (regexp literal validation) was already landed and clean** by the prior invocation (commits `5b1f4c556`/`2189fcb96`); I verified it and did the outstanding work: **slice 2 (module-goal fold audit)**.

### Slice 1 — regexp literal validation (verified, no new work)
`language/literals` whole top-level dir: **total=430 divergent=0 endor-rejected=0 accept-disagree=0 — BAR MET.** Bar already satisfied on the remote tip.

### Slice 2 — module-goal audit (fixed, not folded)
Key finding: the differential harness (`compile_diff_files → compile_one`) compiles **every file as the script goal for both engines**, so the residual `flags: [module]` accept-disagreements were **real script-goal frontend gaps, not oracle-shim seam artifacts**. State had already shifted since the spec snapshot — all the previously-listed ENDOR-REJECTED cases and `expressions/new.target` were already clean (endor-rejected=0). The two remaining disagreements were both category (b) real gaps → **fixed**:

1. **`import.meta` early error in script goal** (`endor-compile/src/parser.rs`, `import_literal`) — mirrored XS's `mxProgramFlag` gate in `fxLiteralExpression`: reject `import.meta` when `flags::PROGRAM` is set (seeded by `parse_program`, preserved across nested functions via `PARSER_FLAGS`, never set by `parse_module`).
   - `expressions/import.meta`: accept-disagree **5 → 0** (BAR MET)
   - `expressions/dynamic-import` (`import(import.meta)`): accept-disagree **1 → 0** (BAR MET)

2. **`ContainsDuplicateLabels`** (`endor-compile/src/coder.rs`, `code_label`) — mirrored both of `fxLabelNodeCode`'s duplicate checks: the folded direct-chain check (`L: L: 0;`) and the enclosing break-target-stack walk (`L: { L: 0; }`).
   - `module-code`: accept-disagree **1 → 0** (BAR MET, `early-dup-lables.js`)

`new.target` position gating needed no change (already parity).

### Fixtures & ledger
- Added 3 locked fixtures to `endor-compile/tests/coder_byte_identity.rs`: `import_meta_in_script_goal_rejects`, `duplicate_labels_reject`, `distinct_nested_labels_accept` (the last guards that distinct-label nestings and the loop-absorbed-label case stay accepted/byte-identical — verified one candidate that XS accepts and adjusted the fixture to match the oracle).
- Updated `rust/engine/README.md` residual ledger with the slice-2 closures and the mechanism sentences. No named fold was needed — nothing was attributed; both items were fixed. The 4a-5 runtime module dual-run seam rows were left unchanged (out of scope — the runtime linking/evaluation seam belongs to test262-convergence).

### Invariant bars (all green)
- Curated corpora: **1711/1711 divergent=0 endor-rejected=0 accept-disagree=0**
- `cargo test --workspace -- --test-threads=1`: **EXIT=0**, no failures
- `statements/class` + `expressions/class`: divergent=0 endor-rejected=0 accept-disagree=0
- `#![forbid(unsafe_code)]` intact; no `unsafe` in the diff; `c/moddable` never staged
- Label-regression subtrees (`statements/{labeled,break,continue,for,while,switch}`): all clean

### Landed
Commit `f9962cdff` pushed to `origin/xs2rust-endor` (`5b1f4c556..f9962cdff`), verified by push exit code via rebase-CAS. PR #600 kept DRAFT; no PR comment, no maintainer message. Inbox drained (empty). Both slices complete.

**Follow-ups:** none — every slice-2 subtree is fully clean. The runtime module linking/evaluation seam (4a-5) remains a deliberate named skip for test262-convergence, unchanged.
