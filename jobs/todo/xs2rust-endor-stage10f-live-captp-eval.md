---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T06:28:04Z -->

---
model: opus
---
# stage10f child 2/3 — live daemon worker-evaluate round trip on the Rust engine (`error-trace` un-hangs)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `8eabbdefce` — **sync to the REAL remote tip first**; verify pushes by git EXIT CODE. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`. Seed `rust/engine/target/` + pinned `c/moddable` via `cp -al` from a same-commit sibling; confirm sha + clean status first.

## BINDING precondition gate (run FIRST, ~300s budget)

At your tip verify: the worker bundle **boots to completion and registers `handleCommand`** — ROOT `cargo test -p endo --lib` (with generated bundles), the frontier marker test `boot_drives_the_real_chain_to_the_worker_bundle_frontier` shows `halted_at == None` / `handle_command_registered == true` (equivalently: your predecessor child's tada reports the frontier CLOSED). **If the bundle still halts at a named frontier, do NOT attempt the daemon round trip** — this job DEGRADES to another worker-bundle gap round: continue push-per-gap from the exact frontier in the marker (the predecessor's discipline: oracle-grounded dual-run snippets → implement → gate tests → promote marker → full bars → push). The stage10e live-captp child degraded exactly this way and landed 2 verified gaps (`98333bf528`, `5e26986bd3`) — that is the honest-success template. Three earlier live-captp children died at deadline attempting too much; an honest capability increment is success.

## Definition of done (only when the gate is GREEN)

1. Build the ROOT-workspace release worker: `cargo build --release -p endo --bin endor` (generate the JS bundles, never commit them).
2. Drive the daemon test that pins the finish-line blocker: `packages/daemon` **`error-trace.test.js`** with `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). Anchor: 1 pass + **6 pending after timeout (worker-evaluate HANG)**. DoD: the round trip **completes** — the 6 pending tests reach real pass/fail verdicts (report exact counts; a real fail with a named cause is progress, a hang is the blocker).
3. Push every piece of glue/engine fix as its own commit immediately (push-per-item). Grounded oracle snippets for engine-semantic fixes.
4. Default (non-TAP) ava reporter for timeout truth (the TAP reporter crashes in `dumpError` on timed-out tests).

## Daemon environment (the sharp edges, all previously hit)

- AF_UNIX `sun_path` overflow: run from a REAL short path. `~/tmp/s9r` is an existing short-path daemon checkout on host endolin-garden; on another host create `~/tmp/<short>` equivalently. `mkdir -p $HOME/tmp`; `TMPDIR=$HOME/tmp` (`/tmp` is noexec). Sync the short-path checkout to your tip before measuring; rebuild the release `endor` at that tip; confirm clean status + sha before trusting seeded caches.
- Uniform provisioning-race asserts and stale seeded `target/` are the other two environment-artifact classes — classify a mass failure against all three before blaming the engine.
- Smoke gate before the measurement: `channel.test.js` on the Rust worker must pass.

## Bars that must stay green (before EVERY push; outputs to files, check `$?`)

Engine workspace EXIT=0 all-0-failed (797 passed at cut; binary count canonical); compile-diff 1909/1909 + SYMB 1909/1909; boot gate 30 (binary count); ROOT `cargo test -p endo --lib` 0-failed (110 at cut with real bundles, ≥86 with placeholders); zero new Rust warnings; forbid intact (7 anchored roots, endor-oracle exempt); new side tables ledgered day-they-land (VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f…` clean, never staged; no committed bundles. Doctrine: accuracy-over-parity.

## Discipline (BINDING)

- **Push-per-item**; **STOP-and-checkpoint** at ~1800s-with-nothing-pushed: land an honest verified increment, push, tada with the exact resume point + halt signature.
- Report via tada ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.
