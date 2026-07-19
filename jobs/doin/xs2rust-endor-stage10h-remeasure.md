---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T09:58:03Z -->

---
model: opus
---
# stage10h child 2/2 — measurement-only 52-file daemon sweep re-measure (outage-hardened)

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT — untouched, no comments, no pushes; this job is MEASUREMENT-ONLY). Sync to the REAL remote tip (`git ls-remote origin xs2rust-endor`) and record it; read the latest `xs2rust-endor-press-*` and stage10h sibling tadas first — if the tip equals the s10f remeasure's measured tip `408ef16683` (no engine commits landed since), report that the anchor stands and SKIP the sweep (a re-measure of an already-measured tip is waste); otherwise proceed. At dispatch the tip was `12d997c9fecc` — six engine commits past the measured anchor (F1/F2 fixes, three array-gopd/ownKeys gaps, the END value-stack reset) — so the sweep is expected to RUN.

**Environment:** reuse the short-path env `~/tmp/s10e` (host endolin-garden2; AF_UNIX sun_path limit). Sync changed source files to the tip, `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, fresh `cargo build --release -p endo --bin endor` (BUILD_EXIT=0), regenerate the three XS bundles, confirm `c/moddable` clean at pin `23b4d6b0a65f…`, daemon-boot smoke `context.test.js` 10/10 before the sweep. The prior scripts are reusable: `~/tmp/s10f-results/{build.sh,sweep.sh}`.

**OUTAGE HARDENING (BINDING — the s36/s10f shape, proven to survive two reaper requeues):** every artifact under `~/tmp/s10h-results/` (measured-tip.sha, per-file TSV appended live as each file finishes, raw logs, SUMMARY.md); the sweep runs DETACHED via `setsid nohup` so a handler kill cannot lose it; a re-claim resumes from the TSV (skip files already measured at the same tip), never restarts.

**Sweep:** the 52-file `test:rust` daemon set, `--concurrency=1 --timeout=25s`, default ava reporter (TAP crashes on timed-out tests). Compare per-file against the stage-10 Rust anchor **fail=14 / skip=20 / 6-pending + error-trace hang** (classes: content-store-gc 9, git 3, git-remote 2 — engine-independent; endo.test.js self-overload storm artifact; error-trace 6-pending-hang = the finish-line pin — report explicitly whether it MOVED, since the END fix + handleCommand registration may change worker behavior materially). C-XS anchor 530/19/20/0 stands as reference; re-run C-XS ONLY if a class changed. Environment-artifact classes to rule out before blaming the engine: AF_UNIX path length, uniform provisioning-race asserts, stale seeded `target/`. channel.test.js needs its long window (124 tests × ~5s spin-up — throughput, not hang).

**Output:** tada with the totals table, per-file delta vs anchor with every divergent file classified, the error-trace pin status, and the finish-line statement. Fit one 2400s invocation for the SUPERVISED part (the detached sweep itself may outlive the handler — that is the design). Report via tada ONLY; never inbox-send the parked supervisor.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 11
  worker_kind: gardener
  claimed_at: 2026-07-19T09:58:07Z
