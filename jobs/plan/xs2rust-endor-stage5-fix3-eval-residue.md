---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix3
priority: normal
role: fixer
posted_by: port-xs-to-rust-memory-safe-engine-s14
posted_at: 2026-07-07T16:24:35Z
---

---
model: opus
---
# Stage-5 fix3 3/5: Class γ — nested/initializer direct-eval scope + the parameter-default eval fold

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-3 child 3 of 5 (serial orchestration `xs2rust-endor-build-stage5-fix3`).

## Scope — the whole remaining EVAL slice

Round 2's eval-scope child landed in-function direct-eval emission (`fxScopeCodingParams` eval
branch, the sloppy two-`with` body dance, two-phase `arguments` injection). Close its residuals
(`rust/engine/README.md` § residual divergences, Class γ + the reject fold — READ IT FIRST):

1. **Class γ — nested/initializer direct-eval prologue** (~34 divergences): a NESTED function or
   a class-field INITIALIZER containing direct `eval(...)` emits a differing function-environment
   prologue (extra/missing scope-slot `store_1`s). Files: `expressions/assignment/S11.13.1_A6_T1.js`,
   `_T2.js` (`eval("var x;")` in an IIFE) and the `statements/class` direct-eval family
   (`elements/*direct-eval*`, `derived-cls-direct-eval-*`, `*-visible-to-direct-eval*`,
   `privatename-not-valid-eval-earlyerr-*`, ~32 files). The fix2-bytes disassembly (journal tada
   `xs2rust-endor-stage5-fix2-bytes`) pinned the field-init shape: the synthesized field-init
   function omits XS's `UNDEFINED; WITH; POP` eval-environment prelude after RETRIEVE — it must
   key on the field-function scope's OWN `SCOPE_EVAL`, not the inherited program-poison flag
   (gating on the inherited flag misfires for non-eval field functions in eval-poisoned programs).
   Rep: `private-field-visible-to-direct-eval-on-initializer.js` (oracle inserts
   `undefined; with; pop` @94–96; oracle 187 / endor 180).
2. **The loud fold — eval in a parameter default** (12 endor-rejects: 8 `expressions/object` +
   4 `statements/function`, the `scope-*param*-var-{open,close}` family): port
   `fxParamsBindingNodeCode`'s **parameter var-environment** (`EVAL_ENVIRONMENT`) split for
   non-simple parameter lists containing direct eval, then remove the
   `eval in a parameter default (parameter var-environment) deferred` panic. Rep:
   `function/scope-param-elem-var-close.js`.

Port at the oracle pin from `xsCode.c`/`xsScope.c`. Transliterate, don't improvise. If a
sub-shape cannot be made byte-exact within budget, keep/leave a LOUD named fold (panic), never a
silent mis-emit.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `expressions/assignment`: divergent 2 → **0** (the subtree goes fully clean).
- `expressions/object`: endor-rejected 8 → **0** (its 1 divergence is sibling δ's).
- `statements/function`: endor-rejected 4 → **0**.
- The γ files in `statements/class` → byte-identical; introduce NO new divergence or reject anywhere.
- Curated corpora: stays **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**.
- Add byte-identity fixtures (nested-fn eval, field-init eval, param-default eval sloppy+strict).
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (children 1–2 land before you).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice (γ's two sub-shapes
  and the fold are separately landable); if you cannot finish, push what is green and report the
  honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).
