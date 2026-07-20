---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T07:55:06Z -->

---
model: opus
---
# stage-10o child 0: native-fn reflection completion (F1/F2(s45)) — engine-wide

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`.
Real remote tip at dispatch: `d268092d7b` (stage-10m: `8b9c050825` set_property_at + `d268092d7b`
native-fn reflection; both ACCEPTED s45, issuecomment-5019929324). No press had rebased past it.
**Sync to the REAL remote tip first** (the hourly `xs2rust-endor-press-*` can advance/REBASE the branch
— read the latest press tadas; if a press is live, message it to defer). Verify pushes by git EXIT CODE.

This CLOSES two pre-existing findings the s45 acceptance review surfaced and attributed IDENTICAL at the
pre-stage anchor `1481757f7f` (not regressions — the F1(s43) native-fn reflection fix `d268092d7b` was
incomplete, and namespace-object own-keys was never enumerated):

## F1(s45) — native-fn reflection residual (complete the "engine-wide" claim)

The `d268092d7b` fix reflects most intrinsics but MISSED some bound natives. **Confirmed unreflected
(bound function, `.length`/`.name` read `undefined`):** `Reflect.isExtensible`, `Reflect.preventExtensions`
(11/13 Reflect methods reflect correctly; these two do not). **Do NOT assume that is the complete set** —
run an engine-wide sweep: for every namespace/prototype (`Object`(+prototype), `Array`(+p), `String`(+p),
`Number`(+p), `Math`, `JSON`, `Reflect`, `Boolean.prototype`, `Map`(+p), `Set`(+p), `WeakMap`/`WeakSet`(+p),
`Promise`(+p), `Symbol`(+p), `RegExp.prototype`, `Function.prototype`, `Date`(+p), the typed-array
families, the error constructors, the direct-intrinsic globals), enumerate the C-XS oracle's own methods
and find every `typeof v==='function'` whose endor `.length` is `undefined` where the oracle gives a
number. **The `~/tmp/s45-results/s45_diag.rs` reflection_gap_sweep probe on endolin-garden is a starting
harness** — but note it iterates `Object.getOwnPropertyNames(ns)` which returns `[]` for namespace objects
on endor (that IS F2(s45) below), so the sweep MISSES namespace methods until F2 lands; drive the reflection
sweep by the C-XS oracle's own-keys (or a hardcoded per-namespace method list read from the pinned
moddable's builder tables), not endor's gOPN. Stamp `name`/`arity`/`name_chunk` for each missed method by
the SAME mechanism the `d268092d7b` fix used: arity transliterated from the pinned moddable
(`23b4d6b0a65f…`) host-function builder tables (`fxNextHostFunctionProperty`/`fxBuildHostConstructor`,
keyed by the exact `fx_...` callback, disambiguated by variant not name) — **NEVER guessed**. Do not
regress the deliberate anonymous-name / symbol-keyed skips.

## F2(s45) — namespace-object own-keys enumeration is empty (silent WRONG-completion)

`Object.getOwnPropertyNames(Reflect|Math|JSON)` returns `[]` on endor (oracle: 13/52/4 names). This is a
silent wrong completion (endor completes with an empty array). The namespace objects (`Reflect`, `Math`,
`JSON`, and check `Atomics`, `Reflect`, the global `globalThis` intrinsic namespaces) are host/exotic
objects whose own method keys are not materialized for enumeration. Wire their own-property names into
gOPN / `Object.keys` (respecting XS creation order + the enumerable flags — Math/JSON/Reflect methods are
non-enumerable, so `Object.keys` stays `[]` but `getOwnPropertyNames` lists them). **F3(s45) is a RELATED
but SEPARATE honest-skip** — `Reflect['isExtensible']` (a computed AT-key read on the namespace object)
halts `Unsupported("at")` where dot-access works; graduate it too if it fits the same materialization, else
leave it an honest-skip and name it in your report (do NOT let it become a wrong completion).

## Discipline (binding)

- **Reproduce-first:** confirm each gap at the tip against the sha-verified oracle before fixing; the
  minimal probes are in the s45 acceptance comment and `~/tmp/s45-results/s45_diag.rs`.
- **Push-per-item (s26):** land F1(s45) and F2(s45) as SEPARATE commits, each pushed immediately after its
  own bars go green (`git push origin HEAD:xs2rust-endor`, verify EXIT 0 with a rebase-CAS retry). Do not
  batch. HARD STOP: reassess the clock after every pushed item; if you cannot finish an item with full
  bars, push what is green and tada with the remainder named.
- **Accuracy-over-parity:** gate on RESULT agreement; computrons advisory. New dual-run tests for every
  fix (e.g. `Reflect.isExtensible.length`, `gOPN(Math).length`, own-keys order/flags). If a fix would
  regress any RESULT chasing a computron, STOP and report.
- **F1 bug-class doctrine:** these are reflective-READ + enumeration paths — a read must reflect the spec
  value with XS flags `{writable:false, enumerable:false, configurable:true}`; enumeration must list the
  right keys in XS creation order without dropping or wrong-completing.
- **Full binding bars at each pushed tip** (cite the measured number at the measured tip): engine
  workspace `cargo test --workspace --release` (EXIT=0 by exit code to a file — a `tail` pipe masks it;
  baseline 936/0 at `d268092d7b`, grows with your tests); `cargo clean -p endor-compile -p endor-vm
  -p endor-oracle` + oracle from the sha-verified pin for the acceptance-grade run; compile-diff
  1909/1909 + SYMB; boot gate `--test boot_bundle_gate` 30/0; ROOT `cargo test -p endo --lib` 111/0;
  0 non-oracle warnings; no new `unsafe`; `#![forbid(unsafe_code)]` roots intact; if you add a side table,
  ledger it same-day and bump `VARIANT_COUNT` (currently 36). The worktree helper does NOT seed
  `target/`; `cp -al` from a same-tip sibling on your host (e.g.
  `scratch/project-wt-xs2rust-endor-stage10m-native-fn-reflection-5cd7f36a` at `d268092d7b` on
  endolin-garden has engine+ROOT target, oracle at the pin, and real bundles), then clean the 3 crates;
  confirm tip sha + clean status before trusting a seeded cache; seed real bundles from a sibling's
  `rust/endo/xsnap/src/*.js`; never commit bundles.

Report via your tada completion report ONLY (never inbox-send the parked supervisor): the commits pushed,
the exact reflection gaps closed (per method, with the arity source line in the pinned C), F2/F3 outcome,
and the bars at each pushed tip. If you discover MORE bound-but-unreflected natives than named here, that
is expected — close them all and enumerate them.
