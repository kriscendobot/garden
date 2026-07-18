---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T22:34:16Z -->

---
model: opus
---
# stage10d child 3/4 — live daemon worker-evaluate round trip on the Rust engine (`error-trace` un-hangs)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `c345aa838` — **sync to the REAL remote tip first**; verify pushes by git EXIT CODE. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.

## BINDING precondition gate (run FIRST, ~300s budget)

At your tip verify BOTH: (a) the real two-eval SES boot gate (child 1) is green, and (b) the worker boot-chain + `handleCommand` dispatch tests (child 2; ROOT-workspace `cargo test -p endo --lib`) are green. **If EITHER gate is RED, do NOT attempt the daemon round trip** — this job DEGRADES to the next gap round on whichever capability is missing (continue from the predecessor's exact named remainder, push-per-gap; an honest capability increment is success). Two prior live-captp children died at deadline with ZERO pushes attempting the round trip without its prerequisites; the gate exists to prevent a third.

## Definition of done (gates green)

1. Build the ROOT-workspace release worker: `cargo build --release -p endo --bin endor` (needs the generated JS bundles — generate them, never commit them).
2. Drive the daemon test that pins the finish-line blocker: `packages/daemon` **`error-trace.test.js`** with `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE` — it does not route child-process workers). At stage-9/10 anchor this file is 1 pass + **6 pending after timeout (worker-evaluate HANG)**. DoD: the worker-evaluate round trip **completes** — the 6 pending tests reach real pass/fail verdicts (report exact counts; a real fail with a named cause is progress, a hang is the blocker).
3. Push every piece of glue/engine fix as its own commit immediately (push-per-item). Grounded oracle snippets for engine-semantic fixes.
4. Use the default (non-TAP) ava reporter for truth on timeouts (the TAP reporter crashes in `dumpError` on a timed-out test — known measurement artifact).

## Daemon environment (the sharp edges, all previously hit)

- AF_UNIX `sun_path` overflow: run from a REAL short path. `~/tmp/s9r` is an existing short-path daemon checkout on host endolin-garden; on another host create `~/tmp/<short>` equivalently (clone + install per repo README; seed `node_modules` from a sibling checkout if available). `mkdir -p $HOME/tmp` first; `TMPDIR=$HOME/tmp` (`/tmp` is noexec).
- Sync the short-path checkout to your tip before measuring; rebuild the release `endor` bin at that tip; confirm `git status` clean + tip sha before trusting any seeded cache (`cp -al` seeding from same-commit siblings only).
- Uniform provisioning-race asserts and stale seeded `target/` are the other two known environment-artifact classes — if a mass failure appears, classify against these three before blaming the engine.
- Smoke gate before the measurement: `channel.test.js` on the Rust worker must pass (it is green at anchor).

## Bars that must stay green (before EVERY push; outputs to files, check `$?`)

Engine workspace EXIT=0 all-0-failed (708 at cut); compile-diff 1909/1909 + SYMB 1909/1909; boot gate 28 (binary count canonical); ROOT `cargo test -p endo --lib` ≥84/0; zero new Rust warnings; forbid intact (7 anchored roots, oracle exempt); new side tables ledgered day-they-land (VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f…` clean, never staged; no committed bundles. Doctrine: accuracy-over-parity (result agreement gates).

## Discipline (BINDING)

- **Push-per-item**; **STOP-and-checkpoint** at ~1800s-with-nothing-pushed: land an honest verified increment (even partial glue behind a test), push, tada with the exact resume point + halt signature.
- Report via tada ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-18T22:34:21Z
