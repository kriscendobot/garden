All charter items are complete and pushed; the completion note is dead-lettered forward to the supervisor. The job is genuinely done.

## Completion report

**Job:** stage-3b child 4/9 — fundamentals follow-up, PR #600 (`endojs/endo-but-for-bots`, branch `xs2rust-endor`, kept DRAFT).

All charter items landed as their own green, computron-exact commits on `xs2rust-endor` (HEAD `d2d402f30`, working tree clean, in sync with origin):

| Commit | What |
|---|---|
| `8c6b0d520` | **Function `.length`** (declared arity, from `begin`'s param-count operand at the `code` opcode) + **`.name`** (own name, inferred for `var f=function(){}`) as first-class own data-property reads — the prerequisite for bind. |
| `043f01c29` | **`Function.prototype.apply` with a real dense Array** — forwards elements (`APPLY_ARRAY_BASE_METERING` 98040 + 3·`1<<14`/element, raw-exact). `prototype/apply`: 5 covered, 0 divergent. |
| `d25bb8d94` | **`Symbol.prototype.toString`/`valueOf`, `String(symbol)`, `Symbol.for`/`keyFor` registry** (registry-interned identity). `built-ins/Symbol`: 6 covered, 0 divergent. |
| `9de63cfb7` | **`AggregateError(errors, message)`** — base error (message arg 1, `instanceof Error`) + `errors` Array from a dense-array arg (`AGGREGATE_ERROR_EXTRA` 461568 + 246048/elem). 0 divergent. |
| `c7c7b7816` | **`Function.prototype.bind`** — recovered child-2's reverted work: bound-function repr (`bound_functions` side table) + two trampolines, bound `.length`/`.name`, args Array. Creation 198696 (+33296 array +288/arg) & call 180216 + `1<<14`/forwarded-arg, all raw-exact. `prototype/bind`: 11 covered; **whole `built-ins/Function` grew 23 → 39 covered, 0 divergent**. |
| `a38dd2296` | **Differential fuzz arm** (`gen_stage3b_fundamentals_followup_program`, 1200-seed bit-exact sweep) + curated corpus `stage3b-fundamentals-followup.js` with a wired bit-exact test. |
| `d2d402f30` | **README evidence block.** |

**Honest named skips (documented):** `new (boundFn)`, a non-user-function/native bind target, a bound-of-bound *call* (its `.length`/`.name` still read), sparse/non-array `apply`/`AggregateError` args, a non-string `Symbol.for` key, and — per the charter's "if calibratable within budget; else keep the honest skip" — **sloppy primitive-`this` boxing** (`fxToInstance`) in `.call`/`.apply`/bound calls, since the sloppy-boxes-vs-strict-keeps distinction isn't knowable until the callee's `begin`. Kept as the honest skip, not attempted.

**Invariants:** `#![forbid(unsafe_code)]` holds (no new unsafe); Miri GC suite unaffected (`gc.rs` untouched, GC not wired into the interp — new side tables mirror the existing `arrays`/`collections` pattern; Miri component absent on this host, CI confirms); full workspace `cargo test` green (27 endor-262 + 17 endor-fuzz + gc/vm). Followed the coordinator's ruling on the mid-flight accuracy-over-parity doctrine: computron-exact-or-honest-skip against the current runner (which still gates computrons).

**Follow-ups:** (1) sloppy primitive-`this` boxing remains a deferred named skip; (2) if the `DualRun::is_bit_exact` runner predicate is later changed to demote computrons per the new doctrine, the honest-skip corners here could ship result-correct with advisory divergence instead.
