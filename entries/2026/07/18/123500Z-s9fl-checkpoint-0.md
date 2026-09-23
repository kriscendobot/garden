# Stage-9c child 9/9 — `test:rust` finish-line measurement, checkpoint 0

Job: `xs2rust-endor-stage9c-finish-line-measure`. Repo `endojs/endo-but-for-bots`,
PR #600, branch `xs2rust-endor`. Measurement-only (no engine/test/corpus edits).

## Tip measured
- `xs2rust-endor` real remote tip: **`e07903ebee36021f51abf5e35fbc7051f62c16a1`**
  (child 8, the endor-vm worker surface, is the tip).
- Release daemon bin built fresh at this tip: `cargo build --release -p endo --bin endor`
  EXIT=0, only the pre-existing xsnap `function-pointer-comparison` C warning; endo crate
  warning-clean. Bundles (daemon/worker/ses_boot/host_aliases/polyfills) present; c/moddable
  pinned `23b4d6b0` and clean, never staged.
- Run tree at a REAL short path (`~/tmp/s9r`, daemon dirname 41 chars ≤ 60 so the AF_UNIX
  `sun_path` cap 90 is respected), hardlinked from the same-commit worker-surface sibling
  (complete pnpm node_modules with relative symlinks), release bin dropped in.

## Engine-selection correction (critical)
`test:rust` (`ENDO_BIN/ENDO_WORKER_BIN=…/endor worker`) does **not** route separate
(child-process) workers to endor-vm. The worker child picks its engine only from the
`-e` flag (`endor.rs`); **`ENDO_ENGINE` is read only for in-process "shared" workers**, which
the daemon tests do not use. To exercise the Rust engine the worker bin must be
**`endor worker -e rust`** (the daemon forwards the split args through
`bus-manager-rust-xs.js`). All measurements below use `ENDO_WORKER_BIN='…/endor worker -e rust'`.

## Smoke gate — the deterministic finding
`error-trace.test.js` › "evaluate rejection produces a worker trace record":
- On **C-XS** (`endor worker`): the guest evaluate **completes** — the thrown
  `boom-from-eval` returns over CapTP (test then fails only the trace-report assertion, an
  expected C-XS class).
- On **Rust** (`endor worker -e rust`): the worker eval **HANGS** — 6 tests remained pending
  after a 40 s ava timeout; nothing returns.

The Rust worker boots its fd 3/4 transport (standalone it fails init cleanly with
"Bad file descriptor"), but **cannot sustain a live CapTP session for the worker-evaluate
path**. This matches child 8's documented remainder exactly: the ~1 MB
`bus-worker-xs-ses-boot.js` SES bundle does not boot in endor-vm, so `deliver` cannot
dispatch to a real `handleCommand`, and there is no persistent guest realm / host reply
channel — each `deliver` is a stateless guest evaluation.

## Representative subset (Rust engine, --timeout ~30s)
| file | result on Rust | worker? |
| --- | --- | --- |
| hex.test.js | 5 passed | no (pure logic) — engine-independent |
| cidr.test.js | 18 passed | no — engine-independent |
| locator.test.js | 42 passed | no — engine-independent |
| help-text.test.js | 5 passed | no — engine-independent |
| graph-refcount.test.js | 5 passed | no eval — engine-independent |
| debugger-captp.test.js | 16 passed | mock CapTP session (no real worker) — engine-independent |
| content-store-gc.test.js | 6 failed | real worker; **identical** 6 fails + same `TypeError: cannot configure property` on BOTH C-XS and Rust → engine-independent (daemon-side), reproduces the expected C-XS content-store-gc class |
| error-trace.test.js | 1 passed, 6 pending (HANG) | real worker eval — **diverges: C-XS completes, Rust hangs** |

## Bottom line (preliminary)
The Rust worker completes CapTP for flows that fail/return before a real evaluate
(content-store-gc parity), but the **live worker-evaluate result path hangs** on endor-vm.
Under `test:rust` the direct-worker-eval files `channel-relay`/`invite-retention`/`ws-relay`
are node-worker-skipped and `endo.test.js` is the un-runnable detached harness, so
`error-trace` is the representative live-eval test — and it hangs.

A bounded full sweep (per-file `--timeout=25s`, concurrency 1, 52 files, endo.test.js
excluded) is in flight; checkpoint 1 will carry the three-number summary. Top blocker:
SES worker-bundle boot (remainder #2) + persistent-guest / host-reply-channel (remainder #1).
