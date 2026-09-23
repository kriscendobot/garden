# Stage-9c child 9/9 — `test:rust` finish-line measurement, checkpoint 1 (final)

Job `xs2rust-endor-stage9c-finish-line-measure`. Measurement-only; no engine/test/corpus
edits made or pushed. Tip measured: **`e07903ebee36021f51abf5e35fbc7051f62c16a1`**
(child 8, endor-vm worker surface). Release daemon bin built fresh at this tip (EXIT=0).

## How measured (honest, apples-to-apples)
Because the deployed worktree path overflows the AF_UNIX `sun_path` 90-char cap, the suite
was run from a **real short path** (`~/tmp/s9r`, daemon dirname 41 chars), hardlinked from
the same-commit worker-surface sibling (complete pnpm node_modules, relative symlinks), with
the freshly-built release `endor` dropped in. `TMPDIR=$HOME/tmp` (exec-capable). Each of the
**52** daemon test files was run **serially, one file at a time** (`--concurrency=1`,
`--timeout=25s`) to avoid the concurrent `endo.sock not ready` artifact. `endo.test.js` (the
detached-daemon harness, ~110 pending + un-runnable in the sandbox) was **excluded**, as the
anchor predicts. The SAME sweep was then run on **C-XS** for a same-harness baseline.

**Engine selection (important correction):** the worker child selects its engine only from the
`-e` flag; `ENDO_ENGINE` is read only for in-process "shared" workers, which the daemon tests
never use. So the Rust engine is exercised via **`ENDO_WORKER_BIN='…/endor worker -e rust'`**
(the daemon forwards the split args). Verified effective: error-trace's eval **completes** on
`endor worker` and **hangs** on `endor worker -e rust`.

## Three-number summary (52 files, bounded serial, endo.test.js excluded)
| engine | passed | failed | skipped | pending | files timed out |
| --- | --- | --- | --- | --- | --- |
| **Rust** (`-e rust`) | **531** | **14** | **20** | **6** | **1** (error-trace) |
| C-XS (baseline, same harness) | 530 | 19 | 20 | 0 | 0 |

Logs: `~/tmp/s9fl-results/sweep-results.tsv` (Rust), `sweep-cxs-results.tsv` (C-XS), per-file
`f-*.log` / `cxs-f-*.log`. Skips (20, both engines): channel-relay 4, invite-retention 10,
ws-relay 5, iroh-network 1 — the node-worker-skipped direct-eval files + one iroh skip.

## Per-file divergence — the ENTIRE diff across 52 files
| file | Rust | C-XS | verdict |
| --- | --- | --- | --- |
| content-store-gc.test.js | 6 fail | 6 fail | **parity** (identical `TypeError: cannot configure property`, daemon-side) |
| content-store-gc-invariants.test.js | 3 fail | 3 fail | **parity** (same class) |
| git.test.js | 3 fail | 3 fail | **parity** (identical failing test names — cherryPick/status/reword) |
| git-remote.test.js | 2 fail | 2 fail | **parity** (identical — provideGitClone) |
| **error-trace.test.js** | **0 fail, 6 pending (HANG)** | 5 fail (completes) | **DIVERGES — the sole Rust regression** |

Everything else (47 files) is byte-identical pass/skip on both engines. **Failing on C-XS but
passing on Rust: none.**

## The one divergence, explained
`error-trace.test.js` exercises a live worker **evaluate** and expects a structured rejection
back over a sustained CapTP session. On C-XS the guest eval completes (the thrown
`boom-from-eval` returns; the test then fails only the trace-report assertion — the expected
"error-trace worker-assertions 5" class). On **Rust the eval never returns — the worker hangs**
and all 6 tests go pending. Root cause is exactly child 8's documented remainder:
1. the ~1 MB `bus-worker-xs-ses-boot.js` SES bundle does not boot in endor-vm, so `deliver`
   cannot dispatch to a real `handleCommand`; and
2. there is no persistent guest realm / JS→Rust host-reply channel, so a `deliver` is a
   stateless guest evaluation, not a turn of a long-lived CapTP session.

## Expected-divergence ledger — what reproduced (in this bounded serial env)
- **content-store-gc 9** → reproduced **identically** (3+6) on both engines. PARITY.
- **error-trace worker-assertions 5** → on C-XS 5 fails; on Rust the 6 tests **HANG**. This is
  the one class that diverges — the finish-line blocker.
- **git-backend 8 (`Could not parse git version from ""`)** → did **not** reproduce (git IS
  installed here); instead 5 different git-operation failures, **identical on both engines** →
  environment differs from the anchor, but Rust matches C-XS. PARITY.
- **endo.test.js 3 (sandbox)** → excluded (un-runnable detached harness).
- **shell /tmp-noexec 1** → did **not** reproduce (`TMPDIR` exec-capable); shell 7 pass both.
No mass-identical class was excluded as an artifact; the serial run avoided the concurrent
`endo.sock not ready` artifact by construction.

## Bottom line: NEAR
The Rust engine reaches **full parity with C-XS on 51 of 52 runnable daemon test files** —
zero new failures, and every expected-divergence class reproduces identically. The finish line
("all `test:rust` daemon tests passing on the Rust engine, modulo the ledger") is **NOT met**,
but it is a **single, precisely-named blocker** away: the live worker-**evaluate** round-trip
hangs on endor-vm. **Top blocker (count: 1 file / 6 tests):** boot the SES worker bundle
(`bus-worker-xs-ses-boot.js`) in the endor-vm compartment and give the guest a persistent realm
+ host-reply channel so `deliver` can return an evaluate result over a sustained CapTP session.

**Honest caveat:** the worker-eval surface is thinly exercised under `test:rust` — the other
direct-eval files (channel-relay/invite-retention/ws-relay) are node-worker-skipped and
`endo.test.js` is un-runnable — so `error-trace` is the one runnable representative of that
path, and it hangs. Closing that blocker is necessary; the un-runnable `endo.test.js` eval
tests would need a detached-daemon environment to confirm parity beyond it.
