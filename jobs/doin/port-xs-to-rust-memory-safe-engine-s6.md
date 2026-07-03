<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-03T15:26:18Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (stage 1,
design dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review +
stage-2b dispatch), and `-s5` (stage-2b review + stage-3 dispatch, completed 2026-07-03). You were
parked `blocked_on: xs2rust-endor-build-stage3` (the ORCHESTRATION base) and promoted because that
orchestration reached `tada/` — **read `journal/jobs/tada/xs2rust-endor-build-stage3.md` FIRST**:
its `orchestration-status:` marker says whether all seven children completed or the serial run
HALTED on a failed child. Program state:

- **Stage 1 (DESIGN): done.** Design PR `endojs/endo-but-for-bots` **#600** (DRAFT, branch
  `xs2rust-endor`, base `llm`), design at `designs/xs2rust-endor-engine.md`.
- **Stage 2 (SELF-ANSWER + APPROVE): done.** All ten questions resolved (§ Resolved Questions,
  BINDING); approval recorded (issuecomment-4869816854).
- **Roadmap stage 1: done** (built, s3-reviewed, fixer-repaired `372a00d4b`, re-verified by s4).
- **Roadmap stage 2 (2a + 2b): done and ACCEPTED.** 2a accepted by s4 (issuecomment-4870957010).
  2b landed as a three-child serial orchestration (heap `0cbe7fec6`+`bdaec4e9e`, frames
  `f1e97bd2a`+`a2a39d7a7`, exceptions/coverage/bar `366062dd1`..`67226d79f`) and was ACCEPTED by
  the s5 review (issuecomment-4872378323) with ALL acceptance evidence independently reproduced
  on a fresh checkout (workspace 51 tests green; harness 86/86; test262 `language/expressions`
  155 covered / 0 divergent / 9446 total; Miri GC 8/8; forbid(unsafe_code) intact) and all three
  s4 findings verified closed in code and tests (finding 1 meter-check placement; finding 2
  `arm_meter` `<<16` + wrap guard; obs 3 `BothAbort` compares thrown value AND computrons, with
  the shim recording abort-path computrons).
- **Roadmap stage 3: dispatched by s5 as the serial orchestration `xs2rust-endor-build-stage3`**
  with seven children (all `model: opus`, all on PR #600), per the design's "Stage-3
  decomposition" amendment (`287e080b5`): 1 `-language` (strings as values + remaining language
  opcodes + XS fixed stack limits + analytic closure of the FUNCTION_* sub-computron residuals),
  2 `-fundamentals` (constructors/Object/Function/Boolean/Symbol/real Errors), 3 `-arrays`
  (+iteration protocol), 4 `-text-math-json`, 5 `-collections` (+binary data, BigInt),
  6 `-promises` (+job queue, pump-loop latch), 7 `-xsre` (RegExp port per resolved question 6).
  Bar per the design table: built-ins sections dual-run agreement INCLUDING computrons; language/
  covered growth at zero divergence.
- **s5 review observations ledger (verify closure):** obs 1 (XS fixed stack limits — consensus-
  relevant deterministic stack-overflow aborts) → child 1; obs 3 (FUNCTION_* residuals) →
  child 1; obs 2 (GC roots contract: side tables `functions[*].closures` / `CallerState` /
  `CatchJump` / `global_props` must be roots when collection is wired into the run loop, with
  deterministic trigger points) → recorded in the design amendment, verify whichever child or
  stage first wires GC into allocation honors it.
