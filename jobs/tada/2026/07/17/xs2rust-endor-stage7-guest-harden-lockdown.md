Inbox empty. All work is committed and pushed to `origin/xs2rust-endor` (tip `c7fcfa100f`); PR #600 remains DRAFT (untouched). Final summary:

---

## Completion report — Stage 7 child 4/7: guest `harden` + full `lockdown()` + `mutabilities`

**Landed** (commit `c7fcfa100f` on `xs2rust-endor`):

Key discovery via oracle probing: the moddable-8.3.1 pin (`mxLockdown`) has **native, fully-working** `harden`/`lockdown`/`petrify`/`mutabilities` — so all three are a **reliable dual-run result oracle**, not just harden. (The old `oracle-shim-unsafe:lockdown` "shim SIGSEGVs" assumption was stale — the shim survives lockdown now.)

1. **`harden` guest global** — was already bound (stage-4 substrate); added 8 dual-run behavioral tests locking transitive-freeze observables (writable/configurable/isExtensible/isFrozen, sloppy-write-fails, function harden, primitive/no-arg passthrough) against native `harden`. All agree.

2. **`lockdown()` full semantics** (`NativeMethod::GlobalLockdown`) — transitively hardens the realm primordials (global object + boot prototypes + intrinsics, `lockdown_roots`) over the harden worklist; after it `Object.isFrozen(Object.prototype)`/`Object.isFrozen(Math)` are true; returns `undefined`; one-shot `locked_down` latch throwing `TypeError: lockdown already called` on a second call.
   - **Options implemented vs stubbed:** the taming options bag (`errorTaming`/`dateTaming`/`mathTaming`/…) is **accepted as a no-op** — *not* stubbed-with-named-error, because endor's sparse intrinsic set has no tamed surface to alter and the pin *accepts* `lockdown(options)` without throwing; rejecting would diverge from the oracle. There is no lockdown option endor rejects, by design, to hold result parity.
   - **Named gap:** an exotic primordial (side-table instance) is skipped rather than frozen (lockdown is a realm sweep, not a targeted harden that self-names).

3. **`mutabilities()`** (`GlobalMutabilities`) — returns an empty Array (the residue report), matching the pin's `[]`.

4. **Skip flips my work makes real** (`ses-mode:lockdown-unimplemented`): flipped `SesMode::Lockdown.unimplemented_skip()` → `None` and wired the `lockdown();\n{body}` prelude into `run_case` (sync + async), so the `-l` third-host axis genuinely runs and dual-runs against native lockdown. Removed `lockdown` from `DEFAULT_ENDOR_SKIP_FEATURES`. Removed the stale `oracle-shim-unsafe:lockdown` partition. **`feature:Compartment` / `-c` / `-lc` left skipped** (guest `Compartment` intrinsic is out of this child's scope).

**Verification (all green):**
- `cargo test --workspace -- --test-threads=1` → EXIT=0, 32 `test result: ok`, 0 failed (incl. 3 new endor-vm units + 7 new endor-262 dual-run tests).
- `./target/debug/compile-diff` (curated) → EXIT=0, **1711/1711 identical + SYMB 1711/1711**.
- endor-xst `built-ins/Object language/global-code` → 186 covered, **0 failed**.
- endor-xst `-l` third-host axis over `built-ins/Boolean` → **0 failed**, coverage grew (whole-axis skip → 16 covered vs 14 baseline) — proves the prelude runs `lockdown();` on every case end-to-end.
- endor-xst `-l --feature-filter ses-xs-parity --features-include ses-xs-parity built-ins` → **0 failed**, `ses-mode=l`, 2 honest `feature:Compartment` skips.
- `#![forbid(unsafe_code)]` intact.

**Honest remainder / follow-ups:**
- Idempotence-throw is verified **endor-only** (not dual-run): an endor native signals a throw as a host-escaping `Halt::Throw`, not a guest-catchable exception, so the `try{lockdown()}catch` shape the oracle completes can't dual-run. Making native throws guest-catchable is a pre-existing endor limitation, out of scope here.
- End-to-end `ses-xs-parity` corpus coverage is still 0 covered / 0 divergent because **both** corpus files require the guest `Compartment` intrinsic (a later child); the `-l` coverage growth shows on Compartment-free suites.
- lockdown's transitive computron count over sparse intrinsics remains result-gated (structurally, as with harden), not computron-gated.
