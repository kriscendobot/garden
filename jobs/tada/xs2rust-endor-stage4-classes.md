Work complete. Final report:

## Completion report — `xs2rust-endor-stage4-classes` (stage-4 child 2/8)

**What I did.** Assessed the full class opcode family against the one-invocation budget and the "accuracy over parity / never a half-implemented surface" charter, then landed the bounded, metering-trivial, genuinely-complete slice — **`new.target`** — and folded the divergence-prone remainder as explicit honest skips.

**Landed (bit-exact, result AND computron):**
- **`new.target`** via `XS_CODE_TARGET` (the opcode already decoded but had no semantics — exactly as the job called out). It pushes the running frame's target constructor inside a construct (XS's `mxFrameHasTarget → mxFrameTarget`, read from endor's existing `(cur_target, cur_func)` pair) and `undefined` inside a plain call. Pure dispatch — XS's handler only allocs a stack slot and advances — so the generic per-opcode `tick_code` is the whole cost and it is **metering-exact by construction**.
- Curated corpus `endor-262/corpora/stage4-new-target.js` (15 programs: factory-guard idiom, closure-captured constructor, construct/plain-call alternation), locked as the cargo bar `stage4_new_target_corpus_is_bit_exact_against_oracle`.

**Evidence:**
- `built-ins/Function`: **covered 39 → 40, divergent=0** (the `new.target`-gated test now covered — no regression, a +1).
- `language/statements/class`: **total=3908 covered=1 divergent=0 skipped=3907** (every skip named).
- `language/expressions/class`: **total=3663 covered=1 divergent=0 skipped=3662**.
- `cargo test --workspace -- --test-threads=1`: **green**. `#![forbid(unsafe_code)]` intact (0 unsafe added; the change touches no allocation/GC path, so Miri is N/A).
- README evidence block updated; committed with explicit pathspecs and pushed to `origin/xs2rust-endor` (`e81e97986..616193500`). **PR #600 kept DRAFT**; no PR comment (a slice, not a headline milestone). The `c/moddable` gitlink drift was left unstaged per the README §1 note.

**Scope fold (reported, carried to a follow-up class child).** The headline `class` surfaces — definition, concise methods, static members, `extends`, `super`, private fields/methods, static blocks — self-name honest skips, dominated by `to_instance` (1872 in `statements/class` — the class-definition gate opcode), plus `extend`, `super`/`set_home`, `generator`. Landing the definition path bit-exact needs three metering/model surfaces that don't fit one 2400s window alongside a *green* result: (a) constructor `.prototype` / `prototype.constructor` as real readable own properties with `GET_ONLY`/`DONT_ENUM` flags (endor currently keeps `.prototype` in a side map, invisible to `GET_PROPERTY`); (b) method non-enumerability via the `NEW_PROPERTY` flag byte; (c) `CLASS`/`NAME`/`SET_HOME` allocation-metering calibration against the pin.

**Follow-up handoff.** Reported the numbers + scope fold to the supervisor stage `…-s9`; that inbox had already completed, so the message was dead-lettered and auto-promoted to a fresh job (intent preserved). My own inbox was empty.
