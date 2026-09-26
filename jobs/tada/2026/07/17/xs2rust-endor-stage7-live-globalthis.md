All gates are green and the work is landed. Here is my completion report.

---

## Stage 7 child 1/7 — live `globalThis` binding — COMPLETE

**PR:** `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (kept DRAFT). Commit `05dda5747d` pushed (`1559f85856..05dda5747d`).

### What I did
Bound `globalThis` as a first-class, live realm global over the real global object, and kept the global object's own-property state coherent with identifier resolution.

**`endor-vm/src/interp.rs`:**
1. **`link_intrinsics`** — binds `globalThis` → `Reference(global_obj)` as an unmetered realm global (present before the guest runs). From it being an ordinary global property over `global_obj`, three properties follow for free: identifier `globalThis` resolves through the same `global_props` fast index; `globalThis.x` walks `global_obj`'s chain; `globalThis.globalThis === globalThis` is exact.
2. **`instance_put`** — when `inst == global_obj`, a new property (`globalThis.x = 1`) routes through `create_global_property` (the sole `global_props` writer), so identifier resolution sees the new global (`globalThis.x = 1; x` → 1). Metering unchanged (536 property-create, charged once).
3. **`delete_own_property`** — drops the `global_props` entry when deleting from `global_obj`, so a freed slot is never re-read.
4. Updated the `rebuild_global_props` doc to keep the one-to-one chain↔map invariant claim truthful.

**`endor-snapshot/src/sidetable.rs`** — no new side table; extended the `GlobalProps` ledger comment to name the `globalThis.x = 1` create path (classification stays `RebuiltAtRestore`, and restore genuinely re-derives it).

**`endor-262/tests/globalthis_live_binding.rs`** (new) — 8 dual-run behavioral tests locking §1/§2 (result-agreement gate).

**`endor-262/src/lib.rs` + `README.md`** — advanced the ledgered boot-bundle anchor: bundles no longer stop at `boot:no-globalThis-global-object-binding`; they now advance past their opening `globalThis` read to the next honest self-named gaps (`boot:unsupported:to_instance` ×2, `boot:unsupported:at` ×1), still zero divergence.

### Verification (all captured, `$?` checked)
- New behavioral tests: 8 passed / 0 failed.
- `cargo test --workspace -- --test-threads=1`: EXIT=0; all 27 `test result:` lines 0 failed (this surfaced the anticipated ledger flip, which I updated and re-greened).
- `compile-diff` (curated): 1711/1711 identical + SYMB 1711/1711 (compiler untouched).
- `endor-xst built-ins/Object`: 182 covered / 0 failed — **no regression** (baseline on unchanged sibling: 182/0).
- `endor-xst language/global-code`: 4 covered / 0 failed — **no regression** (baseline: 4/0).
- `#![forbid(unsafe_code)]` intact on every crate touched; no `unsafe` added.

### Notes / follow-ups
- The boot bundles' next real gaps — `boot:unsupported:to_instance` and `boot:unsupported:at` (opcode-level surfaces) — are the natural next stage-7 children on the boot-surface critical path; they are now the ledgered anchor.
- Oracle pin (moddable 8.3.1, `23b4d6b0…`) was copied from the s20 sibling scratch worktree into the project `c/moddable` submodule; never `git add`ed (excluded from the commit via explicit pathspecs).
