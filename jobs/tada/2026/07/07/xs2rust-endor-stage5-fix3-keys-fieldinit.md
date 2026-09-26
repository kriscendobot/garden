Pushed cleanly to `origin/xs2rust-endor` (attempt 1, no siblings intervened). Class δ is closed and verified; Class ε is the README's explicitly-deferred larger fold, now precisely diagnosed. All green work is landed and all bars re-measured.

---

## Completion report — `xs2rust-endor-stage5-fix3-keys-fieldinit` (fix3 child 4/5)

**Landed** on `origin/xs2rust-endor` as `4a8bdf6ab9` (rebase-CAS push, first attempt; `c/moddable` never staged). PR #600 kept DRAFT; no PR comment, no maintainer message.

### Class δ — integer-index object-literal key coding → **CLOSED**
Disassembly against the pin corrected the prior README note: the real divergence on `S11.1.5_A3.js` (`{0 : 1, "1" : "x", o : {}}`) was the **string** key `"1"`, not the numeric `0` (endor already coded `0` through the integer path). XS's `fxPropertyName` runs a literal string key through `fxStringToIndex`; a canonical array-index string flips to the `PropertyAt` integer path (`integer`/`at`/`new_property_at`), exactly as a numeric key does. Endor's `property_name` skipped that classification.

Fix: ported `string_key_to_index` (faithful `fxStringToIndex`, matching `endor_vm::string_to_index`) + `push_property_index` (`fxPushIndexNode`), applied to **both** `Token::String` branches (plain and the `get`/`set`/method form). Result on `S11.1.5_A3.js`: byte-identical (63/63).

### Class ε — field-init scope/ordering → **NOT closed (deferred fold), diagnosed**
Root cause pinned: XS binds a **real `instanceInit`/`constructorInit` function node** whose `scopeCount == binder->scopeMaximum` = captured closures **plus the peak temporary depth** of the field-value expressions. Endor models that real scope only for the all-plain-data-field class (`class_field_init_inst`/`fi`); for a computed-key/private/static class it falls to a `k`-only synthesized path, under-`RESERVE`s, and mis-indexes body temporaries.
- `init-value-incremental.js`: oracle `RESERVE 3`/`RETRIEVE 2` vs endor `RESERVE 2`; the `to_numeric` temporary lands at local 1 vs oracle's 3 (5 operand bytes differ, same length).
- `static-field-init-with-this.js`: whole static section diverges — additionally entangled with the direct-eval field family (Class γ, deferred): `static h = eval('this.g')` wraps the field body in a `with`/`SCOPE_EVAL` prelude endor omits.

Both close only with the larger scoper+coder fold (a real field-init function scope for every field class) that the README explicitly defers to avoid regressing the byte-clean class corpora. Left as attributed divergences — **no new mis-emit, no panic, no reject introduced.**

### Bars (measured at tip, captured to files, `$?` checked directly)
- `expressions/object`: divergent **1 → 0**, endor-rejected 0, accept-disagree 0 — **BAR MET**.
- `statements/class`: divergent **62** (unchanged baseline), endor-rejected **0**; both ε files still present, no new divergence — **no regression**.
- `expressions/assignment` (0), `statements/function` (0): byte-clean, **no regression**.
- Curated corpora: **1711/1711**, divergent 0, endor-rejected 0 (corpus additions reverted — integer-index property *runtime* is stage-limited in endor-vm, so they broke the dual-run harness; kept as a compile-only test instead).
- `cargo test --workspace -- --test-threads=1`: **EXIT=0** (all 20 test binaries pass).
- `#![forbid(unsafe_code)]` intact.

### Fixtures added
- Parser AST-shape cases (`parser/tests.rs`): `"1"`/`"0"` → `PropertyAt(Integer …)`; `"01"`, `"1.5"`, `"4294967295"` → `Property` (symbol).
- Compile-only byte-identity test (`compile_diff.rs::integer_index_object_keys_are_byte_identical`): the S11.1.5 program, canonical string/numeric keys, non-canonical/signed negatives, and getter/method canonical-index names.

### Follow-ups (attributed, for the serial orchestration's remaining child / a future γ+ε fold)
- **Class ε** (2 `class` divergences) — the deferred real-`instanceInit`-scope fold (`scopeCount = scopeMaximum`), entangled with **Class γ** field-init direct-eval.
- Pre-existing latent edge (unrelated to this change, noticed while testing): an **unquoted** numeric key above `i32::MAX` (e.g. `4294967294:`) diverges via the Number-token `push_property_index_number` path (`value as i32` wraps negative instead of pushing a Number node per `fxPushIndexNode`). Not in scope here; flagged for the numeric-key path.
