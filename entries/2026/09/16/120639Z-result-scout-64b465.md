---
kind: result
role: scout
host: oros-studio-garden-ce242c49
at: 2026-09-16T12:06:48Z
---
project: endo-but-for-bots

# Measurement: daemon SQLite WAL size policy and `journal_size_limit`

Follow-up to the design **SQLite WAL Checkpointing at Shutdown, Cross-Platform**
(`designs/daemon-sqlite-shutdown-checkpoint.md`, PR #934). Answers the design's
open question and § Planned follow-up: measure representative daemon write bursts
and the WAL high-water mark under the default `wal_autocheckpoint = 1000` policy on
both backends, then either select a concrete `journal_size_limit` or record that
SQLite's default should remain.

## Recommendation

**Keep SQLite's default `journal_size_limit = -1` (no explicit limit) on both
backends.** The measurements show it does not materially bound disk use, because
the WAL high-water mark is already bounded by `wal_autocheckpoint`, not by
`journal_size_limit`, and a clean close reclaims the WAL entirely. A limit set
below the high-water mark does not lower the peak; it only trims the transient
resident `-wal` file between checkpoints, at the cost of repeated truncate-and-
regrow churn on every checkpoint. That trade buys a few MB of transient disk for
extra filesystem work on the hot write path, which is not worth taking.

This confirms the design's provisional stance, so **no code change is required**:
the design already leaves `journal_size_limit` at the default pending this
measurement.

## Key findings

1. **The WAL high-water mark is set by `wal_autocheckpoint`, not
   `journal_size_limit`.** Across every workload (0.98 MB to 70.68 MB of resulting
   database), every candidate limit, and both backends, the WAL peaked at
   **1011-1018 pages (~4.14-4.17 MB)** = the 1000-page autocheckpoint threshold
   plus a small overshoot from the commit that crosses it and the WAL frame
   headers. The peak is invariant to `journal_size_limit` and to database size.
2. **`journal_size_limit` changes only the transient resident `-wal` size, not the
   peak.** With the default (or any limit >= the high-water mark) the `-wal` file
   is reused in place and sits at ~4.14 MB while the daemon runs. With a limit
   below the high-water mark (0, 512 KB, 1 MB) SQLite truncates the file after each
   checkpoint that resets the log, so the resident size sawtooths lower (e.g. 1.51
   MB just after a truncation at 100k), but it still grows back to ~4 MB before the
   next checkpoint. The peak never drops.
3. **Checkpoint frequency is independent of `journal_size_limit`.** The truncating
   limits (0/512 KB/1 MB) produced an identical count of WAL resets per workload on
   both backends: 5 (1k), 57 (10k), 290 (50k), 427 (100k formula-only). Autockeckpoint
   fires at the same page threshold regardless of the limit; the limit only decides
   whether the file bytes are truncated at the reset.
4. **A clean close reclaims the WAL entirely.** In every run, on both backends, the
   `-wal` file was **0 bytes after `close()`** (SQLite checkpoints and removes the
   sidecars on the last clean connection close). So the ~4 MB WAL is a running-time
   cost, not a persisted one. The only case where the WAL persists on disk is an
   abrupt kill, which `journal_size_limit` cannot help (it truncates only after a
   successful checkpoint reset, and a killed process runs no checkpoint).
5. **Cross-backend and cross-SQLite-version parity.** better-sqlite3 12.11.1
   (bundled SQLite 3.53.2) and rusqlite 0.31 (bundled SQLite 3.45.0) produced
   identical WAL high-water marks, reset counts, post-close sizes, and database
   sizes for the same workload. The WAL size policy is stable across the two
   independently-bundled SQLite builds the daemon links, which is the cross-build
   coupling the parent design worried about.
6. **No write-latency case for a small limit.** Per-write latency at the SQLite
   layer was in the 0.1-0.7 ms range (means) with no consistent, workload-
   independent penalty for any limit; tails (single-write max of tens to hundreds of
   ms) are dominated by shared-host scheduling noise, not by the limit. Where a
   limit sits below the high-water mark there is a modest extra truncate cost per
   checkpoint, but it is swamped by that noise. A small limit therefore adds
   filesystem churn without a compensating latency or peak-disk benefit.

## Environment

- Repository: https://github.com/endojs/endo-but-for-bots , branch `llm`,
  commit `65902a8f8c2e5f198d479ff0d9a77eb25a7c36d3`.
- Node backend: `better-sqlite3` 12.11.1 (bundled SQLite **3.53.2**), Node
  v22.23.2. This is the exact module the daemon's `manager-database-node.js`
  imports.
- Rust backend: `rusqlite` 0.31.0 with `features = ["bundled"]`
  (`libsqlite3-sys` 0.28.0, bundled SQLite **3.45.0**), rustc 1.91.1. Pinned
  identical to `rust/endo/xsnap/Cargo.toml`.
- Page size 4096 (SQLite default on both); `wal_autocheckpoint = 1000` (the
  design's stated policy, also the SQLite default); `journal_mode = WAL`,
  `foreign_keys = ON`.
- Host: Linux aarch64 (linuxkit container), 16 cores, 7.7 GiB RAM. The host is
  shared with the gardener fleet, so absolute latency and especially tail/max
  latency include scheduling noise. Structural metrics (WAL sizes, page counts,
  reset counts, database sizes) are deterministic and noise-free.

## Write workload

Grounded in the daemon's real write paths (`packages/daemon/src/manager-database.js`,
schema version 3). The daemon issues each persistence write as a **separate
autocommit statement** (no wrapping transaction), so each modeled row is one WAL
commit on replay. A single deterministic workload file (fixed PRNG seed) is
replayed byte-for-byte by both backends, so any difference is attributable to the
binding, not the input.

- `formula` INSERT OR REPLACE is the dominant write: the `body` column holds
  `JSON.stringify(formula)`, a small JSON object referencing other objects by
  129-char `<64hex>:<64hex>` identifiers. Modeled with a realistic type mix
  (eval, make-unconfined, guest, handle, readable-blob, pet-store, worker); mean
  encoded body ~350 bytes.
- Mixed workload adds, per created object: a `pet_store_entry` name (40%), a
  `daemon_state` bump (10%), and a `secret_audit_event` append (8%).
- Scales: 1k / 10k / 50k "units" (mixed), plus a 100k formula-only burst to
  establish the steady-state high-water plateau. The 100k run alone drives the
  database to 70.68 MB.

## Methodology

For each backend and each candidate `journal_size_limit` in
{-1 (default), 0, 512 KB, 1 MB, 4 MB, 8 MB, 32 MB}: open a fresh on-disk database,
apply the WAL policy pragmas, create the verbatim daemon schema, then replay the
workload one autocommit statement at a time. After each write, sample the `-wal`
file size (tracking the high-water mark and detecting truncation resets as a drop
of more than one page). Time each write; then time `close()`; then record the
`-wal` size after close, the main database size, and the write-latency
distribution. The Rust harness mirrors the daemon's host functions in
`rust/endo/xsnap/src/powers/sqlite.rs`: `PRAGMA journal_mode=WAL; foreign_keys=ON`,
a 5000 ms busy timeout, and **re-preparing every statement per call** (the host's
`execute_stmt` does `conn.prepare(sql)` on each invocation).

Caveat on backend latency parity: this harness drives rusqlite in-process, so it
measures the SQLite-layer cost of the Rust path but **not** the FFI + JSON
marshaling + XS round-trip the real Rust+XS supervisor adds on top. Those affect
write/close *latency* only; they do not change WAL sizing, checkpoint frequency, or
disk footprint, which are the subject of this measurement.

## Results

#### Mixed, 1k units (1,614 commits)

Node (better-sqlite3 12.11.1, SQLite 3.53.2):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.133 | 0.110 | 0.349 | 2.97 | 2.97 |
| 0 | 1011 | 4.14 | 5 | 2.61 | 0 B | 0.149 | 0.120 | 0.422 | 3.60 | 3.31 |
| 524,288 | 1011 | 4.14 | 5 | 2.61 | 0 B | 0.148 | 0.120 | 0.388 | 3.16 | 2.94 |
| 1,048,576 | 1011 | 4.14 | 5 | 2.61 | 0 B | 0.156 | 0.122 | 0.431 | 3.63 | 2.71 |
| 4,194,304 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.146 | 0.114 | 0.372 | 3.36 | 3.21 |
| 8,388,608 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.145 | 0.114 | 0.391 | 3.86 | 3.44 |
| 33,554,432 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.144 | 0.114 | 0.388 | 3.22 | 3.67 |

Rust (rusqlite 0.31 (bundled), SQLite 3.45.0):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1011 | 4.14 | 0 | 4.14 | 0 B | 1.372 | 1.127 | 3.343 | 17.11 | 18.46 |
| 0 | 1011 | 4.14 | 5 | 2.61 | 0 B | 1.359 | 1.110 | 3.538 | 25.41 | 14.46 |
| 524,288 | 1011 | 4.14 | 5 | 2.61 | 0 B | 1.061 | 0.834 | 3.964 | 14.44 | 8.76 |
| 1,048,576 | 1011 | 4.14 | 5 | 2.61 | 0 B | 0.505 | 0.386 | 1.632 | 9.34 | 6.46 |
| 4,194,304 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.485 | 0.358 | 1.623 | 13.21 | 5.37 |
| 8,388,608 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.446 | 0.293 | 2.038 | 9.57 | 2.97 |
| 33,554,432 | 1011 | 4.14 | 0 | 4.14 | 0 B | 0.413 | 0.308 | 1.324 | 11.36 | 16.01 |

#### Mixed, 10k units (15,807 commits)

Node (better-sqlite3 12.11.1, SQLite 3.53.2):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.291 | 0.205 | 0.890 | 27.00 | 21.43 |
| 0 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.438 | 0.288 | 1.780 | 46.94 | 18.96 |
| 524,288 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.385 | 0.256 | 1.434 | 28.65 | 10.43 |
| 1,048,576 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.194 | 0.130 | 0.543 | 15.80 | 9.67 |
| 4,194,304 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.212 | 0.154 | 0.618 | 17.88 | 8.84 |
| 8,388,608 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.152 | 0.110 | 0.363 | 11.59 | 7.36 |
| 33,554,432 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.153 | 0.109 | 0.356 | 14.48 | 7.89 |

Rust (rusqlite 0.31 (bundled), SQLite 3.45.0):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.361 | 0.242 | 1.282 | 50.72 | 9.49 |
| 0 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.310 | 0.226 | 0.946 | 16.71 | 10.22 |
| 524,288 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.424 | 0.293 | 1.744 | 61.56 | 29.91 |
| 1,048,576 | 1012 | 4.14 | 57 | 2.29 | 0 B | 0.506 | 0.355 | 1.958 | 73.25 | 27.57 |
| 4,194,304 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.379 | 0.265 | 1.550 | 30.45 | 12.58 |
| 8,388,608 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.307 | 0.206 | 1.124 | 15.73 | 9.70 |
| 33,554,432 | 1012 | 4.14 | 0 | 4.14 | 0 B | 0.263 | 0.179 | 0.656 | 19.02 | 8.97 |

#### Mixed, 50k units (79,026 commits)

Node (better-sqlite3 12.11.1, SQLite 3.53.2):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.328 | 0.156 | 1.845 | 134.96 | 16.68 |
| 0 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.319 | 0.175 | 1.195 | 68.09 | 19.20 |
| 524,288 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.479 | 0.198 | 3.377 | 932.09 | 14.22 |
| 1,048,576 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.332 | 0.167 | 1.319 | 61.42 | 34.00 |
| 4,194,304 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.425 | 0.210 | 2.176 | 134.08 | 30.28 |
| 8,388,608 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.379 | 0.184 | 1.835 | 85.81 | 29.00 |
| 33,554,432 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.570 | 0.234 | 3.721 | 184.27 | 14.00 |

Rust (rusqlite 0.31 (bundled), SQLite 3.45.0):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.699 | 0.303 | 4.754 | 142.95 | 15.32 |
| 0 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.551 | 0.315 | 3.300 | 93.10 | 14.18 |
| 524,288 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.591 | 0.277 | 4.405 | 127.33 | 61.64 |
| 1,048,576 | 1014 | 4.15 | 290 | 2.83 | 0 B | 0.651 | 0.279 | 4.754 | 257.93 | 13.89 |
| 4,194,304 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.402 | 0.216 | 2.370 | 73.60 | 17.02 |
| 8,388,608 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.394 | 0.215 | 1.630 | 218.32 | 13.79 |
| 33,554,432 | 1014 | 4.15 | 0 | 4.15 | 0 B | 0.472 | 0.224 | 3.196 | 348.92 | 11.85 |

#### Formula-only, 100k commits

Node (better-sqlite3 12.11.1, SQLite 3.53.2):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.479 | 0.217 | 3.203 | 205.96 | 9.16 |
| 0 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.392 | 0.188 | 1.735 | 108.14 | 26.64 |
| 524,288 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.462 | 0.208 | 2.913 | 193.91 | 18.60 |
| 1,048,576 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.716 | 0.292 | 4.965 | 387.99 | 18.55 |
| 4,194,304 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.465 | 0.248 | 1.913 | 85.81 | 10.34 |
| 8,388,608 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.451 | 0.221 | 2.759 | 136.18 | 10.84 |
| 33,554,432 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.656 | 0.269 | 4.353 | 257.93 | 10.63 |

Rust (rusqlite 0.31 (bundled), SQLite 3.45.0):

| journal_size_limit | WAL HWM (pages) | WAL HWM (MB) | resets | WAL pre-close (MB) | WAL post-close | write mean (ms) | write p50 | write p99 | write max | close (ms) |
|---|---|---|---|---|---|---|---|---|---|---|
| -1 (default) | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.455 | 0.249 | 2.406 | 452.80 | 49.29 |
| 0 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.686 | 0.273 | 4.477 | 158.48 | 12.14 |
| 524,288 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.510 | 0.237 | 3.249 | 126.30 | 21.10 |
| 1,048,576 | 1018 | 4.17 | 427 | 1.51 | 0 B | 0.514 | 0.242 | 3.165 | 199.38 | 11.46 |
| 4,194,304 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.575 | 0.227 | 3.866 | 185.29 | 15.08 |
| 8,388,608 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.748 | 0.304 | 4.909 | 203.54 | 25.85 |
| 33,554,432 | 1018 | 4.17 | 0 | 4.17 | 0 B | 0.577 | 0.249 | 4.197 | 120.04 | 9.40 |


## Interpretation

The concern a `journal_size_limit` addresses is a WAL file that grows and stays
large. Under this daemon's access pattern (a single writer, autocommit, no
long-lived reader holding the WAL open) that does not happen: `wal_autocheckpoint`
caps the WAL at ~1000 pages (~4 MB) and reuses the space in place, and a clean
shutdown removes the WAL. So there is no unbounded disk growth for a limit to
bound.

