---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cc-object-mop-exotic-closure
priority: normal
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:28:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 6/7: `defineProperty` on Proxy and remaining exotic receivers

Nested serial child of `ironhorse-js-26-cc-object-mop-exotic-closure`. Work exclusively on open draft endojs/endo-but-for-bots#970, shared branch `feat/ironhorse-262-language-completion`, from a child-keyed isolated project checkout. Fetch/rebase/CAS push, preserve all prior commits, keep open, and do not merge.

Complete `Object.defineProperty`/`Reflect.defineProperty` through Proxy `[[DefineOwnProperty]]`, including trap lookup/call, boolean result distinctions, revoked proxies, target descriptor/extensibility invariants, descriptor-object construction, and forwarding to exotic targets. Complete remaining already-modeled non-Array exotics in this cluster (string/wrapper objects, errors, collections, and related host-independent built-ins). Coordinate typed-array-specific integer-indexed semantics with the already-posted `ironhorse-js-26-cf-typedarray-arraybuffer` child: implement a clean generic seam and leave only explicitly named typed-array residuals to that child, with no suppressions. Eliminate applicable `defineProperty:exotic-object` and Proxy unsupported outcomes by real execution.

Pins: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Add focused differential Rust regressions. Run affected Object/Reflect/Proxy official slices, `cargo test --workspace --release`, and the complete exact-meter corpus. Preserve baseline and prior-child coverage, no new failure/infrastructure result, no exact computron changes. Report commands, before/after totals, reasons, pushed SHA, and PR URL. If a required gate remains unmet after implementation, emit the exact orchestration-failure signal before completion.
