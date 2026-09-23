All findings fixed, verified, committed, and pushed. PR #600 remains DRAFT.

## Completion report

**Job:** Fix PR #600 (`endojs/endo-but-for-bots`, branch `xs2rust-endor`, kept DRAFT) stage-7 review findings F3/F1/F2 in the `rust/engine` workspace.

**Note on resume:** my first two sessions' uncommitted work was lost to reaper requeues (the worktree was recreated at the rebased remote tip). This session redid all edits and **committed + pushed before running the long bars** so the work is now durable. Remote tip = `4010c8f19c` = my commit.

**F3 — parent-realm globals leaked into child Compartments (gating divergence, now fixed):**
- Built a shared **intrinsics-only holder** object at boot in `create_intrinsics`; `link_intrinsics` now mirrors each intrinsic reference slot (constructors, `Math`/`JSON`/`Reflect`, `harden`/`lockdown`, value globals) onto it — but no `globalThis` and no runtime global.
- `Native::Compartment` construction now chains the child global's prototype to the holder instead of the live `global_obj`. Intrinsic identity stays shared (`c.globalThis.Object === Object`); parent runtime globals no longer leak.
- Added the holder to `lockdown_roots()` so it freezes with the realm. Updated the `GET_PROPERTY` `globalThis`-by-id and construction comments.
- Dual-run regressions lock both leak directions (parent global defined before AND after construction, plus a sloppy assign) → `undefined` on both engines.

**F1 — unledgered `compartments` side table:** added `SideTable::Compartments`, classified honestly `Pending` (HashMap-only instance→child-global link, not arena-recoverable — the `CtorPrototype`/`SymbolKeyIds` shape) with deciding-evidence comment; bumped `VARIANT_COUNT` 30→31, extended `ALL`. The new boot-derived `intrinsics_holder` field is recorded in the excluded-transients list.

**F2 — `locked_down`'s false round-trip claim (real fix, small format change):** added an additive `RELM` realm-scalar atom carrying the lockdown latch (absent → boot default `false`, the METR backward-compat discipline; no format-version bump). Wired through `MachineImage`/`write_machine`/`read_machine`/`with_locked_down`, `restore_snapshot_state`, and a new `Interp::is_locked_down()`. Corrected the field doc. Regressions: cross-crank lockdown → snapshot → restore → second lockdown still throws AND primordials observed frozen; plus a byte-level `RELM` round-trip (true + absent-atom-defaults-false).

**Verification bars (all from `rust/engine`, captured, `$?` checked):**
1. `cargo test --workspace -- --test-threads=1` → EXIT=0, all 33 `test result:` lines 0 failed.
2. `compile-diff` → 1711/1711 identical + SYMB 1711/1711, EXIT=0.
3. `endor-xst built-ins/Compartment Object Promise` → 291 covered (Object 182 + Promise 109 + Compartment 0), 0 failed — no coverage regression.
4. `endor-xst -l built-ins/Boolean` → 16 covered / 0 failed; ses-xs-parity filter → 0 failed.
5. `#![forbid(unsafe_code)]` intact at every engine crate root; the only 2 warnings (interp.rs lines 9476, 10842) are pre-existing, outside all my diff hunks.

**Follow-ups:** none required. The s23 supervisor (parked, reads the board) will re-run the full 121-run enumeration per the boot-path-change note; I did not message it.
