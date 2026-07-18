---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T05:01:03Z -->

---
model: opus
---
# Stage-9 child 1/6 — ToPrimitive-in-`op_add`: the native→JS call trampoline

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it** (the supervisor posts all PR comments). Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The hourly press may have rebased — find equivalent commits by subject and verify `git diff -- rust/ c/` byte-identity before treating history as intact. Verify every push by its git EXIT CODE.

**Environment (binding, learned the hard way):**
- `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine` (NOT the repo root). `TMPDIR=$HOME/tmp` for miri; `/tmp` is noexec. Capture test output to files and check `$?` — a pipe to `tail` masks the exit code.
- Seed `rust/engine/target/` by `cp -al` from a same-commit sibling under `/home/kris/garden2/scratch/` if one exists. For `c/moddable`: `rmdir` the empty dir, `cp -al` a sibling's checkout, then `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (the declared pin, now also the committed gitlink) and verify `git -C c/moddable status --porcelain` is EMPTY. **Never `git add c/moddable`.**
- **Any acceptance-grade claim requires `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first** — a stale seeded `target/` can false-pass AND false-fail (the stage-8 F1 saga).
- **Push-per-item discipline:** after EACH coherent item (code + tests green), commit with explicit pathspecs and `git push origin HEAD:xs2rust-endor` (rebase-CAS loop on rejection). Never hold work unpushed. Size to one 2400s invocation: if short on time, push what is done and report the honest remainder in your tada report — never overrun silently.
- **Doctrine (accuracy-over-parity):** never back-fit the oracle, the corpus, a test, or the meter. If endor is arguably right and the oracle disagrees, report and leave failing for the supervisor to judge.

## The work

Implement the **native→JS re-entrant call trampoline** required for ToPrimitive inside `op_add`, semantically annotated against the XS sources (`fxToPrimitive` in xsType.c and the ADD path in xsRun.c): when an `add` operand is an object, endor must be able to call user JS functions (`[Symbol.toPrimitive]`, `valueOf`, `toString`, with correct hint and ordering) from within the opcode and resume. This is the residual stop behind the boot-gate skip `skip_assert_details_add_needs_toprimitive` (the assert.details residue `{toString(){}} + ""` case) — class/method-shorthand construction is already green.

Items (push each separately):
1. The trampoline mechanism itself + `op_add` ToPrimitive wiring, with unit coverage in endor-vm.
2. Convert `skip_assert_details_add_needs_toprimitive` into a green `boot_step_*` dual-run test in `endor-262/tests/boot_bundle_gate.rs` (oracle-agreement form, matching the existing boot-step tests).
3. Corpus + dual-run coverage for ToPrimitive-in-add forms (object+string, `Symbol.toPrimitive` precedence, `valueOf`→`toString` ordering, hint values, throwing converters). Corpus additions must pass compile-diff byte-identity AND endor-xst result agreement.

Advisory, in scope ONLY if it falls out trivially from the same trampoline: `Reflect.apply`/`Reflect.construct` re-entrancy (a standing ledger item). Otherwise leave it ledgered and say so.

**Verification bar (report numbers + exit codes):** after a fresh clean of the three crates — workspace `cargo test --workspace --no-fail-fast` EXIT=0 with all `test result:` lines 0 failed; curated `./target/debug/compile-diff` (no `--`) all-identical + SYMB; boot gate `cargo test -p endor-262 --test boot_bundle_gate` green with your conversion included; zero new Rust warnings; `#![forbid(unsafe_code)]` untouched at all 7 crate roots.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-18T05:01:07Z
