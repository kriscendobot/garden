---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T11:10:27Z -->

---
model: opus
---
# Stage-5 fix 3/5: class tail — computed-key fields, private members, static-block lexicals

Child of orchestration `xs2rust-endor-build-stage5-fix` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Oracle pin `48ee02d8cfe0`. Design: `designs/xs2rust-endor-engine.md`.

## Context (read the two class-fields reports' findings before coding)

Stage-5 child 6 landed the class surface through slices 42-50: base/named/derived classes,
methods/accessors/static, computed method KEYS, data fields (instance+static, base+derived),
static initializer blocks, name inference. What remains is the tail, and its keystone is a
known architectural gap the child-6 crew documented (search the endor-compile README and
git log for "class fields" / "field-init"):

The field-init synthesis (`code_field_init_function` in `endor-compile/src/coder.rs`) emits
the instanceInit/constructorInit functions **scope-free** — fine for plain `x = v` fields
which capture nothing. But per fxFieldNodeCode (xsCode.c ~3097), a **computed-key field**
(`[e] = v`) reads its key via `GET_CLOSURE atAccess` and a **private member** (`#x`) uses
`NEW_PRIVATE symbolAccess` / `GET_CLOSURE valueAccess` — anonymous class-scope closures
(xsScope.c ~480-513, hoisted like instanceInit) the field function must CAPTURE. So the
field-init functions need real scopes with RETRIEVE/STORE aliases. Two routes were named:
(1) have the parser synthesize the FieldNode lists into Class children[3]/[4] the way XS
does, so field functions get normal scoper scopes — bigger parser change, cleaner; or
(2) build synthetic scoper scopes for the field functions during hoist_class — contained to
scoper+coder. Pick one deliberately and record why in the commit message.

## The task (in order)

1. **Scope-aware field-init functions** (the keystone, whichever route).
2. **Computed-key fields** (`[k] = v`): code_class's member loop evaluates the key ONCE at
   class-definition time (key + AT + CONST_CLOSURE atAccess); code_field's PropertyAt branch
   reads it back (RETRIEVE + GET_CLOSURE).
3. **Private members** (`#x` fields, `#m` methods, brands): the class scope's per-member
   symbolAccess/valueAccess const-closure declares + NEW_PRIVATE / GET_PRIVATE / SET_PRIVATE
   / HAS_PRIVATE (incl. `#x in obj`).
4. **Static blocks with their own lexical declarations** (the field function's frame
   reservation — same scope-awareness gap).

Byte-identity fixtures per increment in `endor-compile/tests/coder_byte_identity.rs`; a gap
asserts loudly, never mis-emits. Extend the cross-construct integration corpus with a
private-members + computed-fields + derived-super case.

**Bar:** all four items byte-identical vs the oracle; the in-crate corpus gate green with the
class-tail folds removed from the documented list; `cargo test --workspace --
--test-threads=1` EXIT=0 (capture to file, check `$?`).

## Ground rules

- FIRST: isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip.
- Oracle pin: populate `c/moddable` via `git init` + `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD`. NEVER `git add` it. `cargo` at `$HOME/.cargo/bin`.
- Explicit-pathspec commits; rebase-CAS pushes verified by git EXIT CODE;
  `#![forbid(unsafe_code)]` intact; land green pushed slices as you go.
- Size to ONE 2400s invocation; push what is green and report folds honestly at budget end.
- Report to `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s13` —
  never the maintainer inbox; never comment on the PR; KEEP DRAFT.
