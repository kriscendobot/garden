All four increments are committed and pushed (HEAD == origin/xs2rust-endor), working tree clean, PR #600 still DRAFT. Work is complete and green. Finalizing.

# Stage-3 child-1 (language) — completion report

All work landed on `endojs/endo-but-for-bots@xs2rust-endor` (PR #600, kept DRAFT) as four green, zero-divergence increments over the pin `48ee02d8cfe0`:

- **3b7f02c5c** — `global`/`this`/`current`/`increment`/`decrement`/`to_numeric`/exponentiation (`fx_pow`); reference identity in `===`; **review obs 1 stack limits**.
- **228ee790b** — chunk-backed CESU-8 **string values**: literals, concat, comparison, `typeof`.
- **01dd9a558** — `let`/`const`/`reset`/`refresh` closures, `refresh_local`, `??` (`branch_coalesce`), `?.` (`branch_chain`); stage-3 corpus.
- **92e52660f** — `delete_property`.

## What landed (deliverables)
- **(a)** Chunk-backed CESU-8 string *values*: `STRING_1/2/4` literals (`fxNewChunk`-metered), concatenation via the `ADD` general path (ToString + `fxConcatString` chunk metering, incl. the number-ToString `mxMeterOne`), content-byte equality/relational comparison, `typeof` over every covered kind (interned type strings, dispatch-only), and oracle-matching `from_utf8_lossy` rendering. Ripple-guarded so string values never diverge (empty-string truthiness; string operands in numeric/mixed ops self-name Unsupported instead of coercing to NaN).
- **(b)** `global` opcode; top-level script `this` bound to the realm global.
- **(c)** `increment`/`decrement`/`to_numeric` (primitive subset), exponentiation, `this`, `current`, `let`/`const` closures, `refresh_local`, `delete_property`, `branch_coalesce`/`branch_chain`. **Deferred (blocked — see folds):** `copy_object`/`extend`, `arguments_sloppy`/`strict`, `at_2`.
- **(d)** Review obs 1: modeled XS's fixed 4096-slot value stack (width-not-depth). Deep recursion / wide frames abort to the host (`Halt::StackOverflow`) as C-XS's `fxOverflow → fxAbort`, fixing 13 `tco-*` `EndorOnlyComplete` divergences that appeared once the new opcodes let those programs run further.

## Acceptance evidence (verbatim)
- `test262 language/expressions`: **covered 155 → 418**, **divergent 0** (of 9446; 9028 skipped by named reason).
- `statements/variable`: total=169 covered=38 **divergent=0**.
- `statements/let`: total=140 covered=6 **divergent=0**.
- In-cargo 953-file covered-grammar bar (expressions + statements/{if,while,for,block,empty,throw,try}): **0 divergent**, green.
- New `stage3-language` corpus: **55 programs bit-exact** (result AND computron). All prior corpora green (stage-1 86 / stage-2 23 / stage-2b 33/10/25).
- Full suite: 17 endor-vm + 28 endor-262 tests, **0 failed**. **Miri GC suite: 8 passed, 0 failed.** `#![forbid(unsafe_code)]` intact.

## Scope folds / frictions (for the supervisor)
Sent to `port-xs-to-rust-memory-safe-engine-s6` (inbox gone → dead-lettered → will be promoted to a fresh job), reproduced here:
- Every **remaining** child-1 language-opcode skip is, in substance, a **built-in/intrinsic/array gap owned by a later child**, so they stay honest named skips rather than being forced (which would risk divergence):
  - `at`/`at_2` (223 expr skips): string-keyed `o[k]` needs a runtime string→id intern table shared with the C-XS compiler's symbol ids (no endor compiler until stage 5, no KEYS-atom import); integer indices need the Array exotic (child 3).
  - `copy_object`/`extend`: `copy_object` pushes the intrinsic `mxCopyObjectFunction` to be *called*, and `extend` runs `fxRunExtends` — native/host-function + class machinery (child 2+).
  - `arguments_sloppy`/`strict`: the arguments exotic is built by `gxDefaults.newArguments*Instance`, a native helper (intrinsics, child 2+).
  - Recommendation: child 3 (arrays) revisits `at` once the Array exotic + a string-key path exist.
- **(e)** `FUNCTION_*` residuals: the constants stay measured-and-bit-exact; the ≤288-raw analytical decomposition is deferred as low-risk polish (already bit-exact).

Follow-up: PR remains DRAFT; the serial orchestration proceeds to child 2 (fundamentals), which unblocks several of the deferred opcodes above.
