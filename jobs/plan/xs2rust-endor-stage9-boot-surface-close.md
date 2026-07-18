---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: deadline-overrun
poison_count: 1
requeue_cycles: 1
deadline_overruns: 1
poisoned_at: 2026-07-18T06:13:23Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-18T06:13:23Z
---

---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T05:31:04Z -->

---
model: opus
---
# Stage-9 child 2/6 — boot-surface close: receiver-aware `resolve_at_key` + tagged-template cache

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The hourly press may have rebased — find equivalents by subject, verify `git diff -- rust/ c/` byte-identity. Verify pushes by git EXIT CODE.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; workspace `rust/engine`; `TMPDIR=$HOME/tmp`; capture test output to files, check `$?`. Seed `target/` by `cp -al` from a same-commit sibling; `c/moddable`: `rmdir` empty dir, `cp -al` from sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean status. **Never `git add c/moddable`.** Acceptance-grade runs: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first (stale `target/` false-passes AND false-fails). **Push-per-item**; size to one 2400s invocation; report honest remainder rather than overrun. **Doctrine:** accuracy-over-parity; never back-fit oracle/corpus/tests/meter; if endor is arguably right, report and leave failing.

## The work (two items, push each on its own)

**Item A — receiver-aware `resolve_at_key` (host_aliases).** The boot-gate skip `skip_host_aliases_full_file_does_not_yet_lower` names the residual stop for lowering `host_aliases.js` (the 40-entry alias table) whole-file: the `at`-key resolution needs a receiver-chain-aware absent-key guard — a soundness change to `resolve_at_key` (see the stage-8d ledger commit `43b6128e18` for the reclassification). Annotate the semantics against the XS sources (property lookup along the receiver/prototype chain for absent keys). Convert the skip into a green `boot_step_*` oracle-agreement test. Add dual-run/corpus coverage for the receiver-chain forms the change enables.

**Item B — tagged-template `template_cache` (the real `String.raw` call form).** Stage 8 bound the `String.raw` static and greened the error-formatting boot step; the assert shim's actual call site is a tagged template (``String.raw`…` ``), which needs the per-site template-object cache per XS semantics (xsCode.c template creation + xsRun.c caching — one frozen template array per site, identity-stable across calls). Implement with XS-annotated semantics; add corpus entries for tagged templates (byte-identity vs the oracle) and dual-run tests covering template-object identity across repeated calls, `raw` contents, and the assert shim's actual form.

**Verification bar (report numbers + exit codes):** fresh clean of the three crates, then: workspace EXIT=0 all `test result:` lines 0 failed; curated compile-diff all-identical + SYMB; boot gate green including your conversions; zero new Rust warnings; `forbid(unsafe_code)` intact at all 7 roots.

<!-- garden-deadline-overrun: 1 -->
