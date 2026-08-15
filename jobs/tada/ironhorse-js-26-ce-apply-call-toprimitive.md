---
handed-off: ironhorse-js-26-ce-residual
deliverable-complete: false
---
All remaining work is durably owned by the successor orchestration. Writing the final report.

---

## Completion report: `ironhorse-js-26-ce-apply-call-toprimitive`

**Outcome:** Landed a verified partial closure + honest hand-off of the remainder. The full 707-case cluster is not closed in one handler, but its **dominant sub-family is closed and pushed**, and a named successor orchestration durably owns every remaining case.

### What I did
1. **Diagnosed the cluster** against the real XS oracle. It spans ~10 causal reasons; the largest single in-scope family is `non-primitive-completion` (299). Key finding via oracle probes: the pinned Moddable's `Function.prototype.toString` never reproduces source text — every callable renders as `function ["<name>"] (){[native code]}`. So a function-valued program completion is a **pure display-render gap** (zero metering impact), not a metered-VM feature.

2. **Implemented the fix** in `Interp::render` (`rust/engine/ironhorse-vm/src/interp.rs`): user functions, arrows, class constructors, and bound functions (`"bound "+target`) now stringify through the same host-function synthesis the native-function arm already used. Native *prototype methods* are deliberately excluded (their `FuncInfo` has no `.name`, so rendering them would turn an honest skip into a divergence — a regression I verified and avoided).

3. **Added regression coverage:** `ironhorse-262/tests/function_completion_tostring.rs` (6 tests, all green).

### Verification (real XS-oracle execution, per acceptance bar)
- Affected slices before→after: `language/statements/class` covered **3550→3572**, NPC **24→2**; `language/expressions/function` **191→197**; `language/statements/function` **295→301**; `language/expressions/object` **932→942**; arrow-function **271→274**; built-ins/Function **136→137**. **+48 covered / −48 non-primitive-completion / 0 new failures** across the sample.
- `cargo test --workspace --release`: **green** (30 suites). Exact-metering corpus (`corpus_conversion_equivalence`, the `cases/**` `--gate-meter-exact` gate): **green**.
- Rebased onto the peer-advanced branch head, re-verified all gates, pushed with CAS.

**Commit:** `feat(ironhorse): render function-valued completions via Function.prototype.toString`
**Branch/PR head SHA:** `3f24768032` — https://github.com/endojs/endo-but-for-bots/pull/970 (kept OPEN + DRAFT, not merged).

### Hand-off of the remainder
The remaining causal sub-families were decomposed into a **serial, halt-on-failure** nested orchestration `ironhorse-js-26-ce-residual` (recorded in `jobs/orch/`, 3 children parked in `jobs/plan/`, all on `origin/journal2`), run order front-loading the safe wins:
1. `ironhorse-js-26-ce-exotic-completion-render` — display-only render of exotic-builtin completions (ArrayBuffer/DataView `[object X]`, typed-array join, arguments, `Symbol.toStringTag`).
2. `ironhorse-js-26-ce-toprimitive-coercion` — ToPrimitive (`valueOf`/`toString`/`@@toPrimitive`), incl. `to_primitive:no-primitive-result`/`non-callable`/`native-method` and user-`toString` completion coercion.
3. `ironhorse-js-26-ce-fn-native-receivers` — the metering-heavy namesake: `call`/`apply`/`bind`/callback on non-user (native/bound) receivers.

Each child carries the full acceptance bar, shared-branch discipline, pins, and precise line-level pointers into the interpreter.

### Notes / follow-ups
- I did **not** relabel, suppress, or skip-list anything; the render change is meter-neutral (verified against the exact-metering corpus).
- A pre-existing, out-of-scope observation surfaced: `arguments` objects mis-render as their element join (`1,2`) instead of `[object Arguments]` because they live in `self.arrays` — captured as scope for child 3. Date/WeakRef completions currently throw `ReferenceError` (separate constructor gap) — explicitly excluded from the children.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ce-apply-call-toprimitive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 231 tokens (14092625 cached reads)
- Output: 79236 tokens
- Cost: $10.782660500000004
- Wall-clock: 1290s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
