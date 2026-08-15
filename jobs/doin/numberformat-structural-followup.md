---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-51
---

# NumberFormat structural residue: function length/name descriptors, Intl-namespace string-key install, multi-realm, native subclassing

Successor to child `numberformat-getter-structural`, which landed the
`Intl.NumberFormat.prototype.format` **accessor getter** (real accessor property;
getter returns a cached `[[BoundFormat]]`), plus three general fixes
(`Object.prototype.toString` → `[object Function]` for callables;
`Reflect.construct` requires `IsConstructor`; a thrown property getter routes
through the enclosing `catch`). That child converted **10** intl402/NumberFormat
cases to the accepted terminal (`oracle-host-missing-intl`): slice moved from
89→**99** accepted of 249, **0 regressions**. Commits landed on shared branch
`feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970, keep
OPEN) through head `258c603f7`.

**Remaining structural cases in the slice, each blocked on GENERAL engine
infrastructure beyond the format getter (measured with
`rust/engine/ironhorse-262/scripts/full-run.sh --subtree intl402/NumberFormat`):**

1. **Function `.length`/`.name` are not real own properties** (suite-wide gap).
   They are synthesized in the `GET_PROPERTY` special-case (interp.rs ~9059), so
   `Object.getOwnPropertyDescriptor(fn,'length'|'name')` returns `undefined` and
   `verifyProperty`/`verifyConfigurable`/`verifyNotWritable` fail. Confirmed for
   BOTH user and native functions (e.g. `getOwnPropertyDescriptor(function(a){}, 'length')===undefined`).
   Making these real, non-writable/non-enumerable/**configurable** own data
   properties (matching XS `fxNewFunctionInstance`/`fxNewFunctionLength`/
   `fxNewFunctionName`, WITH exact metering) closes, in this slice:
   `prototype/format/length.js`, `prototype/format/name.js`,
   `prototype/format/format-function-length.js`,
   `prototype/format/format-function-name.js`, top-level `length.js`, `name.js`.
   NOTE: suite-wide impact — this is every built-in's `length.js`/`name.js`
   prop-desc test across test262. High metering-regression risk; gate on the
   `--gate-meter-exact` corpus and `cargo test --workspace --release`.

2. **Intl-namespace constructor properties reachable only by string key.**
   Top-level `prop-desc.js` does `verifyProperty(Intl, 'NumberFormat', {...})`
   with `'NumberFormat'` as a string (never a static `.NumberFormat`), so it is
   not in the compiler SYMB atom and the `proto_methods` install gate
   (`install_intrinsic_bindings`) skips it → `getOwnPropertyDescriptor(Intl,
   'NumberFormat')` is `undefined`. Mirror the `proto_accessors` guard the getter
   child added: force-install the `Intl.*` constructor properties (guarded so a
   non-Intl program's metering is untouched — any `Intl` global reference already
   aborts the Intl-less oracle). Closes top-level `prop-desc.js`.

3. **Multi-realm.** `proto-from-ctor-realm.js` needs `$262.createRealm()` and
   `GetPrototypeFromConstructor` fallback to the realm's `%NumberFormat.prototype%`
   when `newTarget.prototype` is not an object. Out of reach until the harness
   `$262.createRealm` surface exists.

4. **Native subclassing + native-method map callback.** `subclassing.js` does
   `class MyNumberFormat extends Intl.NumberFormat { constructor(){ super(...) } }`
   and `a.map(nf.format)`. Two gaps: (a) a derived class extending a NATIVE base
   with `super()`; (b) `Array.prototype.map` invoking a native-method callback —
   `run_callback` rejects native callees (`callback:non-user-function`), the same
   limitation the getter child worked around only for the accessor-get path via
   `invoke_getter`. Generalizing `run_callback` to dispatch native-method
   callbacks would also help other slices.

**Pins (unchanged):** shared branch `feat/ironhorse-262-language-completion`
(PR #970, keep OPEN, do NOT merge); test262
`tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Rust: prepend `$HOME/.cargo/bin` to
PATH; `TMPDIR` off noexec. Fetch+rebase before every push (CAS loop).

**Acceptance bar (non-negotiable):** genuine `covered` or standards-grounded
`oracle-host-missing-intl` via REAL execution; no classifier weakening, relabel,
suppress, skip-list, or expectation files. No `covered` baseline regression; no new
`ironhorse-failure`/`infrastructure`; `--gate-meter-exact` corpus and
`cargo test --workspace --release` stay green. Item 1 (function length/name) is the
highest-risk; if it destabilizes metering, sub-decompose it further and hand off —
do NOT partially relabel.

**NOTE:** the `legacy-constructed-symbol` trio named in the parent scope does NOT
exist in the pinned test262 revision (verified: no
`intl-legacy-constructed-symbol*` under `intl402/`); it was added upstream after
`be13516fb6`. No action needed unless the test262 pin advances.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-15T04:56:50Z
