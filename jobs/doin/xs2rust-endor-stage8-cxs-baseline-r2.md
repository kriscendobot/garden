---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T17:04:13Z -->

---
model: opus
---
# Stage-8b child 1/4 (was stage-8 child 3/6, re-cut after transient-outage poisoning) — libxs provisioning + boot-bundle generation + C-XS `test:rust` BASELINE

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8b`; tada-only reporting. One 2400s invocation.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; push via CAS, verify by exit code.

**Recovery context (read before provisioning — it saves you most of the work).** The first cut
of this child (`xs2rust-endor-stage8-cxs-baseline`) was claimed 5× on 2026-07-17 and every
handler died to a transient API/usage-cap outage window (~11:30–12:40Z), so the reaper poisoned
it — a fleet-infra event, NOT a spec defect; the fleet has been healthy since ~13:00Z. Its
worktree survives with most provisioning DONE:
`/home/kris/garden/scratch/project-wt-xs2rust-endor-stage8-cxs-baseline-5cd7f36a` at
`65180ad877` (a pre-rebase equivalent of the current tip — verify by subject + empty
`git diff <old> <new> -- rust/engine` before trusting it): `node_modules` installed,
`c/moddable` populated at the oracle pin, all three gitignored boot bundles already emitted in
`rust/endo/xsnap/src/`, and the ROOT `target/` (770M) with `target/release/endor` built
(11:55Z). `cp -al` those caches into your worktree instead of rebuilding from scratch (mind the
empty-dir nesting gotcha for `c/moddable`).

**CRITICAL measurement gotcha (post-mortem finding — do not repeat it).** The dead child DID
run `yarn test:rust` to completion (log: `/home/kris/garden/tmp/s8-test-rust.log`, 12:10Z):
279 failed / 65 skipped, with 549 occurrences of `endo.sock not ready within 10000ms`. That is
NOT an honest engine baseline: the daemon's per-test socket path
`<worktree>/packages/daemon/tmp/<test>/endo.sock` is 126 bytes under the long scratch-worktree
name — over the AF_UNIX `sun_path` limit. `test/channel.test.js` caps at
`MAX_UNIX_SOCKET_PATH = 90` and truncates per-test dir names to fit, but under the long
worktree the FIXED overhead (`<worktree>/packages/daemon/tmp` ≈ 100 chars) already exceeds 90,
so truncation cannot save it — every daemon spawn fails identically regardless of engine. Your
own worktree name (`...-r2-<hash8>`) is just as long, and a symlink will NOT work (Node
resolves module/cwd paths to the real path). Fix: make a secondary MEASUREMENT checkout at a
short REAL path — e.g. `git clone --shared /home/kris/garden/worktrees/endojs-endo-but-for-bots.git
$HOME/tmp/s8cxs && git -C $HOME/tmp/s8cxs checkout <tip-sha>` (local clone is cheap), `cp -al`
the caches (node_modules, c/moddable, target, the generated bundles) into it, and run
`yarn test:rust` from `$HOME/tmp/s8cxs/packages/daemon`
(`.../s8cxs/packages/daemon/tmp` ≈ 48 chars — fits). Keep pushes/commits (if any) in your
ensure-project-worktree checkout; the short clone is measurement-only. THEN classify the
remaining failures honestly. Persist the log under `$HOME/tmp` EARLY and append as you go, so a
requeue cannot lose the measurement; note $HOME/tmp is shared and survives requeues.

**Task — establish the C-XS-backed daemon baseline (the probe's step 4: "before any pure-Rust
swap").** Stage-8 children 1–2 (already landed on the branch) fixed the daemon bundle and
landed the three generators. Now:
1. `yarn install` (yarn PATH shim if needed); run all three bundlers → emit the three gitignored
   boot `.js` into `rust/endo/xsnap/src/` (`daemon_bootstrap.js`, `worker_bootstrap.js`,
   `ses_boot.js`). NEVER commit them.
2. Populate `c/moddable` at the oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`
   (`git -C c/moddable fetch --depth 1 --filter=blob:none origin <sha> && git -C c/moddable
   checkout <sha>` — or `cp -al` the checkout from a sibling scratch worktree that has it; if
   `c/moddable` exists but is empty, `rmdir` it first so the copy does not nest). NEVER
   `git add c/moddable`. (`xsnap/build.rs` needs `c/moddable/xs/sources/xsAll.c` or a prebuilt
   `libxs.a`.)
3. `cargo build --release --bin endor` from the repo root workspace (`cargo` at
   `$HOME/.cargo/bin`). Capture to a file, check `$?`.
4. `cd packages/daemon && yarn test:rust` (it sets `ENDO_BIN=../../target/release/endor`,
   `ENDO_WORKER_BIN='… worker'`). Capture the FULL output; check `$?`.

**Deliverable:** the measured C-XS baseline — how many `test:rust` tests exist, pass, fail, and
for each failure a one-line classification (pre-existing daemon issue vs bundle/provisioning
issue vs flake). A fully green baseline is NOT required to complete — an honestly measured
baseline is the deliverable (it is what the pure-Rust swap will be compared against). Land only
small unblocking source fixes if any are needed and clearly attributable; anything structural
goes in the report as a named remainder.

**Practical notes:** `$HOME` = `/home/kris/garden`; logs under `$HOME/tmp`; `/tmp` noexec;
`TMPDIR=$HOME/tmp` for anything that execs from temp. The build may be slow — budget your
invocation; commit/push source changes before long runs so nothing is lost to a requeue.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-17T17:04:21Z
