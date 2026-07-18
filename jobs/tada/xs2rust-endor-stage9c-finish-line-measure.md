Inbox empty; project worktree is unmodified at tip `e07903ebee` (measurement-only, nothing to push to the branch). Both checkpoints are on `journal2`. The job is complete.

---

## Completion report — stage-9c child 9/9: `test:rust` finish-line measurement

**Measurement-only, honored.** No engine/test/corpus edits; the project worktree stays at tip `e07903ebee` with nothing committed or pushed to `xs2rust-endor`. PR #600 untouched/draft.

**Tip measured:** `e07903ebee36021f51abf5e35fbc7051f62c16a1` (child 8, the endor-vm worker surface). Release `endor` daemon bin built fresh at this tip (`cargo build --release -p endo --bin endor`, EXIT=0, only the pre-existing xsnap `function-pointer-comparison` C warning; `c/moddable` pinned `23b4d6b0` and clean, never staged; all 5 xsnap bundles present).

**Engine-selection correction (material):** `ENDO_ENGINE=rust` does *not* route the daemon's separate (child-process) workers to endor-vm — the worker child picks its engine only from the `-e` flag. The Rust engine is exercised via `ENDO_WORKER_BIN='…/endor worker -e rust'`. Verified effective (a worker eval completes on `endor worker`, hangs on `endor worker -e rust`).

**Smoke gate:** the worker-evaluate path **hangs** on Rust (`error-trace` "evaluate rejection" — C-XS returns `boom-from-eval`, Rust never returns), matching child 8's documented remainder. But because some flows complete, I ran a **bounded serial sweep** (52 files, `--concurrency=1 --timeout=25s`, `~/tmp/s9r` short path for the AF_UNIX cap, `endo.test.js` excluded as the un-runnable detached harness) on **both** engines for an apples-to-apples baseline.

**Three-number summary (52 files, same bounded harness):**
- **Rust:** 531 passed / 14 failed / 20 skipped / 6 pending (1 file timed out: error-trace)
- **C-XS:** 530 passed / 19 failed / 20 skipped / 0 pending

**Per-file divergence — the entire diff across 52 files is one file:**
- **error-trace.test.js** — C-XS fails 5 (completes); **Rust hangs, 6 pending.** The sole Rust regression.
- content-store-gc (6), content-store-gc-invariants (3), git (3, identical test names), git-remote (2) — **fail identically on both engines** (parity). Failing on C-XS but passing on Rust: **none**.

**Expected-divergence ledger reproduction:** content-store-gc **9** reproduced identically (parity); error-trace worker-assertions became a **hang** on Rust (the one divergence); git-backend `Could not parse git version` did *not* reproduce (git installed here) — instead 5 git-op failures identical on both engines; `endo.test.js` (3, sandbox) excluded; shell `/tmp-noexec` (1) not reproduced (`TMPDIR` exec-capable). No mass class excluded as an artifact — the serial run avoids the concurrent `endo.sock not ready` artifact by construction.

**Bottom line: NEAR.** The Rust engine reaches full parity with C-XS on **51 of 52 runnable daemon files** — zero new failures, all expected-divergence classes identical. The finish line is **not met**, blocked by exactly one thing: the live worker-**evaluate** round-trip hangs on endor-vm. **Top blocker (1 file / 6 tests):** boot the ~1 MB `bus-worker-xs-ses-boot.js` SES bundle in the endor-vm compartment and give the guest a persistent realm + host-reply channel so `deliver` can return an evaluate result over a sustained CapTP session. Honest caveat: the worker-eval surface is thinly exercised under `test:rust` (channel-relay/invite-retention/ws-relay are node-worker-skipped; endo.test.js un-runnable), so error-trace is the one runnable representative of that path — closing this blocker is necessary, and confirming eval parity beyond it needs a detached-daemon environment for endo.test.js.

**Artifacts/follow-ups:** checkpoints pushed to `journal2` — `entries/2026/07/18/123500Z-s9fl-checkpoint-0.md` and `…124300Z-s9fl-checkpoint-1-final.md`; raw logs in `~/tmp/s9fl-results/` (`sweep-results.tsv`, `sweep-cxs-results.tsv`, per-file logs). Follow-up for the fixer track: the single named blocker above (SES-bundle boot + persistent guest/host-reply channel) is the entire remaining distance to the finish line.
