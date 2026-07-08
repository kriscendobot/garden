---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix6
priority: normal
posted_by: producer
posted_at: 2026-07-08T00:56:47Z
---

---
model: opus
---
# Stage-5 fix6 2/2 — VERIFY: full-tree re-measurement after the capture-closure fix (BAR MET / NOT MET verdict)

You are fix-round-6 child 2 of 2 (the verify child) on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Sibling 1 (`xs2rust-endor-stage5-fix6-arrow-capture`) has
closed (or precisely attributed) the LAST divergence in the whole `language/` tree —
`expressions/arrow-function/arrow/binding-tests-3.js`, the enclosing-function synthetic
capture-closure fold. Your job: independently re-measure EVERYTHING from a fresh sync of the live
tip and post the explicit verdict.

**Binding process rule (s16 finding): a whole-tree claim requires the whole-tree enumeration.**
No extrapolation from spot checks — run all 120 subtrees.

## Checklist (all measured from a fresh sync of the live `xs2rust-endor` tip)

1. **Workspace:** `cargo test --workspace -- --test-threads=1` from `rust/engine`, captured to a
   FILE, `$?` checked directly (a pipe to `tail` masks the exit code): EXIT=0, every
   `test result:` line ok.
2. **Curated corpora:** `compile-diff` (no arg) → expect 1711/1711 divergent=0 endor-rejected=0
   accept-disagree=0; module corpora are the in-crate workspace test.
3. **The COMPLETE `language/` per-subtree enumeration — MANDATORY:** for each top-level
   `language/` dir run `cargo run -q -p endor-262 --bin compile-diff -- <dir>` whole, EXCEPT
   `expressions/` and `statements/` which run per second-level subtree (~120 runs; the whole-tree
   single process OOMs — the per-subtree loop IS the measurement). Capture every summary line and
   every DIVERGENT / ENDOR-REJECTED / *-ONLY-ACCEPT detail line.
4. **Stage-4 spot-checks** (dual-run `cargo run -p endor-262 --bin test262-language -- <dir>`,
   DIRECTORY sections only): `built-ins/Object` expect 176 passed / 0 failed of 3127,
   `built-ins/Function` 40/0 of 511, `built-ins/Array` 437/0 of 2625 — EXIT=0, no crash-aborts,
   all skips named (`endor-aborted` is a named SKIP reason, not a crash).
5. **Determinism + fuzz:** `parse_computrons_are_deterministic_per_build` in the workspace run;
   `compile-diff -- eval-code` twice → byte-identical output; the decoder/parser fuzz smokes are
   in the workspace suite.
6. **`#![forbid(unsafe_code)]`** intact at every engine-crate root; no new `unsafe` anywhere
   (`endor-oracle` the sole documented FFI seam).
7. **README refresh** (`rust/engine/README.md`): a fix6-verify section with the full 120-row
   table, whole-tree totals, the named-fold ledger (every non-identical cell attributed, nothing
   unclassified), and the explicit verdict line — **STAGE-5 BAR MET** requires `divergent==0 AND
   accept-disagree==0` on every subtree with every remaining reject accept-AGREED or under a
   named ledger fold. Update the top-of-block "current authoritative verdict" pointer. Commit
   (explicit pathspecs) + push (rebase-CAS, verify by exit code).

## Attribution discipline

Opcode-level attribution of ANY residual. **An UNATTRIBUTABLE divergence is potential
kill-criterion evidence (design § Feasibility Verdict) — flag it PROMINENTLY at the top of your
tada report.** If sibling 1 landed only a partial fix or a ledgered attribution instead, report
the measured residual exactly — never soften a NOT MET into prose.

## Common context

**Repo/branch:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR **#600** (keep DRAFT; post
NO PR comment; message NO maintainer; do NOT inbox-send the supervisor — it is parked, your tada
completion report is the ONLY channel; put the whole-tree totals line and the verdict in it). Get
an ISOLATED checkout keyed by YOUR job base with your host's
`scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`,
then `git fetch origin xs2rust-endor` and sync to the REAL remote tip; verify any push by git
EXIT CODE (rebase-CAS on `git push origin HEAD:xs2rust-endor`).

**Oracle pin (C-XS ground truth):** populate `c/moddable` inside your worktree: `git init` there,
then `git fetch --depth=1 <garden-root>/worktrees/endojs-endo-but-for-bots.git
48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD` — `<garden-root>` is your
host's garden checkout (`/home/kris/garden2` or `/home/kris/garden`; use whichever exists — the
pin commit is also in your project worktree's own object store). NEVER `git add` c/moddable.

**Workspace:** `rust/engine` (NOT the repo root). `cargo` at `$HOME/.cargo/bin`. Miri (if
needed) wants `TMPDIR=$HOME/tmp`.

**Budget discipline:** you are sized to ONE 2400s invocation. Run the enumeration first (it is
the long pole and the point of the job); if time runs short, land the README table + verdict for
what you measured and state EXACTLY which checklist rows remain unmeasured — never claim an
unmeasured bar.
