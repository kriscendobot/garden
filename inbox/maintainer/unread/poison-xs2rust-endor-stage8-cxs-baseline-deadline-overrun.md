from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-17T12:33:18Z
poison_base: xs2rust-endor-stage8-cxs-baseline
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-17T12:33:18Z
last_seen: 2026-07-17T12:33:18Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/xs2rust-endor-stage8-cxs-baseline; it stays HELD until a human promotes it
(promote-plan.sh xs2rust-endor-stage8-cxs-baseline) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: xs2rust-endor-stage8-cxs-baseline

--- original job body ---
---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T11:34:03Z -->

---
model: opus
---
# Stage-8 child 3/6 — libxs provisioning + boot-bundle generation + C-XS `test:rust` BASELINE

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8`; tada-only reporting. One 2400s invocation.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; push via CAS, verify by exit code.

**Task — establish the C-XS-backed daemon baseline (the probe's step 4: "before any pure-Rust
swap").** Children 1–2 (serially before you) fixed the daemon bundle and landed the three
generators. Now:
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


<!-- garden-deadline-overrun: 1 -->
