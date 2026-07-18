---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T07:46:04Z -->

---
model: opus
---
# Stage-9b child 5/5 — the `test:rust` finish-line measurement on the Rust engine

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer. **This job is MEASUREMENT-ONLY: no engine fixes, no test edits, no corpus edits.** (A trivial harness-only unblocking change — e.g. an env knob the seam already defines — is allowed if it is provably not an engine-behavior change; push it separately and flag it.)

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). Record the tip sha — the whole measurement is AT that tip (a whole-tree claim requires the whole tree at the claimed tip).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`. Build the ROOT workspace (the `endor` daemon bin) and the engine workspace `rust/engine` fresh: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` in the engine workspace before any engine build (stale seeded `target/` false-passes AND false-fails). `c/moddable`: `rmdir` empty dir, `cp -al` from a sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean. **Never `git add c/moddable`.** Capture ALL output to files; verify by exit codes.

## The work

From a **short real path**, run the **FULL `test:rust` daemon suite serially on the RUST engine** (the spawn selection wired by stage-9b child 3 (endor-vm-daemon-wiring)) at the recorded tip, and compare per-test against the serial C-XS anchor.

**Environment-artifact discipline (all three classes, binding):**
1. **AF_UNIX `sun_path`:** run from a REAL short path (e.g. `~/tmp/s9fl`; symlinks do NOT work; `test/channel.test.js` caps the socket path at 90 chars). Recipe (the `~/tmp/s8cxs` pattern): `git clone --shared` from the bare `worktrees/endojs-endo-but-for-bots.git`, `git checkout --detach <tip-sha>`, provision node_modules, run ava as `node ../../node_modules/ava/entrypoints/cli.js`, **serially** (concurrency amplifies to mass `endo.sock not ready` artifacts).
2. **Provisioning-race:** mass-identical `AssertionError null == true` = killed-mid-install artifact; re-provision before believing it.
3. **Stale build cache:** fresh rebuild of the daemon bin and engine crates at the tip before measuring.

**The comparison anchor — serial C-XS baseline (endolin-garden log `/home/kris/garden/tmp/s26-cxs-baseline-serial.log`, corroborated on endolin-garden2): 804 passed / 26 failed / 65 skipped** (+110 pending only from `test/endo.test.js`, the detached-daemon harness, un-runnable in the sandbox — expect the same on the Rust run). Expected C-XS failure classes (the expected-divergence ledger; the Rust engine matching these failures is PARITY, not regression): git-backend 8 (`Could not parse git version from ""` — daemon filtered env); error-trace worker-assertions 5; content-store-gc 9 (daemon connection ends mid-GC-test; marshalled error fails client decode in marshal/decodeErrorCommon); endo.test.js 3 (sandbox); shell 1 (`/tmp`-noexec EACCES).

**Report (tada):**
- The three-number Rust-engine summary (passed/failed/skipped) + ava exit code, with the log file path.
- A per-class divergence table: tests failing on Rust but not in the C-XS anchor (grouped by first-line error class, with one verbatim first failure per NEW class), and tests failing in the C-XS anchor but passing on Rust.
- Which of the 5 expected classes reproduced identically, and any mass-identical class you excluded as an environment artifact (name the class and the exclusion evidence).
- An honest bottom line: is the maintainer's finish line (all `test:rust` passing on the Rust engine, modulo the expected-divergence ledger) met, near, or far — with the top blockers named.
