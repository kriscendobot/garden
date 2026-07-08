---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-08T00:58:27Z -->

---
model: opus
---
# Stage-5 fix6 1/2 — the enclosing-function synthetic capture-closure fold (the LAST divergence in the whole language/ tree)

You are fix-round-6 child 1 of 2 on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Stage-5 bar: byte-identical bytecode vs the C-XS oracle
compiler. After fix round 5, the COMPLETE 120-subtree `language/` enumeration (20,602 files) reads
**divergent=1, endor-rejected=0, accept-disagree=0** — the entire stage has converged onto ONE
byte-divergent file, and this job closes it.

## The residual

`language/expressions/arrow-function/arrow/binding-tests-3.js`, class `byte-length/endor-shorter`
(endor's stream is SHORTER than XS's). Reduced shape: `function foo(){ return ()=>eval("this"); }`
— a direct `eval` inside an arrow that captures `this`/home from its **enclosing** non-arrow
function.

**Mechanism (named by fix5 1/5, ledgered in `rust/engine/README.md`):** when an arrow containing a
direct `eval` is created inside an eval-poisoned non-arrow function, XS reserves a
**materialization-free synthetic closure in the ENCLOSING function** — `NEW_CLOSURE` + a
`with`-publish `STORE_1`, with NO `ARGUMENTS_SLOPPY` materialization — so the arrow's
`STORE_ARROW`/`RETRIEVE` capture of `this`/home is reachable through the direct eval's scope.
endor does not yet emit that reservation.

**A known WRONG fix (fix5 1/5 tried it, measured it, reverted it — do NOT repeat):** propagating
`mxArgumentsFlag` so the enclosing function materializes a real `arguments` VAR with
`ARGUMENTS_SLOPPY`. That produces a stream 2 bytes TOO LONG — the right mechanism is the
materialization-free synthetic closure, not an arguments materialization.

**Where to look in the XS pin:** `fxScopeCoded` / `fxScopeCodingParams` / the arrow
(`XS_TOKEN_ARROW`) and eval-poisoning paths in `c/moddable/xs/sources/xsScope.c` and `xsCode.c` —
find where XS reserves the enclosing function's capture closure for an arrow's `this`/home when a
direct eval sits inside the arrow. In-tree precedent for scope-shape surgery:
`endor-compile/src/scoper.rs` (fix4's `hoist_field_init_scope`/`bind_field_init_scope`, fix5's
`scope_coding_params` publish fixes). Diff the two byte streams opcode-by-opcode first (compile
both engines' output for the reduced shape) so the fix is driven by the measured delta, not the
prose above.

## Bars (this child — regressions are failures)

- `compile-diff -- expressions/arrow-function`: **total=326 divergent=0 endor-rejected=0
  accept-disagree=0** (326th file closes; 250→251 identical).
- Neighboring fix5 folds STAY clean (same scoper region — re-measure each): `eval-code` 151/151,
  `arguments-object` 260/260, `expressions/optional-chaining`, `expressions/tagged-template`.
- Invariants: curated corpora **1711/1711 divergent=0 endor-rejected=0**; `cargo test --workspace
  -- --test-threads=1` from `rust/engine` **EXIT=0** (capture to a file, check `$?` — a pipe to
  `tail` masks it); `statements/class` + `expressions/class` stay divergent=0 endor-rejected=0;
  `#![forbid(unsafe_code)]` intact, no new unsafe (`endor-oracle` stays the only FFI seam).
- Add a locked byte-identity fixture to `endor-compile/tests/coder_byte_identity.rs` for the
  closed shape (arrow + direct eval capturing enclosing `this`, plus a variant with the enclosing
  function eval-poisoned directly) — and keep fix5's locked fixtures green.
- Update the `rust/engine/README.md` residual ledger: the enclosing-function synthetic
  capture-closure fold moves from "sole open divergence" to closed, with the mechanism sentence.

## Common context

**Repo/branch:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR **#600** (keep DRAFT; post
NO PR comment; message NO maintainer; do NOT inbox-send the supervisor — it is parked, your tada
completion report is the ONLY channel; state measured before/after numbers in it). Get an ISOLATED
checkout keyed by YOUR job base with your host's
`scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`
(the claim wrapper prints the absolute script path for your host), then `git fetch origin
xs2rust-endor` and rebase onto the REAL remote tip before working; verify pushes by git EXIT CODE,
rebase-CAS loop on `git push origin HEAD:xs2rust-endor`. Commit with explicit pathspecs.

**Oracle pin (C-XS ground truth):** populate `c/moddable` inside your worktree: `git init` there,
then `git fetch --depth=1 <garden-root>/worktrees/endojs-endo-but-for-bots.git
48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD` — `<garden-root>` is your
host's garden checkout (`/home/kris/garden2` on this fleet's s17 host; `/home/kris/garden` on the
sibling; use whichever exists — the pin commit is also in your project worktree's own object
store, so `git fetch --depth=1 <your-worktree-repo-path> <sha>` works too). NEVER `git add`
c/moddable.

**Workspace:** `rust/engine` (NOT the repo root — the root Cargo.toml is a different, broken
workspace). `cargo` at `$HOME/.cargo/bin`. Byte-identity harness: `cargo run -q -p endor-262
--bin compile-diff -- <language-subtree>` (no arg = curated corpora; prints DIVERGENT /
ENDOR-REJECTED / *-ONLY-ACCEPT detail lines and a summary; EXIT!=0 when not clean).

**Method (the proven fix1–fix5 loop):** compile the reduced failing shape with both engines;
disassemble/diff the streams; find the mechanism in the XS pin; mirror it STRUCTURALLY in
`rust/engine/endor-compile/src/` (`scoper.rs`/`coder.rs`); add the locked fixture; re-measure.

**Budget discipline:** you are sized to ONE 2400s invocation. This is a single narrow fold —
land it CLEANLY (fix + fixture + green bars + push). If the mechanism resists after a genuine
opcode-level diff, land nothing speculative: write the exact measured opcode delta and your
attribution into the README ledger + your tada report instead (an honest attributed residual
beats a divergence-introducing guess).
