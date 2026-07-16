Inbox empty. Work complete.

## Completion report

**Job:** Stage 6 child 3/6 — `Machine` snapshot surface + meter state across suspend, on PR `endojs/endo-but-for-bots` #600 (branch `xs2rust-endor`, kept DRAFT).

**What I did**, building on child 2's `endor-snapshot` crate (synced to real remote tip `edf0ebbe81` first):

1. **The xsnap-shaped `Machine` snapshot surface** — a `MachineSnapshot` extension trait on `endor_vm::Interp` exposing `write_snapshot` / `write_snapshot_to_file` (streaming, SHA-256 on the fly) / `suspend_to_cas` (temp-write + atomic rename to `{cas_dir}/{sha256_hex}`), plus `from_snapshot_file` / `resume_from_cas` / `from_snapshot_bytes` reconstructing a live machine. Verb-for-verb match to what the xsnap crate exposes today, so the supervisor swaps engines without surgery. The trait lives in `endor-snapshot` (sees both engine and format); the `Interp`↔image conversion primitives (`stack_slots`/`meter_state`/`restore_snapshot_state`) stay in the engine, honoring image.rs's contract.

2. **Meter state across suspend (design row 6)** — a new `METR` atom carrying the 16.16 fixed-point counters (index/interval/count) plus a frozen, release-versioned cost-table id (`endor-meter-1` — endor's *own* table, never back-fit to the oracle). Resume under a different cost-table version fails closed, the metering analogue of the `SIGN` gate. `SideTable::Meter` recorded as `Serialized` in the completeness ledger (VARIANT_COUNT 27→28).

3. **Dependency-free, `unsafe`-free SHA-256** (NIST known-answer-tested) for CAS content addressing — the engine crates forbid `unsafe` and pull no external deps.

4. **Suspend-point contract documented honestly**: snapshots are taken at machine quiescence *between top-level `run` cranks*, never mid-dispatch (exactly `fxWriteSnapshot`'s constraint and the xsnap between-delivery model). The rich per-instance side tables (closures, generators, promises, …) remain the enumerated `Pending` remainder — a live generator/promise spanning suspend is the honest narrower contract, not a silent gap.

**Verification:**
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → **EXIT=0**, every `test result:` line 0 failed (endor_snapshot 33, endor_vm 82, all others green). Fetched the oracle pin `23b4d6b0…` (moddable 8.3.1) shallowly to build the oracle; never `git add`ed `c/moddable`.
- The row-6 bar locked and green: `suspend_resume_equals_uninterrupted` asserts snapshot→resume→run-to-end equals the uninterrupted A-then-B run in **both** result and final computron count; plus armed-meter survival, full `suspend_to_cas`→`resume_from_cas` round-trip through the store, and cost-table/signature mismatch fail-closed tests.
- `#![forbid(unsafe_code)]` intact everywhere touched (only doc-comment mentions of "unsafe").

**Pushed:** commit `c24cf4aa17` to `origin/xs2rust-endor` (rebase-CAS, verified by git exit + `origin/xs2rust-endor` rev). PR stays DRAFT.

**Honest remainder / follow-ups for later children:** the snapshot carries arenas + stack + program symbol names + meter; runtime-interned keys (`KEYS`), well-known symbol identities (`SYMB`), and the full per-instance side tables stay `Pending`. Cross-crank *persistent-heap* continuity (a crank reading a global a prior crank set) is not yet exercised — it needs the `global_props`/interning tables serialized, which is the natural next increment for machines that carry state beyond the arena+meter surface.
