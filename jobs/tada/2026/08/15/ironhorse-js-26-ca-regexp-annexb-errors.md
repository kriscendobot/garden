All work is complete, verified, committed, and pushed. Here is my completion report.

---

## Completion report: `ironhorse-js-26-ca-regexp-annexb-errors`

**Repository:** endojs/endo-but-for-bots — shared branch `feat/ironhorse-262-language-completion`, draft PR #970 (kept **open + draft**).
**Pushed:** `1c41b9a61..cf9247cd0` (rebased onto the peer's latest ArrayBuffer work; stack preserved, CAS clean).
**Pins used:** test262 `be13516fb…`; Moddable XS `23b4d6b0a65f…` (seeded the oracle from the exact pin and built `xs-oracle` + `ironhorse-xst`).

### What I found
The prior Unicode/groups/modifier work had already brought `ironhorse-regexp` to XS parity across almost the entire grammar / early-error surface. I confirmed this empirically by driving the **XS oracle directly** over a large hand-built battery (decimal/octal/control/identity escapes, class ranges, leading/trailing escapes, quantifiable assertions, malformed groups/classes/quantifiers, duplicate/invalid flags, constructor-vs-literal, strict u/v boundaries) and comparing accept/reject **and** match/meter. Notably, XS is deliberately *stricter* than the ECMAScript Annex B leniency (e.g. `\1` with no group, `\c5`, `[\12-\14]`, all quantified assertions are hard SyntaxErrors) — ironhorse already matched that.

**One real defect surfaced:** `\p`/`\P` were gated on the `u`/`v` flag, but XS's `fxCharSetParseEscape` dispatches `p`/`P` to `fxCharSetUnicodeProperty` **unconditionally** (the flag only gates the v-mode string-property table inside it). So legacy non-Unicode `/\p{Foo}/`, `/\pL/`, `/\p/`, `/\p{/` **over-accepted** (XS rejects), and a valid `/\p{L}/` in non-Unicode mode matched the literal text `p{L}` instead of a letter.

### What I changed (implementation, not skips)
- **`ironhorse-regexp/src/compile.rs`** — dropped the UV guard on the `\p`/`\P` arm so property escapes fire in every mode, exactly as the pin.
- **Regression tests, three levels:**
  - `ironhorse-regexp/src/lib.rs` — 5 XS-locked Annex B early-error unit tests (property escapes unconditional; legacy decimal/octal escapes; control-escape fallback as SyntaxError; class-range/malformed boundaries; quantifiable-assertion + malformed-quantifier rejection).
  - `ironhorse-regexp/tests/parity.rs` — non-Unicode `\p` match cases added to the oracle-backed corpus (bit-exact vs pin).
  - `ironhorse-262/tests/regexp_properties.rs` — end-to-end `RegExp`-surface tests (non-Unicode property escapes execute; non-Unicode + Annex B early errors throw catchable SyntaxError agreeing with XS).

### Verification (before → after)
- **Oracle differential probe:** 28 compile-verdict divergences → **0** over 1716 cases; **0** match/meter divergences.
- `cargo test --workspace --release`: **green** (60 ok result blocks, 0 failures).
- `cargo test -p ironhorse-regexp`: 35 pass (incl. 5 new) + 3 parity pass.
- **language/literals/regexp**: 229 covered / **0 failed** (unchanged; also passes **`--gate-meter-exact`**).
- **built-ins/RegExp**: 986 covered / **0 failed** (unchanged — prior covered cases and exact metering preserved).
- **annexB/built-ins/RegExp**: 5 covered / **1 failed** / 56 skipped — see below.
- fmt/clippy: my edited files are clean under the repo's `cargo fmt`; the only drift (`compile_diff.rs`, `charcase.rs` pinned tables) is pre-existing in untouched files.

### The one remaining annexB failure — out of scope, pre-existing
`annexB/built-ins/RegExp/prototype/compile/this-subclass-instance.js` over-accepts: this is a **`RegExp.prototype.compile` subclass brand-check** (features `legacy-regexp,class`), a **method-surface** gap — not RegExp grammar or early-error validation. It was present in the baseline before any of my changes (the method is largely unported; most `.compile` cases skip as `ironhorse-aborted`). It is unrelated to this job's scope and the grammar/early-error gates are all met.

**Recommended follow-up (not posted, to avoid injecting into the active orchestration):** a builder job to port `RegExp.prototype.compile`'s B.2.5.1 brand check + subclass/realm semantics, which would clear that last annexB divergence.

I am **not** emitting an orchestration-failure signal: the gated deliverable this job owns — closing RegExp grammar and early-error validation against pinned XS, by implementation — is complete, a real defect was fixed and verified, and no prior coverage or metering regressed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-annexb-errors.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 226 tokens (14749313 cached reads)
- Output: 76015 tokens
- Cost: $11.145297500000005
- Wall-clock: 1196s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
