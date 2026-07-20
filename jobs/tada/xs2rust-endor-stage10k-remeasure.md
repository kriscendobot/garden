No real endor orphans remain (those matches were my own `ps`/`pgrep` command lines). The measurement is complete. PR #600 was never touched — no commits, pushes, or comments were made.

## Completion report — stage-10k 52-file daemon sweep re-measure (PR #600)

**Measurement-only. No commits, no pushes, no PR comments. PR #600 stays DRAFT and untouched.** Container guard clean (inside container). Fetched the real remote tip first.

**Tip measured (advanced — did NOT skip):** `3b18435c4e1a2f062985c280bf2f31b013b78ecb` — the s10k `dub_at` commit, **+3 rust-only commits** over the s10i anchor `afff3aaf6`: `57270f306` (s10k F1 accessor→data method-redefine), `861cbdea0` (s10k `trace` bind — CapTP dispatch gate GREEN), `3b18435c4` (s10k `dub_at`). `git diff afff3aaf6..tip` touches only `rust/` (no JS, no Cargo). Latest press tada (`20260719-133501`) and the child-1 dispatch tada were read first.

**Environment (endolin-garden2, reuse env `/home/kris/garden2/tmp/s10e`; job authored for endolin-garden `/home/kris/garden/tmp/s9r` — adapted garden→garden2, same recipe as the s10i remeasure that ran on this host):** short AF_UNIX/TMPDIR path (`/home/kris/garden2/tmp`), `$HOME/tmp` present. Full `rust/` tree tar-synced from tip (rsync absent on host; verified zero deletions in range, so tar-overwrite is exact). Touched interp/compartment/rust_worker/sidetable → **recompile triggered** (`Compiling endor-vm`, `endor-compile`, `endo`, `xsnap`). Fresh `cargo build --release -p endo --bin endor` → **BUILD_EXIT=0** (16.8s, binary 33.2 MB; only the pre-existing `xsnap` fn_addr_eq lint). `c/moddable` clean at pin `23b4d6b0a65f`. 3 XS bundles regenerated → **byte-identical (md5 unchanged)**. Daemon-boot smoke `context.test.js` **10/10**, ec=0. All three env-artifact classes guarded and clean (no AF_UNIX overflow, no provisioning-race asserts, no stale target — full rust/ resynced from tip).

**Sweep (52 files, default reporter, `--concurrency=1 --timeout=25s`, detached setsid nohup, resumable TSV):** **pass=760 · fail=15 · skip=20 · pending=6** — **TSV byte-identical to the s10i baseline in every column except `elapsed_s`** (±1–2s jitter). Decomposes to the s10h/s10j anchor exactly.

**Required answers:**

1. **Did the error-trace 6-pending pin MOVE? — NO. Zero flipped.** `host exposes a traces facet` passes (1); the same 6 remain pending after timeout — accounted for each: (a) evaluate-rejection worker-trace record; (b) @daemon stub records; (c) recent() multiple emissions; (d) clear() drops records; (e) lookup unknown errorId; (f) two-workers numbered-errorId collision. **Why the pin held despite child 1 landing `trace`+`dub_at`:** child 1 delivered a **gate-GREEN checkpoint and explicitly DEFERRED the LIVE daemon round trip** (per its own tada). These 6 exercise the live worker-eval trace round trip through the daemon, which the deferred round trip did not close. The expected flip was contingent on the live round trip landing; it did not, so the pin correctly did not move.

2. **New daemon class? — NONE.** Every fail is in the ledger: content-store-gc **9** (invariants 3 + gc 6), git **3**, git-remote **2** = 14; plus error-trace 1 fail + 6 pending. Every skip in the ledger: channel-relay 4 + invite-retention 10 + iroh-network 1 + ws-relay 5 = 20. channel.test.js 87/0.

3. **Any class changed? — NO** → **C-XS same-harness baseline NOT re-run** (anchor 530/19/20/0 stands, unchanged).

**Artifacts** under `/home/kris/garden2/tmp/s10k-results/`: MEASURED-TIP.txt, build-exit.txt, build.log, bundle-gen.log, prior-bundles/, smoke-context.log, sweep.sh, sweep-driver.log, sweep-rust.tsv, logs/ (52), SUMMARY.md, SWEEP-COMPLETE.

**Follow-up:** the error-trace 6-pending live-worker-trace round trip remains the open finish-line pin — it is now unblocked at the code level (gate GREEN) and awaits the deferred LIVE daemon round trip (child 1 follow-up #1) to actually flip these 6.
