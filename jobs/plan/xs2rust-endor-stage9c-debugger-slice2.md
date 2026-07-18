---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9c
priority: normal
posted_by: gardener
posted_at: 2026-07-18T08:44:22Z
---

---
model: opus
---
# Stage-9c child 6/9 — Debugger slice 2/3: VM-side inspection hooks behind `DebugTransport`

**Provenance:** stage-9b's debugger child landed slice 1 — the `endor-debug` crate (protocol/
transport/parse/serialize: `DebugTransport` trait, `CommandParser` porting
`fxDebugParse`/`fxDebugParseTag`, `Echo` porting the `<xsbug>` framing and `fxEchoString`
escaping; commit `cf45517211e`, 28 tests, purely additive, 7th forbid root) and named slice 2
as its remainder. That is YOUR job, per its own words:

## The work (transliterate against `xsDebug.c`, annotated)

- Wire `endor-debug` to the VM (the slice adds the `endor-vm` dependency direction the crate
  layering wants — keep `forbid(unsafe_code)` on both).
- **Execution control:** break / step / step-inside / step-outside driving the interpreter
  loop; the breakpoint table (set/clear/clear-all/set-all from the already-parsed `Command`
  vocabulary); break-on-uncaught via the `firstJump`-equivalent JS/host-flag walk.
- **Inspection:** `<frames>` / `<local>` / `<global>` views sourced from the live endor-vm
  frame + slot arenas, serialized through slice 1's `Echo` builders (byte-exact escaping
  already proven there).
- **Metering-neutral when disarmed (the acceptance property):** a single dormant branch in
  the run loop when no debugger is attached. PROVE it: dual-run computron identity across the
  curated corpus with the debugger disarmed (the full corpus compile-diff + workspace bar
  below), plus a targeted test asserting identical computron totals for a representative
  program with the debug feature compiled in but detached.
- The breakpoint table and any debugger-held VM state: ledger the day it lands (GC-roots +
  snapshot contract — debugger state is expected snapshot-EXCLUDED; say so explicitly in the
  ledger row).

**Full-row acceptance bar applies from this slice on** (debugger code now reaches metered
paths): fresh clean of endor-compile/endor-vm/endor-oracle, workspace all-green incl. oracle,
curated compile-diff + SYMB, boot gate, zero new warnings, forbid intact everywhere.

Honest remainder allowed (e.g. eval-in-frame, profiling commands) — name precisely.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