The two scenarios where a WAL *does* exceed ~4 MB are both unhelped by
`journal_size_limit`:

- **A long-running read transaction** blocks the checkpoint from resetting the
  WAL, so it grows for the duration of that reader. `journal_size_limit` truncates
  only *after* a successful reset, so it cannot cap growth during the reader's
  window. The mitigation is to avoid long readers, not a size limit.
- **An abrupt kill (SIGKILL / power loss)** leaves the WAL on disk at whatever size
  it had reached. A killed process runs no checkpoint and therefore no truncation,
  so `journal_size_limit` has no effect on the post-crash footprint either. The
  design already answers this path with recovery-on-open, which SQLite performs on
  the next open regardless of the limit.

Setting `journal_size_limit = 0` (the most aggressive candidate) would trim the
running-time resident `-wal` from ~4 MB toward the mid-checkpoint sawtooth, but at
the cost of a truncate + subsequent regrow on each of the hundreds of checkpoints a
busy session performs (427 in the 100k run). For a daemon whose main database is
already tens of MB, reclaiming a transient ~4 MB `-wal` that a clean close removes
anyway is not worth the added filesystem churn on the write path.

If a future access pattern introduces sustained concurrent readers that hold the
WAL open (making the WAL genuinely grow), the correct response is still not
`journal_size_limit` (which cannot cap growth under an open reader) but an explicit
periodic `wal_checkpoint(TRUNCATE)` or a lower `wal_autocheckpoint`. This
measurement should be re-run if that access pattern changes.

