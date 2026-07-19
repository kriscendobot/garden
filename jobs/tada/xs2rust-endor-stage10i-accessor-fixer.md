All bars are green, the work is committed and pushed, PR #600 remains DRAFT, and my inbox is empty. Here is my completion report.

---

## Completion report — `xs2rust-endor-stage10i-accessor-fixer` (F1 s39, PR #600)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` — pushed (`9c54df61e`), local in sync with remote tip, PR #600 confirmed **still DRAFT**.

### The bug (reproduced, then fixed)
The VM's `XS_CODE_NEW_PROPERTY` / `NEW_PROPERTY_AT` handlers ignored the define-flag byte the compiler faithfully emits, defining every object-literal / class-body `get`/`set` member as a plain DATA property holding the accessor **function**. I reproduced all four probe scenarios wrong-completing pre-fix (e.g. setter never invoked → `no`; `gopd(...).get` → `undefined`; `c.a===9` → `false`).

### The fix (`endor-vm/src/interp.rs`, +124/−2)
Read the flag byte (`code[pc+4]` for `NEW_PROPERTY`, `code[pc+2]` for the AT form — the folded-in `INTEGER_1` operand XS's `NEW_PROPERTY_ALL` consumes). When it carries `XS_GETTER_FLAG`/`XS_SETTER_FLAG`, route through a new `instance_define_accessor` that uses the **same holder-instance model** `Object.defineProperty` uses, so downstream get/set/gopd/assign ride the already-verified accessor paths. It handles get-only, set-only, and the XS **merge** of a later `set a` onto an earlier `get a` for one key (in place). Property flags carry the accessor markers plus the define byte's `DONT_ENUM`/`DONT_DELETE` (class members non-enumerable, literal members enumerable — both configurable). **Metering is bit-exact**: one property-slot create for a new key, none for a merge; the internal holder + `get`/`set` slots are unmetered (they represent XS's inline accessor slot). Confirmed via pure-define computron probes.

### Verification (all at the pushed tip)
- **New suite** `literal_accessor_define.rs` (11 tests, reproduce-first): covered define/read/write/merge/reflection/computed-key shapes agree **bit-exact** (result + computrons). Existing `object_assign.rs §5` / `array_sort_comparator.rs §7` untouched.
- Engine `cargo test --workspace` — all pass, EXIT 0.
- compile-diff **1909/1909** + SYMB **1909/1909**, EXIT 0 (compiler untouched — diff is VM-only).
- boot gate **30/0**; ROOT `cargo test -p endo --lib` **110/0** with real bundles seeded (packages `diff -rq` content-identical; bundles gitignored, never committed).
- Worker-bundle marker frontier **held** at `worker_bootstrap`/`Unsupported("for_of")` with `handle_command_registered: true` — no regression.
- `VARIANT_COUNT` 35, no new side table, no new `unsafe`, zero new non-oracle warnings.

### Doctrine note — the two downstream honest-skips are pre-existing, not regressions
`Object.assign` onto an accessor target (`assign:accessor-target`) and `Object.keys` over an enumerable accessor (`Object.keys:unclassified-property`) now honest-skip — I verified they take the **identical** named skips on `Object.defineProperty`-built accessors, so my define fix simply joins the already-verified path (probe 3 now honestly self-names instead of wrong-completing `ok get=2 no`).

### Sweep findings (DoD item 4 — reported, not fixed; out of scope / would scope-creep)
Enumerating consumers of the define-flag byte surfaced two OTHER silently-dropped flags with observable divergence, both distinct from the accessor bug and both pre-existing:

1. **`XS_DONT_ENUM_FLAG` (4) dropped on class DATA methods.** `instance_put` stamps flag=0, so class methods are enumerable in endor but non-enumerable in XS. `class C{m(){}}Object.keys(C.prototype).length` → oracle `0`, endor `1`; the descriptor's `.enumerable` diverges `false`/`true`. (Object-literal methods correctly enumerable.) A small stamp in the data-define path would fix it, but it changes the hot data-define path's behavior broadly and warrants its own verified slice.
2. **`XS_NAME_FLAG` (1) / `XS_METHOD_FLAG` (16) inferred names dropped.** An anonymous function value/method gets no inferred `.name`: `({a:function(){}}).a.name` → oracle `"a"`, endor `""`; `({m(){}}).m.name` → `"m"`/`""`; class method `.name` likewise. Named function expressions are unaffected (they keep their own name). The fix needs `fxRenameFunction` (name-chunk alloc + 2 metered built-in steps, per the existing generator-method rename) — non-trivial; a separate slice.
