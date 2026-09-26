All work is committed and pushed. Here is my completion report.

---

## Stage-6 child 4: snapshot round-trip-invariance + malformed-atom fuzz targets — DONE

**PR** endojs/endo-but-for-bots #600, branch `xs2rust-endor` (kept **DRAFT**). Landed as commit `e26375cbb5` on `origin/xs2rust-endor` (rebase-CAS push, verified by git exit code + branch head).

### What I built
Two fuzz arms in `endor-fuzz` (substance in the `forbid(unsafe_code)` lib per house style; thin libFuzzer wrappers in `fuzz/fuzz_targets/`):

- **`snapshot_roundtrip`** — folds fuzzer bytes into an adversarially-shaped `MachineImage` (slot/chunk arena graph: closures, instances, property chains, bigints, references, a free list, a value stack, symbol/key/name tables, a meter — including boundary values arena-driving never hits: NaN payloads, `u32::MAX` indices), **and** drives the live engine with the existing rich generators (objects/calls/closures/exceptions, bigints, keyed collections, re-entrant array methods). Asserts **write→read→write byte-equality**, plus meter preservation and **suspend→resume→continue transparency vs the uninterrupted run** (result + computron count) for the engine arm.
- **`snapshot_decoder`** — arbitrary and mutated-valid bytes into `read_machine`/`from_snapshot_bytes` must never panic, hang, or allocate unboundedly; every malformed input yields a structured `SnapshotError`.

### Trophies found and locked
1. **Three unbounded-allocation defects** in `endor-snapshot` (`decode_strings`, `decode_u32s`, `decode_heap` free list) pre-reserved a `Vec` sized by an untrusted `u32` count (up to `u32::MAX`) *before* the per-entry bounds check — a malformed container reserved 16–100 GB and aborted the worker instead of failing closed. **Clamped** each pre-reservation to what the payload can hold. Locked as 6 regression tests in `endor-snapshot/src/image.rs`.
2. **Round-trip arm found input `22 03 ff ff`** (real libFuzzer crash): a `Number(NaN)` payload round-trips **byte-exact** (codec preserves the NaN bits) but derived `MachineImage` `PartialEq` reports inequality since `NaN != NaN`. Fix was in the *invariant*, not the codec — assert write→read→write byte-equality (NaN-safe), the exact bar the job names. Locked as a regression test.

### Verification (all captured to files, `$?` checked)
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → **EXIT=0**, all **24** `test result:` lines `0 failed`.
- **cargo-fuzz reality check: a real libFuzzer campaign was reachable.** Installed `cargo-fuzz 0.13.2` (`cargo install cargo-fuzz`, exit 0), nightly present. Both targets built as real libFuzzer binaries. Post-fix campaigns ran green: `snapshot_decoder` **300k runs / 44s**, `snapshot_roundtrip` **400k runs / 15s** — no crashes, rss stable (~400–465 MB, confirming no unbounded allocation). The bounded in-`cargo-test` property loop (thousands of deterministic seeded iterations) is also committed as the always-on in-tree gate.

### Setup note
The `c/moddable` oracle gitlink was empty; seeded it via shallow fetch from a sibling checkout at the correct pin `23b4d6b0a65f` (moddable 8.3.1). Never `git add`ed `c/moddable` (confirmed excluded from the commit).

### Follow-ups
The engine-driven round-trip and suspend/resume arms honor the current honest snapshot contract (arenas/stack/names/meter carried; KEYS/SYMB and the `sidetable`-`Pending` tables travel empty). A **live generator/promise/collection held across a suspend** is the enumerated remaining work (sidetable coverage), so behavioral-continuation over those states is deliberately not asserted yet — it lights up when those atoms land.
