Inbox empty. Work is complete and verified.

## Completion report

**Job:** Stage-5 child 5/7 — the `endor-compile` coder (emitter framework + expression/simple-statement bytecode). PR `endojs/endo-but-for-bots#600`, branch `xs2rust-endor`, kept **DRAFT**.

**What I did (3 commits pushed):**
- **Ported the XS coder framework faithfully** (`endor-compile/src/coder.rs`): `fxParserCode`'s exact **three passes** — pass 1 sizes with branches assumed widest and accrues `delta` slack; pass 2 selects each branch's `_1`/`_2`/`_4` width from the now-known target offsets; pass 3 emits with back-patched displacements — plus `fxCoderAdd*` record constructors, the target/fixup arena, stack-depth accounting, the `fxCoderOptimize` branch-to-next peephole, and the `INTEGER`/`STRING`/`BIGINT`/index-family width selection with XS's byte-order constant encodings. Program header via `fxScopeCodingEval` (the oracle compiles the script goal as an eval program).
- **Node surface:** every scalar literal (int/number/string/true/false/null/undefined/**BigInt**, limb-encoded), all unary/binary/relational/shift/bitwise operators, `&&`/`||`/`??`, conditional, sequence, expression statements, `if`/`else`, blocks.
- **`opcodes.rs`** generated from `endor-vm`'s opcode table; **scoper** now exposes `node_scopes` + `node_key` so the coder resolves a node's scope by address (same-tree walk), faithful to XS's in-place `txScope*`.
- **`coder_byte_identity.rs`** differential test with an opcode-level disassembler for triage.

**Verification:** `cargo test --workspace -- --test-threads=1` → **EXIT=0** (all stage-1..4 corpora still green; +4 new coder byte-identity tests, every fixture byte-for-byte equal to `endor_oracle::run(src).bytecode`). `#![forbid(unsafe_code)]` intact.

**Folds (named, deferred to child 6 — each panics in tests rather than emit a wrong byte):** everything gated on the **atom/symbol table** (its per-symbol ID assignment is embedded in the code stream and must be reproduced in XS's hash-walk order) — identifier/property loads-stores, `var`/lexical declarations, assignment, call/`new`/member, object/array/template, `Access`/`this`. Child 6 also needs a per-`Access`-node→declaration map (mirror of the `node_scopes` change I landed). Full handoff sent to inbox `port-xs-to-rust-memory-safe-engine-s12`.
