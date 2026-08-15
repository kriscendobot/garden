---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cf-resid
priority: normal
posted_by: gardener
posted_at: 2026-08-15T01:02:24Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: built-ins/Array non-dense fast paths

**Scope:** the `built-ins/Array` (~429 cases) subset in this cluster — the non-dense /
holey-array and abrupt-completion fast paths surfaced by the parent's example set:
`copyWithin` (call-with-boolean, fill-holes, length-near-integer-limit, return-abrupt-from-
delete/get-start/has-start/set-target on a Proxy or plain target), and the sibling holey-array
behaviors in `fill/lastIndexOf/indexOf/includes/flat/flatMap` etc.

**Reason families:** `ironhorse-aborted` + `abort-value-differs` dominate — these exercise
the generic (non-dense) element machinery: `HasProperty`/`Get`/`Set`/`DeleteProperty` over holes,
Proxy-trap abrupt completions, and `ToLength` near 2^53. Many are gated on the general
object-model prerequisite noted above (Proxy trap results + `.constructor` inspection).

**Engine sites:** interp.rs Array prototype method arms + the generic property MOP
(`arraylike_length`, HasProperty/Get/Set over sparse indices). Existing
`array_generic_receiver` test is the pattern.

Part of the **js-26 TypedArray/ArrayBuffer residual-closure** effort, re-decomposed
from the oversized parent `ironhorse-js-26-cf-typedarray-arraybuffer` (PR endojs/endo-but-for-bots#970
head `b3c3ae93`). Parent closed the ArrayBuffer/SharedArrayBuffer constructor ToIndex-coercion +
catchable errors (landed on `feat/ironhorse-262-language-completion`, head `1c41b9a61`).

**Shared branch/PR:** `feat/ironhorse-262-language-completion` (PR #970 — OPEN draft, keep open, do NOT
merge). Fetch+preserve prior commits, stack bounded commits, push with a rebase CAS loop. Serial — fetch+rebase before push.

**Pins:** engine head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; test262
`tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`
(`git submodule update --init --depth 1 c/moddable`). PATH prepend `$HOME/.cargo/bin`; TMPDIR off noexec.
Cached test262 at pin: `/home/kris/garden/scratch/test262-pin-be13516f` (`--test262-dir … --no-fetch`).

**Acceptance bar:** convert to **covered** via real execution against the XS oracle
(`scripts/full-run.sh --subtree <PREFIX> --test262-dir <pin>`), except a justified standards-grounded
host-only/proposal exclusion. Add Rust regression tests under `rust/engine/ironhorse-262/tests/`.
Do NOT relabel/suppress/skip-list. Zero generic `ironhorse-aborted`, `parse-or-decode`,
`unsupported-opcode:*`, `abort-value-differs`, `non-primitive-completion` in scope.

**Regression invariant:** no covered baseline/earlier-child case regresses; no new
`ironhorse-failure`/`infrastructure`; exact-metering corpus green
(`ironhorse-xst --gate-meter-exact rust/engine/ironhorse-262/cases` + `cargo test --workspace --release`).
Run the affected slice + gates before EVERY push.

**CROSS-CUTTING PREREQUISITE (from parent):** many error-path cases are blocked by a general
object-model gap (`.constructor` on a user-function instance, `Foo.prototype.constructor`, and
`null`/`undefined` property-access TypeError all abort). `assert.throws(Ctor, fn)` reads
`thrown.constructor`, so error cases stay `ironhorse-aborted` even after the right error is thrown.
This is OUTSIDE the TypedArray cluster (general object-model). Throw the correct error anyway and note the dependency.

**If too large for your budget:** bank verified bounded progress + land it, then sub-decompose the
remainder into a nested halt-on-failure orchestration and hand off. Recursion is expected.

Repository: `endojs/endo-but-for-bots`. issue_spine: issue-kriscendobot-garden-51
