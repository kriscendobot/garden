All work committed and pushed; PR #600 stays draft (untouched). Writing the honest-partial report.

---

## Completion report — stage-8d child 1/2: engine boot-surface remainder r2

**Setup.** Isolated project worktree keyed to this job base, synced to the real remote tip `2ef06cfdde` (clean), seeded `rust/engine/target/` + `c/moddable` by `cp -al` from the same-commit sibling. Baseline gate green (14/14).

**What landed (pushed, verified green):**

**Item 2 — `String.raw`: DONE.** Bound `String.raw` as a static on the `String` constructor (`fx_String_raw`, `xsString.c`): reads `template.raw`, its `length`, interleaves `ToString` of each literal segment with `ToString` of each substitution into one fresh chunk; models a plain-array `.raw` with primitive segments/subs and honest-skips an object segment/substitution (would need re-entrant `toString`).
- Promoted boot_bundle_gate `skip_assert_error_formatting_needs_string_raw` → green `boot_step_assert_error_formatting_string_raw_agrees`.
- Added `endor-262/tests/string_raw.rs` — 10-test dual-run behavioral gate (result agreement + self-name coverage for the object-substitution and tagged-template surfaces).
- **Bars:** workspace `cargo test --workspace` EXIT=0, **35** `test result:` lines all `0 failed` (+1 = the new file); `endor-xst built-ins/String/raw` = **3 covered, 0 failed** (26 honest named skips), up from 0 covered before binding; `forbid(unsafe_code)` intact; no new warnings; the suspected `module_corpora_byte_identity` flake did **not** fire. Commit `4f0ea7a830`.

**Items investigated but NOT implemented (each too large to finish+verify in budget; sizing discipline → land the green item first). Ledger corrected + pushed (commit `43b6128e18`):**
- **Item 1 — "method shorthand":** reclassified. Probe proved object-literal-with-method-shorthand construction is **already green** (`({toString(){…}})` builds; `o.toString()` calls, both agree). The `Unsupported("add")` halt is one opcode later: `XS_CODE_ADD` with an object operand needs **ToPrimitive** (a mid-opcode re-entry into `@@toPrimitive`/`valueOf`/`toString`) that `op_add` self-names on a `Kind::Reference`. Renamed the skip test + corrected its comment to name the true surface.
- **Item 3 — the `at` skip:** precise site is `globalThis['trace']` in host_aliases' `for-in` loop — a *runtime* default-key string that `resolve_at_key` self-names to avoid an unsound absent-own-vs-inherited-builtin read. Clearing it is a receiver-aware soundness change (consult the modeled chain), deferred as its own increment. Ledger comment corrected.
- **Item 4 — HandledPromise (investigate-only):** the eventual-send shim installs `globalThis.HandledPromise` as a full constructor + WeakMap-backed handler side table + four eventual-send ops (each re-entering user handlers) — an async-stage subsystem, not a small primitive. Named skip stays; finding recorded.

**Follow-ups for the next child:**
1. ToPrimitive-in-`add` (needs the native→JS call trampoline) — clears the method-shorthand/`add` skip.
2. Receiver-aware `resolve_at_key` soundness fix — clears the host_aliases `at` skip.
3. Tagged-template `template_cache` — reaches `String.raw\`…\``, the assert shim's actual call form (the explicit-call form is now covered).
4. HandledPromise subsystem (async stage).
5. Advisory: String.raw carries a small, consistent computron gap vs the oracle — endor meters its own list-slot/render/chunk allocations and deliberately does not back-fit XS's per-`mxGetID` accounting (accuracy-over-parity); regression cases left untagged for meter-exact.

PR #600 remains DRAFT; nothing else touched. Two commits pushed to `xs2rust-endor`, tip `43b6128e18`.
