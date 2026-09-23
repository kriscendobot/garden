<<<REPORT>>>

## Fixer: side-table ledger restore truthfulness — PR #600 (`xs2rust-endor`, kept DRAFT)

Isolated project worktree, synced to real remote tip `2208ba8ad5`, oracle seeded from a sibling checkout at pin `23b4d6b0a65f` (never `git add c/moddable`). Pushed to `origin xs2rust-endor` (CAS attempt 1, HEAD now `14febb8093`).

### Per-row disposition

**1. `SideTable::GlobalProps` — REBUILD LANDED** (was `InArena` → now `RebuiltAtRestore`).
The global object's own-property *slots* round-trip inside the slot arena (linked into `global_obj`'s chain by `create_global_property`), but the `global_props` id→slot fast index that `resolve_get`/`resolve_set` consult is a HashMap, not arena state, left empty by boot. Added `rebuild_global_props` — walks the restored chain to reconstruct the map exactly (chain↔map are 1:1). Bounds-checks every index and caps the walk at the slot count so the malformed-atom fuzz path cannot panic/hang on a garbage/cyclic `next`.
Locked test: `runtime_global_survives_suspend_resume` (`tests/restore_side_tables.rs`).

**2. `SideTable::CtorPrototype` — RECLASSIFIED PENDING** (was `InArena` → now `Pending`).
Determined the link is **not** arena-recoverable: `new_function` stores the constructor→`.prototype` link in the `ctor_prototype` HashMap only — it is never installed as an arena property slot — and reaching it also needs the `functions` table (already Pending). Empirically confirmed a truthful cross-crank `new f()` test is unreachable today regardless of restore (the *uninterrupted* machine already aborts cross-crank construction, `completed=false`), which is the deciding evidence the row cannot be claimed covered.
Locked test: `pending_is_derived_from_ledger` extended to assert `CtorPrototype` is now Pending.

**3. `SideTable::SymbolTables` — REBUILD LANDED** (was `Serialized` → now `RebuiltAtRestore`).
Only `symbol_names` is serialized; `symbol_ids` (inverse) and `next_intern_id` are derived by `link_intrinsics` at boot and never persisted, so after restore they stayed empty / at `1` (a novel runtime key would collide with a program symbol id, and every by-name global read broke). Extracted the pure name→tables derivation into `bind_program_symbols` (shared by `link_intrinsics` and `restore_snapshot_state`, so the two can't drift) and call it at restore on the restored names — also re-deriving the name-keyed lookup-id caches (`length_id`/`name_id`/… + RegExp clusters).
Locked test: `symbol_tables_rebuilt_at_restore` (`tests/restore_side_tables.rs`).

### Taxonomy honesty + minor
- Added a dedicated `Coverage::RebuiltAtRestore` variant (documented vs. `InArena`/`BootDerived`) rather than stretching the old contracts; new test `rebuilt_at_restore_rows_are_classified_honestly` asserts the two rebuilt rows carry it and no row still claims a false `InArena`.
- Added the explicit **excluded-transients list** to the module docs — per-activation registers (`args`/`this_val`/`cur_func`/`cur_target`/`exception`/`locals`/`frame_slots`/`id_map`/`resume_status`) and the boot/program-symbol caches (`intrinsics`/`*_proto`/`proto_methods`/`proto_data`/`well_known_symbols`/`default_keys`/`math_object`/`static_str`/`*_id` caches/`regexp_*_ids`) — each with a one-line rationale for why exclusion is sound at the quiescent suspend point.

### Measured bars (at tip, `$?` checked)
- `cargo test --workspace -- --test-threads=1` (from `rust/engine`) → **EXIT=0**, every `test result:` line **0 failed** (includes the fuzz `decoder_never_panics_on_arbitrary_or_mutated_bytes`, which my arena walk initially regressed and the bounds/cycle guard fixes).
- `./target/debug/compile-diff` (built first, invoked directly) → **EXIT=0**, **1711/1711 identical**, **SYMB 1711/1711 identical**.
- `#![forbid(unsafe_code)]` untouched (no `unsafe` added anywhere).
- PR #600 left DRAFT; committed with explicit pathspecs (interp.rs, sidetable.rs, endor-snapshot Cargo.toml, restore_side_tables.rs, Cargo.lock); pushed, verified by git exit code.

Files changed: `rust/engine/endor-vm/src/interp.rs`, `rust/engine/endor-snapshot/src/sidetable.rs`, `rust/engine/endor-snapshot/Cargo.toml` (+`endor-compile` dev-dep for the pure-Rust compile path), `rust/engine/endor-snapshot/tests/restore_side_tables.rs` (new), `rust/engine/Cargo.lock`.

Follow-ups (not in scope, noted for the ledger's remaining work): `CtorPrototype`/`Functions` and the rich per-instance tables remain honestly `Pending` — cross-crank construction and function-call paths need those side tables carried by dedicated atoms before they can be claimed.
