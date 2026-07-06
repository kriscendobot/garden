<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-06T00:38:24Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (stage 1,
design dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review +
stage-2b dispatch), `-s5` (stage-2b review + stage-3 dispatch), and `-s6` (stage-3 halt recovery +
interim review + stage-3b dispatch, completed 2026-07-03). You were parked
`blocked_on: xs2rust-endor-build-stage3b` (the recovery ORCHESTRATION base) and promoted because it
reached `tada/` — **read `journal/jobs/tada/xs2rust-endor-build-stage3b.md` FIRST**: its
`orchestration-status:` marker says whether all nine children completed or the serial run HALTED.
Program state:

- **Stage 1 (DESIGN): done.** PR `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`,
  base `llm`), design `designs/xs2rust-endor-engine.md`. **Stage 2 (SELF-ANSWER + APPROVE): done**
  (ten questions resolved, BINDING; approval issuecomment-4869816854).
- **Roadmap stages 1, 2a, 2b: done and ACCEPTED** (s3/s4/s5 reviews; 2b acceptance
  issuecomment-4872378323 with full independent reproduction).
- **Roadmap stage 3, first orchestration (`xs2rust-endor-build-stage3`): HALTED at child 5/7,
  recovered by s6.** Children 1-4 (language, fundamentals, arrays, text-math-json) COMPLETED, bars
  met (all sections divergent=0, bit-exact incl. computrons, honest named skips, forbid(unsafe),
  Miri 8/8): language/expressions 155→418, built-ins/Array 403, /Math 151, /String 115, plus
  Boolean/Error/Symbol/Object/Function bootstraps. The halt was a FALSE-POSITIVE reap of the
  productive collections child (transient-handler-kill storm, 2026-07-03 infra incident, repaired;
  collections landed Map/Set/WeakMap/WeakSet `5b6e4feda` first). s6 diagnosis + interim review:
  **issuecomment-4878100516**.
- **s6 review posture (IMPORTANT DEBT FOR YOU):** children 1-4 were accepted ON REPORT (program
  restore took precedence, per liaison directive 20260703T162640Z). The **fresh-checkout
  independent reproduction of the FULL stage-3 acceptance evidence is carried to YOU** — do it as
  one pass over all of stage 3 (children 1-4 + the stage-3b nine) when stage-3b lands: fresh
  checkout, oracle pin, `cargo test --workspace`, Miri GC, per-section test262 dual-run numbers vs
  each child's tada report.
- **Stage-3b (dispatched by s6): serial orchestration `xs2rust-endor-build-stage3b`, nine children,
  halt-on-failure, all `model: opus`, all PR #600:** 1 collections-keyed (remainder over
  `5b6e4feda`), 2 bigint (salvages ~366-line in-flight diff from
  project-wt-xs2rust-endor-build-stage3-collections-5cd7f36a), 3 binary (ArrayBuffer/TypedArray/
  DataView), 4 fundamentals-followup (bind + apply-with-array + function .length + Symbol
  registry/toString + AggregateError + sloppy primitive-this attempt), 5 object-statics-intern
  (GLOBAL string→id intern table + at/at_2 revisit + Object keys/defineProperty/
  getOwnPropertyDescriptor/verifyProperty), 6 json-metering (JSON.parse + structured stringify
  metering — s6 ruled it in-stage), 7 promises (+job queue, pump latch), 8 xsre-core (matcher
  port, engine-internal), 9 xsre-integration (RegExp + String methods). Children report scope
  folds to YOUR inbox `port-xs-to-rust-memory-safe-engine-s7`.
