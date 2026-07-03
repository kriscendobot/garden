All four commits are on `origin/xs2rust-endor`; the `c/moddable` gitlink is correctly left unstaged (no commit touched it); PR #600 remains DRAFT. Work is complete.

---

## Completion report — stage-3b child 2/9: BigInt (PR #600)

**Repo** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, kept DRAFT). Pushed 4 green commits: `c8de281bf` (core) · `e021feaf6` (corpus+fuzz) · `9713ee930` (String skip) · `76db05dd4` (GC test).

### What I did
- **Salvaged** the ~366 uncommitted lines from the poisoned collections predecessor (BigInt value Kind, `[sign][LE u32 limbs]` digit chunk, literal decode, equality, rendering, limb arithmetic) into my own worktree via a 3-way apply, resolving the one additive constants conflict. Never worked in the poisoned tree.
- **Completed the surface to the stage-3 bar**, all **raw-exact** vs pin `48ee02d8cfe0`:
  - Literals (`XS_CODE_BIGINT_1/2` → `fxNewBigInt`); `typeof "bigint"`; decimal completion rendering.
  - Arithmetic `+ - *` with the `mxBigInt_meter` digit step over the trimmed result size **and** the allocation-faithful result chunk at XS's **pre-trim** `fxBigInt_alloc` size (add `max+1`, sub `max`, mul `a+b` limbs).
  - Unary minus (`fxBigInt_neg`); strict/loose `=== == !== !=` including BigInt-vs-Number (`fxNumberToBigInt`, incl. multi-limb and non-integral); relational `< <= > >=` (both-BigInt).
- **Fixed a calibration bug the salvage carried**: its metering was computron-off with *canceling* errors that crossed computron boundaries on accumulation (e.g. `-3n*-4n`). The true per-op residuals are each `1<<14` (literal/arith-frame/neg-frame); the both-BigInt compare carries **zero** residual (the salvage's "builtin per operand" was the literal undercharge in disguise).
- **Added** a 93-program curated corpus (`stage3-bigint.js`, graduated into the bit-exact bar) + a structure-aware fuzz generator swept over 800 seeds through `differential_check` + a BigInt GC-relocation test (native **and** Miri green).
- **Honest skip over wrong meter**: made `String(BigInt)` self-name (`fxBigintToString`'s radix-formula chunk + `fxBigInt_dup` + call-frame residual unmodeled; ~82k-raw off) rather than ship a covered surface with a wrong computron count.

### Verification
- Bar met: `built-ins/BigInt` **divergent=0**; bigint-relevant `language/` sections **204 covered / divergent=0**.
- Full workspace test green (prior corpora + covered-grammar bar intact); Miri GC suite green (9 tests incl. the new BigInt one); `#![forbid(unsafe_code)]` intact; `c/moddable` gitlink never committed.

### Honest named skips (never a wrong value/meter)
`BigInt**`, `BigInt / %`, mixed BigInt/Number **arithmetic** (a TypeError), the fractional-delta mixed **relational** path, and `String(BigInt)`/concat/template.

### Follow-up
The **`BigInt()` constructor** (new intrinsic global) + `BigInt.prototype.toString/valueOf` + `asIntN/asUintN` is the biggest remaining coverage (unlocks the 67 `built-ins/BigInt` files, all currently endor-aborted on the missing global). It's a delicate surface — new-intrinsic registration must not double-count the realm-setup metering constant — so I left it as a clean next increment rather than rush an invariant violation. Sent this to the supervisor inbox `port-xs-to-rust-memory-safe-engine-s7`; that inbox had completed, so the note was dead-lettered for promotion (intent preserved).
