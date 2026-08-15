The work is complete and pushed. Let me write the completion report.

---

## Completion report

**Job:** Build the reusable runtime source-compilation and same-realm execution bridge for `eval` string source and dynamic `Function` constructors in the Ironhorse Rust engine, replacing the source-text pattern-matching `eval:string-source` boundary. Repo `endojs/endo-but-for-bots`, shared branch `feat/ironhorse-262-language-completion` (draft PR #970).

**What I did**

Replaced the `eval:string-source` source-text hack (which pattern-matched `"function NaN"`, `let/const/class` + `typeof`) with a principled compiler/VM interface:

- **Compiler/VM seam** (`ironhorse-vm`): a `SourceCompiler` trait + `CompiledSource`/`SourceCompileError`, installed via `Interp::set_source_compiler`. The VM stays compiler-agnostic (no `ironhorse-compile` dependency); `ironhorse-262` supplies `IronhorseSourceCompiler` (the same front end the top-level program rides). `eval` of a string and the `Function` constructor now compile and execute in the live realm through this seam.
- **Symbol/linkage ownership:** an independently-compiled unit's program-local symbol ids are relinked into the realm's shared symbol table by an `fxReadCode`-exact walk (`instruction_len`; a size-0 opcode's operand is authoritatively a symbol id, everything else — including length-prefixed string/bigint literal payloads — skipped), interning novel names and binding any intrinsic the outer program never referenced.
- **Nested invocation / realm identity / safe lifetime:** the unit runs as an isolated program activation (scope, `this`, args, target, catch-jump chain, call stack, result all saved/restored), on the same Interp (global object, intrinsics, heap, meter). Units are persisted as **code segments** so a function that outlives the eval (the completion value, a stored global, or the `Function` result) still dispatches over the right bytes — cross-segment calls route through a nested dispatch, **gated so a program that never evals is byte-for-byte unchanged**.
- **Catchable parse errors:** a compiler syntax error → realm-local catchable `SyntaxError`; an unported construct → honest `Halt::Unsupported`. Direct eval whose scope is a function frame is a named gap (`eval:direct-scope`), never a wrong-scope result — preserving the 0-failures bar.
- **Genuine realm semantics the hack faked:** GlobalDeclarationInstantiation `CanDeclareGlobalFunction` (a `function NaN(){}` redeclaring a non-configurable value global is a `TypeError`; `NaN`/`Infinity`/`undefined` now carry their spec non-configurable/non-writable/non-enumerable descriptor), and a catchable `ReferenceError` on TDZ local reads (including `typeof`).
- **`Function` constructor** via CreateDynamicFunction (assembles `(function anonymous(P\n) {\nbody\n})`, evaluates through the bridge). No semantics by source-text pattern matching; byte identity for ahead-of-time code preserved.
- **Tests:** oracle-backed `rust/engine/ironhorse-262/tests/eval_runtime_source.rs` (10 tests: string compilation, completion values, syntax errors, nested execution, realm-local TDZ/redeclaration errors, `Function`), plus VM relinker unit tests (byte-identity round-trip + data-payload safety).

**Verification (commands run, all green)**
- `cargo test --workspace --release` — 58 groups, 0 failed.
- Exact-meter corpus `ironhorse-xst --gate-meter-exact ironhorse-262/cases` — **BAR MET: 1712 covered, 0 failed** (35 advisory, unchanged); confirms byte-identity/metering for AOT code untouched.
- Full `ironhorse-262` suite (incl. the new eval tests) — 0 failures, before and after rebasing onto peer commits.
- Affected official slices, pinned test262 + XS, before→after with **zero Ironhorse failures** both ways:
  - `language/eval-code`: covered **11 → 43**
  - `built-ins/Function`: covered **139 → 167**

**Head SHA / PR:** pushed `47d5bb8c6202be6ad40ab832ec4c0b98064d2004` to `feat/ironhorse-262-language-completion` (fetch/rebase/CAS, clean fast-forward). PR https://github.com/endojs/endo-but-for-bots/pull/970. Did **not** merge or undraft.

**Follow-ups / notes**
- Direct eval nested inside a function frame is a deliberate named gap (`eval:direct-scope`); implementing caller-local scope capture would lift the remaining `language/eval-code/direct` cases. Eval-path computrons are advisory (lower than XS) — the exact-meter corpus is non-eval and stays exact.
- Operational hazard hit and recovered: `git stash` on the shared bare repo races with concurrent gardeners across worktrees; I recovered my change set from a dangling commit and left peers' stashes intact. Saved as a memory to avoid repeating.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-eval-01-runtime-source.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 331 tokens (40770812 cached reads)
- Output: 199725 tokens
- Cost: $28.960171000000006
- Wall-clock: 3053s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