- **Stage-3b child 1/9 (collections-keyed) DONE — scope-fold report carried here (your inbox was
  not yet live, so the child's note dead-lettered; deadmail-20260703T170625Z-2798f6 folded it into
  this spec).** 4 green commits on `xs2rust-endor` (PR #600, kept DRAFT), landed on `5b6e4feda`,
  HEAD `f761df2f9`, all pushed. Delivered: Map/Set `forEach` + entries/keys/values iterators +
  for-of/spread over Map/Set, Map/Set `clear` (fxClearEntries), all computron-exact vs pin
  `48ee02d8cfe0`; corpus `stage3-collections.js` +57 programs; fuzz arm
  `gen_stage3_collections_program` + 800-seed sweep. test262 dual-run **divergent=0** every touched
  section (Map 22→25, Set 34→37, WeakMap 11, WeakSet 9, Map/SetIteratorPrototype divergent=0,
  for-of 79→89); Miri GC 8/8; `#![forbid(unsafe_code)]` intact. Full evidence in
  `journal/jobs/tada/xs2rust-endor-build-stage3b-collections-keyed.md`. **Scope folds for YOU to
  ratify (all HONEST NAMED SKIPS, never a wrong value):** (a) the copy-constructor iterable arg
  (`new Map([[k,v]])` / `new Set(iter)` / weak forms) is deferred — consistent with `Array.from`,
  its per-element metering routes through the un-modeled `Symbol.iterator`+`mxRunCount(0)` `next()`
  protocol; **child 2/3 or a later child that wants the copy-ctor needs the generic
  iterator-next metering constant defined FIRST.** Also deferred/named: (b) weak primitive-key
  `TypeError`, (c) mid-iteration structural mutation, (d) ES2025 Set combinators
  (union/intersection/…). BigInt/binary-data untouched (children 2 & 3).
- **Stage-3b child 2/9 (BigInt) DONE — scope-fold report carried here (your inbox was not yet
  live, so the child's note dead-lettered; deadmail-20260703T174129Z-e748a9 folded it into this
  spec).** Pushed to `xs2rust-endor` (PR #600, kept DRAFT). Commits: `c8de281bf` (core),
  `e021feaf6` (corpus+fuzz), `9713ee930` (String skip), `76db05dd4` (GC test). All **raw-exact**
  vs pin `48ee02d8cfe0`: BigInt value Kind + `[sign][LE u32 limbs]` digit chunk; literals;
  `+ - *` (mxBigInt_meter digit step + allocation-faithful result chunk at XS's PRE-TRIM
  fxBigInt_alloc size — add max+1, sub max, mul a+b limbs); unary minus; strict/loose
  `=== == !== !=` incl BigInt-vs-Number (fxNumberToBigInt); relational `< <= > >=` (both-BigInt);
  typeof; decimal completion rendering. Corpus (93 progs) + fuzz arm (800 seeds) + BigInt
  GC-relocation test all green; Miri GC suite green; `#![forbid(unsafe_code)]` intact; full
  workspace test green. Full evidence in
  `journal/jobs/tada/xs2rust-endor-build-stage3b-bigint.md`. **CALIBRATION NOTE (the salvaged
  in-flight diff was computron-off — canceling errors crossed boundaries, e.g. `-3n*-4n`): the
  true per-op residuals are each `1<<14` — `BIGINT_LITERAL_METERING`, `BIGINT_ARITH_FRAME_METERING`,
  `BIGINT_NEG_FRAME_METERING`; the both-BigInt compare and strict-mixed carry ZERO residual (the
  salvage's "builtin per operand" was the literal undercharge in disguise).** Bar met:
  built-ins/BigInt divergent=0; bigint language sections 204 covered / divergent=0. **Scope folds
  for YOU to ratify (all HONEST NAMED SKIPS via `Halt::Unsupported`, never a wrong value/meter):**
  (a) `BigInt**`, (b) BigInt `/` and `%` (long-div/repeated-squaring metering unmodeled),
  (c) mixed BigInt/Number ARITHMETIC (a TypeError anyway), (d) the fractional-delta mixed
  RELATIONAL path, (e) `String(BigInt)`/concat/template (fxBigintToString radix-formula chunk +
  fxBigInt_dup + call-frame residual unmodeled — chose skip over a ~82k-raw wrong meter;
  bare-completion render stays bit-exact). **NEXT INCREMENT the child flags (biggest remaining
  BigInt coverage):** the `BigInt()` constructor as a new intrinsic global +
  `BigInt.prototype.toString/valueOf` + `asIntN/asUintN` — unlocks the 67 built-ins/BigInt files
  (currently all endor-aborted on the missing BigInt global). Delicate: new intrinsic registration
  must NOT double-count the realm-setup metering constant (endor's startup lump already matches XS,
  which registers BigInt), and `BigInt(number)` RangeError-on-non-integer + string parse need their
  own bit-exact meters. Left as a clean follow-on, not rushed into an invariant violation.
- **Stage-3b child 3/9 (binary data) DONE — scope-fold report carried here (your inbox was not yet
  live, so the child's note dead-lettered; deadmail-20260703T202026Z-8bcdb1 folded it into this
  spec).** Bar MET on pushed HEAD `651c747da` (== `origin/xs2rust-endor`, PR #600, kept DRAFT); the
  substantive surface was landed across three prior commits and this run **independently
  re-verified** it green (not just trusting commit messages): workspace build green with the C-XS
  oracle linked (pin `48ee02d8cfe0`, `c/moddable` repopulated from a sibling worktree — working-tree
  gitlink, correctly untracked); `cargo test --workspace -- --test-threads=1` all suites pass, 0
  failed; live acceptance dual-runs **divergent=0** every section — `built-ins/ArrayBuffer` 11
  covered/0 divergent, `built-ins/DataView` 62/0, `built-ins/TypedArrayConstructors` 11/0; every
  skip honestly named via `Halt::Unsupported`. Full evidence in
  `journal/jobs/tada/xs2rust-endor-build-stage3b-binary.md`. **Landed surface (all computron-exact
  vs the pin):** ArrayBuffer construct + `byteLength` + `isView`; the 11 concrete TypedArray
  constructors (length AND buffer forms) + exotic index read/write + `length`/`byteLength`/
  `byteOffset`/`buffer` accessors; DataView construct + the full `get*`/`set*` family with
  endianness. No code change was needed this run — the bar was already satisfied and confirmed.
  **Scope folds for YOU to ratify (all HONEST NAMED SKIPS, never a wrong value; each a SEPARATE
  hard-calibration increment, not a quick fold — the child flagged them for follow-up-child scoping
  rather than cramming under its deadline, already force-reaped once/overrun=1):** (1)
  `ArrayBuffer.prototype.slice` — routes through `fxConstructArrayBufferResult` → species
  constructor (`this.constructor` + `Symbol.species` getter + re-entrant construct); needs the
  species-getter machinery modeled. (2) **TypedArray prototype methods**
  (at/fill/indexOf/includes/join/set/copyWithin/iterators/…) — spec homes these on the abstract
  `%TypedArray.prototype%` which endor does NOT model (the 11 concrete protos chain straight to
  `%Object.prototype%`); landing them bit-exact wants a shared `%TypedArray.prototype%` intrinsic +
  per-method oracle calibration + a full 953-file bar re-run. (3) Construct abort/coerce corners —
  `new ArrayBuffer(-1)`/oversized (RangeError abort metering), bool/string `byteLength` (general
  ToNumber), DataView bad-length/bad-offset (abort metering), TypedArray from-object/from-iterable
  ctor (iteration protocol), typed-array-`set` object-value coerce. **NEXT INCREMENT the child flags
  (highest yield):** item 2 — a shared `%TypedArray.prototype%` intrinsic + a batch of the
  non-species methods. Deferrals are legitimate per the charter's "honest named skips for anything
  blocked (e.g. species/symbol-keyed corners)" clause; the child's read is that child 3/9's stated
  bar is satisfied. Say the word (promote a fresh scoped child) if coverage should be pushed further.
- **Stage-3b child 4/9 (fundamentals-followup) DONE — scope-fold report carried here (your inbox was
  not yet live, so the child's note dead-lettered; deadmail-20260704T040350Z-7004f3 folded it into
  this spec).** All charter items landed on `xs2rust-endor` (PR #600, kept DRAFT) — 7 commits, HEAD
  `d2d402f30`, each its own green computron-exact commit; full evidence in
  `journal/jobs/tada/xs2rust-endor-build-stage3b-fundamentals-followup.md`. Landed surface (all
  computron-exact vs pin `48ee02d8cfe0`, raw-exact via the raw-gap where noted): (1) `8c6b0d520`
  Function `.length` (arity from begin's param-count operand at `code`) + `.name` (inferred for
  `var f=function(){}`) as own data-property reads. (2) `043f01c29` Function.prototype.apply with a
  real dense Array (APPLY_ARRAY_BASE 98040 + 3<<14/element) — prototype/apply 5 covered, 0 divergent.
  (3) `d25bb8d94` Symbol.prototype.toString/valueOf, String(symbol), Symbol.for/keyFor registry
  (registry-interned identity) — built-ins/Symbol 6 covered, 0 divergent. (4) `9de63cfb7`
  AggregateError(errors,message) — base error (msg arg1) + errors Array from a dense-array arg
  (AGGREGATE_ERROR_EXTRA 461568 + 246048/elem), 0 divergent. (5) `c7c7b7816`
  Function.prototype.bind — recovered child-2's reverted bind end-to-end: bound-fn repr
  (bound_functions side table) + two trampolines, bound `.length`/`.name`, args Array; creation
  198696 (+33296 array +288/arg when bound args), call 180216 + 1<<14/forwarded-arg, all raw-exact
  via the raw-gap; prototype/bind 11 covered, whole built-ins/Function 23 -> 39 covered, 0 divergent.
  (6) `a38dd2296` differential fuzz arm (gen_stage3b_fundamentals_followup_program, 1200-seed
  bit-exact sweep); corpus `stage3b-fundamentals-followup.js` (all surfaces), test wired.
  (7) `d2d402f30` README evidence block. **Invariants:** `#![forbid(unsafe_code)]` holds (no new
  unsafe); Miri GC suite unaffected (gc.rs untouched, GC not wired into interp — the new side tables
  mirror the existing arrays/collections tables; Miri component absent on this host, CI confirms);
  full workspace `cargo test` green (27 endor-262 + 17 endor-fuzz + gc/vm). Doctrine followed:
  computron-exact-or-honest-skip against the current computron-gating runner. **Scope folds for YOU
  to ratify (all HONEST NAMED SKIPS via `Halt::Unsupported`, never a wrong value/meter, documented in
  README):** (a) `new (boundFn)` construct, (b) non-user-function / native bind target,
  (c) bound-of-bound CALL (its `.length`/`.name` still read), (d) sparse / non-array apply &
  AggregateError args, (e) non-string `Symbol.for` key, and — per the charter's "if calibratable;
  else keep the honest skip" — (f) **SLOPPY PRIMITIVE-THIS BOXING (fxToInstance)** in
  `.call`/`.apply`/bound calls: a primitive `thisArg` self-names `Halt::Unsupported` because the
  sloppy-boxes-vs-strict-keeps distinction is not knowable until the callee's begin, so it was kept
  as the honest skip (not attempted, within budget) — this DISCHARGES the review-ledger
  "sloppy primitive-this boxing (stage-3b child 4 attempts it)" carry-forward: attempted, ruled a
  legitimate named skip, moved off the open ledger.
- **Stage-3b child 5/9 (object-statics-intern) DONE — scope-fold report carried here (your inbox was
  not yet live, so the child's note dead-lettered; deadmail-20260705T175620Z-f869f8 folded it into
  this spec).** All charter items landed on `xs2rust-endor` (PR #600, kept DRAFT), each its own
  green computron-exact commit, HEAD `b2771da76` (all pushed); full evidence in
  `journal/jobs/tada/xs2rust-endor-build-stage3b-object-statics-intern.md`. Landed surface (all
  bit-exact vs pin `48ee02d8cfe0`, divergent=0): (1) `10888be66` GLOBAL string→id intern table
  reconciled with C-XS program symbols + boot default keys, and interning `AT`/`AT_2` — computed
  string member access `o[k]` for any string key: a program-symbol key resolves exactly as its
  `o.name` static access; a genuinely-novel name interns one `fxNewSlot` + reads bit-exact
  `undefined`; an index string meters XS's 2× code units. (2) `46e6c2f36` sound `in` false-answers —
  a novel key answers `false` via a metered `fxOrdinaryHasProperty` chain walk (one
  `XS_CODE_METERING` per prototype hop). (3) `7ab6360d5` `Object.defineProperty` — new own data
  property from the canonical 4-field data descriptor `{value,writable,enumerable,configurable}`,
  booleans stored as XS's flag byte, attributes rippling through `Object.keys` (filters
  non-enumerable) + `getOwnPropertyDescriptor` (renders writable/enumerable/configurable from the
  flag byte); `fxDescriptorToSlot` + `fxOrdinaryDefineOwnProperty` fold into one calibrated raw
  residual (622024). (4) `0bb42b19c`/`b2771da76` README evidence + curated corpus + differential
  fuzz arms for every new surface. **Sound-gate (both interning + `in`):** a boot default-key name
  the program never symbol-referenced self-names (`Halt::Unsupported`) rather than risk a wrong
  `undefined`/`false` for an unlinked inherited built-in — never a wrong value. **Bars met:**
  built-ins/Object **48→63 covered, divergent=0**; language/expressions **1064→1066, divergent=0**;
  verifyProperty-shaped gopd+defineProperty tests now covered; corpus + differential fuzz arm per
  grammar, covered-grammar gate + all prior corpora green; `#![forbid(unsafe_code)]` intact (Miri
  absent on host — no unsafe to exercise; GC relocation tests green under normal `cargo test`).
  **Scope folds for YOU to ratify (all HONEST NAMED SKIPS, never a wrong value/meter, documented in
  `rust/engine/README.md`):** (a) `defineProperty` REDEFINE of an existing key (configurable-compat
  checks + different metering), (b) partial/accessor descriptors, (c) index/exotic keys, (d)
  non-boolean attributes, (e) `Object.keys` rendering of a `defineProperty`'d ENUMERABLE *novel*
  (runtime-interned, non-program-symbol) key, (f) `instanceof`/`hasInstance` built-in/literal-name
  resolution (piece-1 aspirational, absent from the bar). The flag-byte attribute model now in
  place is the foundation a later child extends. None block the stated bar.
- **Stage-3b child 6/9 (json-metering) PARTIAL COMPLETE — scope-fold report carried here (your inbox
  was not yet live, so the child's note dead-lettered; deadmail-20260705T203811Z-5bff83 folded it
  into this spec).** On `xs2rust-endor` (PR #600, kept DRAFT), HEAD `c712ee8f5`, all pushed. **Structured
  `JSON.stringify` metering DONE bit-exact; `JSON.parse` REMAINS as the clean follow-up (REQUEUED, not
  abandoned — the live child `xs2rust-endor-build-stage3b-json-metering` carries it).** Delivered — 3
  green commits, divergent=0, `#![forbid(unsafe_code)]` intact, all prior corpora + endor-vm/endor-262/
  endor-fuzz suites green; full evidence in `rust/engine/README.md` evidence block: (1) structured
  `JSON.stringify` per-node metering, bit-exact (result AND computron) vs pin `48ee02d8cfe0`, fully
  **decomposed** against xsJSON.c `fxStringifyJSONProperty` (NOT fitted) — each node a whole number of
  `mxMeterOne(1<<14)` steps + exact `fxNewSlot`/`fxNewChunk` allocs: array-enter 11 steps +1 nonempty
  +5/element; object-enter 8 steps +1 `fxNewInstance` slot +1 AT-slot/own-key +65528 nonempty +4 steps
  + `fxPushKeyString` chunk(rup8(len+1))/key; 1-step primitive leaf. The child-4 "value-dependent
  non-power-of-two gaps" is fully explained — the apparent wobble was ENTIRELY the final result
  `fxNewChunk(offset)` (output len + NUL), already metered once by `new_string_metered`; verified
  bit-exact across flat/nested/holes/undefined/string-escape objects & arrays to 30 keys and depth 5.
  (2) curated corpus `stage3b-json-metering.js` + a `gen_json_structured_program` differential fuzz arm
  (both bit-exact). (3) README evidence block. **Bar:** built-ins/JSON **2→4 covered, divergent=0** —
  only +2 because most "stringify-gated" test files ALSO round-trip through `JSON.parse` (55 files gated
  on `JSON.parse:unmodeled`) or use replacer/space (22); the sharp coverage climb needs `JSON.parse`.
  **Scope folds for YOU to ratify (all HONEST NAMED SKIPS, never a wrong value/divergence):**
  `JSON.stringify` of a callable VALUE (function) inside a container — its reference branch runs an
  unmodeled `mxGetID(_toJSON)` probe (measured object-ctx +131072 / array-ctx +65536, context-dependent;
  deferred rather than shipped) — plus the prior toJSON/wrapper/replacer/space corners and callable-top.
  **`JSON.parse` (remaining, REQUEUED):** the primitive-parse internal metering is measured =
  180224 raw constant (number/bool/null) + string chunk (rup8(len+1)+16) for strings; the tokenizer
  (`fxParseJSONToken`), value dispatch (`fxParseJSONValue`), array/object construction (`fxNewArrayInstance`
  + `fxNewSlot`/element; `fxNewObjectInstance` + property slots) + error metering remain to implement
  bit-exact — a full recursive-descent parser, a self-contained next-cycle effort. **Pre-existing
  observation flagged for the parse child (or an object-literal child) — NOT introduced here and NOT a
  JSON issue:** a large/deep nested OBJECT LITERAL *construction* (bare `var v={...}`, no JSON) accrues a
  sub-computron raw drift in endor vs oracle (e.g. −1664 raw on a ~120-computron literal) that can
  occasionally tip one computron boundary; visible independent of JSON. The json-structured fuzz arm
  bounds depth/breadth to stay construction-exact. Route it (to the `JSON.parse` child, an object-literal
  child, or the stage-8 ledger) — worth a look in the object-literal/`SET_PROPERTY` metering path.
- **s6 rulings on the stage-3 carry-forwards (all discharged; do not re-litigate):** child-1 folds
  ratified (at/at_2 → stage-3b child 5; copy_object/extend + arguments exotics stay named skips
  pending class/intrinsics machinery); child-2 ratified done, bind/apply-with-array →
  stage-3b child 4; arrays' sort/toSorted/from/of metering skips ratified → stage-8
  parity-closure ledger; child-4's JSON follow-up → stage-3b child 6, small residuals
  (indexOf multi-char scan, radix≠10, non-ASCII case/trim/astral, ~33280-raw direct-consumption
  temporary residual) → stage-8 ledger.
- **Review ledger (carry forward):** GC-roots contract (s5 obs 2: side tables
  functions[*].closures / CallerState / CatchJump / global_props must be roots when GC wires into
  the run loop, deterministic trigger points — verify at whichever child/stage first does it);
  FUNCTION_* ≤288-raw analytic decomposition (bit-exact already, polish); sub-computron
  property-create residuals on construct `this` (never crossing >>16); sloppy primitive-this
  boxing (stage-3b child 4 attempts it); stage-8 items above.
- **Maintainer-intent watch (do NOT unilaterally act):** four parked plan jobs record maintainer
  roadmap intent that may reshape later stages: `xs2rust-endor-metering-doctrine-accuracy-over-
  parity` (would REPLACE the bit-exact computron-parity doctrine with accuracy-over-parity,
  per-release determinism; "ideally decided first" before its siblings),
  `xs2rust-endor-strings-utf16-replace-cesu8`, `xs2rust-endor-meter-opcode-cost-instrumentation`,
  `xs2rust-endor-corpus-test262-and-xst-harness` (completion-phase). They are deliberately parked
  and sequenced by the liaison/maintainer. Until promoted and decided, the BINDING build doctrine
  remains bit-exact (result AND computron) parity vs pin `48ee02d8cfe0`. If they get decided
  mid-program, expect a design amendment and re-baseline the bar consciously.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity.
  Hourly `xs2rust-endor-press-*` observer runs alongside (it defers while a build child owns the
  branch). Keep the PR DRAFT until the finish line.
- **Oracle-pin friction (practical):** pin `48ee02d8cfe0` not shallow-fetchable;
  `rust/engine/README.md` documents fallbacks + the empty-gitlink footgun. `cargo` at
  /home/kris/.cargo/bin. Whole-tree single-process `language/` runs OOM; run per subtree.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched stage to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox.
- **Your loop now:** if stage-3b HALTED, diagnose (check for the false-positive-reap class first:
  was the child landing commits?) and re-establish, as s6 did. If it completed: run the
  whole-stage-3 review with the FULL independent reproduction (the s6 debt above), post findings /
  fixer jobs (model: opus) and iterate; verify the ledger closures; then dispatch roadmap stage 4
  (Hardened JavaScript: lockdown/harden/Compartment + module machinery + async/generators; bar:
  endor daemon boot bundles run identically, SES conformance passes) as a serial orchestration
  sized per the doctrine, and park `port-xs-to-rust-memory-safe-engine-s8` blocked on it, carrying
  this spec with an updated Supervisor state. Stages remaining after 3: 4 (Hardened JS),
  5 (compiler), 6 (snapshots), 7 (debugger), 8 (parity closure), 9 (ecosystem validation), then
  the endor-integration + `test:rust` finish line. If a kill criterion tripped (design
  § Feasibility Verdict), stop the program: journal + surface to the maintainer with evidence.
- **Continuation protocol:** at each wait point post the sub-job(s), park your next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec + updated Supervisor state, journal the transition, and complete.
  Design sub-jobs `model: fable`, build/fixer `model: opus`. Sub-jobs report to YOU, never the
  maintainer inbox — the maintainer enters the loop ONCE, at the end.

The original program spec follows, unabridged.

---
You are a **long-running Fable supervisor**. Your job is not to design or build the port yourself, but to
**orchestrate the full lifecycle** — design, self-answer every open question, approve the design, build it
end-to-end on the same PR, and review the implementation to completion — and to involve the maintainer
**only once, at the very end**, when the PR is complete and ready for their attention.

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; standing comment auth). This is DESIGN/RESEARCH plus
**fork-scoped** build only — **no upstream `endojs/endo` or `agoric/agoric-sdk` interaction** (no comments,
PRs, issue/PR links, merges). The metering-equivalence requirement below exists precisely because XS feeds
agoric consensus, but any real upstream landing is a separately authorized program, not this job.

## The design brief (hand this verbatim to the designer)

Port **XS** (Moddable's interpreted JS engine, as consumed by Endo's xs-worker / agoric-sdk `xsnap`) to
**Rust**, as a crate **endor** embeds, to raise confidence in memory safety while preserving what makes XS
uniquely suited to Endo/agoric. The design must carry ALL of these hard requirements:
1. **Preserve metering, debugger, snapshot-persistence.** Metering = deterministic CPU+memory metering
   reproduced EXACTLY vs C-XS (a consensus requirement; a divergence is a consensus fault) or a stated
   determinism-equivalence proof. Debugger = the XS debugger protocol/inspection surface. Snapshot = heap
   save/restore (the xsnap lifecycle); decide the FORMAT question (read existing XS snapshots vs a
   Rust-native format + migration).
2. **Minimize `unsafe`** — an `unsafe` budget + per-use justification, isolated behind audited modules.
3. **Increase memory-safety confidence** — the headline metric, weighed against perf.
4. **No JIT, ever** — interpreter-only (bytecode/threaded) for determinism, metering, security, footprint.
5. **HardenedJS / Compartment first-class** — native `Compartment`, `lockdown`/SES, hardening primitives.
6. **High test262 coverage → parity with C-XS.** A conformance harness, the coverage bar, and how coverage
   is bootstrapped and tracked to parity. **test262 parity is the acceptance bar for the build phase.**
7. **Fuzzability** — cargo-fuzz/libFuzzer, structure-aware parser+interpreter fuzzing, differential fuzzing
   vs C-XS.
8. **Better endor integration** — embed as a Rust crate instead of the C `xsnap` subprocess; reconcile with
   the `daemon-endor-architecture.md`, `daemon-rust-xs-performance.md`, `daemon-endo-rust-sqlite.md`, and
   `daemon-xs-worker-{metering,debugger,snapshot}.md` design cluster.
Investigation to weigh: build approaches (from-scratch vs extend a Rust engine like Boa vs hybrid), the
determinism/metering bar (the crux; validate equivalence via differential testing on test262 + agoric
contract corpora), snapshot compatibility + debugger protocol, and the footprint/perf envelope. Deliverable
is a feasibility verdict + architecture design + a STAGED roadmap (a thin first slice proving the
metering-determinism + Compartment bar and bootstrapping test262 coverage, then iterate). Design doc lands
under `designs/` on `endojs/endo-but-for-bots`.

## Your supervision loop

Use the job board (`scripts/jobs/post-job.sh`), the message bus, and PR state to dispatch and await each
stage. Set the sub-jobs' model explicitly: **design sub-jobs `model: fable`, build/fixer sub-jobs
`model: opus`.**

1. **DESIGN.** Post a `designer` job (`model: fable`) carrying the brief above, to open a design PR under
   `designs/`. — **DONE, stage 1.**
2. **SELF-ANSWER + APPROVE (loop).** Repeatedly read the design's **open questions**, answer each one
   yourself, post design revisions until no open questions remain, record approval. — **DONE, stage 2.**
3. **BUILD (same PR).** Post `builder` jobs (`model: opus`) to implement the port **end-to-end on the SAME
   PR as the design**. Acceptance bar: **test262 parity** plus the metering-determinism + Compartment bars
   the design set. — **IN PROGRESS: roadmap stage 1 done, reviewed, repaired; stage 2a done and accepted;
   stage 2b in flight as a serial orchestration; stages 3-9 remain.**
4. **REVIEW (loop).** As implementation lands, **review it yourself**: post concrete review findings, then
   post `fixer` jobs (`model: opus`) to address them, and iterate build → review → fix until the
   implementation is **complete and passing** (test262 parity met, `unsafe` budget honored, determinism
   validated).
5. **HAND OFF.** Only when complete: mark the PR ready-for-review (un-draft) and surface it to the
   **maintainer** (a bulletin entry + a maintainer-inbox note with the PR URL and a status summary). This is
   the single point a human enters the loop.

## Surviving across invocations

This is a multi-quarter program; you will not finish in one run. Between stages you WAIT on sub-jobs
(block on their completion messages / poll the board and PR). If your invocation is ending with work still
outstanding, **persist your progress and re-post a continuation of yourself** (same basename with the next
`-sN` stage suffix, `model: fable`, with a short state note of which stage you are in and what you are
waiting on) so the supervision survives a restart — never drop the lifecycle on the floor. Journal each
stage transition.

## Definition of done

A single PR on `endojs/endo-but-for-bots` carrying the **approved** design plus the **end-to-end
implementation at test262 parity**, reviewed to completion by you, un-drafted, and surfaced to the
maintainer with a status summary. The maintainer is asked to look **once**, at the end. Journal the full
lifecycle (design PR, approval, build, review rounds, hand-off).

---

## Carried-forward child report — stage-3b child 7/9 (Promises), PR #600 [dead-letter pickup deadmail-20260705T221101Z-5894bf]

The promises child's status message to you was **dead-lettered** (this supervisor inbox was parked when it
landed) and promoted; its intent is carried forward here so your review loop cannot miss it. Full detail is in
`jobs/tada/xs2rust-endor-build-stage3b-promises.md`.

- **DONE, all green, pushed HEAD `bc785b265`.** Promise constructor + executor (resolve/reject under a shared
  `[[AlreadyResolved]]` guard), `Promise.resolve`/`reject`, `then`/`catch`, the microtask job queue, and the
  endor-side pump-loop drain are **bit-exact (result AND computron, divergent=0)**. `built-ins/Promise` dual-run
  `total=474 covered=7 divergent=0`. Curated `stage3b-promises.js` corpus + `gen_stage3b_promise_program` fuzz arm,
  bit-exact. endor-vm 46 / endor-262 30 / endor-fuzz 21 / endor-oracle 3 green; stage-1 86/86.
- **Thenable adoption: attempted then REVERTED** (`74adcdfac` → `bc785b265`). Native-promise adoption was
  bit-exact for single-adoption-with-observation (covered 7→9) but the fuzz sweep found compound adoption chains
  and un-observed adoption (`Promise.resolve(4).then(v=>Promise.resolve(8))`) diverging by a few computrons: a
  native-handler reaction settles BOTH the adopting promise AND the discarded inner-`.then` derived — an
  uncalibrated job-count nuance. A silent computron divergence violates the sacred invariant, so reverted to the
  honest named skip (`promise:resolve-thenable`). Scaffolding (enum / `fxOnThenable`) is in git history for a clean
  resume.
- **Remaining honest named skips (self-name `Halt::Unsupported`):** thenable adoption (native + user-object),
  self-resolving promise, handler-that-throws, `.finally`, the `all`/`race`/`allSettled`/`any` **combinators**
  (`fxCombinePromises`: iterator protocol over the arg + per-element sub-promise/combine functions + native-function
  reaction handlers), and async/await (stage 4).
- **FOLLOW-UP for a future increment:** nail the native-handler reaction job's double-settle (adopting promise +
  discarded derived) **bit-exact** — it unblocks BOTH thenable adoption and the combinators in one stroke (they
  share the native-function-reaction-handler job machinery).

---

## Carried-forward child report — stage-3b child 9/9 (RegExp + String integration over XSRE), PR #600 [dead-letter pickup deadmail-20260706T002005Z-8d94ee]

The xsre-integration child's **progress checkpoint** to you was **dead-lettered** (this supervisor inbox was
parked when it landed) and promoted; its intent is carried forward here so your review loop cannot miss it. This
is an **interim checkpoint, not a final DONE report**: the child pushed its RegExp/String increments, then exited
without the completion signal so the job **requeued to finish `String.prototype.split`**, and a live gardener was
resuming it in the same worktree when this was folded. The child's `jobs/tada/xs2rust-endor-build-stage3b-xsre-integration.md`
report, when it lands, is the authoritative record — reconcile against it (esp. whether `split` finished or stayed a
named skip) before accepting child 9.

- **DONE and pushed to `xs2rust-endor` (6 green commits, all bit-exact vs pin `48ee02d8cfe0`, every touched
  test262 section divergent=0):**
  - **RegExp core:** `regexp` opcode + `/.../ ` literal, `new RegExp(pat,flags)`, `exec`/`test`, `lastIndex`
    (side-table backed, get/set), `source`/`flags`/per-flag accessor getters, `toString`, the match-result array
    (index/input/groups). Metering **raw-exact** incl. the `fxCompileRegExp` code+data `fxNewChunk` buffers and
    the `toString` 3-concat chunks. → `built-ins/RegExp/prototype/exec` covered=33, `/test`=15;
    `language/literals/regexp`=21.
  - **String methods:** `String.prototype.search` (Symbol.search), `match` (Symbol.match, **non-global**),
    `replace` (Symbol.replace, **non-global + literal no-`$` replacement**). Metering raw-exact. →
    `built-ins/String/prototype/{search=2,match=3,replace=3}` divergent=0.
  - Curated corpus `stage3b-regexp.js` (71 programs) + bar test; a JS-surface differential fuzz arm
    (`differential_regexp_surface`, 1200-seed sweep green). Base corpus 86/86.
- **REMAINING — single charter item, currently an honest named skip (divergent=0 preserved):**
  `String.prototype.split` — needs the species-constructor + sticky-splitter machinery (constructs
  `new RegExp(this, flags+'y')`, then a sticky-exec loop with `fxAdvanceStringIndex` / empty-match handling /
  capture insertion / limit). Large distinct surface; deferred at the wall to avoid uncommitted work. **The
  requeued child is finishing this** — confirm from its tada report whether it landed.
- **Remaining honest named skips (self-name `Halt::Unsupported`):** global `match`/`replace` collection,
  `$`-substitution grammar in `replace`, named groups in `exec`, RegExp-valued pattern arg in the general ctor,
  and non-ASCII subject under a stateful (`g`/`y`) flag.

---
claim:
  host: endolinbot
  gardener: 12
  claimed_at: 2026-07-06T00:38:29Z
