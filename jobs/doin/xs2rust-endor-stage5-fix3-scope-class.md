---
role: fixer
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T16:25:37Z -->

---
model: opus
---
# Stage-5 fix3 1/5: Class α — closure-vs-local scope classification (a MIS-EMIT)

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-3 child 1 of 5 (serial orchestration `xs2rust-endor-build-stage5-fix3`).

## Scope

Close **Class α** of the stage-5 residual ledger (`rust/engine/README.md` § residual divergences —
READ IT FIRST): endor's scoper does not promote a binding to a **closure** slot when a nested
function captures it, so the coder emits `new_local`/`let_local`/`const_local`/`var_local` where
the oracle emits the `*_closure` family (opcodes 230↔228). ~25 divergences, a real byte mismatch
on accepted programs:

- class-body bindings whose class has literal-named or numeric-keyed members (21 in
  `statements/class`; rep `class/elements/regular-definitions-literal-names.js`);
- a parameter named `arguments` (`statements/function/S13_A15_T1.js`, `S13_A15_T3.js`,
  `class/strict-mode/arguments-callee.js`);
- a class binding captured by a field initializer
  (`class/elements/intercalated-static-non-static-computed-fields.js`).

Port the promotion at the oracle pin from `xsScope.c` (the closure-capture walk —
`fxScopeLookup`/`fxAccessNodeBind`/`fxScopeBindDefineNode` family). Transliterate, don't
improvise. If a sub-case cannot be made byte-exact within budget, leave a LOUD named fold
(panic), never a silent mis-emit.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `statements/function`: divergent 2 → **0** (the 4 endor-rejects are a sibling's fold, leave them).
- The α files in `statements/class` → byte-identical (class divergent 113 → ≤92; the β/γ/ε
  classes are siblings' scope — introduce NO new divergence or reject anywhere).
- Curated corpora (`cargo run -p endor-262 --bin compile-diff`): stays
  **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**.
- Add byte-identity fixtures (`endor-compile/tests/coder_byte_identity.rs`) for the closed shapes.
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (peers advance the branch).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice as you go; if you
  cannot finish, push what is green and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-07T16:25:41Z
