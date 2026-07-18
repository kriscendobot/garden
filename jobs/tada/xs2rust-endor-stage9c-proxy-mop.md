All work complete, pushed, and verified. HEAD matches origin/xs2rust-endor at `85504f5297`.

## Completion report

**Job:** Stage-9c child 4/9 — minimal Proxy MOP (construction + get, then has/set) on `endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor`.

**Branch state:** synced at start to the real remote tip `6c9ca62198` (child 3 had landed after the body was written; measured, not assumed). Landed two commits, pushed each as it completed:
- `7dc527e52f` — construction + get trap (items 1–2)
- `85504f5297` — has + set traps (item 3)

Final tip `85504f5297`. PR kept **draft**, never commented on.

**What I built** (transliterated from `c/moddable/xs/sources/xsProxy.c`):
1. **Construction** — `new Proxy(target, handler)` (`fx_Proxy` + `fxNewProxyInstance`): an ordinary heap instance slot; target+handler live in a new `proxies` side table (no `Payload` proxy arm — membership marks the slot exotic, the preferred "ordinary heap slots" shape). Non-object target/handler and a bare `Proxy()` call throw matching TypeErrors (BothAbort).
2. **Get trap** (`fxProxyGetPropertyValue`): `get` trap called `(target, key, receiver)` via the shared `run_reentrant_call` trampoline (children 1/3's re-entry, not a new shape); trap-absent forwards to the target; both non-configurable invariants (non-writable-data value agreement; accessor-without-getter → undefined) throw. Hooked in `GET_PROPERTY` + `GET_PROPERTY_AT` (dot/computed/symbol keys).
3. **Has trap** (`fxProxyHasProperty`) hooked in `XS_CODE_IN`; **set trap** (`fxProxySetPropertyValue`) hooked in `SET_PROPERTY` + `SET_PROPERTY_AT`, both with their non-configurable/non-extensible invariants.

A throwing trap or invariant violation builds a **catchable** TypeError and routes through the innermost handler (the `op_add` ToPrimitive precedent), so a surrounding `try`/`catch` binds it.

**Ledger:** new `proxies` side table registered in `endor_snapshot::sidetable` (VARIANT_COUNT 31→32, `Pending` — the `CtorPrototype`/`Compartments` HashMap-link shape; GC-roots + snapshot contract documented). No new GC side-table roots wiring needed (GC `collect` is test-only today).

**Verification (all bars met):**
- engine-workspace `cargo test --workspace` **EXIT=0** (43 `test result: ok`, every line 0 failed)
- curated compile-diff **1878 identical / 0 divergent** + **SYMB 1878 identical** (CORPUS_PROGRAM_COUNT 1841→1878; +37 curated cases: 10 construct, 13 get, 14 has/set)
- corpus-conversion runtime equivalence: 1878 covered, 0 failed
- boot gate green (17 passed)
- **zero new Rust warnings**; `#![forbid(unsafe_code)]` intact at all 7 engine crate roots (endor-oracle stays the FFI seam)
- `c/moddable` clean at pin `23b4d6b0`, never staged
- 29 hand-written `dual_run` tests (`proxy_global_binding.rs` updated §3 + new `proxy_mop.rs`), all green

**Honest remainders (named `Unsupported`s / not attempted):** revocable proxies; the `deleteProperty`/`ownKeys`/`defineProperty`/`getOwnPropertyDescriptor`/`getPrototypeOf`/`setPrototypeOf`/`isExtensible`/`preventExtensions` traps; Proxy-as-callable/constructable target (`apply`/`construct` traps); exotic-target trap forwarding (`proxy.{get,has,set}:exotic-target-forward`); strict-mode set-forward rejection.
