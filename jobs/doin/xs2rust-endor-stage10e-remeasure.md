---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T00:34:03Z -->

---
model: opus
---
# stage10e child 3/3 — bounded-serial 52-file daemon sweep re-measure (measurement-only)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`. **Measurement-only: no engine/worker/test edits, nothing committed or pushed to the branch.** Sync your isolated checkout (`scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`) to the REAL remote tip and RECORD the measured sha in your tada.

## Procedure

1. Short-path daemon environment (AF_UNIX limit): `~/tmp/s9r` exists on host endolin-garden; else create `~/tmp/<short>` (clone + install; seed node_modules from a sibling). Sync it to the measured tip. Rebuild the release worker fresh at that tip: `cargo build --release -p endo --bin endor` after `cargo clean -p endor-compile -p endor-vm -p endor-oracle`; generated bundles regenerated, never committed; `c/moddable` at pin `23b4d6b0a65f…` clean.
2. **Smoke gate first:** `channel.test.js` on `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). If it fails, classify against the three environment-artifact classes (AF_UNIX path length, provisioning-race asserts, stale seeded target/) before proceeding or blaming the engine.
3. Sweep all 52 daemon test files serially, `--concurrency=1 --timeout=25s`, generous per-file outer timeout (channel.test.js needs >600s at concurrency 1 — 124 tests × ~5s worker spin-up; its non-finish inside a 90s window is a KNOWN harness-throughput artifact, not a hang). Checkpoint per-file results to a TSV OUTSIDE the worktree (`~/tmp/s10e-results/`), so a deadline death loses nothing.
4. Use the default ava reporter to confirm any timeout file (the TAP reporter crashes in `dumpError` on timed-out tests — known artifact); `error-trace.test.js` is the finish-line pin (anchor: 1 pass + 6 pending HANG; if the stage10e round-trip child landed, expect it to move — report exact per-test verdicts).
5. Compare per-file classes vs the stage-10 Rust anchor (fail=14: content-store-gc 9, git 3, git-remote 2 — all daemon-side engine-independent; skip=20; 6 pending + 1 hang at error-trace) and the C-XS anchor **530/19/20/0** (re-run C-XS via `~/tmp/s8cxs` ONLY for classes that changed). Explain EVERY class delta; maintain the expected-divergence ledger.

## Output (tada report)

Measured tip sha; totals table (pass/fail/skip/pending vs both anchors); per-file delta table with verdicts; environment artifacts encountered; the finish-line statement (does any `test:rust` daemon class still fail on the Rust engine beyond the expected-divergence ledger — name each).

## Discipline

Checkpoint continuously (a partial sweep with a TSV is an honest tada); report via tada ONLY — never inbox-send the parked supervisor.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-19T00:43:13Z
