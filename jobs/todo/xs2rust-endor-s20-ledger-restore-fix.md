---
model: opus
---
# Fixer: make the endor-snapshot side-table ledger's coverage claims truthful at restore

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — keep it **DRAFT**). Workspace `rust/engine` (NOT the repo root); `cargo` at `$HOME/.cargo/bin`. Get an isolated checkout with `scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor` and sync to the REAL remote tip first. Oracle pin `23b4d6b0a65f` (moddable 8.3.1); `rust/engine/README.md` § Building the oracle has the shallow-fetch recipe; never `git add c/moddable`.

**Findings (supervisor stage-6 review, PR #600 issuecomment-4997416149):** the side-table completeness ledger (`rust/engine/endor-snapshot/src/sidetable.rs`) overstates snapshot coverage in three rows — the exact bug class the ledger exists to prevent. `Interp::restore_snapshot_state` (endor-vm/src/interp.rs ~4282) reinstates arenas + stack + `symbol_names` + meter only.

1. **`SideTable::GlobalProps` is classified `InArena`**, but `Interp::global_props` is an authoritative map — `resolve_get`/`resolve_set` (~interp.rs 15658–15686) consult ONLY the map, no arena-walk fallback — and restore never rebuilds it. A runtime-materialized global (`var x = 5` in crank 1) vanishes after suspend/resume. The data is genuinely in the arena (the global object's property list slots carry their ids), so the preferred fix is a deterministic **restore-time rebuild**: walk the global object's property list in the restored arena and repopulate the map. If that is not cleanly reachable, reclassify the row `Pending` instead — never leave the claim false.
2. **`SideTable::CtorPrototype` — same shape** (`InArena`, runtime-populated at interp.rs 3365/6994, consulted at every `new` site, never rebuilt). Determine whether the constructor→prototype link is recoverable from the restored arena (is the function's `.prototype` materialized as an arena property slot?). If yes, rebuild at restore; if not, reclassify `Pending`.
3. **`SideTable::SymbolTables` is classified `Serialized`**, but only `symbol_names` round-trips; `symbol_ids` (inverse map, e.g. interp.rs 3240/9578) and `next_intern_id` are set by `link_intrinsics` (~interp.rs 4080–4130) which restore never calls — both stay at fresh-boot values. Rebuild both from the restored `symbol_names` inside `restore_snapshot_state` (the same derivation `link_intrinsics` performs: invert names → ids, `next_intern_id = names.len()+1`).

**Also (minor, do it):** add to sidetable.rs module docs an explicit excluded-transients list so "enumerated against `Interp`'s actual fields" is auditable: per-activation registers (`args`, `this_val`, `cur_func`, `cur_target`, `exception`, `locals`, `frame_slots`, `resume_status`, `id_map`) and the boot-derived intrinsic/prototype/interned-id caches (`intrinsics`, `*_proto`, `proto_methods`, `proto_data`, `well_known_symbols`, `default_keys`, `math_object`, `static_str`, `*_id` caches, `regexp_getter_ids`, `regexp_result_ids`), with one line each on why exclusion is sound at the quiescent suspend point.

**Taxonomy honesty:** if you land restore-time rebuilds, don't silently stretch `InArena`/`Serialized` — either their doc contracts must say "possibly via a documented restore-time rebuild step" or add a dedicated `Coverage::RebuiltAtRestore` variant. The ledger's one job is that a reader can trust each row without re-deriving it.

**Lock every fix with a regression test** in the shape the review used: crank 1 runs a program that materializes a runtime global and defines a function (`var x = 5; function f(){}` — or split across tests as the bytecode fixtures allow), suspend via `write_snapshot`/`from_snapshot_bytes`, crank 2 on the restored machine reads the global / constructs `new f()` and must behave identically to the uninterrupted machine (result AND computrons). For rows you reclassify `Pending` instead, extend `pending_is_derived_from_ledger` and the module docs. Note: you will need bytecode fixtures with real symbol atoms — follow how `dual_run`/`compile_for` link programs (endor-262) or capture fixtures the way machine.rs tests did; if a truthful cross-crank test is not reachable for a row, that row must be `Pending`, not claimed.

**Bars (binding; measure at your tip, capture to files, check `$?`):**
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, every `test result:` line 0 failed.
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 identical, SYMB 1711/1711 (build first; invoke the binary directly WITHOUT `--`).
- `#![forbid(unsafe_code)]` untouched everywhere.
- Keep PR #600 DRAFT. Commit with explicit pathspecs; push `origin xs2rust-endor` with a rebase-CAS loop; verify by git exit code.

Report via your tada completion report ONLY (never inbox-send the parked supervisor). Name in the report, per row: rebuild-landed vs reclassified-Pending, the locked test names, and your measured bar numbers.
