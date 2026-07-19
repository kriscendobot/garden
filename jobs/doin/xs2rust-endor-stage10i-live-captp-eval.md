---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T11:01:03Z -->

---
model: opus
---
# Builder: worker-bundle frontier — the `for_of` iteration-protocol op, then the gated live round trip (PR #600, stage 10i)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — keep it DRAFT).
Isolated checkout keyed by THIS base:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10i-live-captp-eval endojs/endo-but-for-bots xs2rust-endor`
Sync to the REAL remote tip (a serial predecessor — the stage10i accessor fixer — lands first;
`git fetch origin xs2rust-endor`, work at FETCH_HEAD). Seed `rust/engine/target/` `cp -al` from a
same-branch sibling; copy the sibling's `c/moddable` (verify pin `23b4d6b0a65f…`, clean); then
`cargo clean -p endor-compile -p endor-vm -p endor-oracle`. `cargo` at `$HOME/.cargo/bin`; REAL
bundles seed from `/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/` (packages content-identity
`diff -rq … -x node_modules` first; never commit bundles). Verify pushes by git EXIT CODE.

**State:** the worker bundle boots through the entire SES + `@endo` graph, registers a real
`globalThis.handleCommand`, learns its daemon handle via `hostGetDaemonHandle`, and halts at
`BootReport { last_clean_stage: Some("ses_boot"), halted_at: Some(("worker_bootstrap",
Unsupported("for_of"))), handle_command_registered: true }` — the ES iteration-protocol opcode is
the first engine op the deeper `@endo` graph needs. The self-updating marker test is
`boot_drives_the_real_chain_to_the_worker_bundle_frontier` (real bundles).

## Step 1 — close `for_of` (push-per-item)

Transliterate XS's `for…of` runtime seam bit-exact vs the C-XS oracle (dual-run: result AND
computrons for covered shapes): iterator acquisition (`Symbol.iterator` lookup + call), `.next()`
invocation, `done`/`value` reads, and IteratorClose on abrupt completion. Cover at least the
shapes the worker bundle drives (arrays and whatever the marker shows next); uncovered iterables
self-name (honest named skip; the ledger already names non-array Map/Set iterables). Land
dual-run suites; re-run the marker — record the new frontier. **At most ONE more frontier item**
after `for_of` if it is small and the clock allows; a NEW-KIND frontier (another host binding, a
big op family) is the next child's work — do NOT reach.

## Step 2 — the BINDING precondition gate (~300s)

Re-run the marker: the round-trip gate is `halted_at == None && handle_command_registered == true`.
If RED: push the checkpoint, report the frontier honestly (a DEGRADED gap round IS the honest
success — the stage10h precedent), and STOP.

## Step 3 — the live round trip (ONLY if the gate is GREEN and ≥1200s remain)

HARD STOP discipline (five predecessors died at deadline): reassess the clock after EVERY pushed
item. If green + time: drive one real daemon round trip on the Rust engine
(`ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — NOT `ENDO_ENGINE`; build the ROOT `endor` bin
`cargo build --release -p endo --bin endor`; the short-path env `/home/kris/garden/tmp/s9r`
avoids the AF_UNIX sun_path limit — `export TMPDIR=/home/kris/garden/tmp`). A completed
`context.test.js`-class round trip (or the first error-trace test flipped) is the prize; push and
report exactly what ran. If not: STOP at the pushed gate-GREEN checkpoint.

Bars at EVERY push: engine workspace all-pass EXIT=0 (`--test-threads=1`, captured to file, `$?`
checked); compile-diff 1909/1909 + SYMB 1909/1909 EXIT=0 (compiler changes need the byte-identity
bar re-proven); boot gate 30/0; ROOT `cargo test -p endo --lib` 110/0 real bundles; zero new
non-oracle warnings; VARIANT_COUNT 35 (ledger any new side table the day it lands); no new
`unsafe`. Accuracy-over-parity doctrine governs: never back-fit meters; result agreement gates,
oracle certifies results; uncovered shapes self-name, never wrong-complete. The s34/s37/s39 F1
doctrine binds: any new write/mutation path onto guest-reachable targets routes through the flag
machinery, never `set_own_unmetered`.

Size to ONE 2400s invocation. Report via your tada ONLY; keep PR #600 DRAFT; confirm its state.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-19T11:01:07Z