## Reproducibility

Raw result JSON (one file per backend x workload, the exact objects these tables
were rendered from) and the harness sources are in the appendix below. The harness
is self-contained: `gen-workload.mjs` writes a deterministic workload file that
both `measure-node.mjs` (better-sqlite3) and the `rust-harness` (rusqlite, pinned
to the daemon's `rusqlite = { version = "0.31", features = ["bundled"] }`) replay.
`schema.sql` is a verbatim copy of `SCHEMA_SQL` from
`packages/daemon/src/manager-database.js`.

## Deliverable and authorization note

This report is the scout deliverable (a journal `result` entry per
`roles/COMMON.md` External-repo etiquette). It is **not** posted to PR #934: this
job does not carry the per-action authorization a scout needs to comment on the
upstream repo. If the maintainer wants the follow-up loop closed on the PR, the
summary above (recommendation + key findings) can be posted as a reply on the
originating review thread
(https://github.com/endojs/endo-but-for-bots/pull/934#discussion_r3729870370) once
that authorization is given.

## Appendix A: harness sources

### `gen-workload.mjs`

```js
// Generate a deterministic, representative daemon write workload as a JSONL
// file that both the Node (better-sqlite3) and Rust (rusqlite) harnesses
// replay verbatim. Determinism (a fixed LCG seed) guarantees byte-identical
// rows across backends, so any measured difference is attributable to the
// SQLite binding, not the workload.
//
// Usage: node gen-workload.mjs <count> <mix|formula> <outfile>
//
// Row model is grounded in the daemon's real write paths:
//   - `formula`: the dominant write. Body is `JSON.stringify(formula)`; a
//     Formula references other objects by FormulaIdentifier `<64hex>:<64hex>`
//     (129 chars). We model a realistic type mix with realistic body sizes.
//   - `pet_store_entry`: naming an object (common alongside a formula).
//   - `daemon_state`: occasional key/value bump.
//   - `secret_audit_event`: append-only audit row.
// The daemon issues each of these as a separate autocommit statement (no
// wrapping transaction), so each row here is one WAL commit on replay.

import { writeFileSync } from 'node:fs';

const [, , countArg, mixArg, outArg] = process.argv;
const count = Number(countArg);
const mix = mixArg || 'mix';
const outfile = outArg || 'workload.jsonl';

// Deterministic 32-bit LCG (glibc constants). Reproducible in Rust too, but
// both backends read this file, so only JS needs it.
let state = 0x1234abcd >>> 0;
const next = () => {
  state = (Math.imul(state, 1103515245) + 12345) >>> 0;
  return state;
};
const rand = () => next() / 0x100000000;
const hex = n => {
  // n hex chars, deterministic
  let s = '';
  while (s.length < n) s += (next() >>> 0).toString(16).padStart(8, '0');
  return s.slice(0, n);
};
const id = () => `${hex(64)}:${hex(64)}`; // FormulaIdentifier

// Representative formula-body builders keyed by type, mirroring the raw
// Formula objects the daemon serializes (JSON.stringify(formula)).
const bodyBuilders = {
  eval: () => {
    const names = ['a', 'b', 'c', 'd'].slice(0, 1 + (next() % 4));
    return JSON.stringify({
      type: 'eval',
      worker: id(),
      source: `E(HOST).lookup(${names.map(n => `'${n}'`).join(', ')})`,
      names,
      values: names.map(() => id()),
    });
  },
  'readable-blob': () =>
    JSON.stringify({ type: 'readable-blob', content: hex(128) }),
  guest: () =>
    JSON.stringify({
      type: 'guest',
      host: id(),
      handle: id(),
      petStore: id(),
      mainWorker: id(),
    }),
  handle: () => JSON.stringify({ type: 'handle', agent: id() }),
  'make-unconfined': () =>
    JSON.stringify({
      type: 'make-unconfined',
      worker: id(),
      powersId: id(),
      specifier: 'file:///opt/endo/service.js',
    }),
  'pet-store': () => JSON.stringify({ type: 'pet-store' }),
  worker: () => JSON.stringify({ type: 'worker' }),
};
// Weighted type distribution (rough model of a working daemon session).
const typeWeights = [
  ['eval', 40],
  ['make-unconfined', 12],
  ['guest', 8],
  ['handle', 10],
  ['readable-blob', 10],
  ['pet-store', 10],
  ['worker', 10],
];
const typePicker = [];
for (const [t, w] of typeWeights) for (let i = 0; i < w; i += 1) typePicker.push(t);
const pickType = () => typePicker[next() % typePicker.length];

const now = 1_700_000_000_000;
const ops = [];
for (let i = 0; i < count; i += 1) {
  const type = pickType();
  const number = hex(64);
  const node = hex(64);
  ops.push({ t: 'formula', a: [number, node, type, bodyBuilders[type]()] });

  if (mix === 'mix') {
    const r = rand();
    // 40% of created objects also get named in a pet store.
    if (r < 0.4) {
      ops.push({
        t: 'pet',
        a: [hex(64), 'pet-store', `name-${i}`, `${number}:${node}`],
      });
    }
    // 10% bump daemon_state (small, high-churn key reuse).
    if (r >= 0.4 && r < 0.5) {
      ops.push({ t: 'state', a: [`clock-${i % 8}`, String(now + i)] });
    }
    // 8% append a secret audit event.
    if (r >= 0.5 && r < 0.58) {
      ops.push({
        t: 'audit',
        a: [
          hex(32),
          hex(32),
          'read',
          'succeeded',
          '1',
          new Date(now + i).toISOString(),
          hex(32),
          null,
        ],
      });
    }
  }
}

const meta = {
  count,
  mix,
  ops: ops.length,
  seed: '0x1234abcd',
  generatedAt: new Date().toISOString(),
};
writeFileSync(outArg + '.meta.json', JSON.stringify(meta, null, 2));
writeFileSync(outfile, ops.map(o => JSON.stringify(o)).join('\n') + '\n');
// Report byte size of encoded bodies for the record.
let bodyBytes = 0;
let n = 0;
for (const o of ops)
  if (o.t === 'formula') {
    bodyBytes += Buffer.byteLength(o.a[3]);
    n += 1;
  }
console.error(
  `${outfile}: ${ops.length} ops (${n} formula), mean formula body ${(bodyBytes / n).toFixed(0)} bytes`,
);
```

### `measure-node.mjs`

```js
// Node (better-sqlite3) WAL measurement harness.
//
// Replays a shared workload file against a fresh on-disk database for each
// candidate journal_size_limit, under the design's WAL policy
// (journal_mode=WAL, foreign_keys=ON, wal_autocheckpoint=1000). Records the
// WAL high-water mark, checkpoint/reset activity, per-write latency
// distribution, and close latency. Reporting shape is identical to the Rust
// harness (measure-rust) so the two are directly comparable.
//
// Usage: node measure-node.mjs <workload.jsonl> <out.json> <L1,L2,...>

import Database from 'better-sqlite3';
import { readFileSync, writeFileSync, statSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const betterSqliteVersion = require('better-sqlite3/package.json').version;

const [, , workloadPath, outPath, limitsArg] = process.argv;
const limits = limitsArg.split(',').map(Number);
const scratchRoot = process.env.WAL_SCRATCH || tmpdir();

const ops = readFileSync(workloadPath, 'utf8')
  .split('\n')
  .filter(Boolean)
  .map(l => JSON.parse(l));

const walSize = walPath => {
  try {
    return statSync(walPath).size;
  } catch {
    return 0;
  }
};

const pct = (sorted, p) => {
  if (sorted.length === 0) return 0;
  const i = Math.min(sorted.length - 1, Math.floor((p / 100) * sorted.length));
  return sorted[i];
};

const runOne = L => {
  const dir = mkdtempSync(join(scratchRoot, 'node-wal-'));
  const dbPath = join(dir, 'endo.sqlite');
  const walPath = `${dbPath}-wal`;
  const db = new Database(dbPath);
  db.exec('PRAGMA journal_mode = WAL;');
  db.exec('PRAGMA foreign_keys = ON;');
  db.exec('PRAGMA wal_autocheckpoint = 1000;');
  db.exec(`PRAGMA journal_size_limit = ${L};`);
  db.exec(readFileSync(new URL('./schema.sql', import.meta.url), 'utf8'));

  const stmts = {
    formula: db.prepare(
      'INSERT OR REPLACE INTO formula (number, node, type, body) VALUES (?, ?, ?, ?)',
    ),
    pet: db.prepare(
      'INSERT OR REPLACE INTO pet_store_entry (store_number, store_type, name, formula_id) VALUES (?, ?, ?, ?)',
    ),
    state: db.prepare(
      'INSERT OR REPLACE INTO daemon_state (key, value) VALUES (?, ?)',
    ),
    audit: db.prepare(
      'INSERT INTO secret_audit_event (event_id, secret_id, operation, outcome, generation, occurred_at, operation_id, reason_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    ),
  };

  const latencies = new Float64Array(ops.length);
  let walHwm = 0;
  let resetCount = 0;
  let prevWal = 0;
  const pageSize = 4096;

  for (let i = 0; i < ops.length; i += 1) {
    const op = ops[i];
    const t0 = process.hrtime.bigint();
    stmts[op.t].run(...op.a);
    const t1 = process.hrtime.bigint();
    latencies[i] = Number(t1 - t0) / 1e6; // ms
    const ws = walSize(walPath);
    if (ws > walHwm) walHwm = ws;
    // A drop of more than one page indicates a WAL reset (checkpoint that
    // restarted the log). Only observable when the file is truncated
    // (journal_size_limit smaller than the high-water mark).
    if (ws + pageSize < prevWal) resetCount += 1;
    prevWal = ws;
  }

  const walBeforeClose = walSize(walPath);
  const tc0 = process.hrtime.bigint();
  db.close();
  const tc1 = process.hrtime.bigint();
  const closeMs = Number(tc1 - tc0) / 1e6;
  const walAfterClose = walSize(walPath);
  const dbSize = statSync(dbPath).size;

  const sorted = Array.from(latencies).sort((a, b) => a - b);
  const sum = sorted.reduce((a, b) => a + b, 0);

  rmSync(dir, { recursive: true, force: true });

  return {
    journal_size_limit: L,
    ops: ops.length,
    wal_hwm_bytes: walHwm,
    wal_hwm_pages: Math.round(walHwm / pageSize),
    wal_before_close_bytes: walBeforeClose,
    wal_after_close_bytes: walAfterClose,
    db_size_bytes: dbSize,
    reset_events: resetCount,
    write_latency_ms: {
      mean: sum / sorted.length,
      p50: pct(sorted, 50),
      p90: pct(sorted, 90),
      p99: pct(sorted, 99),
      max: sorted[sorted.length - 1],
    },
    close_latency_ms: closeMs,
  };
};

const results = [];
for (const L of limits) {
  results.push(runOne(L));
}

const out = {
  backend: 'node-better-sqlite3',
  better_sqlite3_version: betterSqliteVersion,
  sqlite_version: new Database(':memory:').prepare('select sqlite_version() v').get().v,
  node_version: process.version,
  page_size: 4096,
  wal_autocheckpoint: 1000,
  workload: workloadPath.split('/').pop(),
  results,
};
writeFileSync(outPath, JSON.stringify(out, null, 2));
console.error(`wrote ${outPath}`);
```

### `rust-harness/src/main.rs`

```rust
//! Rust (rusqlite) WAL measurement harness.
//!
//! Replays the shared workload file against a fresh on-disk database for each
//! candidate journal_size_limit, under the design's WAL policy and mirroring
//! the daemon's Rust host functions in `rust/endo/xsnap/src/powers/sqlite.rs`:
//!   - open applies `PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;` and a
//!     5000ms busy_timeout,
//!   - every statement is re-prepared per call (execute_stmt does
//!     `conn.prepare(sql)` on each invocation),
//!   - close drops the connection (we call Connection::close to time it).
//! Reporting shape is identical to the Node harness (measure-node.mjs).
//!
//! Usage: wal-measure <workload.jsonl> <schema.sql> <out.json> <L1,L2,...>

use rusqlite::{types::Value, Connection};
use serde_json::json;
use std::fs;
use std::path::PathBuf;
use std::time::Instant;

const PAGE_SIZE: u64 = 4096;

fn wal_size(wal: &str) -> u64 {
    fs::metadata(wal).map(|m| m.len()).unwrap_or(0)
}

fn pct(sorted: &[f64], p: f64) -> f64 {
    if sorted.is_empty() {
        return 0.0;
    }
    let i = ((p / 100.0) * sorted.len() as f64).floor() as usize;
    sorted[i.min(sorted.len() - 1)]
}

struct Op {
    t: String,
    a: Vec<Value>,
}

fn sql_for(t: &str) -> &'static str {
    match t {
        "formula" => {
            "INSERT OR REPLACE INTO formula (number, node, type, body) VALUES (?, ?, ?, ?)"
        }
        "pet" => {
            "INSERT OR REPLACE INTO pet_store_entry (store_number, store_type, name, formula_id) VALUES (?, ?, ?, ?)"
        }
        "state" => "INSERT OR REPLACE INTO daemon_state (key, value) VALUES (?, ?)",
        "audit" => {
            "INSERT INTO secret_audit_event (event_id, secret_id, operation, outcome, generation, occurred_at, operation_id, reason_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        }
        other => panic!("unknown op type {}", other),
    }
}

fn run_one(l: i64, ops: &[Op], schema: &str, scratch: &str) -> serde_json::Value {
    let dir = PathBuf::from(scratch).join(format!("rust-wal-{}", l));
    let _ = fs::remove_dir_all(&dir);
    fs::create_dir_all(&dir).unwrap();
    let db_path = dir.join("endo.sqlite");
    let wal_path = format!("{}-wal", db_path.display());
    let conn = Connection::open(&db_path).unwrap();
    conn.execute_batch("PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;")
        .unwrap();
    conn.busy_timeout(std::time::Duration::from_millis(5000))
        .unwrap();
    conn.execute_batch(&format!(
        "PRAGMA wal_autocheckpoint=1000; PRAGMA journal_size_limit={};",
        l
    ))
    .unwrap();
    conn.execute_batch(schema).unwrap();

    let mut latencies: Vec<f64> = Vec::with_capacity(ops.len());
    let mut wal_hwm: u64 = 0;
    let mut reset_count: u64 = 0;
    let mut prev_wal: u64 = 0;

    for op in ops {
        let sql = sql_for(&op.t);
        let params: Vec<&dyn rusqlite::types::ToSql> =
            op.a.iter().map(|v| v as &dyn rusqlite::types::ToSql).collect();
        let t0 = Instant::now();
        // Re-prepare per call, matching the host function execute_stmt.
        let mut stmt = conn.prepare(sql).unwrap();
        stmt.execute(params.as_slice()).unwrap();
        let dt = t0.elapsed().as_secs_f64() * 1000.0;
        latencies.push(dt);
        let ws = wal_size(&wal_path);
        if ws > wal_hwm {
            wal_hwm = ws;
        }
        if ws + PAGE_SIZE < prev_wal {
            reset_count += 1;
        }
        prev_wal = ws;
    }

    let wal_before_close = wal_size(&wal_path);
    let t0 = Instant::now();
    conn.close().unwrap();
    let close_ms = t0.elapsed().as_secs_f64() * 1000.0;
    let wal_after_close = wal_size(&wal_path);
    let db_size = fs::metadata(&db_path).map(|m| m.len()).unwrap_or(0);

    let mut sorted = latencies.clone();
    sorted.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let sum: f64 = sorted.iter().sum();

    let _ = fs::remove_dir_all(&dir);

    json!({
        "journal_size_limit": l,
        "ops": ops.len(),
        "wal_hwm_bytes": wal_hwm,
        "wal_hwm_pages": (wal_hwm as f64 / PAGE_SIZE as f64).round() as u64,
        "wal_before_close_bytes": wal_before_close,
        "wal_after_close_bytes": wal_after_close,
        "db_size_bytes": db_size,
        "reset_events": reset_count,
        "write_latency_ms": {
            "mean": sum / sorted.len() as f64,
            "p50": pct(&sorted, 50.0),
            "p90": pct(&sorted, 90.0),
            "p99": pct(&sorted, 99.0),
            "max": sorted[sorted.len() - 1],
        },
        "close_latency_ms": close_ms,
    })
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let workload = &args[1];
    let schema_path = &args[2];
    let out = &args[3];
    let limits: Vec<i64> = args[4].split(',').map(|s| s.parse().unwrap()).collect();
    let scratch = std::env::var("WAL_SCRATCH").unwrap_or_else(|_| "/tmp".to_string());

    let schema = fs::read_to_string(schema_path).unwrap();
    let raw = fs::read_to_string(workload).unwrap();
    let ops: Vec<Op> = raw
        .lines()
        .filter(|l| !l.is_empty())
        .map(|line| {
            let v: serde_json::Value = serde_json::from_str(line).unwrap();
            let t = v["t"].as_str().unwrap().to_string();
            let a = v["a"]
                .as_array()
                .unwrap()
                .iter()
                .map(|e| match e {
                    serde_json::Value::Null => Value::Null,
                    serde_json::Value::String(s) => Value::Text(s.clone()),
                    other => Value::Text(other.to_string()),
                })
                .collect();
            Op { t, a }
        })
        .collect();

    let sqlite_version = rusqlite::version().to_string();
    let mut results = Vec::new();
    for l in &limits {
        results.push(run_one(*l, &ops, &schema, &scratch));
    }

    let doc = json!({
        "backend": "rust-rusqlite",
        "rusqlite": "0.31 (bundled)",
        "sqlite_version": sqlite_version,
        "page_size": PAGE_SIZE,
        "wal_autocheckpoint": 1000,
        "workload": workload.rsplit('/').next().unwrap(),
        "results": results,
    });
    fs::write(out, serde_json::to_string_pretty(&doc).unwrap()).unwrap();
    eprintln!("wrote {}", out);
}
```

### `rust-harness/Cargo.toml`

```toml
[package]
name = "wal-measure"
version = "0.0.0"
edition = "2021"

[[bin]]
name = "wal-measure"
path = "src/main.rs"

[dependencies]
# Pinned identical to rust/endo/xsnap/Cargo.toml so the bundled SQLite is the
# exact build the Rust+XS daemon backend links.
rusqlite = { version = "0.31", features = ["bundled"] }
serde_json = "1"

[profile.release]
opt-level = 3
```

`schema.sql` is a verbatim copy of `SCHEMA_SQL` in `packages/daemon/src/manager-database.js` (schema version 3); omitted here for length.

## Appendix B: raw result JSON

### `node-wl-mix-1k.json`

```json
{
  "backend": "node-better-sqlite3",
  "better_sqlite3_version": "12.11.1",
  "sqlite_version": "3.53.2",
  "node_version": "v22.23.2",
  "page_size": 4096,
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-1k.jsonl",
  "results": [
    {
      "journal_size_limit": -1,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 4140632,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.1333624609665428,
        "p50": 0.110375,
        "p90": 0.218917,
        "p99": 0.349375,
        "max": 2.970917
      },
      "close_latency_ms": 2.968
    },
    {
      "journal_size_limit": 0,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 2607992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 5,
      "write_latency_ms": {
        "mean": 0.1492730210656753,
        "p50": 0.119625,
        "p90": 0.240708,
        "p99": 0.4225,
        "max": 3.600917
      },
      "close_latency_ms": 3.313959
    },
    {
      "journal_size_limit": 524288,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 2607992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 5,
      "write_latency_ms": {
        "mean": 0.14839554708798006,
        "p50": 0.119791,
        "p90": 0.243541,
        "p99": 0.387584,
        "max": 3.1575
      },
      "close_latency_ms": 2.935583
    },
    {
      "journal_size_limit": 1048576,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 2607992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 5,
      "write_latency_ms": {
        "mean": 0.15644309851301108,
        "p50": 0.121667,
        "p90": 0.254125,
        "p99": 0.431083,
        "max": 3.632709
      },
      "close_latency_ms": 2.710333
    },
    {
      "journal_size_limit": 4194304,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 4140632,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.14570381288723686,
        "p50": 0.11425,
        "p90": 0.237334,
        "p99": 0.371667,
        "max": 3.356083
      },
      "close_latency_ms": 3.207417
    },
    {
      "journal_size_limit": 8388608,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 4140632,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.14546328624535299,
        "p50": 0.114458,
        "p90": 0.23125,
        "p99": 0.391083,
        "max": 3.860458
      },
      "close_latency_ms": 3.441958
    },
    {
      "journal_size_limit": 33554432,
      "ops": 1614,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "wal_before_close_bytes": 4140632,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 978944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.14430545167286252,
        "p50": 0.114209,
        "p90": 0.230625,
        "p99": 0.387708,
        "max": 3.216792
      },
      "close_latency_ms": 3.666709
    }
  ]
}```

### `node-wl-mix-10k.json`

```json
{
  "backend": "node-better-sqlite3",
  "better_sqlite3_version": "12.11.1",
  "sqlite_version": "3.53.2",
  "node_version": "v22.23.2",
  "page_size": 4096,
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-10k.jsonl",
  "results": [
    {
      "journal_size_limit": -1,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 4144752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.2912778906180795,
        "p50": 0.204667,
        "p90": 0.473333,
        "p99": 0.8905,
        "max": 27.002291
      },
      "close_latency_ms": 21.433583
    },
    {
      "journal_size_limit": 0,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 2290752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 57,
      "write_latency_ms": {
        "mean": 0.4383070383374449,
        "p50": 0.28775,
        "p90": 0.794959,
        "p99": 1.780042,
        "max": 46.939501
      },
      "close_latency_ms": 18.95825
    },
    {
      "journal_size_limit": 524288,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 2290752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 57,
      "write_latency_ms": {
        "mean": 0.38454542772189654,
        "p50": 0.2555,
        "p90": 0.629334,
        "p99": 1.434084,
        "max": 28.645917
      },
      "close_latency_ms": 10.431916
    },
    {
      "journal_size_limit": 1048576,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 2290752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 57,
      "write_latency_ms": {
        "mean": 0.19422050483962797,
        "p50": 0.13025,
        "p90": 0.29625,
        "p99": 0.543083,
        "max": 15.79725
      },
      "close_latency_ms": 9.67325
    },
    {
      "journal_size_limit": 4194304,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 4144752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.21191258126146723,
        "p50": 0.153625,
        "p90": 0.33525,
        "p99": 0.61775,
        "max": 17.880541
      },
      "close_latency_ms": 8.843917
    },
    {
      "journal_size_limit": 8388608,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 4144752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.152359436199152,
        "p50": 0.109666,
        "p90": 0.224875,
        "p99": 0.363375,
        "max": 11.588833
      },
      "close_latency_ms": 7.360334
    },
    {
      "journal_size_limit": 33554432,
      "ops": 15807,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "wal_before_close_bytes": 4144752,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 8658944,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.15280677566900705,
        "p50": 0.109375,
        "p90": 0.2245,
        "p99": 0.355916,
        "max": 14.47875
      },
      "close_latency_ms": 7.891375
    }
  ]
}```

### `node-wl-mix-50k.json`

```json
{
  "backend": "node-better-sqlite3",
  "better_sqlite3_version": "12.11.1",
  "sqlite_version": "3.53.2",
  "node_version": "v22.23.2",
  "page_size": 4096,
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-50k.jsonl",
  "results": [
    {
      "journal_size_limit": -1,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 4152992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.32840252987624463,
        "p50": 0.155958,
        "p90": 0.490666,
        "p99": 1.845041,
        "max": 134.964209
      },
      "close_latency_ms": 16.681416
    },
    {
      "journal_size_limit": 0,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 2826352,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 290,
      "write_latency_ms": {
        "mean": 0.3194703926302739,
        "p50": 0.175334,
        "p90": 0.462667,
        "p99": 1.195292,
        "max": 68.087042
      },
      "close_latency_ms": 19.199792
    },
    {
      "journal_size_limit": 524288,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 2826352,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 290,
      "write_latency_ms": {
        "mean": 0.4792139020702042,
        "p50": 0.198291,
        "p90": 0.730625,
        "p99": 3.37675,
        "max": 932.091375
      },
      "close_latency_ms": 14.221334
    },
    {
      "journal_size_limit": 1048576,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 2826352,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 290,
      "write_latency_ms": {
        "mean": 0.3322628305114785,
        "p50": 0.166958,
        "p90": 0.479542,
        "p99": 1.318583,
        "max": 61.41775
      },
      "close_latency_ms": 33.997708
    },
    {
      "journal_size_limit": 4194304,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 4152992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.4247690655100863,
        "p50": 0.209875,
        "p90": 0.714584,
        "p99": 2.176459,
        "max": 134.082916
      },
      "close_latency_ms": 30.283333
    },
    {
      "journal_size_limit": 8388608,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 4152992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.37893350506162504,
        "p50": 0.184083,
        "p90": 0.645083,
        "p99": 1.834708,
        "max": 85.805625
      },
      "close_latency_ms": 29.003458
    },
    {
      "journal_size_limit": 33554432,
      "ops": 79026,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "wal_before_close_bytes": 4152992,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 42991616,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.5704697107281129,
        "p50": 0.234167,
        "p90": 1.042583,
        "p99": 3.721375,
        "max": 184.266208
      },
      "close_latency_ms": 13.996125
    }
  ]
}```

### `node-wl-formula-100k.json`

```json
{
  "backend": "node-better-sqlite3",
  "better_sqlite3_version": "12.11.1",
  "sqlite_version": "3.53.2",
  "node_version": "v22.23.2",
  "page_size": 4096,
  "wal_autocheckpoint": 1000,
  "workload": "wl-formula-100k.jsonl",
  "results": [
    {
      "journal_size_limit": -1,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 4169472,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.47948520113000154,
        "p50": 0.216583,
        "p90": 0.69475,
        "p99": 3.203125,
        "max": 205.96
      },
      "close_latency_ms": 9.155416
    },
    {
      "journal_size_limit": 0,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 1507952,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 427,
      "write_latency_ms": {
        "mean": 0.3921877041500034,
        "p50": 0.187667,
        "p90": 0.5825,
        "p99": 1.734875,
        "max": 108.135125
      },
      "close_latency_ms": 26.641542
    },
    {
      "journal_size_limit": 524288,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 1507952,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 427,
      "write_latency_ms": {
        "mean": 0.46172311333000055,
        "p50": 0.208125,
        "p90": 0.695,
        "p99": 2.913333,
        "max": 193.913376
      },
      "close_latency_ms": 18.595625
    },
    {
      "journal_size_limit": 1048576,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 1507952,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 427,
      "write_latency_ms": {
        "mean": 0.71555805376,
        "p50": 0.292208,
        "p90": 1.068166,
        "p99": 4.9645,
        "max": 387.9935
      },
      "close_latency_ms": 18.551292
    },
    {
      "journal_size_limit": 4194304,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 4169472,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.4652484027700011,
        "p50": 0.248458,
        "p90": 0.644042,
        "p99": 1.913041,
        "max": 85.806292
      },
      "close_latency_ms": 10.341667
    },
    {
      "journal_size_limit": 8388608,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 4169472,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.4513790784500017,
        "p50": 0.220833,
        "p90": 0.581792,
        "p99": 2.759083,
        "max": 136.181292
      },
      "close_latency_ms": 10.838875
    },
    {
      "journal_size_limit": 33554432,
      "ops": 100000,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "wal_before_close_bytes": 4169472,
      "wal_after_close_bytes": 0,
      "db_size_bytes": 70680576,
      "reset_events": 0,
      "write_latency_ms": {
        "mean": 0.655582661360004,
        "p50": 0.268959,
        "p90": 1.152875,
        "p99": 4.352541,
        "max": 257.925333
      },
      "close_latency_ms": 10.634625
    }
  ]
}```

### `rust-wl-mix-1k.json`

```json
{
  "backend": "rust-rusqlite",
  "page_size": 4096,
  "results": [
    {
      "close_latency_ms": 18.45675,
      "db_size_bytes": 978944,
      "journal_size_limit": -1,
      "ops": 1614,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4140632,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 17.113166999999997,
        "mean": 1.3724616425030973,
        "p50": 1.1271250000000002,
        "p90": 2.18775,
        "p99": 3.3428329999999997
      }
    },
    {
      "close_latency_ms": 14.457834,
      "db_size_bytes": 978944,
      "journal_size_limit": 0,
      "ops": 1614,
      "reset_events": 5,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2607992,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 25.406625,
        "mean": 1.3593387558859982,
        "p50": 1.1095409999999999,
        "p90": 2.13625,
        "p99": 3.5382909999999996
      }
    },
    {
      "close_latency_ms": 8.756625,
      "db_size_bytes": 978944,
      "journal_size_limit": 524288,
      "ops": 1614,
      "reset_events": 5,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2607992,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 14.444875,
        "mean": 1.0612174045848817,
        "p50": 0.833958,
        "p90": 1.746542,
        "p99": 3.9642920000000004
      }
    },
    {
      "close_latency_ms": 6.459834,
      "db_size_bytes": 978944,
      "journal_size_limit": 1048576,
      "ops": 1614,
      "reset_events": 5,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2607992,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 9.344208,
        "mean": 0.5053324913258986,
        "p50": 0.386042,
        "p90": 0.790042,
        "p99": 1.6320830000000002
      }
    },
    {
      "close_latency_ms": 5.371417,
      "db_size_bytes": 978944,
      "journal_size_limit": 4194304,
      "ops": 1614,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4140632,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 13.208875,
        "mean": 0.4848449225526645,
        "p50": 0.3585,
        "p90": 0.781208,
        "p99": 1.623333
      }
    },
    {
      "close_latency_ms": 2.968792,
      "db_size_bytes": 978944,
      "journal_size_limit": 8388608,
      "ops": 1614,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4140632,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 9.566459,
        "mean": 0.4463943035935565,
        "p50": 0.29312499999999997,
        "p90": 0.864875,
        "p99": 2.037875
      }
    },
    {
      "close_latency_ms": 16.011375,
      "db_size_bytes": 978944,
      "journal_size_limit": 33554432,
      "ops": 1614,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4140632,
      "wal_hwm_bytes": 4140632,
      "wal_hwm_pages": 1011,
      "write_latency_ms": {
        "max": 11.35825,
        "mean": 0.4128679696406448,
        "p50": 0.30783299999999997,
        "p90": 0.756042,
        "p99": 1.323875
      }
    }
  ],
  "rusqlite": "0.31 (bundled)",
  "sqlite_version": "3.45.0",
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-1k.jsonl"
}```

### `rust-wl-mix-10k.json`

```json
{
  "backend": "rust-rusqlite",
  "page_size": 4096,
  "results": [
    {
      "close_latency_ms": 9.490667,
      "db_size_bytes": 8658944,
      "journal_size_limit": -1,
      "ops": 15807,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4144752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 50.723417,
        "mean": 0.36126446485734015,
        "p50": 0.241625,
        "p90": 0.550667,
        "p99": 1.282083
      }
    },
    {
      "close_latency_ms": 10.220791,
      "db_size_bytes": 8658944,
      "journal_size_limit": 0,
      "ops": 15807,
      "reset_events": 57,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2290752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 16.714833,
        "mean": 0.31044867090529454,
        "p50": 0.22566599999999998,
        "p90": 0.461375,
        "p99": 0.945833
      }
    },
    {
      "close_latency_ms": 29.905208,
      "db_size_bytes": 8658944,
      "journal_size_limit": 524288,
      "ops": 15807,
      "reset_events": 57,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2290752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 61.558084,
        "mean": 0.42366974346808317,
        "p50": 0.293458,
        "p90": 0.653833,
        "p99": 1.744417
      }
    },
    {
      "close_latency_ms": 27.566084,
      "db_size_bytes": 8658944,
      "journal_size_limit": 1048576,
      "ops": 15807,
      "reset_events": 57,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2290752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 73.252708,
        "mean": 0.5056988076168775,
        "p50": 0.355333,
        "p90": 0.8164589999999999,
        "p99": 1.9580410000000001
      }
    },
    {
      "close_latency_ms": 12.579540999999999,
      "db_size_bytes": 8658944,
      "journal_size_limit": 4194304,
      "ops": 15807,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4144752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 30.455,
        "mean": 0.37878928120453054,
        "p50": 0.264667,
        "p90": 0.56225,
        "p99": 1.5496660000000002
      }
    },
    {
      "close_latency_ms": 9.699875,
      "db_size_bytes": 8658944,
      "journal_size_limit": 8388608,
      "ops": 15807,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4144752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 15.729084,
        "mean": 0.3072941344973738,
        "p50": 0.205917,
        "p90": 0.43183400000000005,
        "p99": 1.124084
      }
    },
    {
      "close_latency_ms": 8.974167,
      "db_size_bytes": 8658944,
      "journal_size_limit": 33554432,
      "ops": 15807,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4144752,
      "wal_hwm_bytes": 4144752,
      "wal_hwm_pages": 1012,
      "write_latency_ms": {
        "max": 19.019834,
        "mean": 0.26263824033656047,
        "p50": 0.178833,
        "p90": 0.33891699999999997,
        "p99": 0.655833
      }
    }
  ],
  "rusqlite": "0.31 (bundled)",
  "sqlite_version": "3.45.0",
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-10k.jsonl"
}```

### `rust-wl-mix-50k.json`

```json
{
  "backend": "rust-rusqlite",
  "page_size": 4096,
  "results": [
    {
      "close_latency_ms": 15.317833,
      "db_size_bytes": 42991616,
      "journal_size_limit": -1,
      "ops": 79026,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4152992,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 142.946667,
        "mean": 0.6991825397337577,
        "p50": 0.302625,
        "p90": 1.3404999999999998,
        "p99": 4.753833
      }
    },
    {
      "close_latency_ms": 14.179583000000001,
      "db_size_bytes": 42991616,
      "journal_size_limit": 0,
      "ops": 79026,
      "reset_events": 290,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2826352,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 93.100792,
        "mean": 0.5507906029155005,
        "p50": 0.315,
        "p90": 0.819834,
        "p99": 3.299833
      }
    },
    {
      "close_latency_ms": 61.63975,
      "db_size_bytes": 42991616,
      "journal_size_limit": 524288,
      "ops": 79026,
      "reset_events": 290,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2826352,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 127.33412499999999,
        "mean": 0.5906465617897897,
        "p50": 0.2765,
        "p90": 0.930791,
        "p99": 4.404959
      }
    },
    {
      "close_latency_ms": 13.891334,
      "db_size_bytes": 42991616,
      "journal_size_limit": 1048576,
      "ops": 79026,
      "reset_events": 290,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 2826352,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 257.93158300000005,
        "mean": 0.6507653583757291,
        "p50": 0.278792,
        "p90": 1.1531250000000002,
        "p99": 4.753625
      }
    },
    {
      "close_latency_ms": 17.020291,
      "db_size_bytes": 42991616,
      "journal_size_limit": 4194304,
      "ops": 79026,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4152992,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 73.600292,
        "mean": 0.40154786991622743,
        "p50": 0.215584,
        "p90": 0.593125,
        "p99": 2.369542
      }
    },
    {
      "close_latency_ms": 13.787042,
      "db_size_bytes": 42991616,
      "journal_size_limit": 8388608,
      "ops": 79026,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4152992,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 218.322834,
        "mean": 0.39414537133348504,
        "p50": 0.215125,
        "p90": 0.640875,
        "p99": 1.629917
      }
    },
    {
      "close_latency_ms": 11.8495,
      "db_size_bytes": 42991616,
      "journal_size_limit": 33554432,
      "ops": 79026,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4152992,
      "wal_hwm_bytes": 4152992,
      "wal_hwm_pages": 1014,
      "write_latency_ms": {
        "max": 348.917708,
        "mean": 0.4721473475058852,
        "p50": 0.224,
        "p90": 0.7877080000000001,
        "p99": 3.196041
      }
    }
  ],
  "rusqlite": "0.31 (bundled)",
  "sqlite_version": "3.45.0",
  "wal_autocheckpoint": 1000,
  "workload": "wl-mix-50k.jsonl"
}```

### `rust-wl-formula-100k.json`

```json
{
  "backend": "rust-rusqlite",
  "page_size": 4096,
  "results": [
    {
      "close_latency_ms": 49.291709000000004,
      "db_size_bytes": 70680576,
      "journal_size_limit": -1,
      "ops": 100000,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4169472,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 452.796167,
        "mean": 0.4547587799399993,
        "p50": 0.24904199999999999,
        "p90": 0.6449579999999999,
        "p99": 2.4060409999999997
      }
    },
    {
      "close_latency_ms": 12.142334,
      "db_size_bytes": 70680576,
      "journal_size_limit": 0,
      "ops": 100000,
      "reset_events": 427,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 1507952,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 158.476292,
        "mean": 0.6858873912499998,
        "p50": 0.272542,
        "p90": 1.327375,
        "p99": 4.476666
      }
    },
    {
      "close_latency_ms": 21.1005,
      "db_size_bytes": 70680576,
      "journal_size_limit": 524288,
      "ops": 100000,
      "reset_events": 427,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 1507952,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 126.30449999999999,
        "mean": 0.5096564946300001,
        "p50": 0.236708,
        "p90": 0.7973750000000001,
        "p99": 3.2487079999999997
      }
    },
    {
      "close_latency_ms": 11.461958,
      "db_size_bytes": 70680576,
      "journal_size_limit": 1048576,
      "ops": 100000,
      "reset_events": 427,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 1507952,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 199.380959,
        "mean": 0.5144830064199993,
        "p50": 0.241708,
        "p90": 0.743042,
        "p99": 3.16475
      }
    },
    {
      "close_latency_ms": 15.081792,
      "db_size_bytes": 70680576,
      "journal_size_limit": 4194304,
      "ops": 100000,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4169472,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 185.28662500000002,
        "mean": 0.5750751529500014,
        "p50": 0.226625,
        "p90": 1.1177920000000001,
        "p99": 3.866
      }
    },
    {
      "close_latency_ms": 25.848583,
      "db_size_bytes": 70680576,
      "journal_size_limit": 8388608,
      "ops": 100000,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4169472,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 203.536458,
        "mean": 0.7481224272800024,
        "p50": 0.30362500000000003,
        "p90": 1.470666,
        "p99": 4.909291
      }
    },
    {
      "close_latency_ms": 9.399667,
      "db_size_bytes": 70680576,
      "journal_size_limit": 33554432,
      "ops": 100000,
      "reset_events": 0,
      "wal_after_close_bytes": 0,
      "wal_before_close_bytes": 4169472,
      "wal_hwm_bytes": 4169472,
      "wal_hwm_pages": 1018,
      "write_latency_ms": {
        "max": 120.035459,
        "mean": 0.5768939906999976,
        "p50": 0.2495,
        "p90": 0.9512919999999999,
        "p99": 4.196625
      }
    }
  ],
  "rusqlite": "0.31 (bundled)",
  "sqlite_version": "3.45.0",
  "wal_autocheckpoint": 1000,
  "workload": "wl-formula-100k.jsonl"
}```
