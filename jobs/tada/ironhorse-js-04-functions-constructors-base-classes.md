Inbox empty. All work is committed, pushed, and verified. Writing the completion report.

## Completion report — `ironhorse-js-04-functions-constructors-base-classes`

**Job:** Complete functions, construction, new.target, and base classes on the shared Ironhorse-262 completion PR (kriscendobot/garden#51). Repo `endojs/endo-but-for-bots`, branch `feat/ironhorse-262-language-completion`, **PR #970 (OPEN, draft — not merged)**.

### What I did

Built on the latest remote branch (preserving every earlier child's commits, including the js-01/js-02 gauntlet fixes and js-03's object-MOP commit `6c497251c`). Landed **three causal engine fixes** in `ironhorse-vm`, each converting `ironhorse-aborted` skips into oracle-covered cases against the pinned XS differential oracle — no relabeling, no suppression:

1. **Catchable `TypeError` on calling a non-callable / constructing a non-constructable ordinary object.** The user-function dispatch choke point (`enter_call`) raised the uncatchable `Halt::Throw("call: not a function")`; it now builds a realm-correct `TypeError` and raises it through the jump-buffer chain (`build_error` + `raise_js`), so `try`/`catch` and `assert.throws` observe it per ECMA-262 `Call` (7.3.14).
2. **Catchable `ReferenceError` on an unresolvable reference** (`GetValue` 6.2.5.5), replacing the uncatchable `Halt::Throw("get …: undefined variable")`.
3. **`XS_CODE_TO_INSTANCE` (ToObject, 7.1.18)** implemented: object identity (the base-class constructor bind and object destructuring of an object RHS), catchable `TypeError` for `null`/`undefined`, and an honest `to_instance:primitive-box` named skip for the boxed-primitive arm (a wrong wrapper would diverge, so it is named, not guessed).

Each raise preserves the prior host-escape for an uncaught throw, so ironhorse only ever *aborts catchably* — never completes-where-the-oracle-aborts — which is why no over-acceptance failure can be introduced.

### Verification (all run; `tc39/test262@be13516`, XS oracle `23b4d6b0`, engine base advanced only by peer commits — pins unchanged)

- **Affected slice, before → after, 0 failed throughout, per-case regression check = 0 regressions:** `expressions/call` 19→41, `expressions/new` 12→29, `statements/function` 110→117; `built-ins/Function`, `expressions/{function,arrow-function,new.target}`, `{expressions,statements}/class` all unchanged with **0 failures** (their gaps are the still-unimplemented `native-call:Function`, `class` opcode, `arguments`, `with`, `for-of`). **Net +46 covered, no new `ironhorse-failure`/`infrastructure`.**
- **Full Rust workspace gates:** `cargo test --workspace --exclude ironhorse-fuzz --release` — all green (incl. the exact-metering **`corpus_conversion_equivalence`** and byte-identity suites; computron expectations under `cases/**` unchanged).
- **3 focused regression tests added** (`ironhorse-262`): catchable call/new `TypeError`, catchable `ReferenceError`, ToObject identity + null/undefined `TypeError`.
- **Boot-bundle ledger test advanced** (a required consequence of closing `to_instance`): the 2 bundles that stopped at `to_instance` now stop at the next real gap, the `class` opcode.
- Removed the throwaway debug bin; no stray files. Rebased CAS onto the moved remote (resolved a peer's concurrent test insertion in `lib.rs`), re-tested, pushed.

**Head SHA:** `5bc920c3e7f47362dc855fa165d37a0025c1cb23` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (OPEN, draft)

### Follow-ups (remaining in-scope surface, deliberately not attempted here to protect the strict no-new-failure / metering invariant)
- **`class` opcode + `BEGIN_STRICT_BASE`** (base-class constructor/method init): interlocking with class-requires-new enforcement and non-enumerable method flags — omitting any piece risks over-acceptance failures, so it needs its own focused pass. `to_instance` already clears its precursor.
- **`arguments` objects** (`arguments_sloppy`/`arguments_strict`) — mapped/unmapped array-like.
- **`native-call:Function`** (dynamic `Function(...)` construction) — requires a runtime-compiler seam the vm crate does not currently link; an architectural change.
- **Constructable/callable discrimination for arrows/generators/async/methods** (`new (arrow)` must throw) — needs a per-function constructability flag, touching the definition-time prototype allocation, so metering-sensitive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-04-functions-constructors-base-classes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 325 tokens (24733144 cached reads)
- Output: 107047 tokens
- Cost: $17.475473000000004
- Wall-clock: 1904s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
