---
role: fixer
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T17:25:05Z -->

---
model: opus
---
# Stage-5 fix3 2/5: Class β — private class-member installation bytes

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-3 child 2 of 5 (serial orchestration `xs2rust-endor-build-stage5-fix3`).

## Scope

Close **Class β** of the stage-5 residual ledger (`rust/engine/README.md` § residual divergences —
READ IT FIRST): the private brand / home-object / accessor / method **installation** byte sequence
is not byte-exact (~56 of the `statements/class` divergences). Round 2's private-reads child made
these programs COMPILE (the read path landed); the residual is the install coding. The fix2-bytes
child's disassembly (journal tada `xs2rust-endor-stage5-fix2-bytes`) attributes three sub-shapes,
two of them **scoper-side**:

1. **Accessor-pair brand double-capture** (~20 files, `class/elements/private-accessor-name/*`,
   endor LONGER by 2): a `get #x`/`set #x` pair resolves to TWO distinct `symbolAccess` closures
   in endor's scoper, so the synthesized field-init function RESERVE/RETRIEVE/STOREs one extra
   slot; XS shares a single brand closure across the pair. Fix is scoper-side (share the brand);
   a coder-side dedup was tried and does NOT work (the ids genuinely differ). Rep:
   `inst-private-name-common.js` (extra `store_1` at op idx 128; oracle 373 / endor 375 bytes).
2. **Nested-class private-member scope count** (~35 files, `private-*-on-nested-class.js`
   family): opcode names identical, divergence is an OPERAND (byte 4: oracle `0x09` vs endor
   `0x0d`, same length) — endor over-counts scope slots for a nested class declaring private
   members. Scoper-side. Rep: `private-field-on-nested-class.js`.
3. **Install `store_1`/`pop` ordering** on the remaining private install files
   (`privatefield{get,set}-typeerror-1`, `{get,set}-access-of-*-private-*`).

Port at the oracle pin from `xsScope.c` (class-scope `symbolAccess` closure creation,
`fxClassNodeHoist`/`fxScopeLookup`) and `xsCode.c` (`fxClassNodeCode` private install).
Transliterate, don't improvise. If a sub-shape cannot be made byte-exact within budget, leave a
LOUD named fold (panic), never a silent mis-emit.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- The β files in `statements/class` → byte-identical (class divergent drops by your ~56;
  siblings own α/γ/ε — introduce NO new divergence or reject anywhere).
- Curated corpora (`cargo run -p endor-262 --bin compile-diff`): stays
  **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**.
- Add byte-identity fixtures (`endor-compile/tests/coder_byte_identity.rs`) for the closed shapes
  (accessor pair, nested class, install ordering).
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (child 1 lands before you).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice; if you cannot
  finish, push what is green and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  claimed_at: 2026-07-07T17:25:09Z
