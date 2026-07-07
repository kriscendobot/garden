Both landed slices touch only `rust/engine/` — no `c/moddable` in either commit. The working-tree submodule drift is a peer's pointer, never staged by me.

## Handler summary

**Landed this handler** (byte-identical, `cargo test --workspace -- --test-threads=1` EXIT=0, pushed to `xs2rust-endor`):

- **Slice 50 — static initializer blocks.** A `static { … }` block folds into the same `constructorInit` field-init function as the static data fields, in source order. The realization that made it a small, safe change: the `Body` static-block items are **already** collected into `static_fields` (they're non-method STATIC items), so the only coder change was `code_field` running a `Body` item as statements directly (no `this`/`NEW_PROPERTY`), with `this` bound to the constructor — reusing the peer's `code_field_init_function` wholesale. Covers blocks mixed with static fields, multiple blocks, `super`, control flow, and interleaving with methods.
- Byte-identity test count: **61 → 62** (`static_blocks`, 9 cases).
- README "Still folded" updated.

**Deferred cleanly** (coder panics, never mis-emits):
- **Computed-key fields** (`[k]=v`) — the scoper *does* provide the declares (an `atAccess` Const closure + a field-function use-closure alias), but coding needs the peer's synthetic field-init function made **scope-aware** (RESERVE/RETRIEVE the captured key), which isn't AST-keyed — best done by the field-function owner.
- **Private members** and **static blocks with local declarations** — same scope-awareness / private-declare gap.
- **Modules** — still blocked on a shared-oracle module-goal compile entry (infra).

Classes now cover base/named/derived + methods/accessors/static/computed **keys** + instance & static data fields + static blocks + `super()`/`super.x`. Report sent to `port-xs-to-rust-memory-safe-engine-s12`.
