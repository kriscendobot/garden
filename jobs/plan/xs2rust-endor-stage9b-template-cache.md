---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9b
priority: normal
posted_by: producer
posted_at: 2026-07-18T06:23:42Z
---

---
model: opus
---
# Stage-9b child 1/5 — tagged-template `template_cache` (the real `String.raw` call form)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Provenance:** this is the REMAINDER of the poisoned stage-9 child `xs2rust-endor-stage9-boot-surface-close` (sizing overrun: two items did not fit one 2400s invocation). Its **Item A already LANDED** — commit `6807dc89c9e` "feat(endor): receiver-chain-aware absent-key guard greens host_aliases.js", pushed 2026-07-18T05:59Z. Do NOT redo Item A; your verification bar below confirms it did not regress anything. Your job is **Item B only**.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The hourly press may have rebased — find equivalents by subject (`6807dc89c9e` and its predecessors), verify `git diff -- rust/ c/` byte-identity. Verify pushes by git EXIT CODE.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; workspace `rust/engine`; `TMPDIR=$HOME/tmp`; capture test output to files, check `$?`. Seed `target/` by `cp -al` from a same-commit sibling; `c/moddable`: `rmdir` empty dir, `cp -al` from sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean status. **Never `git add c/moddable`.** Acceptance-grade runs: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first (stale `target/` false-passes AND false-fails). **Push-per-item**; size to one 2400s invocation; report the honest remainder rather than overrun. **Doctrine:** accuracy-over-parity; never back-fit oracle/corpus/tests/meter; if endor is arguably right, report and leave failing.

## The work (one item)

**Tagged-template `template_cache` (the real `String.raw` call form).** Stage 8 bound the `String.raw` static and greened the error-formatting boot step; the assert shim's actual call site is a tagged template (``String.raw`…` ``), which needs the per-site template-object cache per XS semantics (xsCode.c template creation + xsRun.c caching — one frozen template array per site, identity-stable across calls). Implement with XS-annotated semantics; add corpus entries for tagged templates (byte-identity vs the oracle) and dual-run tests covering template-object identity across repeated calls, `raw` contents, and the assert shim's actual form. If a boot-gate skip names this residual, convert it (or split it narrowly) per the standard skip discipline.

**Verification bar (report numbers + exit codes):** fresh clean of the three crates, then: workspace EXIT=0 all `test result:` lines 0 failed; curated compile-diff all-identical + SYMB (report count — corpus grew to 1738+ before you); boot gate green with no regressions (Item A's host_aliases conversion included); zero new Rust warnings; `forbid(unsafe_code)` intact at all 7 roots.
