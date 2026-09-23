Inbox empty. Work is complete, verified green, and pushed. Writing my completion report.

Stage-6 child 2/6 complete. Created the `endor-snapshot` crate on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, kept DRAFT), pushed as commit `edf0ebbe81`.

## What I built

New crate `rust/engine/endor-snapshot` (`#![forbid(unsafe_code)]`, zero `unsafe`), added to the `rust/engine` workspace:

- **`atom`** — the XS_M length-prefixed big-endian FourCC atom container (`XS_M` envelope over `VERS`/`SIGN`/`CREA`/`BLOC`/`HEAP`/`STAC`/`KEYS`/`NAME`/`SYMB`). `AtomWriter`/`AtomReader` with framing-error handling (truncation, bad length, wrong envelope).
- **`format`** — the **endor `VERS` discriminator** (`ENDR` magic + format version + slot width + endianness), so an endor snapshot is never confused with a C-XS one and vice versa (C-XS importer out of scope, resolved question 3); and the host **`SIGN` callback-table signature** scheme (append-only table, signature bump on layout change; a read fails closed on signature mismatch exactly like `fxReadSnapshot`).
- **`slot_codec`** — `Slot` ↔ fixed 20-byte record. Deterministic zero-fill makes write→read→write byte-identical; NaN bit patterns and `NULL` handles preserved exactly.
- **`image`** — `MachineImage` + `write_machine`/`read_machine`, the **narrow, documented API child 3 calls**. Because the heap is index arenas, the writer is a *serializer, not a relocator*: `HEAP`/`BLOC` are the flat arena images and a read reconstructs identical arenas via `SlotArena::from_image`/`ChunkArena::from_image` (narrow accessors I added to `endor-vm/src/value.rs`). I deliberately did **not** wire the `Machine`-level `write_snapshot_to_file`/`from_snapshot_file`/`suspend_to_cas` surface — that's child 3.
- **`sidetable`** — the **side-table completeness ledger** (job item 3, the bug class to design against). One compiler-forced `SideTable` variant per `Interp` side table, enumerated against the live struct (functions+closures, `bound_functions`, `call_stack`, `jumps`/CatchJump, `global_props`, `error_data`, `wrapper_data`, arrays/collections/buffers/typed-arrays/data-views, iterators, promises + functions/guards/jobs, generators + `gen_run_stack`, async_instances + `async_run_stack`, regexps, `ctor_prototype`, symbol registry/tables, modules, harden state). `descriptor()` is an exhaustive match (compile-forced) and each carries its `Coverage`, so a missed table is a compile-checked gap, not a snapshot-shaped missing GC root.

## Verification

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → **WORKSPACE_EXIT=0**, every `test result:` line 0 failed (captured to `/tmp/ws-test.log`, `$?` checked). Oracle built against pin `23b4d6b0a65f` (moddable 8.3.1) after I populated `c/moddable` by seeding from a sibling checkout (never `git add`ed).
- 24 `endor-snapshot` tests pass, including a round-trip fixture over an object graph + closure cell + heap strings + a freed slot + BigInt through the full container (write→read→write byte-equal *and* structural), signature-mismatch-fails-closed, missing-HEAP rejection, and the ledger exhaustiveness guard.
- `#![forbid(unsafe_code)]` at the crate root; grep confirms no `unsafe` anywhere in it.

## Honest remainder / follow-ups

- The rich per-instance side tables marked **`Pending`** in the ledger (functions/closures, call_stack, jumps, promises, generators, async, regexps, arrays, collections, buffers, iterators, modules, harden state, symbol registry) are not yet carried by dedicated atoms — the crate today serializes the index arenas (`HEAP`/`BLOC`), the interpreter stack (`STAC`), and the symbol/key tables (`NAME`/`KEYS`/`SYMB`). Wiring these requires `endor-vm` to expose an `Interp`→image conversion (reading its private fields), which is child-3-adjacent work; the `Coverage::Pending` rows are the compile-checked to-do list.
- Consequently, item 4's *observable-behavior resume* fixtures (a live suspended generator/pending promise resuming correctly) await that `Interp`-level capture/restore path. The fixtures I shipped exercise the serializer against arena shapes modeling those reachability classes.
- The C-XS snapshot importer remains out of scope (resolved question 3).
