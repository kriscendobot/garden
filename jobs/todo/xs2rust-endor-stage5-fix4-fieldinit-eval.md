---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T20:10:03Z -->

---
model: opus
---
# Stage-5 fix4 2/4: field-initializer direct-eval scope emission (Class γ, the last eval slice)

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-4 child 2 of 4 (serial orchestration `xs2rust-endor-build-stage5-fix4`). Sibling 1 has
just landed the real field-init function scope (the `instanceInit`/`constructorInit` fold) —
**sync to the live tip and read its landed code + tada-visible commit messages first**; your work
builds directly on that scope.

## Scope

Close **Class γ**'s remaining sub-shape (`rust/engine/README.md` § residual divergences — READ IT
FIRST): a class-field initializer containing a direct `eval(...)` emits a differing
function-environment prologue. 19 files in `statements/class` (the `elements/*direct-eval*`,
`*-visible-to-direct-eval-on-initializer`, `derived-cls-direct-eval-*`,
`direct-eval-err-contains-{arguments,newtarget}`, `privatename-not-valid-eval-earlyerr-3` family;
rep spot-check: `derived-cls-direct-eval-contains-superproperty-1` diff@195, endor 7 bytes shorter
on the omitted eval prelude) plus their `expressions/class` mirrors, plus the eval half of
`static-field-init-with-this.js`.

Fix3's γ child pinned the mechanism precisely (its tada report + README ledger): the synthesized
field-init function must key its eval prelude (`undefined; with; pop`) and store-all on the field
function scope's **OWN `SCOPE_EVAL`** — which endor must set at bind, after the hoist poison walk
— not on inherited poison. Fix3 already landed the general machinery you need: the whole-frame
store-all (`fxScopeCodeStoreAll`, commit `9f45d63ba5`), the faithful `node->declaration` `bound`
bit (`729a581ba6`), and the parameter-scope eval teardown (`632bb6c04d`). With sibling 1's real
field-init scope now in place, the remaining work is: set SCOPE_EVAL on the field-init scope at
bind when an initializer contains direct eval; emit the prelude + params-publish + store-all
against the class-frame `node->declaration` gate; cover the derived-constructor / superproperty /
early-error shapes. Transliterate from the pin (`xsScope.c`/`xsCode.c` at `c/moddable`), don't
improvise. If a sub-shape cannot be made byte-exact within budget, leave it as an attributed
divergence (or a LOUD named fold), never a silent mis-emit.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `statements/class`: the γ family → byte-identical (divergent falls by ~19 from wherever
  sibling 1 left it; introduce NO new divergence or reject anywhere).
- `expressions/class`: measure before/after; report both numbers.
- Curated corpora (`cargo run -p endor-262 --bin compile-diff`): stays
  **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0** (the
  `eval_scope_in_function` + param-default eval fixtures must keep passing).
- Add byte-identity fixtures (`endor-compile/tests/coder_byte_identity.rs`): field-init direct
  eval (plain, derived-with-super, static, private-adjacent).
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (peers advance the branch).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`
  (fallback source: a surviving sibling worktree's `c/moddable`).
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- The byte-identity harness takes a subtree arg: `cargo run -p endor-262 --bin compile-diff -- statements/class`.
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice as you go; if you
  cannot finish, push what is green and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).
