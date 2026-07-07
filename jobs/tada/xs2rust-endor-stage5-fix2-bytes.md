Inbox empty. Both slices are pushed and green. Here is my completion report.

---

## Completion report: stage-5 fix2 3/6 — Class B + Class C byte divergences

**Worked on** PR #600 `endojs/endo-but-for-bots` branch `xs2rust-endor` (KEPT DRAFT; no PR comments, no maintainer messages). Oracle pinned at `48ee02d8`. Isolated project checkout; re-measured at the real remote tip (siblings Class A + private-reads had already landed).

### Fixes landed (2 commits, pushed to origin/xs2rust-endor)

**1. `5d14f9e64` — Tail-call `RUN_TAIL`/`EVAL_TAIL` emission (Class C tail).**
XS sets `mxTailRecursionFlag` on a strict, non-generator `return`'s expression (when its return target is a direct branch, not a `try`/`finally` alias) and threads it through `&&`/`||`/`??`/`?:`/comma to the tail-position call, whose params node emits the `RUN_TAIL`/`EVAL_TAIL` family. Endor emitted plain `RUN`/`EVAL` everywhere. Ported the flag as a staged coder field mirroring the existing `no_value` staging (`code_return` origin + gating, propagation through the short-circuit/ternary/comma/option coders, consumption in `code_params`). **Closed 135 divergences** (oracle `0xaf run_tail_1` vs endor `0xab run_1`).

**2. `9ed2f12c2` — Async-generator return awaits + status-checks (Class B).**
In an `async function*`, `fxReturnNodeCode` emits `AWAIT; THROW_STATUS` after the return expression and before `SET_RESULT`, and a bare `return;` emits nothing (the resume machine supplies the result). Gated the async-gen (`ASYNC & GENERATOR`) return path. **Closed the yield*/return byte-length divergences.**

Both commits add fixtures to `endor-compile/tests/coder_byte_identity.rs` (`tail_call_run_tail`, `async_generator_return`), including suppression cases (sloppy, generator, try/finally, plain async).

### Measured tallies (at my pushed tip)

| Subtree | Divergent before → after |
|---|---|
| statements/class | 330 → **100** |
| expressions/object | 7 → **1** |
| statements/for-of | 0 → **0** ✓ (Class B fully closed here) |
| expressions/assignment | 0 → **0** ✓ |
| statements/try | 0 → **0** ✓ |

- Curated corpora: **1711/1711 identical, divergent=0, endor-rejected=0** ✓
- Module corpora test: **passes** (35/35) ✓
- `cargo test --workspace -- --test-threads=1`: **EXIT=0** ✓ (verified at this exact tip)
- `#![forbid(unsafe_code)]` intact. `endor-rejected`/`accept-disagree` counts unchanged (pre-existing, out of my both-accept scope).

### Remaining 101 divergences (100 class + 1 object) — attributed folds

All remaining are in the **class-tail / private-member / synthesized field-init machinery** landed by the private-reads sibling (`e9a9ed587`), and are **scoper-coordinated, not byte-only coder folds** (I confirmed a coder-only attempt on A does not close it):

- **A. Private-accessor brand double-capture** (20 files, `elements/private-accessor-name`, endor-LONGER by 2). A `get #x`/`set #x` pair resolves to **two distinct `symbolAccess` closures** in endor's scoper, so the field-init function RESERVE/RETRIEVE/STOREs one extra slot; XS shares the single brand. I tried a coder-side intern/dedup of the capture ids — it does **not** close it because the ids genuinely differ; the fix is scoper-side (share the brand across the accessor pair). Rep: `inst-private-name-common.js` (extra `store_1` at op idx 128; oracle 373 / endor 375).
- **B. Direct-eval-in-field-initializer WITH prelude** (~18–19 files, `elements/*direct-eval*`, endor-SHORTER by ~3–7). The synthesized field-init function omits XS's `UNDEFINED; WITH; POP` eval-environment prelude emitted after RETRIEVE when the field function itself contains direct eval. Endor's `self.eval_flag` is true there but only as an **inherited program-poison** signal (`saved_eval=true`), not the field function's own eval flag — a precise fix needs the field-function scope's own `SCOPE_EVAL` (gating on the inherited flag would misfire for non-eval field functions in eval-poisoned programs). Rep: `private-field-visible-to-direct-eval-on-initializer.js` (oracle inserts `undefined; with; pop` @94–96; oracle 187 / endor 180).
- **C. Nested-class private-member scope count** (35 files, `elements/*-on-nested-class.js`). Opcode-**name** sequences are byte-identical; the divergence is an **operand at byte 4** (oracle `0x09` vs endor `0x0d`, same total length) — endor's scoper over-counts scope slots for a nested class declaring private members. Scoper-level. Rep: `private-field-on-nested-class.js` (same len 406; first diff @4).
- **D. Numeric property / accessor keys** (object `S11.1.5_A3.js` + 4 class `accessor-name-*/literal-numeric-*.js`, Class C). A numeric literal key `{0: 1}` / `get 1(){}` is coded by endor as a string-atom `NEW_PROPERTY`; XS canonicalizes the numeric key and codes it via `INTEGER; AT; NEW_PROPERTY_AT` (integer-indexed). Rep: `object/S11.1.5_A3.js` (oracle `integer;at;new_property_at` vs endor `string;new_property`).
- **E. Closure-capture classification under eval poison** (remaining `literal-name`/`static`/`gen`/`async` endor-shorter in `elements`). A class-body declare XS makes `new_closure` (captured) endor makes `new_local` in an eval-poisoned scope. Scoper-level. Rep: `after-same-line-gen-literal-names.js` (op idx 9: oracle `new_closure` vs endor `new_local`).

### Follow-ups
Classes A, C, E (and the field-function eval flag needed by B) are scoper-side and should be routed to whoever owns the private-member/scoper surface (the private-reads sibling's domain); Class D (numeric-key AT encoding) is a coder+parser change. None are pure byte-only coder folds closable without scoper coordination or corpora risk, which is why I stopped here rather than sit on a speculative tree.
