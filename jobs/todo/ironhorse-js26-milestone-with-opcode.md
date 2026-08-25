---
tier: mentor
handler-timeout: 14000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-25T10:10:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
# js-26 MILESTONE — the `with` opcode family (VM prerequisite + Annex-B/language/built-ins residue)

Consolidates the over-fragmented `ironhorse-js-26-cb-with-*` causal children
(`cb-with-annexb`, `cb-with-statements-exprs`, `cb-with-builtins-strict`) into ONE
per-family milestone with a real budget, minted by `ironhorse-js26-milestone-consolidation`
(2026-08-22). The old children were split under the disproven "one handler closes a
cluster" model and inherited a budget that could not reach the shared prerequisite.

**This is the FIRST milestone minted by the consolidation, and it is deliberately
`#1046`-free.** It does NOT depend on, duplicate, or build the `@endo/hardened262`
`ironhorse`/`ironhorse+ses` coverage-agent wiring that endojs/endo-but-for-bots#1046
is landing on a separate track. This milestone is pure `ironhorse-vm` engine work
measured directly by `full-run.sh` against the XS oracle; it needs neither hardened262
nor #1046. Do not wait on them.

## The prerequisite (do this FIRST — the whole ~949-case cluster cascades off it)
The entire `unsupported-opcode:with` cluster (~949 cases across `language/statements`,
`language/expressions`, `language/eval-code`, `annexB/language`, and a built-ins tail)
is the downstream shadow of ONE missing VM prerequisite: `ironhorse-vm/src/interp.rs`
has no handler for `XS_CODE_WITH`/`XS_CODE_WITHOUT`, so they fall to the default
`Halt::Unsupported(op.name())`. The parser already parses `with` (strict `with` is
already a parse SyntaxError) and the coder already EMITS the opcodes. Implement the VM
prerequisite first; the residual sub-families then clear as a cascade.

MECHANISM CONTEXT (shared finding from the cb-with analysis — port from
`c/moddable/xs/sources/xsRun.c`): `XS_CODE_WITH` (~L4429) sets
`variable=mxEnvironment; slot=fxNewEnvironmentInstance(the,variable); mxEnvironment=slot`.
`fxNewEnvironmentInstance` (xsType.c:1156) allocates TWO slots (instance + behavior slot
ID=`XS_ENVIRONMENT_BEHAVIOR` whose kind/value = top-of-stack `with` value: a Reference for
`with(obj)`, NULL/UNDEFINED for the eval prelude), prototype=prior env, and REPLACES
top-of-stack with the env-instance reference (the following POP removes it).
`XS_CODE_WITHOUT` (~L4438) pops `mxEnvironment` to its prototype. Name resolution:
`XS_CODE_EVAL_REFERENCE` (~L4346) / `PROGRAM_REFERENCE` walk the `mxEnvironment` prototype
chain; for an object env it calls `fxIsScopableSlot` (xsRun.c:4872 = `HasProperty(obj,id)`
AND NOT `(obj[@@unscopables]?.id` is truthy)) and on success pushes the object reference;
for a closure env it calls `mxBehaviorHasProperty` on the env instance; the fallthrough
pushes the realm global. `GET_VARIABLE`/`GET_THIS_VARIABLE` (xsRun.c:2331) and
`SET_VARIABLE` (2514) then do an ordinary property get/set on whatever object the
`*_REFERENCE` resolved. Metering: each WITH = one dispatch + 2× `SLOT_ALLOCATION_METERING`
(2×256 raw); the `EVAL_REFERENCE` scopable-walk cost and GET/SET-VARIABLE property costs
MUST be calibrated exactly against the oracle. In ironhorse-vm today, `EVAL_REFERENCE`
pushes a sentinel (`Kind::EnvReference`) and GET/SET-VARIABLE ignore it and call
`resolve_get`/`resolve_set` over `id_map`/`global_props`; STORE (`store_closure`, ~L24764)
already appends a closure cell to a top-of-stack Reference environment. Keep the EMPTY
with-chain path byte-identical to today so the large covered baseline never regresses —
make the env-chain resolution ADDITIVE (consulted only when a with/eval environment is
active).

