---
model: opus
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:02:13Z cleared=none -->

---
model: opus
---
# Stage-10p child 3 (re-posted by s47 after the serial-halt sweep — spec unchanged): FRESH-ENV live drive + 52-file sweep remeasure (PR #600, xs2rust-endor)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600 (DRAFT — keep DRAFT). ZERO engine
pushes expected (measurement + diagnosis job; the ONLY permitted commits are none — report via tada).

## Why this job exists (read carefully — it replaces the host-gated remeasure that double-misrouted)

The LIVE daemon round trip (`packages/daemon/test/error-trace.test.js` under the rust worker) is 7/7
green on the s9r env (endolin-garden, re-proven 2026-07-20 by the s46 supervisor at tip `139b8561f1`
after a full reset + rebuild + byte-identical bundle regen) yet stalls deterministically 1/7 on the s10e
env (endolin-garden2), with IDENTICAL git sources, IDENTICAL bundle md5s (`worker_bootstrap 79e35217…`,
`ses_boot dae58892…`, `polyfills e23d7225…`), and the stall invariant across the whole engine-tip range
(stage-10o diagnosis). Env-health is refuted; the engine is deterministic. The remaining suspect is the
HOST-LOCAL SOFTWARE INSTALL of the s10e env (node_modules vintage / node binary / rustc toolchain).
**This job builds a brand-new env from scratch on WHATEVER host claims it — no host gate — and measures.**

## Procedure (outage-hardened; your worktree survives a requeue — resume, don't restart)

1. `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
   `git fetch origin xs2rust-endor && git reset --hard FETCH_HEAD`; record the measured tip sha.
2. **Fresh install:** run the repo's real `yarn install` in the worktree (corepack yarn; PATH shims for
   yarn/node per the local-test conventions; `TMPDIR=$HOME/tmp`, `/tmp` is noexec). Record
   `node --version`, `rustc -V`, `yarn --version`, and `md5sum yarn.lock`. FALLBACK (only if install is
   truly impossible on this host): `cp -al` node_modules from an existing env on the claiming host — but
   RECORD the provenance loudly; a fallback from s9r contaminates the experiment (the conclusion then
   weakens from "fresh install" to "s9r-install replica") and a fallback from s10e inverts it. Prefer
   failing honestly over a silent fallback.
3. **Build:** regenerate the 3 XS bundles (`packages/daemon/scripts/bundle-bus-worker-xs.mjs` +
   `bundle-bus-worker-xs-ses-boot.mjs`); record md5s vs the trio above. Then
   `cargo build --release -p endo --bin endor` from `rust/` (binary at `<worktree>/target/release/endor`;
   BUILD_EXIT must be 0). You may `cp -al` CARGO TARGET caches from a same-tip sibling (rust caches
   don't touch the node-side experiment; on endolin-garden:
   `scratch/project-wt-port-xs-to-rust-memory-safe-engine-s46-5cd7f36a`).
4. **LIVE drive:** smoke `test/context.test.js`, then `test/error-trace.test.js` TWICE, from
   `packages/daemon`, ava `--concurrency=1 --timeout=25s` DEFAULT reporter (TAP crashes in dumpError),
   `ENDO_WORKER_BIN='<abs>/target/release/endor worker -e rust'`. Record per-test pass/fail.
5. **52-file bounded-serial sweep** (same harness as the s10i/s10k/s10l/s10n remeasures — the sweep
   runner is `sweep.sh` in `/home/kris/garden/tmp/s10n-results/` on endolin-garden; on another host
   reconstruct from its TSV columns): run DETACHED (nohup + log + TSV), resume-from-TSV on requeue,
   reap orphaned `endor` processes when done. Compare classes to the anchor
   pass=760 fail=15 skip=20 pending=6 (TSV byte-identical s10i/s10k/s10l/s10n on s10e).

## Interpretation matrix (write the verdict in your tada)

- **Fresh env GREEN (error-trace 7/7) + sweep classes match the anchor (or strictly improve):** the s10e
  env is CONDEMNED as a rotten install — sweep-observability of the LIVE flip is achieved on a fresh
  env; recommend retiring/rebuilding `/home/kris/garden2/tmp/s10e`. Also record whether the error-trace
  pin rows now flip inside the sweep itself.
- **Fresh env STALLS (1/7, worker emits no reply to the CapTP bootstrap deliver):** s9r becomes the
  anomaly (its older install happens to green). Then capture evidence for the fix: instrument the worker
  serve loop (local, uncommitted) to dump the framed bootstrap deliver bytes; record the versions from
  step 2 plus `node_modules` resolutions for `ses`, `@endo/captp`, `@endo/marshal`, `@endo/daemon`; the
  s10e diagnosis trail is `/home/kris/garden2/tmp/s10o-diagnosis/FINDINGS.md` (garden2) and the s9r
  green env is `/home/kris/garden/tmp/s9r` (endolin-garden) for whoever holds the matching host.
- **Mixed (drive green, sweep classes shift):** report the new classes as the finding; do NOT chase
  advisory computron families.

Size to one 2400s invocation with the detached sweep carrying past it (requeue resumes from TSV). Tada
ONLY (never inbox-send the parked supervisor); keep PR DRAFT; zero pushes.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T11:15:24Z
