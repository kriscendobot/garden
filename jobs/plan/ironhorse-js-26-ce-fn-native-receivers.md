---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ce-residual
priority: normal
posted_by: gardener
posted_at: 2026-08-15T00:06:57Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: Function apply/call/bind + Array-method callbacks on NON-USER-FUNCTION (native) receivers

Part of the js-26 residual-closure arc (cluster `ironhorse-js-26-ce-apply-call-toprimitive`,
measured on PR endojs/endo-but-for-bots#970). The parent cluster's `non-primitive-completion`
sub-family (function/class/arrow/bound completions rendered via `Function.prototype.toString`)
was ALREADY CLOSED by commit `feat(ironhorse): render function-valued completions via
Function.prototype.toString` (branch head at hand-off `3f24768032`). THIS child owns the
remaining `unsupported-opcode` namesake family: invoking a callable whose receiver/callback is
a NON-USER (native/bound) function.

**In-scope skip reasons (all in `rust/engine/ironhorse-vm/src/interp.rs`):**
- `unsupported-opcode:call:non-user-function-receiver` (`enter_call_dot_call`, ~line 15952)
- `unsupported-opcode:apply:non-user-function-receiver` (`enter_call_dot_apply`, ~16024)
- `unsupported-opcode:apply:sparse-arguments-array` / `apply:arguments-array` (~16062/16071)
- `unsupported-opcode:call:primitive-this-boxing` / `apply:primitive-this-boxing` (~15980/16045)
- `unsupported-opcode:bind:non-user-function-receiver` (~15741)
- `unsupported-opcode:bind:new-bound` (~8513) and `bind:bound-callback` / `bind:call-target`
- `unsupported-opcode:callback:non-user-function` (`run_callback`, ~10723/10752)

Each self-names because invoking a native receiver/callback re-entrantly needs the calibrated
metering the authors deferred. NOTE: for test262 coverage the computron meter is ADVISORY
(only observable result/error agreement gates); the meter-exact gate applies ONLY to the
proprietary `rust/engine/ironhorse-262/cases/**` corpus. So the path to `covered` is to route a
native receiver/callback through the existing `call_native` / `call_native_method`
machinery (see `to_primitive` at ~28078 for the re-entrant-native-method pattern) and produce
the correct observable result; then confirm no `cases/**` meter-exact case regresses.

**Shared branch (do not create a new one):** work on `feat/ironhorse-262-language-completion`
(PR endojs/endo-but-for-bots#970 — OPEN, draft, keep open, do NOT merge). Fetch+rebase before
every push (serial arc; peers push to the same head). Init the XS oracle submodule:
`git submodule update --init --depth 1 c/moddable`. Rust: prepend `$HOME/.cargo/bin` to PATH,
set `TMPDIR` off any noexec mount.

**Acceptance (identical to the arc, non-negotiable):** convert cases to `covered` via REAL
execution against the XS differential oracle (`rust/engine/ironhorse-262/scripts/full-run.sh
--subtree <PREFIX> --test262-dir <pinned checkout>`; a clean tree is required — commit first).
Add focused Rust regression tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel,
suppress, skip-list, or add expectation files. Before every push run the affected official slice,
`cargo test --workspace --release`, and the exact-metering corpus (via
`corpus_conversion_equivalence`). Regression invariant: no covered case regresses; NO new
`ironhorse-failure` may appear (in particular, do not render an unnameable receiver as a wrong
value — keep the honest skip until the result is correct). Pins unchanged: engine head
`b3c3ae93b8`, test262 `be13516fb6441b950ba8a3df97eb34062c186972`, Moddable
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. A pinned test262 checkout at the exact SHA exists at
`/home/kris/garden/scratch/test262-src-ca`.

**Report:** commands run, totals before/after for the affected slice, changed skip reasons, head
SHA, PR URL. Keep the PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot
