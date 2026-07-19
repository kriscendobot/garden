Tree clean, all three commits pushed and remote-synced. Work complete for this session.

---

## Completion report — stage-10f worker-bundle frontier gap round

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT, kept draft, no PR comments), branch `xs2rust-endor`. Synced to real tip `8eabbdefce` at start; three increments pushed by git EXIT=0.

**Gaps closed (push-per-gap, oracle-grounded, full bars each):**

1. **`Object.fromEntries`** (`b0329460bc`) — the frontier halt `Throw("call: not a function")`. Installed the `Object.fromEntries` static (`NativeMethod::ObjectFromEntries` / `fx_Object_fromEntries`) over the covered array-of-`[key,value]`-pairs boot shape (`@endo/marshal` rankOrder `fromEntries(entries(passStylePrefixes).sort(…).map(…))`). 11 dual-run cases (`object_from_entries.rs`). **Advanced the frontier.**

2. **`harden` an Array** (`2828ebf390`) — the frontier halt `Unsupported("harden:exotic-object")`. Extended the harden traversal to Arrays: freeze via the existing `is_freeze_ordinary_exotic` treatment (`XS_DONT_PATCH_FLAG`) **plus** a traversal into the array's out-of-band element referents (the `arrays` side table) so the transitive freeze reaches the whole graph (`harden(passStyleRanks)` → each value's `cover` array). 10 dual-run assertions (`hardened_javascript.rs` § `harden_freezes_an_array_in_the_graph`). **Advanced the frontier.**

3. **`Object.getOwnPropertyDescriptors` over a symbol key** (`4e3561013e`) — correctness fix (does **not** advance the frontier). The plural gopds wrongly rejected symbol-keyed own properties (the singular already handled them); relaxed the guard to accept symbol-key ids, re-keying each descriptor by the same stable id. 4 dual-run cases (`object_gopds_symbol_keys.rs`).

**Marker:** promoted to the new frontier `Unsupported("getOwnPropertyDescriptors:unclassified-property")`, self-updating.

**Bars (green before every push):** engine workspace 0 failed (797→813 passed); compile-diff 1909/1909 + SYMB 1909/1909; boot gate 30; ROOT `cargo test -p endo --lib` 110/0; zero new Rust warnings; forbid intact (7 roots, endor-oracle exempt); VARIANT_COUNT 35 (no new side table); c/moddable at pin `23b4d6b0a65f`, never staged; no bundles committed (gitignored, seeded bit-identically).

**Resume point / follow-up (the exact frontier):** The boot now halts at `getOwnPropertyDescriptors:unclassified-property` on a **runtime-interned string key** — `__getMethodNames__` (a computed-key name never referenced as an identifier), id 2313 = `symbol_names.len()+1`. This is the deep **runtime-string-key enumeration boundary**: runtime-interned string keys aren't name-resolvable, so they also block `Object.keys`/`JSON.stringify`/gopds over such keys (`intern_key` mints ids from `next_intern_id` shared with symbol keys but never extends `symbol_names`). Forcing gopds to complete over it only moves the halt to SES's next `ownKeys`/`defineProperties` over the result. Closing it needs runtime string keys made name-resolvable across the enumeration sites (likely a `runtime_key_names` map + snapshot round-trip) — a broader change deliberately deferred out of the push-per-gap cadence due to 1909-corpus/snapshot regression risk. Named sub-gaps still ledgered on the likely path: `Object.isExtensible` over arrays (adjacent, surfaced here); the earlier ledgered `set_property_at`/template-`join`/defineProperty items.