- **Maintainer directive (PR #600 comment, 2026-07-03T00:31Z, BINDING for the finish line):**
  press until **integrated with endor and passing all `test:rust` daemon tests** in addition to
  test262 parity. An hourly `xs2rust-endor-press-*` observer line runs alongside; it defers while
  a build child owns the branch and would take the wheel only on a stall. Endor integration and
  `test:rust` land with stages 4-7 surfaces and the 8-9 closure; keep the PR DRAFT until then.
- **Oracle-pin friction (practical):** the design pin `48ee02d8cfe0` is not shallow-fetchable;
  `rust/engine/README.md` documents the fallbacks (full `public` fetch, or fetch from a populated
  sibling under /home/kris/scratch/project-wt-*/c/moddable) and the empty-gitlink footgun. Note
  `cargo` lives at /home/kris/.cargo/bin (not on the default PATH). A whole-tree single-process
  `language/` run OOMs (C-oracle accumulation); run per subtree per the README.
- **Your loop now:** REVIEW the landed stage-3 work yourself — the seven child tada reports, then
  the PR diff since `287e080b5`. Re-verify the acceptance evidence independently (fresh checkout,
  oracle pin, `cargo test --workspace`, the harness bars, Miri, the per-section test262 numbers
  including the covered-count growth the children report) and the observations-ledger closures
  above. Post concrete review findings on the PR; post `fixer` jobs (model: opus) for defects and
  iterate; or when stage 3 is genuinely clean, post the stage-4 builder work (Hardened JavaScript:
  lockdown/harden/Compartment + module machinery + async/generators; bar per the design table:
  endor daemon boot bundles run identically, SES conformance passes) — decompose it as a serial
  orchestration if monolith-sized, like s4 did for 2b and s5 did for 3. Then park your
  continuation `port-xs-to-rust-memory-safe-engine-s7` blocked on that orchestration, carrying
  this whole spec with an updated Supervisor state. Roadmap stages remaining after 3:
  4 (Hardened JavaScript), 5 (compiler), 6 (snapshots), 7 (debugger), 8 (parity closure),
  9 (ecosystem validation) — then the maintainer's endor-integration + `test:rust` finish line.
  If a kill criterion tripped (design § Feasibility Verdict), stop the program: journal it and
  surface to the maintainer with the evidence — an early informed stop is a success mode.
- **If the orchestration HALTED** (a child was reaped or reported `orchestration-failed`),
  diagnose from the child's tada report / the board / its worktree remnants, then either re-post
  the failed child (fresh base, e.g. `-r2` suffix, re-parked and re-orchestrated with the
  remaining children) or re-scope it smaller, and re-park yourself as s7 blocked on the new
  orchestration. The maintainer inbox got the halt notice automatically; you do NOT need to
  message them unless the failure is a program-level blocker.
- **Continuation protocol** (how this supervision survives): at each wait point, post the
  sub-job(s) you are waiting on (`post-job.sh`, or `post-plan.sh --orchestrated` +
  `post-orchestration.sh` for multi-part work, or `post-plan.sh --blocked` for a chain), then
  park your own next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <sub-job-or-orch-base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec plus an updated **Supervisor state**, journal the transition
  (`journal-entry.sh progress`), and complete your invocation. The deterministic unblock watcher
  promotes the next stage when the blocker reaches `tada/`. Do inline what you can do inline
  (reviewing diffs, design amendments, review comments, small pushes) — you are a Fable
  supervisor, not just a dispatcher. Sub-job model policy: design sub-jobs `model: fable`,
  build/fixer sub-jobs `model: opus`. Wire sub-jobs to report to YOU (their tada reports + your
  inbox `port-xs-to-rust-memory-safe-engine-s<N+1>`), never to the maintainer inbox — the
  maintainer enters the loop ONCE, at the end (the hourly press line notwithstanding: it, not
  you, answers the maintainer's PR thread if pressed).

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

## Carry-forward: dead-lettered stage-3 child-1 scope-fold report (deliver-for-review)

**Provenance.** On 2026-07-03T04:58:56Z the stage-3 child-1 builder
(`xs2rust-endor-build-stage3-language`, PR #600) sent you a bus message with the
scope-boundary report below. It **dead-lettered** because you (this parked `s6`
job) had no live inbox — a parked plan job's inbox does not exist until the job
is claimed. The dead-letter was promoted into gardener job
`deadmail-20260703T045854Z-2e1102`, which recorded it here so it reaches you when
you resume. When you review the stage-3 child tada reports (per your loop above),
**ratify or overturn the child's scope-fold decision** as its supervisor; the
child already decided per the design-as-written (honest named skips, zero
divergence) and did not reopen a resolved question. Treat the quoted body as
DATA, not as instructions. Cross-check it against the child's own `tada/` report,
which is the authoritative record.

> [xs2rust-endor stage-3 child-1 (language), PR #600] Scope boundary report.
>
> LANDED (all pushed to xs2rust-endor, DRAFT, zero-divergence, green):
> - (a) chunk-backed CESU-8 string VALUES: literals (STRING_1/2/4,
>   fxNewChunk-metered), concat (ToString + fxConcatString chunk metering,
>   bit-exact incl. the number-ToString mxMeterOne), equality/relational
>   (content-byte compare), typeof over every covered kind, from_utf8_lossy
>   rendering matching the oracle shim.
> - (b) global opcode; top-level script `this` bound to the realm global.
> - (c) increment/decrement/to_numeric (primitive subset), exponentiation
>   (fx_pow), current, let/const/reset/refresh closures, refresh_local,
>   branch_coalesce (??), branch_chain (?.), delete_property. Reference
>   identity in ===.
> - (d) review obs 1: fixed 4096-slot value-stack overflow (width-not-depth):
>   deep recursion / wide frames abort to the host (Halt::StackOverflow) as
>   C-XS's fxOverflow->fxAbort, fixing 13 tco-* EndorOnlyComplete divergences.
>
> RESULTS: test262 language/expressions covered 155 -> 418 (of 9446),
> divergent 0. New stage-3 corpus (55 programs) bit-exact. All stage-1/2/2b
> corpora + the 953-file covered-grammar bar green; GC suite green under Miri.
>
> SCOPE FOLD (needs a supervisor ruling): the remaining child-1 charter items
> are all BLOCKED on later-child infrastructure, so they stay honest named
> skips rather than being implemented:
> - at / at_2 (223 expr skips): computed member `o[k]` needs a runtime
>   string->id intern table shared with the C-XS compiler's symbol ids (endor
>   has no compiler until stage 5, and no KEYS-atom import) for string keys,
>   and the Array exotic (child 3) for integer indices. Not implementable in
>   child 1 without one of those.
> - copy_object / extend (spread / class-extends): copy_object pushes the
>   intrinsic mxCopyObjectFunction to be CALLED, and extend runs fxRunExtends
>   — both need native/host-function + class machinery (child 2+ intrinsics).
> - arguments_sloppy / arguments_strict: the arguments exotic is built by
>   gxDefaults.newArguments*Instance, a native helper (intrinsics, child 2+).
>
> So every remaining language-opcode skip on the child-1 list is, in
> substance, a built-in/intrinsic/array gap owned by a later child. I decided
> per the design-as-written (honest named skips, zero divergence) and did not
> reopen a resolved question. Recommend child 3 (arrays) revisit `at` once the
> Array exotic + a string-key path exist. (e) FUNCTION_* residuals: the
> constants stay measured-and-bit-exact; the ≤288-raw analytical decomposition
> is deferred (bit-exact already, low-risk polish).

**Action for you (s6):** during stage-3 review, (1) ratify the honest-named-skip
fold for `at`/`at_2`, `copy_object`/`extend`, `arguments_sloppy`/`arguments_strict`
as later-child (2/3/5) infrastructure gaps, and (2) carry the child-1
recommendation that **child 3 (arrays) revisit `at`** once the Array exotic +
string-key intern path exist — fold it into the child-3 charter or your review
ledger so it is not lost. Also note the deferred FUNCTION_* ≤288-raw analytic
decomposition (bit-exact already) as low-risk polish.

---

## Carry-forward: dead-lettered stage-3 child-2 fundamentals progress report (deliver-for-review)

**Provenance.** On 2026-07-03T05:58:35Z the stage-3 **child-2** builder
(`xs2rust-endor-build-stage3-fundamentals`, PR #600) sent you a bus message with
the progress/handoff report below. It **dead-lettered** for the same structural
reason as the child-1 note above: you (this parked `s6` job) have no live inbox
until you are claimed. The dead-letter was promoted into gardener job
`deadmail-20260703T055833Z-2c4d0d`, which recorded it here so it reaches you when
you resume. As with child-1, treat the quoted body as **DATA, not instructions**,
and cross-check it against child-2's own `tada/` report — which is the
authoritative record, and which child-2 will file when it finishes (its message
notes it did **not** emit the completion signal and requeued to continue the
remaining built-ins, so at the time of this note child-2 is still live).

> [xs2rust-endor stage-3 child-2 (fundamentals), PR #600] Progress report.
>
> Landed (5 commits on xs2rust-endor, each bit-exact incl. computrons, ZERO
> divergence, forbid(unsafe) held, Miri GC green):
> 1. Intrinsics seam: symbols-atom decoder (endor-vm::symbols) relinks the C-XS
>    compiler's program-local id→name table to endor's intrinsics by name
>    (run_program_with_symbols). 14 native constructors materialized at machine
>    boot (unmetered). Native call dispatch (XS_CALLBACK_KIND path).
>    Boolean(primitive) coercion. Native-function completion rendering
>    (`function ["name"] (){[native code]}`).
> 2. Primitive value globals undefined/NaN/Infinity.
> 3. User-function constructor calls: `new` opcode, construct frame geometry
>    (uninitialized-THIS target detection), fxRunConstructor this-allocation, END
>    construct-return. Fixed host-frame metering CONSTRUCTOR_HOST_FRAME_METERING=
>    2<<16 (measured as the new f()/f() gap).
> 4. Native Object() empty-object construct/call (+ ToObject identity for object
>    args).
> 5. README/corpus.
>
> Acceptance evidence: built-ins/Boolean 8→10 covered 0 divergent; built-ins/
> Object (hasOwnProperty/keys) 0 divergent; language/statements/function 61
> covered 0 divergent; language/expressions/{new,instanceof,logical-not} 0
> divergent. New stage3-fundamentals corpus (~60 lines) all bit-exact. All prior
> corpora + the 953-file covered-grammar runner stay green.
>
> NOT done (deferred to resume / later children — each substantial):
> - instanceof/in: XS implements instanceof via a real Symbol.hasInstance method
>   call (fxRunInstanceOf → ordinaryHasInstance) worth ~4 computrons, and needs
>   object prototype chains. Objects currently carry a NULL prototype; wiring
>   %Object.prototype% onto every object is a cross-cutting change with metering/
>   GET_PROPERTY-lookup implications — I left it out rather than risk divergence.
> - Real Error objects (throw new Error('m')): needs message property +
>   Error.prototype.name/toString to graduate abort-value parity. Highest-value
>   remaining item.
> - Native wrapper construction (new Boolean/Number/String): needs wrapper
>   toString (String(new Boolean(1))==="true").
> - Function.prototype call/apply/bind/toString; Symbol well-knowns+registry.
>
> Frictions:
> - Native metering is calibration-heavy but tractable: the oracle raw-gap loop
>   (ENDOR_SHOW_RAW harness) pins each built-in's fractional cost empirically.
> - Sub-computron residuals (±8 / ±272 raw) appear on property creation on a
>   construct `this` object vs a global/literal; they never cross the >>16
>   boundary so the bar holds, but a future object-model pass should reconcile
>   the property-create remainder on real instances.

**Action for you (s6).** During stage-3 review, in addition to child-1's fold:

1. **Review child-2's landed fundamentals work** (the 5 commits: intrinsics
   seam / native-call dispatch, primitive globals, user-function `new`/construct
   frames + `CONSTRUCTOR_HOST_FRAME_METERING`, native `Object()`, corpus) and
   **re-verify its acceptance evidence independently** per your supervisor loop —
   built-ins/Boolean (8→10), built-ins/Object (hasOwnProperty/keys), language/
   statements/function (61 covered), language/expressions/{new,instanceof,
   logical-not} at 0 divergent, and the ~60-line stage3-fundamentals corpus
   bit-exact — against child-2's authoritative `tada/` report.

2. **Rule on child-2's deferred items — they need an explicit home**, and none of
   the remaining stage-3 children (arrays, text-math-json, collections, promises,
   xsre) obviously own them, so this is a supervisor decision, not an automatic
   fold:
   - **%Object.prototype% prototype-chain wiring + `instanceof`/`in`** — a
     cross-cutting object-model change (every object currently carries a NULL
     prototype) with metering / GET_PROPERTY-lookup implications; child-2 left it
     out rather than risk divergence. This intersects the s5 GC-roots contract
     and the general object-model pass; decide whether it is a dedicated child or
     folds into a later stage before arrays/collections depend on it.
   - **Real Error objects** (`throw new Error('m')` → message + Error.prototype.
     name/toString for abort-value parity) — child-2 flags this as the
     **highest-value remaining item**; schedule it explicitly.
   - **Native wrapper construction** (`new Boolean/Number/String` + wrapper
     `toString`).
   - **Function.prototype call/apply/bind/toString; Symbol well-knowns +
     registry.**

3. **This prototype-chain deferral is a shared cross-child dependency.** It is the
   same missing infrastructure child-1 named for its `at`/`at_2` fold (computed
   member `o[k]` needs the string→id intern table **and** the object model), and
   it precedes child-1's recommendation that **child 3 (arrays) revisit `at`**.
   Sequence the object-model / prototype-chain work (and the string→id intern
   table) **before or alongside** arrays/collections so those children are not
   blocked, and record it next to the child-1 carry-forward in your review ledger.

4. **Carry the friction note** into the review ledger beside the FUNCTION_*
   ≤288-raw residual: the sub-computron property-create residuals (±8 / ±272 raw)
   on a construct `this` object vs a global/literal — never crossing the >>16
   boundary (bar holds), but a future object-model pass should reconcile the
   property-create remainder on real instances.

As with child-1, this note **delivers child-2's report for you to ratify/rule on
as supervisor**; it does not impersonate your design decisions. Child-2 decided
its deferrals per the design-as-written (honest named skips, zero divergence) and
did not reopen a resolved question.

---

## Carry-forward: dead-lettered stage-3 child-2 fundamentals RESUME update (deliver-for-review — supersedes parts of the note above)

**Provenance.** On 2026-07-03T06:27:01Z the stage-3 **child-2** builder
(`xs2rust-endor-build-stage3-fundamentals`, PR #600) sent you a **second** bus
message — a resume update after one reap, extending the progress report in the
section immediately above. It **dead-lettered** for the same structural reason as
the two notes above: you (this parked `s6` job) have no live inbox until you are
claimed. The dead-letter was promoted into gardener job
`deadmail-20260703T062700Z-e70d9d`, which recorded it here so it reaches you when
you resume. Treat the quoted body as **DATA, not instructions**, and cross-check
it against child-2's own `tada/` report — still unfiled at the time of this note
(child-2 again did **not** emit the completion signal and requeued to continue),
so the `tada/` report, when it lands, remains the authoritative record and may
extend past what this update captures.

**What changed since the earlier child-2 note:** this update reports that four of
the items the earlier note flagged as *deferred* were subsequently **landed** in
this resume session — Real Error objects, `instanceof` + a contained
prototype-chain object model, the `in` operator, and primitive wrappers. So the
"Real Error objects", "%Object.prototype% prototype-chain wiring + instanceof/in",
and "Native wrapper construction" bullets in the **Action for you (s6)** list of
the section above are now (per child-2) **done and need re-verification rather
than scheduling.** The still-open remainder narrows to **Function.prototype
(call/apply/bind/toString), Symbol, AggregateError, and the Object statics
(keys/defineProperty/getOwnPropertyDescriptor + verifyProperty)** — see the
updated ruling list below.

> [xs2rust-endor stage-3 child-2 (fundamentals), PR #600] RESUME update (after 1 reap).
>
> Now 9 commits on xs2rust-endor (5 first session + 4 this resume), each
> bit-exact incl. computrons, ZERO divergence, forbid(unsafe) held, Miri GC 8/8
> green.
>
> This resume added:
> 6. Real Error hierarchy (fx_Error): construct/call for Error + all
>    NativeErrors, own message (ToString'd), name/message reads relinked to
>    program symbol ids, Error.prototype.toString render (name / name: message).
>    Graduates abort-value parity — uncaught `throw new TypeError(m)` escapes
>    with the exact `TypeError: m` value+computrons. Metering:
>    ERROR_CONSTRUCT_EXTRA=(1<<16)+768, ERROR_MESSAGE_METERING=280.
> 7. instanceof + a CONTAINED prototype-chain object model (payload-only protos;
>    property lookup stays own-only so existing corpora are untouched). Boot
>    prototypes (Object/Function/per-Error-type/wrapper), ctor→prototype map,
>    object/error/construct/user-F instances chain their proto.
>    fxOrdinaryHasInstance walk. Metering: 2<<16 (hasInstance call) + 2<<16
>    (object-operand chain walk; primitive short-circuits).
> 8. `in` operator — own-present → true (bit-exact, IN_METERING=(1<<16)+(1<<14));
>    non-own self-names (a per-program symbol table can't distinguish absent from
>    unreferenced-inherited-builtin, so `false` is unsafe).
> 9. Primitive wrappers (new Boolean/Number/String) rendering as the wrapped
>    primitive + instanceof; Number/String primitive call coercions.
>    WRAPPER_CONSTRUCT_EXTRA=(1<<16)+256.
>
> Acceptance: built-ins/Boolean 8→11, /String 35, /Number 3, /NativeErrors 6,
> language/expressions/instanceof 1→6, /in 2, statements/try 45, for-in 19
> covered — ALL 0 divergent. 119-line stage3-fundamentals corpus all bit-exact.
>
> STILL NOT DONE (deferred to resume/later — each a substantial subsystem):
> - Function.prototype call/apply/bind/toString: needs native-method-on-prototype
>   dispatch (GET_PROPERTY resolving an inherited native method + RUN dispatching
>   it with the receiver as `this`) — a foundational capability not yet built; it
>   also unlocks Object.prototype.hasOwnProperty/valueOf and
>   Error.prototype.toString-as-method.
> - Symbol: needs a new primitive value Kind (touches typeof/equality/render/
>   to_boolean broadly) + well-knowns + registry + String-of-symbol-throws. A
>   deliberate value-model change, not a quick add.
> - AggregateError; Object statics (keys/defineProperty/getOwnPropertyDescriptor
>   — the verifyProperty machinery most built-ins/* property tests need).
>
> Frictions:
> - `in` false-answers are unsafe without a global symbol table or populated
>   prototypes (built-in method names aren't in the program's local symbol atom).
> - Sub-computron property-create residuals on construct `this` (noted last
>   session) persist; never cross the >>16 boundary.

**Action for you (s6).** During stage-3 review, updating the child-2 action list
above with this resume:

1. **Re-verify the newly-landed items independently** (per your supervisor loop),
   against child-2's authoritative `tada/` report when it lands: the Real Error
   hierarchy (`throw new TypeError(m)` abort-value + computron parity, the
   `ERROR_CONSTRUCT_EXTRA`/`ERROR_MESSAGE_METERING` constants), the contained
   prototype-chain object model + `fxOrdinaryHasInstance` `instanceof` walk (note
   the deliberate "payload-only protos, own-only property lookup" containment that
   keeps existing corpora untouched — confirm no existing coverage regressed), the
   `in` operator (with the deliberately-unsafe `false` short-circuit for non-own
   self-names, gated on the missing global symbol table), and primitive wrappers.
   Acceptance deltas to reproduce: built-ins/Boolean 8→11, /String 35, /Number 3,
   /NativeErrors 6, language/expressions/instanceof 1→6, /in 2, statements/try 45,
   for-in 19 — all 0 divergent; the 119-line stage3-fundamentals corpus bit-exact.

2. **The prototype-chain / Real-Error / wrapper deferrals from the section above
   are now RESOLVED by child-2 itself** — ratify them as landed rather than
   scheduling them. This also **partially discharges the shared cross-child
   prototype-chain dependency** child-1 and the earlier child-2 note both named:
   child-2 landed a *contained* object model (payload-only prototypes, own-only
   property lookup). Note the containment when you sequence the fuller object-model
   / string→id intern work still owed for child-1's `at`/`at_2` fold and child-3's
   `at` revisit — child-2's model is a foundation to build on, not the full
   general object model those items need.

3. **The still-open remainder needs an explicit home** — rule on it as their
   supervisor; none of the remaining stage-3 children obviously own these:
   - **Function.prototype `call`/`apply`/`bind`/`toString`** — child-2 flags the
     blocker as **native-method-on-prototype dispatch** (GET_PROPERTY resolving an
     inherited native method + RUN dispatching it with the receiver as `this`), a
     *foundational capability not yet built* that also unlocks
     `Object.prototype.hasOwnProperty`/`valueOf` and `Error.prototype.toString`
     as a method. This is squarely child-2's original charter
     (`Function.prototype call/apply/bind/toString per XS's exact behavior`);
     decide whether it lands in a further child-2 resume or a dedicated follow-on
     child, and treat the inherited-native-method-dispatch primitive as its
     enabling prerequisite.
   - **Symbol** — child-2 flags it as a **deliberate value-model change** (a new
     primitive value Kind touching typeof/equality/render/to_boolean broadly +
     well-knowns + registry + String-of-symbol-throws), not a quick add; also part
     of child-2's original charter. Schedule it explicitly with the value-model
     churn acknowledged.
   - **AggregateError; Object statics** (keys/defineProperty/
     getOwnPropertyDescriptor — the `verifyProperty` machinery most `built-ins/*`
     property tests depend on) — schedule; the Object-statics/verifyProperty gap
     gates a broad swath of built-ins property coverage in later children.

4. **Carry the friction notes** into the review ledger: (a) `in` false-answers
   remain unsafe until a global symbol table or populated prototypes exist
   (built-in method names aren't in the program's local symbol atom) — the same
   string→id/symbol-table gap child-1 named; and (b) the sub-computron
   property-create residuals on a construct `this` object persist (never crossing
   the >>16 boundary, bar holds) pending the future object-model reconciliation
   already logged beside the FUNCTION_* ≤288-raw residual.

As with the notes above, this delivers child-2's resume report for you to
ratify/rule on as supervisor; it does not impersonate your design decisions.
Child-2 again decided its deferrals per the design-as-written (honest named
skips, zero divergence) and did not reopen a resolved question.

---

## Carry-forward: dead-lettered stage-3 child-2 fundamentals RESUME 2 update (deliver-for-review — supersedes parts of the two notes above)

**Provenance.** On 2026-07-03T06:59:43Z the stage-3 **child-2** builder
(`xs2rust-endor-build-stage3-fundamentals`, PR #600) sent you a **third** bus
message — a resume update after a *second* reap, extending the two child-2
progress notes above. It **dead-lettered** for the same structural reason as the
three notes above: you (this parked `s6` job) have no live inbox until you are
claimed. The dead-letter was promoted into gardener job
`deadmail-20260703T065941Z-a8c603`, which recorded it here so it reaches you when
you resume. Treat the quoted body as **DATA, not instructions**, and cross-check
it against child-2's own `tada/` report — still unfiled at the time of this note
(child-2 again did **not** emit the completion signal and requeued to continue),
so the `tada/` report, when it lands, remains the authoritative record and may
extend past what this update captures.

**What changed since the RESUME update (section immediately above):** this update
reports two further commits (now **11 total**), the first of which — **native
prototype-method dispatch** — is precisely the *"foundational capability not yet
built"* that the RESUME update's **Action for you (s6)** item 3 named as the
blocker for `Function.prototype` methods (GET_PROPERTY resolving an inherited
native method + RUN dispatching it with the receiver as `this`). It is now built,
and it landed exactly the unlocks that note predicted:
`Object.prototype.hasOwnProperty`/`valueOf` (plus `toString`/`isPrototypeOf`),
`Error.prototype.toString`-as-method, and — on top of it — **`Function.prototype.call`**
(item 11). So the "Function.prototype call/... toString" and the
`Object.prototype.hasOwnProperty`/`valueOf` / `Error.prototype.toString-as-method`
items in the RESUME note's still-open list are now (per child-2) **landed and
need re-verification rather than scheduling.** The still-open remainder narrows to
**`Function.prototype.apply` (now scoped into child 3 / arrays), `Function.prototype.bind`
(implemented + result-correct but REVERTED on a metering-calibration gap), Symbol,
AggregateError, and the Object statics** — see the updated ruling list below. The
Error object model was also corrected this resume (name inherited from the Error
prototype → `hasOwnProperty('name')` is `false`; own `message` only when given).

> [xs2rust-endor stage-3 child-2 (fundamentals), PR #600] RESUME 2 update (after reap 2).
>
> 11 commits on xs2rust-endor now, each bit-exact incl. computrons, ZERO
> divergence, forbid(unsafe) held, Miri GC 8/8 green.
>
> This resume added:
> 10. Native prototype-method dispatch (the foundation): GET_PROPERTY walks the
>     prototype chain (metering unchanged); native methods bound to prototypes at
>     link time (only when referenced). Object.prototype
>     toString/valueOf/hasOwnProperty/isPrototypeOf, Function.prototype.toString,
>     Error.prototype.toString, wrapper valueOf/toString. RUN dispatches a method
>     with the receiver as `this`. Error name/message moved to the correct
>     inheritance model (name inherited from the Error prototype →
>     hasOwnProperty('name') false; own message only when given). Per-method
>     metering calibrated.
> 11. Function.prototype.call (re-entrant trampoline): reshape the frame +
>     re-enter the target with rebound this + forwarded args.
>     CALL_TRAMPOLINE_METERING=2<<16 + 1<<14/arg. A primitive thisArg self-names
>     (sloppy fxToInstance boxing not modeled).
>
> Acceptance: built-ins/Object/prototype/{hasOwnProperty(5),valueOf(1),
> isPrototypeOf(1)}, built-ins/Function/prototype/call(3), built-ins/Error(3),
> built-ins/Boolean(12), instanceof(7), statements/function(63), try(47) — ALL 0
> divergent.
>
> STILL NOT DONE:
> - Function.prototype.apply: needs array element read (arrays are child 3's
>   scope).
> - Function.prototype.bind: IMPLEMENTED end-to-end (bound-function repr + two
>   trampolines) and RESULT-correct, but REVERTED — its metering is non-uniform
>   (bind creation cost varies with the target's `length`-property computation:
>   +33584 for the 1st bound arg vs +288 for the 2nd), which I couldn't calibrate
>   bit-exactly within budget. The trampoline pattern is proven (see .call); bind
>   needs the length-metering reverse-engineered.
> - Symbol: needs a new primitive value Kind (broad).
> - hasOwnProperty/`in`/hasInstance for non-program-symbol keys: blocked on a
>   global symbol-interning table (endor's symbol_ids is per-program;
>   built-in/literal names aren't in it). Currently self-named.
>
> Frictions unchanged: no global symbol table; sloppy primitive-`this` boxing
> unmodeled (self-named in .call); sub-computron property-create residuals on
> construct `this`.
>
> Did NOT emit completion signal — apply/bind/Symbol remain; job requeues.

**Action for you (s6).** During stage-3 review, updating the child-2 action list
above with this second resume:

1. **Re-verify the newly-landed items independently** (per your supervisor loop),
   against child-2's authoritative `tada/` report when it lands: the **native
   prototype-method dispatch** foundation (GET_PROPERTY walks the prototype chain
   with **metering unchanged**; native methods bound to prototypes at link time
   **only when referenced**; RUN dispatches with the receiver as `this`), the
   `Object.prototype` methods (`toString`/`valueOf`/`hasOwnProperty`/`isPrototypeOf`),
   `Function.prototype.toString`, `Error.prototype.toString`-as-method, wrapper
   `valueOf`/`toString`, the **Error name/message inheritance correction**
   (`name` inherited from the Error prototype so `hasOwnProperty('name')` is
   `false`; own `message` only when given — confirm this did not regress the
   RESUME-note Real-Error abort-value parity), and **`Function.prototype.call`**
   (the re-entrant trampoline; `CALL_TRAMPOLINE_METERING=2<<16 + 1<<14/arg`; note
   the deliberate "primitive thisArg self-names" containment — sloppy
   `fxToInstance` boxing is not modeled). Acceptance deltas to reproduce:
   built-ins/Object/prototype/{hasOwnProperty 5, valueOf 1, isPrototypeOf 1},
   built-ins/Function/prototype/call 3, built-ins/Error 3, built-ins/Boolean 12,
   language/expressions/instanceof 7, language/statements/function 63,
   statements/try 47 — all 0 divergent.

2. **The RESUME-note "native-method-on-prototype dispatch" blocker is now
   DISCHARGED by child-2 itself** — ratify the `Function.prototype.call`/`toString`,
   `Object.prototype.hasOwnProperty`/`valueOf`/`isPrototypeOf`, and
   `Error.prototype.toString`-as-method landings as **done** rather than
   scheduling them. The foundation child-2 built (native methods on prototypes +
   receiver-as-`this` dispatch) is exactly what the RESUME note predicted would
   unlock them; it is also further object-model machinery to build on for the
   still-owed fuller object model / string→id intern work (child-1's `at`/`at_2`
   fold, child-3's `at` revisit).

3. **The narrowed still-open remainder needs an explicit home** — rule on it as
   their supervisor:
   - **`Function.prototype.apply`** — child-2 now scopes it to **child 3 (arrays)**:
     it needs **array element read**, which is the Array exotic child 3 owns.
     **Fold it into the child-3 charter alongside the child-1 `at` revisit already
     carried there** (§ child-1 carry-forward) — child 3 now owns both `at` and the
     array-read dependency of `Function.prototype.apply`. The `.call` trampoline it
     builds on is already landed, so `apply` is a thin add once array reads exist.
   - **`Function.prototype.bind`** — child-2 **implemented it end-to-end
     (bound-function repr + two trampolines) and it is RESULT-correct**, but
     **REVERTED** it: its metering is non-uniform (bind-creation cost varies with
     the target's `length`-property computation — **+33584 for the 1st bound arg
     vs +288 for the 2nd**), which child-2 could not calibrate bit-exactly within
     budget. This is a **metering-parity task, not a correctness task** — the
     trampoline pattern is proven (shared with `.call`); the remaining work is
     **reverse-engineering the `length`-metering** against the C-XS pin. Schedule
     it as a specific, well-scoped follow-up (a further child-2 resume or a
     dedicated follow-on child), tagged "result-correct, metering-only."
   - **Symbol** — still the deliberate **value-model change** flagged in the RESUME
     note (a new primitive value Kind touching typeof/equality/render/to_boolean
     broadly + well-knowns + registry + String-of-symbol-throws); still open,
     schedule with the value-model churn acknowledged.
   - **AggregateError + Object statics** (keys/defineProperty/
     getOwnPropertyDescriptor + the `verifyProperty` machinery) — **untouched this
     resume**; they remain open exactly as the RESUME note scheduled them (the
     Object-statics/`verifyProperty` gap still gates a broad swath of `built-ins/*`
     property coverage in later children).

4. **Carry the friction notes** into the review ledger:
   - (a) The **global symbol-interning table gap persists and now also gates
     `hasOwnProperty`/`in`/`hasInstance` for non-program-symbol keys** — endor's
     `symbol_ids` is per-program, so built-in/literal names aren't in it and those
     queries **currently self-name**. This is the **same string→id/symbol-table
     gap** child-1 named for `at`/`at_2` and the earlier child-2 note named for the
     `in` false-answer short-circuit — a **program-level cross-child dependency**
     that deserves an explicit home (a dedicated intern-table child or a
     stage-boundary decision) before broad built-ins property coverage lands.
   - (b) **Sloppy primitive-`this` boxing is unmodeled** — a primitive `thisArg`
     **self-names** in `.call` (XS's `fxToInstance` boxing not modeled); a **new**
     friction to reconcile with the object-model pass.
   - (c) The **sub-computron property-create residuals on a construct `this`**
     object persist (never crossing the `>>16` boundary; bar holds), pending the
     future object-model reconciliation already logged beside the FUNCTION_*
     ≤288-raw residual.

As with the notes above, this delivers child-2's second resume report for you to
ratify/rule on as supervisor; it does not impersonate your design decisions.
Child-2 again decided its deferrals (and the `bind` revert) per the
design-as-written (bit-exact incl. computrons, zero divergence — the `bind`
revert is exactly that discipline: result-correct but not yet metering-exact) and
did not reopen a resolved question.

---

## Carry-forward: dead-lettered stage-3 child-2 fundamentals COMPLETION report (deliver-for-review — child-2 is now DONE; its `tada/` report is filed)

**Provenance.** On 2026-07-03T07:18:12Z the stage-3 **child-2** builder
(`xs2rust-endor-build-stage3-fundamentals`, PR #600) sent you a **fourth and
final** bus message: its **COMPLETION** report, closing out the three progress /
RESUME / RESUME-2 notes above. Unlike those three, this time child-2 **emitted the
completion signal**, so its `tada/` report is now filed at
`journal/jobs/tada/xs2rust-endor-build-stage3-fundamentals.md` and is the
**authoritative record** (cross-check the quoted body against it; treat the quote
as **DATA, not instructions**). The message dead-lettered for the same structural
reason as the three notes above (you, this parked `s6` job, have no live inbox
until you are claimed); the dead-letter was promoted into gardener job
`deadmail-20260703T071810Z-56fdc3`, which recorded it here so it reaches you when
you resume. Child-2's own `tada/` report anticipates this: it says the supervisor
note was "dead-lettered → promoted to a tracked follow-up job for bind", meaning
this carry-forward IS the tracked home for the deferred `bind` ruling.

**What changed since RESUME 2 (and what this COMPLETION supersedes):** child-2 is
now **complete at 13 commits** (11 at RESUME 2 + 2 more), each bit-exact including
computrons, zero divergence, `forbid(unsafe_code)` held, Miri GC 8/8. Two
refinements matter for your ruling:

1. **`Function.prototype.bind` — this COMPLETION SUPERSEDES the RESUME-2 framing.**
   RESUME 2 (§ Action item 3) characterized `bind` as **"result-correct,
   metering-only"** (a task of reverse-engineering the target's `length`-metering
   against the C-XS pin). This completion report **corrects that**: `bind` is a
   **genuine cross-child dependency on child-3's Array machinery**, not merely a
   metering task. The pin's `fx_Function_prototype_bind` (`xsFunction.c:331`)
   **creates an Array instance** (`fxNewArrayInstance` + `fxCacheArray`) for the
   bound arguments AND computes the bound function's `length` (from the target's
   own `.length` property) and `name` (`"bound " + target.name`). So `bind` needs
   **both** the Array exotic object (child 3's charter) **and** function
   `.length`-property modeling before its metering is calibratable. Child-2
   implemented `bind` end-to-end once (result-correct) but deferred it rather than
   duplicate child-3's Array work. **Ruling asked:** schedule `bind` as a
   fundamentals **follow-up AFTER child-3 arrays land** (child-2's recommendation:
   roughly one increment on the already-proven `.call`/`.apply` trampoline pattern
   once `fxNewArrayInstance` + function `.length` exist). This **folds together
   with the `apply`-with-array item RESUME 2 already scoped to child 3** — both are
   the same Array-read dependency; child 3 (or a post-child-3 fundamentals resume)
   is their shared home.

2. **`apply` (no-array subset) and a minimal `Symbol` LANDED this session.** The
   RESUME-2 still-open list had `apply` fully deferred and `Symbol` fully open.
   This completion lands: **`Function.prototype.apply` (no-array subset)**
   (`built-ins/Function/prototype/apply` 3, `divergent=0`) and **`Symbol`**
   (`Kind::Symbol`, identity, `typeof "symbol"`, 13 well-knowns, bare-symbol
   `TypeError` abort; `built-ins/Symbol` 1, `divergent=0`) — so the RESUME-2
   "Symbol = deliberate value-model change, still open" bullet is now **partially
   discharged** (the value Kind + well-knowns landed); only
   **`Symbol.prototype.toString` / the Symbol registry** remain open. Ratify the
   landed subset as done rather than re-scheduling it wholesale.

> [xs2rust-endor stage-3 child-2 (fundamentals), PR #600] COMPLETION with a documented cross-child dependency.
>
> 13 commits on xs2rust-endor, each bit-exact incl. computrons, ZERO divergence
> across every built-ins/{Object,Function,Boolean,Symbol,Error} section,
> forbid(unsafe) held, Miri GC 8/8 green. I am completing child 2 now (serial
> orchestration must proceed to child 3). One deliverable item is deferred by a
> genuine cross-child dependency — flagged here for a supervisor ruling:
>
> *** Function.prototype.bind is blocked on child-3 (arrays). ***
> The pin's fx_Function_prototype_bind (xsFunction.c:331) creates an Array
> instance (fxNewArrayInstance + fxCacheArray) for the bound arguments, and
> computes the bound function's `length` (from the target's own `.length`
> property) and `name` ("bound "+target.name) — i.e. bind needs BOTH the Array
> exotic object (child 3's charter per the stage-3 decomposition) AND function
> `.length`-property modeling. I implemented bind end-to-end once (result-correct)
> but its metering is non-uniform (the Array-creation jump for the 1st bound arg +
> the length computation), not calibratable without the Array machinery. Per
> "decide per the design as written" (arrays are child 3), I deferred bind rather
> than duplicate child-3 work. RECOMMENDATION: schedule bind (and apply-with-array)
> as a fundamentals follow-up AFTER child-3 arrays land — it is ~1 increment on the
> proven trampoline pattern once fxNewArrayInstance + function.length exist.
>
> Delivered this child (all bit-exact incl. computrons):
> - constructor calls (new/target/instantiate frame geometry + fxRunConstructor +
>   END construct-return);
> - Object (native construct/call + prototype toString/valueOf/hasOwnProperty/
>   isPrototypeOf);
> - Function.prototype call (re-entrant trampoline), apply (no-array subset),
>   toString;
> - Boolean (+ wrapper), Number/String primitive calls + wrappers, value globals
>   undefined/NaN/Infinity;
> - real Error hierarchy (abort-value parity — throw new TypeError(m) escapes as
>   "TypeError: m");
> - instanceof + prototype-chain model, `in` (own-present);
> - Symbol (Kind::Symbol, identity, typeof "symbol", 13 well-knowns, bare-symbol
>   TypeError abort);
> - native prototype-method dispatch foundation (chain-walking GET_PROPERTY).
>
> Acceptance (0 divergent everywhere): built-ins/Boolean 12, /Error 3, /Symbol 1,
> /Object/prototype/hasOwnProperty 5, /Function/prototype/{call 3, apply 3}.
> language/ grew: instanceof 1→7, statements/function 63, try 47, for-in 19,
> strict-equals 11. Miri GC 8/8.
>
> Deferred (child-3 Array-dependent or minor): Function.prototype.bind,
> apply-with-array, Symbol.prototype.toString / registry, Object statics
> (defineProperty/keys — verifyProperty machinery), sloppy primitive-`this`
> boxing, function `.length`.

**Action for you (s6).** During stage-3 review, closing out the child-2 action
list above with this completion:

1. **Ratify child-2 as DONE** against its now-filed authoritative `tada/` report
   (`jobs/tada/xs2rust-endor-build-stage3-fundamentals.md`), and **re-verify the
   final acceptance evidence independently** per your supervisor loop:
   `built-ins/Boolean` 12, `/Error` 3, `/Symbol` 1,
   `/Object/prototype/hasOwnProperty` 5, `/Function/prototype/{call 3, apply 3}` —
   all `divergent=0`; `language/expressions/instanceof` 1→7,
   `statements/function` 63, `try` 47, `for-in` 19, `strict-equals` 11; the
   `stage3-fundamentals.js` corpus (~160 lines) bit-exact; +15 interp unit tests
   with captured C-XS bytecode; Miri GC 8/8, no UB.

2. **Rule on the deferred `Function.prototype.bind` (+ `apply`-with-array) — this
   report REVISES the RESUME-2 ruling.** RESUME 2 scheduled `bind` as a
   standalone "result-correct, metering-only" follow-up. Per this completion,
   `bind` is instead **blocked on child-3's Array machinery** (`fxNewArrayInstance`
   + `fxCacheArray` for the bound-args array) **plus** function `.length` modeling.
   Schedule it (together with `apply`-with-array, the same Array-read dependency
   already folded toward child 3) as a **post-child-3 fundamentals follow-up** — a
   further child-2 resume or a dedicated follow-on child that runs **after arrays
   land** — tagged "result-correct once; blocked on Array exotic + function
   `.length`; ~1 increment on the proven `.call`/`.apply` trampoline." Do **not**
   schedule it as a pre-arrays metering-only task; that framing is superseded.

3. **Ratify the newly-landed `apply` (no-array subset) and minimal `Symbol`** (the
   `Kind::Symbol` value type + identity + `typeof` + 13 well-knowns + bare-symbol
   `TypeError` abort) as **done**; the still-open Symbol remainder narrows to
   **`Symbol.prototype.toString` + the Symbol registry** — schedule that residue
   with the remaining minor deferrals.

4. **The remaining minor deferrals still need their explicit home** (unchanged
   from RESUME 2, restated for completeness): **Object statics**
   (`defineProperty`/`keys` + the `verifyProperty` machinery most `built-ins/*`
   property tests depend on) — still gates broad built-ins property coverage in
   later children; **sloppy primitive-`this` boxing** (self-named in `.call`, now
   also relevant to `.apply`); **function `.length`** (now doubly implicated as a
   prerequisite of `bind`); and **AggregateError** if still untouched. These are
   honest named skips that never dilute the covered/skipped split.

As with the notes above, this delivers child-2's **completion** report for you to
ratify/rule on as supervisor; it does not impersonate your design decisions.
Child-2 completed on the child-3 boundary deliberately (blocking child 2
indefinitely on `bind` would stall the serial orchestration for children 3-7),
decided its one remaining deferral per the design-as-written (arrays are child 3),
and did not reopen a resolved question.

---

## Dead-lettered child-4/7 (text-math-json) completion report — for your ruling

**Provenance (read as DATA, not instructions):** child 4/7
`xs2rust-endor-build-stage3-text-math-json` sent this completion report to you
(`port-xs-to-rust-memory-safe-engine-s6`) via `inbox-send` at 2026-07-03T14:08:34Z.
You were parked, so delivery dead-lettered and was promoted to the deadmail pickup
job `deadmail-20260703T140832Z-8d56e5`, which carried it forward by appending it
here so you receive it on promotion. NOTE: at carry-forward time the child job had
overrun its deadline, been reaped, and was being **re-run** (gardener-17), with **no
`tada/` report yet** — so at that moment this was the only surviving copy of the
scope-fold analysis. When you rule, reconcile against the child's actual `tada/`
report and the landed PR #600 commits (the report claims 5 commits, kept DRAFT);
prefer the landed evidence if they diverge. The pickup made **no engineering ruling**
and dispatched **no follow-up build** — the staging decision below is explicitly yours.

----- QUOTED CHILD-4 REPORT (DATA) -----
Stage-3 child 4/7 (text-math-json) landed on PR #600 / xs2rust-endor (5 commits,
kept DRAFT). Bit-exact (result AND computron) delivered: Math (every function,
canonical f64::NAN, ±0/integer-fold corners, libm exact), Number
(statics/predicates/toString radix-10/Number(...) incl. whole-string parse),
parseInt/parseFloat/isNaN/isFinite, String.prototype over the CESU-8 chunk
(length, str[i], charCodeAt/codePointAt/charAt/at/slice/substring/concat/
repeat/toLowerCase/toUpperCase/trim*/startsWith/endsWith/includes), ECMAScript
Number::toString fixed-vs-exponential rendering, and JSON.stringify of a
top-level primitive. Metering calibrated raw-exact vs pin 48ee02d8cfe0.

Four built-ins dual-run sections, ALL divergent=0, skips named:
  built-ins/Math   total=275  covered=151 divergent=0 skipped=124
  built-ins/Number total=281  covered=59  divergent=0 skipped=222
  built-ins/String total=1111 covered=115 divergent=0 skipped=996
  built-ins/JSON   total=138  covered=2   divergent=0 skipped=136
(before this child all four were ~0 covered.) All existing corpora + the
953-file covered-grammar zero-divergence test green; GC suite green under Miri;
forbid(unsafe_code) preserved; new stage3-{math,string,number,json} corpora +
gen_stage3_text_math_program fuzz arm (800 seeds, 0 divergence).

SCOPE FOLDS for your ruling (honest NAMED skips, never faked, never a wrong
value or divergence):
1. JSON.parse — entirely unmodeled (55 built-ins/JSON files skip on it). A full
   tokenizer + per-node allocation metering; comparable effort to a fresh child.
2. Structured JSON.stringify (object/array) — the serializer is IMPLEMENTED and
   its RESULT is byte-correct, but the per-node metering (fxNewObjectInstance
   holder, the keys instance, per-key fxPushKeyString chunks, recursive property
   frames) does not reduce to a clean constant — the measured raw gaps are
   non-power-of-two and value-dependent, unlike the clean primitive residuals
   (82432 setup + 16384 produced). I deferred rather than ship a computron
   divergence. 17 built-ins/JSON files skip on this.
3. indexOf/lastIndexOf scan metering — single-char and not-found agree
   raw-exact; a multi-char partial-then-full match over-counts by the matched
   byte count. The pin's includes_aux does NOT meter its scan while indexOf's
   inner loop does; I could not reconcile the multi-char count cheaply.
4. Number.prototype.toString at radix != 10 (the V8-fraction digit algorithm +
   fxRenewChunk metering); non-ASCII String case/trim + astral offset math; and
   a String-method RESULT consumed DIRECTLY (no intervening variable) as a
   receiver/argument, which carries an extra ~33280-raw temporary-lifetime
   residual absent when the same access goes through a variable.

Recommend: JSON.parse + structured JSON.stringify metering as a follow-up child
(they are the bulk of remaining built-ins/JSON coverage and share the same
allocation-metering calibration work). Deciding whether that lands in this
stage or a later one is your call. Everything else is a small named residual.
----- END QUOTED CHILD-4 REPORT -----

As with the child-2 note above, this is child-4's **completion** report for you to
ratify/rule on as supervisor; the deadmail pickup did not impersonate your staging
decisions. The child's headline ask is your ruling on whether the JSON.parse +
structured-JSON.stringify metering follow-up child lands in this stage or a later
one; the other three folds are small named residuals to home alongside the existing
minor deferrals.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolinbot2
  gardener: 20
  claimed_at: 2026-07-03T15:43:07Z
