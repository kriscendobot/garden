---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T00:10:21Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: exotic-builtin completion rendering (Object.prototype.toString tag / typed-array join)

Part of the js-26 residual-closure arc (cluster `ironhorse-js-26-ce-apply-call-toprimitive`, PR
endojs/endo-but-for-bots#970; parent branch head at hand-off `3f24768032`). The parent closed
function-valued completions; THIS child owns the remaining `non-primitive-completion` residue:
an EXOTIC BUILTIN completion value whose XS `String()` is not `[object Object]`.

**Observed (oracle vs ironhorse) — all DISPLAY-ONLY render gaps in `Interp::render`
(`rust/engine/ironhorse-vm/src/interp.rs` ~6298), zero metering impact, same shape as the parent's
function-completion fix:**
- `new ArrayBuffer(8)` → oracle `[object ArrayBuffer]`, iron `[object Object]`
- `new DataView(...)` → `[object DataView]`
- `new Int8Array(3)` → `0,0,0` (typed array stringifies via join of its elements)
- `(function(){return arguments})(1,2)` → `[object Arguments]` (iron WRONGLY renders `1,2`
  because it stores `arguments` in `self.arrays`; fix render, do not change storage)
- objects with a `Symbol.toStringTag` → `[object <Tag>]`

`render` already handles arrays/collections/promises/regexps/errors/wrappers/natives and (new)
user+bound functions; extend it to the builtin exotics above via their internal type maps
(`array_buffers`, `data_views`, `typed_arrays`, the arguments marker) and any `Symbol.toStringTag`
own/inherited property. Date/WeakRef completions currently THROW `ReferenceError` in ironhorse
(a separate constructor gap — OUT of this child's scope; skip those, do not mask them).

**Shared branch:** `feat/ironhorse-262-language-completion` (PR #970 — OPEN, draft, keep open, do
NOT merge). Fetch+rebase before every push (serial arc). `git submodule update --init --depth 1
c/moddable`. Rust: `$HOME/.cargo/bin` on PATH, `TMPDIR` off noexec.

**Acceptance (arc-standard):** convert to `covered` via REAL XS-oracle execution
(`scripts/full-run.sh --subtree <PREFIX> --test262-dir /home/kris/garden/scratch/test262-src-ca`;
clean tree required). Add Rust regression tests under `rust/engine/ironhorse-262/tests/` (mirror
`tests/function_completion_tostring.rs`). No relabel/suppress/skip-list/expectation-file. Before
every push: affected slice + `cargo test --workspace --release` + exact-metering corpus.
Regression invariant: no covered case regresses; no new `ironhorse-failure` (a render that names a
WRONG string turns an honest skip into a divergence — verify each against the oracle). Pins
unchanged (engine `b3c3ae93b8`, test262 `be13516fb6441b950ba8a3df97eb34062c186972`, Moddable
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`).

**Report:** commands, before/after totals for the affected slice, changed reasons, head SHA, PR
URL. Keep PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot
