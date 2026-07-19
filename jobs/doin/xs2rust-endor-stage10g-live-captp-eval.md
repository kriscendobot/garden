---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T08:43:07Z -->

---
model: opus
---
# stage10g child 2/3 — gated live daemon round trip (BINDING precondition gate; else DEGRADE to a gap round)

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`, base `llm`. Sync to the REAL remote tip; read the latest `xs2rust-endor-press-*` and stage10g sibling tadas first. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`; seeding recipe as the sibling children (target `cp -al` same-commit sibling; `c/moddable` at pin `23b4d6b0a65f…`; bundles from `~/tmp/s10e/rust/endo/xsnap/src/` after the `packages/` content-identity check; never commit either).

**BINDING PRECONDITION GATE (~300s budget):** build and run the in-tree marker test `boot_drives_the_real_chain_to_the_worker_bundle_frontier` (`cargo test -p endo --lib` with real bundles). The round trip is attempted ONLY if the boot reaches `halted_at == None` AND `handle_command_registered == true`. If the gate is RED (the worker bundle still halts at a frontier), **DEGRADE IMMEDIATELY to a worker-bundle gap round** per the honest-success template (stage10e live-captp tada, `98333bf528`/`5e26986bd3`): close 1-2 frontier gaps with full push-per-gap discipline exactly as child 1's body specifies, and tada the DEGRADED round honestly — that IS success; do NOT chase the round trip past the gate (three prior live-captp children died at deadline over-reaching).

**If the gate is GREEN:** run the live round trip — build the ROOT release binary (`cargo build --release -p endo --bin endor`), then drive the daemon smoke gates in the short-path env `~/tmp/s10e` (host endolin-garden2; AF_UNIX sun_path limit — real short path only; sync its source files to your tip and `cargo clean -p endor-compile -p endor-vm -p endor-oracle` + fresh release build first, per `~/tmp/s10f-results/build.sh`): `context.test.js` 10/10, then `channel.test.js` with the DEFAULT ava reporter (TAP crashes in `dumpError` on a timed-out test; channel.test.js cannot finish a 90s serial window — throughput artifact, NOT a hang) under `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`). Push-per-item any engine fixes surfaced; checkpoint every artifact under `~/tmp/s10g-results/` as it lands.

**Bars (green before every push), sizing, STOP-and-checkpoint, tada-only reporting:** identical to child 1's body (workspace all-0-failed at the tip's binary count; compile-diff + SYMB 1909/1909; boot gate 30/0; ROOT lib 0-failed; zero non-oracle warnings; forbid 7 + oracle exempt; VARIANT_COUNT 35 or ledger; the s37 integrity-flag doctrine on any new write path; fit one 2400s invocation; STOP at a pushed bar-green checkpoint; report via tada ONLY; keep DRAFT).

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-19T08:43:12Z
