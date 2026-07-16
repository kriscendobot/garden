---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage6
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T21:29:42Z
---

---
model: opus
---
# Stage 6 child 1/6: flip the compiler-seam DEFAULT — endor-compile replaces oracle-compile

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 5
(byte-identity of `endor-compile` vs the C-XS oracle) is formally ACCEPTED at tip `69ec87becb`
(PR comment issuecomment-4996709674): 1711/1711 curated + the complete 121-run `language/`
enumeration are divergence-free with full accept/reject agreement. The endor compiler has EARNED
the default. Your job: make it the default everywhere, leaving the oracle available for
differential harnesses ONLY.

## The work

1. **The pipeline seam** (`rust/engine/endor-262/src/lib.rs`, the `Compiler` enum): move
   `#[default]` from `Compiler::Oracle` to `Compiler::Endor` (the design's promised one-line
   flip, § roadmap row 5). `dual_run` and every default-compiler path then run endor's own
   bytecode; the oracle remains the differential REFERENCE (its result/computrons are what the
   run is compared against) — that consultation is the harness's purpose and stays.
2. **Endor's own symbols atom.** Today `compile_for`'s `Endor` arm pairs endor bytecode with
   `oracle.symbols.clone()` — the SYMB atom still comes from the oracle, so the flip is
   incomplete without an endor emitter. The coder (`endor-compile/src/coder.rs`) already interns
   the identical symbol table (SEED_SYMBOLS + program symbols in the same ID order — that ID
   contract is what byte-identity of `GET_VARIABLE`/`SYMBOL` operands proves). Add a compile
   entry that also returns the SYMB payload in the C-XS wire format (`endor-vm/src/symbols.rs`
   `parse_symbols` documents the decode side). **Verify the emitted symbols atom is
   byte-identical to `oracle.symbols` across the curated 1711 corpus** (extend `compile-diff` or
   add a locked test — either way the check must be a committed, repeatable gate). Then
   `compile_for(Endor)` stops cloning the oracle's symbols.
3. **Sweep every oracle-compiles-by-default seam.** Grep all `endor_oracle::` call sites
   (endor-262, endor-regexp, endor-compile tests, endor-fuzz). Classify each: (a) differential
   reference / byte-identity harness — KEEP; (b) a default execution path that feeds oracle
   bytecode to endor-vm (the endor-vm compartment-evaluate callers, any test or runner that
   compiles-to-run rather than compiles-to-compare) — FLIP to endor-compile. The review ledger
   names "the endor-vm compartment evaluate path still oracle-compiles" as the standing residual.
4. **Grep-proof in your completion report:** list every remaining `endor_oracle::` call site and
   its classification, demonstrating no DEFAULT path invokes the oracle compiler. The oracle
   crate stays in the workspace for differential harnesses only (design: dev/CI, never a shipped
   engine path).

## Verification (all captured to files, `$?` checked directly)

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, every
  `test result:` line 0 failed.
- Curated `compile-diff` (no arg) → EXIT=0, `1711 identical, 0 divergent`.
- Stage-4 spot-check: `endor-xst built-ins/Object` (floor 182 covered / 0 failed),
  `built-ins/Function` (43/0), `built-ins/Array` (487/0) — floors hold, all skips named,
  EXIT=0. These now run endor's OWN bytecode under the flipped default — that they still meet
  the floors is the point of the flip's verification.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; ALWAYS sync to the real remote tip first; verify
  pushes by git exit code. Commit explicit pathspecs; push `origin HEAD:xs2rust-endor` with a
  rebase-CAS loop.
- Rust workspace is `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1):
  `git -C c/moddable init` then
  `git -C c/moddable fetch --depth 1 --filter=blob:none https://github.com/Moddable-OpenSource/moddable <sha>`
  then checkout. NEVER `git add` c/moddable.
- A `cargo test` piped to `tail` masks the exit code — capture to a FILE and check `$?`.
- `/tmp` is noexec — run scripts via `bash /path/script.sh`.
- `#![forbid(unsafe_code)]` stays at every engine crate root.
- DOCTRINE accuracy-over-parity (design § Metering + Design Decision 9): result agreement
  gates; computron-vs-oracle is advisory; never back-fit meters.
- Budget: size to ONE 2400s invocation. If you cannot finish, commit+push only what is green
  and report the honest remainder — never leave the branch red.
- Report via your tada completion report ONLY. Do NOT inbox-send the parked supervisor
  (`port-xs-to-rust-memory-safe-engine-s20`) — dead-letter noise.
