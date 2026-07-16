---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage6
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T21:29:46Z
---

---
model: opus
---
# Stage 6 child 2/6: `endor-snapshot` crate — the XS_M atom container writer/reader

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 6
(Snapshots, design § roadmap row 6 + § Snapshots requirement 1c — READ BOTH from the live tree:
`designs/xs2rust-endor-engine.md`, plus `designs/daemon-xs-worker-snapshot.md` for the container
grammar and callback-table discipline). Child 1 (compiler-seam flip) has already run.

## The work

Create the `endor-snapshot` crate (`rust/engine/endor-snapshot`, `#![forbid(unsafe_code)]` at the
root — the design's unsafe budget for engine crates is ZERO):

1. **The XS_M atom container writer/reader**: the length-prefixed big-endian atom grammar over
   `VERS`/`SIGN`/`CREA`/`BLOC`/`HEAP`/`STAC`/`KEYS`/`NAME`/`SYMB`, with an **endor `VERS`
   discriminator** (an endor snapshot is never mistaken for a C-XS one and vice versa; the C-XS
   importer is OUT of scope — resolved question 3). Host signature scheme unchanged: append-only
   callback table, signature bump on layout change (per daemon-xs-worker-snapshot.md).
2. **The index-based heap serializer**: because the heap is index arenas, the writer is a
   serializer, not a relocator. Serialize the machine's arenas into `HEAP`/`STAC`/`KEYS`/
   `NAME`/`SYMB` payloads and read them back into a fresh machine.
3. **SIDE-TABLE COMPLETENESS (the review ledger's standing snapshot note — this is the bug class
   to design against):** the `HEAP`/`STAC` grammar MUST serialize every side table the engine's
   reachability actually spans: `functions[*].closures`, `CallerState`, `CatchJump` snapshots,
   `global_props`, the regexp/bound-function/promise side tables, `async_instances` +
   `async_run_stack`, generator saved state, module records/maps, and the harden worklist /
   frozen-intrinsics tables. An atom grammar that misses one is the snapshot-shaped version of a
   missing GC root: it round-trips fine on trivial heaps and corrupts on real ones. Enumerate the
   side tables from the live `endor-vm` sources (do not trust this list to be exhaustive — verify
   against `Interp`'s actual fields) and make the enumeration EXPLICIT in the code (a single
   match/struct the compiler forces you to extend when a new table lands).
4. **Locked round-trip unit fixtures**: write→read→write on machines exercising each side table
   (a closure capture, a caught-and-pending exception, a suspended generator, a pending promise
   with reactions, a hardened object graph, a bound function, a live regexp lastIndex, async
   state) asserting (a) second write byte-equals the first, (b) the resumed machine's observable
   behavior continues correctly.

Do NOT wire the `Machine`-level public surface (`write_snapshot_to_file`/`from_snapshot_file`/
`suspend_to_cas`) — that is child 3's job on top of your crate. Keep your surface the atom
container + arena (de)serialization with a narrow, documented API child 3 can call.

## Verification

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (captured to a file, `$?` checked).
- Your round-trip fixtures pass and are committed.
- `#![forbid(unsafe_code)]` at the new crate root; no `unsafe` anywhere in it.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST (child 1 landed
  ahead of you); verify pushes by git exit code; explicit pathspecs;
  `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1); populate c/moddable via
  shallow sha fetch (README § Building the oracle); NEVER `git add` c/moddable.
- Capture test runs to files, check `$?`; `/tmp` is noexec (`bash /path/script.sh`).
- Budget: ONE 2400s invocation. Land green increments; report the honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.
