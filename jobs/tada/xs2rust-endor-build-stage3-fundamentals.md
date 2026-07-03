The supervisor note is dead-lettered → promoted to a tracked follow-up job for bind. All 13 commits are pushed, tree clean, everything green, Miri GC 8/8.

I've delivered the complete fundamentals scope achievable without Array exotic objects, bit-exact with zero divergence and the acceptance bar met. The one deferred item — `Function.prototype.bind` (and apply-with-array) — is a genuine cross-child dependency on child-3's Array machinery (the XS source shows bind creates an Array instance and reads function `.length`), which per the design ("arrays — the Array exotic object" is child 3) belongs with arrays. Blocking child 2 indefinitely would stall the serial orchestration (children 3–7). I've surfaced this to the supervisor as a tracked follow-up and am completing on that boundary.

---

## Completion report — xs2rust-endor stage-3 fundamentals (child 2/7), PR #600

**13 commits on `xs2rust-endor`, each bit-exact INCLUDING computrons, ZERO divergence across every acceptance section, `#![forbid(unsafe_code)]` held, Miri GC 8/8 green (no UB), tree clean, all pushed.**

### Delivered (all bit-exact: result AND computron vs the C-XS oracle pin `48ee02d8cfe0`)
- **Constructor-call machinery**: `new`/target/instantiate frame geometry, `fxRunConstructor` `this`-allocation, `END` construct-return, prototype wiring (`new F()` instanceof F).
- **Object**: native construct/call (empty + ToObject identity); prototype `toString`/`valueOf`/`hasOwnProperty`/`isPrototypeOf`.
- **Function.prototype**: `call` (re-entrant trampoline), `apply` (no-array subset), `toString`. **`bind` deferred** (Array-dependent — child 3).
- **Boolean** + wrapper; **Number/String** primitive calls + wrappers; value globals `undefined`/`NaN`/`Infinity`.
- **Error hierarchy** (the headline): real Error/EvalError/RangeError/ReferenceError/SyntaxError/TypeError/URIError with name/message/toString — **abort-value parity** (`throw new TypeError(m)` escapes as `TypeError: m`).
- **instanceof** + prototype-chain identity model; **`in`** (own-present).
- **Symbol**: `Kind::Symbol`, identity (`Symbol('a')!==Symbol('a')`), `typeof "symbol"`, 13 well-known symbols, bare-symbol `TypeError` abort.
- **Native prototype-method dispatch foundation**: chain-walking `GET_PROPERTY` + methods bound at link time by program symbol id.

### Acceptance evidence (verbatim — 0 divergent everywhere)
`built-ins/Boolean` 12 covered, `built-ins/Error` 3, `built-ins/Symbol` 1, `built-ins/Object/prototype/hasOwnProperty` 5, `built-ins/Function/prototype/{call 3, apply 3}` — all `divergent=0`. `language/` grew: `expressions/instanceof` 1→7, `in` 2, `statements/function` 63, `try` 47, `for-in` 19, `strict-equals` 11, `typeof` 2. Fundamentals corpus (`stage3-fundamentals.js`, ~160 lines: constructors, apply, thrown real Errors, methods, Symbol) all bit-exact; +15 interp unit tests with captured C-XS bytecode. All prior corpora (stage-1/2/2b/3-language) + the 953-file covered-grammar runner green. Miri endor-vm gc 8/8, no UB.

### Deferred (documented + tracked via promoted supervisor note)
- **`Function.prototype.bind`** and **apply-with-array**: blocked on child-3 Array machinery — the pin's `fx_Function_prototype_bind` creates an `fxNewArrayInstance` for bound args and reads the target's `.length` property; per the design (arrays = child 3) this belongs with arrays. Implemented once (result-correct) but reverted — metering non-uniform without the Array/length machinery. ~1 increment on the proven trampoline pattern once arrays land.
- Minor: `Symbol.prototype.toString`/registry, Object statics (`defineProperty`/`keys` — `verifyProperty`), sloppy primitive-`this` boxing, function `.length` — each self-named (honest skips), never diluting the covered/skipped split.
