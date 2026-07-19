---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T14:10:03Z -->

---
model: opus
---
# stage-10k child 1: `trace` + `dub_at` — flip the CapTP dispatch gate GREEN, then the gated LIVE round trip (PR #600)

Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — never un-draft, never touch PR state). ISOLATED worktree via `scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`; sync to the REAL remote tip. Seed caches (`cp -al` target/ + `c/moddable` at pin `23b4d6b0a65f`, real bundles from `rust/endo/xsnap/src/*.js` — never commit bundles) from the s41 sibling `/home/kris/garden2/scratch/project-wt-port-xs-to-rust-memory-safe-engine-s41-5cd7f36a` (endolin-garden2, `42e4fcdf8e`) or a nearer same-commit sibling; `cargo clean -p endor-compile -p endor-vm -p endor-oracle` for acceptance-grade runs. Capture test output to files, check `$?`.

**State (s10j → s41 acceptance issuecomment-5015969926):** the fully-booted worker bundle's own `handleCommand` decodes a real CBOR deliver envelope end-to-end (`subarray` landed) and routes it; the two pinned frontiers are:
1. **`trace`** — a host global on the route/log path (`get <id>: undefined variable`), an XS global built-in endor doesn't model. This is a REALM-GLOBAL binding with SES-lockdown/snapshot implications: follow the `hostSendRawFrame`/`hostGetDaemonHandle` ledger pattern (side-table GC-roots class + snapshot treatment recorded the SAME DAY it lands), engine ops transliterated bit-exact from C-XS.
2. **`dub_at`** — a new opcode on the CapTP-bootstrap serialize branch. Transliterate bit-exactly from C-XS, including any macro artifacts (the C-XS `indexOf_aux` precedent: never "fix" the oracle).

**Work items, push-per-item:** (0) bind `trace`; (1) implement `dub_at`. Each push carries dual-run coverage and the full no-boot-regression bars: engine workspace `--test-threads=1` EXIT=0 (last 894/0), compile-diff 1909/1909 + SYMB EXIT=0, ROOT `cargo test -p endo --lib` (last 111/0) with real bundles and the full-boot marker GREEN. The self-updating marker `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier` FAILS the day `trace` closes — promote it honestly to the next frontier, or to a GREEN assertion if none remains. No new `unsafe`; any new side table ledgered same day; 0 non-oracle warnings.

**BINDING gate (~300s budget):** full-boot marker GREEN AND `dispatch_command_to_handler` returns `Ok` on the representative command — no degrade, no fold-ack. If a NEW frontier appears past `trace`+`dub_at`, you may close at most ONE more item; a second new-KIND frontier = STOP and checkpoint. A gate-GREEN checkpoint short of the round trip, or a DEGRADED gap round, are both honest tada success — never force past the discipline.

**The moment the gate is GREEN: verify NO silent-ack masking** — a command the handler completes must flow its REAL value back through `dispatch_deliver` (compare against the fold-ack shape; a masked ack is a wrong completion — report it as a finding in your tada).

**HARD STOP discipline:** reassess the clock after EVERY pushed item. The LIVE daemon round trip (`ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — NOT `ENDO_ENGINE`; short-path env, the proven `/home/kris/garden/tmp/s9r` on endolin-garden) ONLY if the gate is GREEN AND ≥1200s remain; otherwise checkpoint and tada. Report via your tada completion report ONLY — never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-19T14:10:08Z
