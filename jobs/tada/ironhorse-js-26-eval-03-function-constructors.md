All work complete. Final report:

---

## Completion report: `ironhorse-js-26-eval-03-function-constructors`

**Repository:** `endojs/endo-but-for-bots` · **Branch:** `feat/ironhorse-262-language-completion` (draft PR #970)
**Pushed SHA:** `fa331b12dbb925cad53b27ecb486d2e5d7bcc6ab` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970
(Not merged, not undrafted, as instructed.)

### What I implemented
The ECMAScript **dynamic function constructor family** on the runtime source bridge:
- `Function`, `%GeneratorFunction%`, `%AsyncFunction%`, `%AsyncGeneratorFunction%` — call/construct equivalence, parameter/body assembly & grammar, global-realm execution, `name`/`length`/source-text, early errors, and error identity.
- One shared `create_dynamic_function` runs CreateDynamicFunction (20.2.1.1.1): `ToString`-coerces every argument (fixing the old `Function:non-string-arg` gap; `Symbol` → realm `TypeError`), assembles the kind-specific head, compiles through the same seam as `eval`.
- The three non-global constructors are created at boot (reached via a generator/async instance's `.constructor`), with a new `%GeneratorFunction.prototype%`, identity links, and `[[Prototype]]` chains **mirrored from XS exactly** (non-uniform: `%Function.prototype%` for the generator kinds, `%Function%` for `%AsyncFunction%`).

### Three bridge-lifetime bugs fixed (pre-existing, on the family's path)
1. Suspended bodies (generator `.next`, `await` continuation, async-generator resume) defined in an eval/`Function` segment now resume over **that** segment's buffer, not the driver's.
2. An uncaught throw from a cross-segment callee now re-raises into the caller's `try`/`catch` instead of escaping the program.
3. Exotic-property id caches (`length_id`, `value_id`, RegExp clusters…) are refreshed from the realm symbol table after an eval relink (so `Function('...r','return r.length')` and an eval-generator's `{value,done}` result render correctly).

No source-pattern special cases, no result relabeling.

### Tests
`rust/engine/ironhorse-262/tests/function_constructor_family.rs` — 12 oracle-backed differential tests covering each family, parameters, strictness, syntax failures, global isolation, prototype selection, observable properties, error identity.

### Verification (XS oracle, test262 `be13516fb6`)
- `cargo test --workspace --release`: **872 passed, 0 failed** (includes the exact-meter/bit-exact corpus gates).
- Affected slices under `--gate-meter-exact`, before→after, **0 Ironhorse failures**:
  - built-ins/Function **182→211**
  - built-ins/GeneratorFunction **5→9**
  - built-ins/AsyncFunction **7→10**
  - built-ins/AsyncGeneratorFunction **5→10**
  - +1 each on language/{statements,expressions}/generators; language/expressions/async-generator holds at 487 (a strict-mode regression I introduced and then removed).

### Commands
`git submodule update --init c/moddable`; `cargo test --release --workspace`; `cargo fmt --check` (my files clean); `cargo clippy --release -p ironhorse-vm` (clean); `ironhorse-xst [--gate-meter-exact] --test262-dir <pinned> <slice>`.

Rebased twice onto peer commits during the CAS loop; final push clean. No follow-ups outstanding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-eval-03-function-constructors.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 319 tokens (29613778 cached reads)
- Output: 117998 tokens
- Cost: $20.429585999999997
- Wall-clock: 1927s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
