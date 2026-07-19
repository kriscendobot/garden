---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T11:31:04Z -->

---
model: opus
---
# Measurement: 52-file daemon sweep re-measure at the stage-10i tip (PR #600) — outage-hardened, measurement-only

**Measurement-only:** no commits, no pushes, no PR comments; PR #600 stays DRAFT and untouched.

**Precondition:** measure the REAL remote tip of `endojs/endo-but-for-bots` branch `xs2rust-endor`
(`git fetch`; read the latest `xs2rust-endor-press-*` tadas first — the press can advance the
branch). The prior measured anchor is `d911a958947b` (s10h: fail=14/skip=20/1 error-trace hang).
SKIP (and say so) ONLY if the tip equals an already-measured sha; the serial stage10i
predecessors (accessor fixer + for_of/live-captp) will have advanced it.

**Environment (this host, endolin-garden):** reuse the short-path env `/home/kris/garden/tmp/s9r`
(TMPDIR AF_UNIX limit: `export TMPDIR=/home/kris/garden/tmp`). Sync changed sources to the tip,
`cargo clean -p endor-compile -p endor-vm -p endor-oracle`, fresh
`cargo build --release -p endo --bin endor` (record BUILD_EXIT), regenerate the 3 XS bundles and
note byte-identity vs prior, `c/moddable` clean at pin `23b4d6b0a65f…`. Daemon-boot smoke
(context.test.js) before the sweep. The three ruled-out environment-artifact classes to watch:
AF_UNIX sun_path overflow (use the short path), uniform provisioning-race asserts, stale seeded
`target/` (you just cleaned).

**Outage hardening (BINDING — proven across three reaper requeues):** run the sweep DETACHED
(`setsid nohup`), append a per-file TSV live, artifacts under `/home/kris/garden/tmp/s10i-results/`
(MEASURED-TIP.txt, build-exit, per-file logs, SUMMARY.md). On requeue/resume: find the live sweep
and WAIT for it, resume from the TSV — never restart from scratch.

**Sweep:** the 52 daemon test files (excl. endo.test.js — self-overload storm, excluded by
anchor), default ava reporter (`--tap` crashes in `dumpError` on a timed-out test),
`--concurrency=1 --timeout=25s`, per-file serial windows. Compare per-file fail/skip/hang counts
against the stage-10 Rust anchor (fail=14/skip=20/1 error-trace hang; ledger: content-store-gc 9,
git 3, git-remote 2 daemon-side engine-independent; channel.test.js completing clean is an
IMPROVED READOUT, not a class change). Classify EVERY divergent file. A C-XS re-run is gated on a
CHANGED class only (anchor 530/19/20/0).

**Report explicitly:** (1) whether the error-trace 6-pending-hang finish-line pin MOVED — the
stage10i for_of/round-trip work may change worker behavior materially; if any error-trace test
flips to pass/fail, show the per-test list; (2) any NEW daemon class vs the ledger; (3) the
finish-line statement (does any `test:rust` daemon class fail beyond the expected-divergence
ledger at the measured tip?). Report via your tada ONLY; never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-19T11:31:08Z
