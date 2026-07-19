---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T13:16:05Z -->

---
model: opus
---
# Measurement: 52-file daemon sweep re-measure at the stage-10j tip (PR #600) — outage-hardened, measurement-only

**Measurement-only:** no commits, no pushes, no PR comments; PR #600 stays DRAFT and untouched.

**Precondition:** measure the REAL remote tip of `endojs/endo-but-for-bots` branch
`xs2rust-endor` (`git fetch`; read the latest `xs2rust-endor-press-*` tadas first — the press
can advance the branch). The prior measured anchor is `afff3aaf640f` (stage-10i remeasure:
fail=15/skip=20/pending=6, decomposing to ledger-14 + error-trace 1 fail + 6 pending;
channel.test.js 87/0). SKIP (and say so) ONLY if the tip equals an already-measured sha; the
serial stage10j predecessors (flag fixer + captp-dispatch) will have advanced it.

**Environment:** if claimed on endolin-garden, reuse the short-path env
`/home/kris/garden/tmp/s9r`; on endolin-garden2, the equivalent `/home/kris/garden2/tmp/s10e`
(the stage-10i remeasure's proven adaptation). `export TMPDIR` to the short garden tmp path
(AF_UNIX sun_path limit). Sync changed sources to the tip, `cargo clean -p endor-compile -p
endor-vm -p endor-oracle`, fresh `cargo build --release -p endo --bin endor` (record
BUILD_EXIT), regenerate the 3 XS bundles and note byte-identity vs prior (the flag fixer and
dispatch child touch Rust only unless their tadas say otherwise), `c/moddable` clean at pin
`23b4d6b0a65f…`. Daemon-boot smoke (`context.test.js`) before the sweep. The three ruled-out
environment-artifact classes to watch: AF_UNIX sun_path overflow (short path), uniform
provisioning-race asserts, stale seeded `target/` (you just cleaned). Rust engine selection:
`ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). Use the DEFAULT ava
reporter (TAP crashes in `dumpError` on a timed-out test and undercuts throughput).

**Outage hardening (BINDING — proven across four reaper requeues):** run the sweep DETACHED
(`setsid nohup`), append a per-file TSV live, artifacts under
`$HOME/tmp/s10j-results/` (mkdir first; MEASURED-TIP.txt, build-exit, per-file logs,
SUMMARY.md). On requeue/resume: find the live sweep by TSV mtime, resume from the TSV rather
than restarting; classify any kill honestly.

**Sweep:** the 52-file bounded-serial set (excl. endo.test.js), `--concurrency=1
--timeout=25s`. **Report answers (required):**
1. **Did the error-trace 6-pending-hang finish-line pin MOVE?** The stage10j dispatch child
   aims the LIVE round trip directly at this surface — name every error-trace test that
   flipped (pass/fail/pending) vs the anchor.
2. Any NEW daemon class vs the expected-divergence ledger (ledger: content-store-gc 9, git 3,
   git-remote 2; skips: channel-relay 4 + invite-retention 10 + iroh-network 1 + ws-relay 5)?
3. The finish-line statement: does any `test:rust` daemon class fail beyond the ledger at the
   measured tip? Trigger a C-XS re-run ONLY on a CHANGED class (anchor 530/19/20/0).

Report via your tada completion report ONLY — never inbox-send the parked supervisor.
