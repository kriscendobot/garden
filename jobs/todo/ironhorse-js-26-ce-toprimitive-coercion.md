---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T00:34:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: ToPrimitive object-to-primitive coercion (valueOf/toString/@@toPrimitive)

Part of the js-26 residual-closure arc (cluster `ironhorse-js-26-ce-apply-call-toprimitive`, PR
endojs/endo-but-for-bots#970; parent branch head at hand-off `3f24768032`). THIS child owns the
ToPrimitive coercion family — an object coerced to a primitive whose result ironhorse cannot yet
produce.

**In-scope skip reasons (`rust/engine/ironhorse-vm/src/interp.rs`, `to_primitive` ~28106 and
`call_primitive_method` ~28060):**
- `unsupported-opcode:to_primitive:no-primitive-result` (~28137) — `@@toPrimitive`/valueOf/
  toString returned a non-primitive (or the callee path is unmodeled).
- `unsupported-opcode:to_primitive:non-callable` (~28076) — the coercion method is not callable.
- `unsupported-opcode:to_primitive:native-method` (~28097) — a native `valueOf`/`toString`
  (e.g. a boxed wrapper, Date) as the coercion method; route through `call_native_method`.
- The completion-render residue where a completion object has a USER `toString`/`valueOf`
  (e.g. `var x={toString(){return 'hi'}}; x` → oracle `"hi"`, ironhorse `[object Object]`).
  This needs re-entrant coercion at completion time (post-run `String(result)`), analogous to
  the existing Symbol/null-proto completion handling in `Interp::run` (~6424-6442).

The meter is ADVISORY for test262 coverage (only observable agreement gates); the meter-exact
gate applies ONLY to `rust/engine/ironhorse-262/cases/**`. Prefer reusing the existing
re-entrant native-method dispatch (`call_native_method`) and `run_callback` substrate.

**Shared branch:** `feat/ironhorse-262-language-completion` (PR #970 — OPEN, draft, keep open, do
NOT merge). Fetch+rebase before every push (serial arc). `git submodule update --init --depth 1
c/moddable`. Rust: `$HOME/.cargo/bin` on PATH, `TMPDIR` off noexec.

**Acceptance (arc-standard):** convert to `covered` via REAL XS-oracle execution
(`scripts/full-run.sh --subtree <PREFIX> --test262-dir /home/kris/garden/scratch/test262-src-ca`;
clean tree required). Add Rust regression tests under `rust/engine/ironhorse-262/tests/`. No
relabel/suppress/skip-list/expectation-file. Before every push: affected slice + `cargo test
--workspace --release` + exact-metering corpus. Regression invariant: no covered case regresses;
no new `ironhorse-failure`. Pins unchanged (engine `b3c3ae93b8`, test262
`be13516fb6441b950ba8a3df97eb34062c186972`, Moddable `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`).

**Report:** commands, before/after totals for the affected slice, changed reasons, head SHA, PR
URL. Keep PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot
