---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T06:55:04Z -->

---
model: opus
---
# stage10f child 3/3 — bounded-serial 52-file daemon sweep re-measure (measurement-only, outage-hardened)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`. **Measurement-only: no engine/worker/test edits, nothing committed or pushed to the branch.** Sync your isolated checkout (`scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`) to the REAL remote tip and RECORD the measured sha in your tada.

**Predecessor history (why this body has a hardening section):** the stage10e remeasure child was killed 5 times by TRANSIENT HANDLER KILLS (not deadline overruns, not its own errors — an infra outage window 00:34–01:45Z on 2026-07-19 hit every claim on both hosts) and was reaper-poisoned with zero results lost only because its first attempt checkpointed. Its checkpoints survive at `~/tmp/s10e-results/` on host endolin-garden (measured-tip `5e26986bd3`, now stale; release build + bundles + a PASSING channel.test.js smoke log; `sweep.sh`/`sweep51.sh` scripts you may adapt). The measurement content of this job is unchanged from stage10e; the hardening is new.

## Outage hardening (BINDING)

- Write EVERY artifact outside the worktree, under `~/tmp/s10f-results/`: measured-tip sha, per-file TSV row appended the moment each file's run finishes, raw logs.
- Run the long sweep DETACHED (`setsid nohup <sweep-script> >> ~/tmp/s10f-results/sweep.log 2>&1 &`), then poll its TSV — a handler kill then cannot kill the sweep, and a requeued claim finds it finished or still running.
- On (re)claim, FIRST check `~/tmp/s10f-results/`: if the TSV covers files at the current remote tip, resume — skip measured files, run only the remainder. A partial sweep with a TSV is an honest tada.

## Procedure

1. Short-path daemon environment (AF_UNIX limit): `~/tmp/s9r` exists on host endolin-garden; else create `~/tmp/<short>` (clone + install; seed node_modules from a sibling). Sync it to the measured tip. Rebuild the release worker fresh at that tip: `cargo build --release -p endo --bin endor` after `cargo clean -p endor-compile -p endor-vm -p endor-oracle`; generated bundles regenerated, never committed; `c/moddable` at pin `23b4d6b0a65f…` clean.
2. **Smoke gate first:** `channel.test.js` on `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). If it fails, classify against the three environment-artifact classes (AF_UNIX path length, provisioning-race asserts, stale seeded target/) before proceeding or blaming the engine.
3. Sweep all 52 daemon test files serially, `--concurrency=1 --timeout=25s`, generous per-file outer timeout (channel.test.js needs >600s at concurrency 1 — 124 tests × ~5s worker spin-up; its non-finish inside a 90s window is a KNOWN harness-throughput artifact, not a hang). Checkpoint per-file results to the TSV as above.
4. Use the default ava reporter to confirm any timeout file (the TAP reporter crashes in `dumpError` on timed-out tests — known artifact); `error-trace.test.js` is the finish-line pin (anchor: 1 pass + 6 pending HANG; if the stage10f round-trip child landed, expect it to move — report exact per-test verdicts).
5. Compare per-file classes vs the stage-10 Rust anchor (fail=14: content-store-gc 9, git 3, git-remote 2 — all daemon-side engine-independent; skip=20; 6 pending + 1 hang at error-trace) and the C-XS anchor **530/19/20/0** (re-run C-XS via `~/tmp/s8cxs` ONLY for classes that changed). Explain EVERY class delta; maintain the expected-divergence ledger.

## Output (tada report)

Measured tip sha; totals table (pass/fail/skip/pending vs both anchors); per-file delta table with verdicts; environment artifacts encountered; the finish-line statement (does any `test:rust` daemon class still fail on the Rust engine beyond the expected-divergence ledger — name each).

## Discipline

Checkpoint continuously (a partial sweep with a TSV is an honest tada); report via tada ONLY — never inbox-send the parked supervisor.

<!-- garden-reaped: 3 -->
