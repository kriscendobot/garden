---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T09:43:03Z -->

---
model: opus
---
# stage10h child 1/2 — hostGetDaemonHandle host binding, then the gated live daemon round trip (HARD STOP discipline)

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`, base `llm`. Sync to the REAL remote tip (`git ls-remote origin xs2rust-endor`; at dispatch it was `12d997c9fecc`) and read the latest `xs2rust-endor-press-*` and stage10g/10h sibling tadas first — the hourly press can advance the branch between sessions. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`; seeding recipe as the stage10g children (`rust/engine/target/` `cp -al` from a same-commit sibling; `c/moddable` at pin `23b4d6b0a65f…`, never `git add c/moddable`; ROOT bundles from `~/tmp/s10e/rust/endo/xsnap/src/` after the `packages/` content-identity check — `diff -rq` since `~/tmp/s10e` is a bare rsync copy; never commit bundles).

**Where the frontier is (set by 10g's END fix, `12d997c9fecc`):** the worker bundle now boots through the entire SES + @endo graph and registers a real `globalThis.handleCommand`; boot halts at the first missing HOST global, **`hostGetDaemonHandle`** — a host-integration binding (the daemon-handle accessor the runtime injects alongside `hostSendRawFrame`), no longer an engine op. The 10g `Throw("call: not a function")` frontier was a value-stack-corruption artifact, fixed by that commit — do not chase it.

**Step 1 (the sized increment):** bind `hostGetDaemonHandle` in the host-integration layer, mirroring how `hostSendRawFrame` is injected; dual-run/marker-grounded per the in-tree marker test (`boot_drives_the_real_chain_to_the_worker_bundle_frontier`, `cargo test -p endo --lib` with real bundles); push it as its own bar-green commit. If the marker then names a NEXT missing host global or gap, close at most ONE more the same way, push, and reassess the clock.

**Step 2 — BINDING PRECONDITION GATE (~300s budget):** re-run the marker. The round trip is attempted ONLY if `halted_at == None` AND `handle_command_registered == true`. If RED, DEGRADE to the honest gap round above and tada the DEGRADED round honestly — that IS success.

**Step 3 — the round trip, ONLY if the gate is GREEN AND ≥1200s of the 2400s invocation remain:** build the ROOT release binary (`cargo build --release -p endo --bin endor`), then drive the daemon smoke gates in the short-path env `~/tmp/s10e` (host endolin-garden2; AF_UNIX sun_path limit — real short path only; sync its source files to your tip, `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, fresh release build per `~/tmp/s10f-results/build.sh`): `context.test.js` 10/10, then `channel.test.js` with the DEFAULT ava reporter (TAP crashes in `dumpError` on a timed-out test; channel.test.js cannot finish a 90s serial window — throughput artifact, NOT a hang) under `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). If <1200s remain at gate-GREEN, STOP and tada the gate-GREEN checkpoint — the round trip becomes the next child's first act, and that is a GOOD outcome.

**HARD STOP discipline (binding — FOUR live-captp predecessors died at deadline; 10g's landed one push then overran):** after EVERY pushed item, reassess the wall clock; prefer an honest partial tada at a pushed bar-green checkpoint over ANY further reach. Checkpoint artifacts under `~/tmp/s10h-results/` as they land.

**Bars (green before every push):** engine workspace `cargo test --workspace -- --test-threads=1` all-0-failed at the tip's binary count (last measured 842/0 across 64 binaries at `f95d7bcc32`; counts GROW — cite the measured number at your tip); `compile-diff` + SYMB 1909/1909 EXIT=0; boot gate `boot_bundle_gate` 30/0; ROOT `cargo test -p endo --lib` 0-failed with real bundles; zero new non-oracle warnings; forbid 7 anchored roots + oracle exempt; VARIANT_COUNT 35 or ledger the change; the s34+s37 integrity-flag doctrine on any new write path (never `set_own_unmetered` onto a guest-reachable target that can carry flagged or accessor keys). Capture `cargo test` to a file and check `$?` — piping to `tail` masks the exit code. Fit one 2400s invocation; report via tada ONLY (never inbox-send the parked supervisor); keep DRAFT.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-19T09:43:07Z