## Ordered scope (prerequisite-first)
1. **VM WITH/WITHOUT + scopable env-chain resolution** (the prerequisite above). Land it,
   verify the empty-with-chain baseline is byte-identical, push.
2. **`language/statements` + `language/expressions`** with-opcode residue (~276 + ~228),
   plus `language/function-code`, `language/identifier-resolution`, `language/types`
   residuals reached through nested eval/with.
3. **`annexB/language`** (~145): Annex B 3.3 block-level function-declaration hoisting
   through direct eval (`func-block-decl-eval-*`, the `func-existing-{block-fn,fn,var}-
   {no-init,update}` and `func-init` matrix).
4. **Built-ins tail + strict-with**: `built-ins/Proxy` (~9, exercise
   `[[HasProperty]]`/@@unscopables/`[[Get]]`/`[[Set]]` trap order), `built-ins/Array`
   (~8), `built-ins/Function` (~3), and the 6 `strict:unsupported-opcode:with` cases
   (strict `with` must classify as a covered early SyntaxError against the oracle, not
   reach the opcode).

## MILESTONE DISCIPLINE — commit partial gains (this is the point of the re-scope)
COMMIT PARTIAL GAINS. This is a milestone, not an all-or-nothing cluster closure.
Landing verified coverage progress and reporting the honest residual is SUCCESS, not
failure. You are NOT required to fully close the ~949-case family in one claim, and you
MUST NOT emit an orchestration-failure signal merely because residual cases remain.
Work prerequisite-first, bank verified progress in bounded commits (implement → run the
affected slice → push → repeat) until your budget nears its wall, then report before/after
totals and the residual. Reserve the orchestration-failure signal ONLY for a genuine gate
breakage you cannot repair (a baseline regression, a red `cargo test`, a broken exact-meter
gate) — never for un-closed scope. If a large chunk remains, say exactly what and where.

## Quality bar (kept from the arc — non-negotiable for what you DO land)
Convert cases to COVERED via REAL execution against the XS differential oracle
(`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pin>
--no-fetch`), except a specifically-justified standards-grounded host-only/proposal
exclusion (cite spec). Do NOT relabel, suppress, skip-list, or add expectation files to
manufacture a pass. Add focused Rust regression tests under
`rust/engine/ironhorse-262/tests/` for every feature landed (e.g. the Annex-B block-fn
no-init-vs-update matrix, identifier-resolution-through-with). Regression invariant: no
baseline-covered case (`rust/engine/ironhorse-262/baseline/baseline.json`) regresses; no
new `ironhorse-failure`/`infrastructure` result; every exact-metering case under
`rust/engine/ironhorse-262/cases/**` stays passing with its computron expectation
unchanged. Before EVERY push run: the affected official slice, `cargo test --workspace
--release`, and `ironhorse-xst --gate-meter-exact`. Anything failing for a DIFFERENT causal
reason than `with` is OUT of this milestone's scope — leave it, do not relabel.

## COMMON
Repository endojs/endo-but-for-bots. Continue the EXISTING shared branch
`feat/ironhorse-262-language-completion` and draft PR
https://github.com/endojs/endo-but-for-bots/pull/970 — keep it OPEN and DRAFT, do NOT
merge. Get an ISOLATED checkout keyed by THIS job's base:
`scripts/jobs/ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots
feat/ironhorse-262-language-completion`. Fetch+rebase the latest shared head before
measuring and before every push, PRESERVE every prior commit, stack bounded commits, and
CAS-push (`git push origin HEAD:feat/ironhorse-262-language-completion`) with a rebase
loop. Pins: engine head measured `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; test262
`tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1
c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set TMPDIR off any noexec mount.
Cached test262 at the pin: `/home/kris/garden/scratch/test262-pin-be13516f`
(`--test262-dir … --no-fetch`).

**Report:** commands run, before/after totals+reasons for each slice, head SHA, PR URL,
and the honest residual (what remains and where).
