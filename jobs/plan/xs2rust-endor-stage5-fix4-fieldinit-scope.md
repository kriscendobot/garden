---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix4
priority: normal
posted_by: port-xs-to-rust-memory-safe-engine-s15
posted_at: 2026-07-07T19:27:50Z
---

---
model: opus
---
# Stage-5 fix4 1/4: the real field-init function scope (Classes β + ε, the structural fold)

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-4 child 1 of 4 (serial orchestration `xs2rust-endor-build-stage5-fix4`).

## Scope — the ONE fold three fix3 children independently diagnosed and deferred

`rust/engine/README.md` § residual divergences — **READ IT FIRST**. All of Class β (35 files) and
Class ε (2 files) in `statements/class`, plus `elements/intercalated-static-non-static-computed-fields.js`
(Class α's last interleave case), plus their mirrors among `expressions/class`'s 50 divergences,
share one structural root cause: endor synthesizes the member-closure field-init function at
**code** time, while XS binds every class field initializer inside a real `instanceInit` /
`constructorInit` **function scope** at bind time (`fxClassNodeHoist`/`fxFunctionNodeBind`,
`xsScope.c`/`xsTree.c` at the oracle pin in `c/moddable`).

**The fix: unify the member-closure field-init path onto the real `instanceInit` function scope**,
extending the existing plain-data-field mechanism (`scoper.rs`: `class_field_init_inst` /
`scope_new_field_init` / the `bind_class` field-init pass; `coder.rs`: `code_field_init_function`
with its `fi` scope param) to classes with computed-key, private, and static members:

- Bind EVERY instance field initializer inside the field-init function scope; the member closures
  (`atAccess`/`symbolAccess`/`valueAccess`) become use-closure aliases interleaved with value
  captures in field order (XS's `fxScopeGetDeclareNode` dedup semantics — the accessor-pair brand
  dedup landed in fix3 commit `4305c946d0` must keep holding).
- `scopeCount == binder->scopeMaximum` = captured closures PLUS the peak temporary depth of the
  field-value expressions (fix3 child 4 pinned this: `init-value-incremental.js` needs `RESERVE 3`
  not `2`, its `to_numeric` temporary at local 3 not 1).
- A nested class declaring private members must stop leaking its closure slots into the enclosing
  frame (the `private-*-on-nested-class` family's program `RESERVE 0x0d` vs oracle `0x09`).
- A `this.#x` read in a field initializer must code `GET_PRIVATE` with the field function's
  captured retrieve-slot, not the class-scope brand index (`privatefield{get,set}-typeerror-1`,
  `{get,set}-access-of-*-private-*`).
- The static path (`constructorInit`) follows the same shape (`static-field-init-with-this.js` —
  its direct-eval half is sibling 2's; do not chase the eval prelude here).

Fix3's β child measured and REVERTED a bounded shortcut (zeroing the value frame outside a real
scope) — it exposed new RESERVE divergences; the value frame genuinely must be counted IN the
field function. Do not retry shortcuts; build the real scope. Transliterate from the pin, don't
improvise.

**Regression surface is real:** the byte-clean class corpora (curated 1711, the ~40 computed/
private field byte-identity fixtures, `class_field_init_closure_capture`,
`class_private_accessor_pair_shares_brand`) must stay green. Land the scoper-side scope model and
the coder consumption incrementally, pushing each green slice. If a sub-shape cannot be made
byte-exact within budget, leave it as an attributed divergence (or a LOUD named fold if it would
otherwise mis-execute), never a silent mis-emit, and report the honest remainder precisely.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `statements/class`: divergent 62 → **≤ 25** (β's 35 + ε's 2 + α's interleave close; sibling 2
  owns γ's 19 and sibling 3 owns α's other 5 — introduce NO new divergence or reject anywhere).
- `expressions/class`: measure before/after; its β/ε mirrors close too; report both numbers.
- Curated corpora (`cargo run -p endor-262 --bin compile-diff`): stays
  **1711/1711 divergent=0 endor-rejected=0**.
- Module corpora in-crate gate + `cargo test --workspace -- --test-threads=1` from `rust/engine`:
  **EXIT=0**.
- Add byte-identity fixtures (`endor-compile/tests/coder_byte_identity.rs`) for the closed shapes
  (nested-class private RESERVE, field-init brand read, init-value temp depth, static-field-init).
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (peers advance the branch).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`
  (fallback source: a surviving sibling worktree's `c/moddable`, or
  `/home/kris/garden2/worktrees/endojs-endo-but-for-bots.git` on garden2 hosts).
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- The byte-identity harness takes a subtree arg: `cargo run -p endor-262 --bin compile-diff -- statements/class`.
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice as you go; if you
  cannot finish, push what is green and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).
