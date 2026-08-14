---
role: mentor
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-14T23:34:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 1/7: `hasOwnProperty` receiver/key/exotic coverage

Nested child of `ironhorse-js-26-cc-object-mop-exotic-closure`, splitting the 1333-case Object-MOP cluster measured at `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b` into bounded causal work.

Repository: `endojs/endo-but-for-bots`. Work only on the existing open draft PR endojs/endo-but-for-bots#970, branch `feat/ironhorse-262-language-completion`; do not merge or open another PR. Use `ensure-project-worktree.sh` with this child basename, fetch first, preserve all prior commits, and push by fetch/rebase/CAS to that shared branch.

Implement the ECMA-262 `Object.prototype.hasOwnProperty` path through `ToObject`, `ToPropertyKey`, and the receiver's `[[GetOwnProperty]]`, including primitive boxing, canonical/non-canonical index keys, arrays/functions/string wrappers and other already-modeled exotics, symbols, and Proxy traps/invariants. Remove the in-scope `hasOwnProperty:non-string-key` and `hasOwnProperty:index-key` unsupported exits by real semantics, not classification changes. Keep overlap with the later typed-array cluster limited to the generic object-MOP seam; record residual typed-array-specific behavior for that already-posted child rather than suppressing it.

Pins: test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Prepend `$HOME/.cargo/bin` to PATH and put `TMPDIR` on an executable mount. Add focused oracle-backed Rust regressions under `rust/engine/ironhorse-262/tests/`. Run the affected official test262 slices with `full-run.sh --subtree ... --test262-dir <pinned checkout>`, `cargo test --workspace --release`, and the entire proprietary `ironhorse-xst --gate-meter-exact` corpus before pushing. No baseline-covered case may regress, no new failure/infrastructure result may appear, and exact computron expectations must not change. Report commands, before/after slice totals, changed unsupported reasons, pushed SHA, and https://github.com/endojs/endo-but-for-bots/pull/970.

If implementation genuinely completes but a required gate does not pass, end the report with the exact orchestration-failure signal immediately before the normal completion signal.
