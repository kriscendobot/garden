Inbox empty. All DoD items are met and verified. Here is my completion report.

---

## Completion report — `xs2rust-endor-stage10c-cross-turn-symbols` (PR #600 stage-10c child 1/5)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, kept DRAFT, not commented). Synced to real tip `43de4567f6` before starting; pushed two commits (`0a34e82a75` engine, `d27a579659` worker), both on `origin/xs2rust-endor` via fast-forward CAS.

### What I did

**Cross-turn SYMBOL resolution is closed** — a prior-turn function body now resolves intrinsics, named globals (read *and* write), and property keys against the SAME bindings the current turn does.

**Design chosen (least machinery, per the judge-the-tree instruction): a persistent canonical symbol space + per-turn id rewrite at retain time.** Rather than retaining per-turn symbol tables and swapping symbol context on every cross-region frame entry/exit (the resume point stage-10b named — which would also have to swap the many cached intrinsic ids `length_id`/`name_id`/… and keep the global object keyed under every turn's numbering), I canonicalize **once per turn, at append time**:

- `Interp::canonicalize_turn_symbols` folds each turn's program-local symbol ids into one **realm-wide, append-only** symbol space (built dense and id-indexed off the existing `symbol_ids`, so every id already in use — program symbols *and* runtime-interned keys like `constructor` — keeps its id; new names land past the high-water mark, so they can never collide with a runtime-interned id). It re-links only *newly-referenced* intrinsics; all prior globals persist keyed by their canonical ids (no reset, no re-key — `carry_globals_into` is removed).
- `Interp::rewrite_symbol_ids` rewrites this turn's id operands (every `size()==0` opcode — the authoritative, complete set of ID-bearing opcodes in XS bytecode — via a linear `instruction_len` walk that also reaches nested function bodies) from local → canonical before the bytes join `retained_code`.

Because **all** retained turns then speak the same canonical ids, and `global_props` / property keys / cached intrinsic ids all live in that one space, a prior-turn body's `Error`, `JSON.stringify`, or `globalThis.base` binds the same slot this turn does. **No dispatch-loop changes, no per-region swap, no new VM fields.**

**DoD — all five green:**
1. **Named-remainder guard FLIPS** (rewritten to assert correctness): a turn-1 body's `new Error("boom")` invoked in turn 2 is a catchable error with the right `.message`; a turn-1 body reading `globalThis.base` resolves the same binding (15, not NaN); a turn-1 body *writing* `globalThis.base` updates the shared binding a later turn's direct read observes (11).
2. **Real-handler shape test** (endor-vm): turn-1 `handleCommand` using `JSON.stringify`, `new Error`, and a prior-turn realm global (`counter`); turn 2 returns `{"ok":true,"echo":"greet","n":42}`; throwing path catchable.
3. **`endo` crate worker test** extended to the same shape (`rust_worker.rs`): ROOT-workspace `cargo test -p endo --lib` = **84 passed**, 0 failed.
4. **Ledger:** *no new VM side table introduced.* The canonical space **is** `symbol_names`/`symbol_ids`/`next_intern_id` (already ledgered as `SymbolTables`, `symbol_names` the serialized carrier), and the retained bytes are already `RetainedProgramCode` (SnapshotExcluded). The remap is a transient local. Confirmed both rows exist in `endor-snapshot/src/sidetable.rs`; the SymbolTables restore contract still holds.
5. **Byte-identity guard:** metered single-shot path untouched — compile-diff **1909/1909 identical + SYMB 1909/1909**, 0 divergent, full accept/reject agreement.

### Verification (all EXIT=0, captured to files)
- Engine workspace `cargo test` (3 crates cleaned after building moddable at pin): **48 `test result` lines, all 0 failed, 704 passed** (703 at cut + net 1: −1 old guard, +2 new).
- compile-diff curated: **1909 identical, 0 divergent**; **SYMB 1909 identical, 0 divergent**.
- Boot gate: **24 passed, 0 failed** (no skip→green changes).
- **Zero new Rust warnings** (only pre-existing moddable/xsnap C `cc` warnings); `#![forbid(unsafe_code)]` intact on all **8** engine crate roots.
- `c/moddable` clean at pin `23b4d6b0…`, never staged; no committed bundles (gitignored placeholder `ses_boot.js`/`worker_bootstrap.js`/`daemon_bootstrap.js` used for the endo lib build).
- ROOT-workspace `cargo test -p endo --lib`: **84 passed, 0 failed**.

### Named remainder (honest boundary)
The symbol gap this child owned is fully closed. The only cross-turn non-survivor left is **closures over a prior turn's top-level `var`** (a frame local, not a global) — unchanged and by design; the realm idiom is `globalThis.X = …`. This is the capability the live round trip (child 4) depends on, and it is landed and pushed.
