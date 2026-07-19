---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T12:40:11Z -->

---
model: opus
---
# Builder: the CapTP-dispatch frontier — from full boot to the LIVE round trip (PR #600, stage 10j)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — keep it DRAFT).
Isolated checkout keyed by THIS base:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10j-live-captp-dispatch endojs/endo-but-for-bots xs2rust-endor`
Sync to the REAL remote tip (a serial predecessor — the stage10j flag fixer — lands first:
`git fetch origin xs2rust-endor`, work at FETCH_HEAD). Seed `rust/engine/target/` `cp -al` from a
same-branch sibling; `rmdir` the empty `c/moddable`, copy the sibling's (verify pin
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, clean); then `cargo clean -p endor-compile -p
endor-vm -p endor-oracle`. `cargo` at `$HOME/.cargo/bin`. REAL bundles seed from
`/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/` (packages content-identity `diff -rq … -x
node_modules` first; never commit bundles). Verify pushes by git EXIT CODE.

**State (stage-10i):** the worker bundle boots the ENTIRE SES + `@endo` graph —
`BootReport { halted_at: None, handle_command_registered: true }`, the full-boot marker
`boot_drives_the_real_chain_to_the_worker_bundle_frontier` asserts it. `deliver` routes to the
guest's REAL `handleCommand`, which halts when INVOKED on a missing command-dispatch-path
global: `Throw("get <id>: undefined variable")`. `dispatch_deliver` currently DEGRADES to the
fold-ack round trip on that handler frontier (`rust_worker.rs` — the `Err(_frontier)` arm);
when the frontier closes, the real completion value flows through the `Ok` arm unchanged.

## Step 1 — close the dispatch-path frontier (push-per-item)

Identify the missing global(s) the real `handleCommand` needs when invoked (instrument the halt
to name the id; expect a CapTP-dispatch binding — a host function or an engine op the dispatch
path reaches). Close it the established way: a host binding follows the
`hostSendRawFrame`/`hostGetDaemonHandle` pattern (ledgered side table + GC-roots row +
SnapshotExcluded contract the day it lands — VARIANT_COUNT grows and its snapshot test with
it); an engine op is transliterated bit-exact vs the C-XS oracle with a dual-run suite (result
+ computrons for covered shapes; uncovered shapes self-name — NEVER wrong-complete). **At most
ONE more frontier item** after the first closes if it is small and the clock allows; a NEW-KIND
frontier (a big op family, a different subsystem) is the next stage's work — do NOT reach.

## Step 2 — the BINDING gate (~300s)

Re-run the marker + a real-handler invocation: the round-trip gate is
`halted_at == None && handle_command_registered == true` AND `dispatch_command_to_handler`
returning `Ok` for a representative command (no degrade). If RED: push the checkpoint, report
the remaining frontier honestly (a DEGRADED gap round IS honest success — the stage10h/10i
precedent), and STOP.

## Step 3 — the LIVE round trip (ONLY if the gate is GREEN and ≥1200s remain)

HARD STOP discipline (five predecessors died at deadline): reassess the clock after EVERY
pushed item. If green + time: drive one real daemon round trip on the Rust engine
(`ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — NOT `ENDO_ENGINE`; build the ROOT bin
`cargo build --release -p endo --bin endor`; the short-path env `/home/kris/garden/tmp/s9r`
avoids the AF_UNIX sun_path limit — `export TMPDIR=/home/kris/garden/tmp`). A completed
`context.test.js`-class round trip carrying the handler's REAL completion value (superseding
the fold-ack assertions with a real round-trip test), or the first error-trace test flipped, is
the prize; push and report exactly what ran. If not: STOP at the pushed gate-GREEN checkpoint.

**Bars at EVERY push:** engine workspace all-pass EXIT=0 (`--test-threads=1`, captured to file,
check `$?`); compile-diff 1909/1909 + SYMB EXIT=0 (counts grow with the corpus — cite what you
measure); boot gate 30/0; ROOT `cargo test -p endo --lib` all-pass (real bundles); the
full-boot marker stays GREEN. No silent-ack masking: with the dispatch path live, verify
`dispatch_deliver` does NOT degrade for commands the handler actually completes. Accuracy over
parity: result agreement gates; oracle computrons advisory. No new `unsafe`; zero new
non-oracle warnings; any new side table ledgered same-day.

**Sizing:** fit one 2400s handler invocation. Report via your tada completion report ONLY —
never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-19T12:40:16Z
