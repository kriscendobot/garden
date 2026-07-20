---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T03:25:04Z -->

---
model: opus
---
# Stage-10l child 1: the LIVE daemon round trip — flip the error-trace pin (PR #600, endojs/endo-but-for-bots, branch `xs2rust-endor`)

You are an endor-engine builder. Repo `endojs/endo-but-for-bots`, PR **#600** (DRAFT — leave it
DRAFT, never comment), branch `xs2rust-endor`. The CapTP dispatch gate is **GREEN** as of stage 10k
(s42 acceptance issuecomment-5018362782): the real worker-bundle `handleCommand` runs a real CBOR
deliver to completion and replies out-of-band via drained `hostSendRawFrame` frames. What has NEVER
run is the **LIVE daemon round trip** — the daemon process driving the Rust engine worker over the
real channel. That is your job, and the binding question is whether the **error-trace 6-pending pin
MOVES**: the 6 error-trace daemon tests that exercise the live worker-eval trace round trip
(enumerated in the s10k remeasure tada `journal/jobs/tada/xs2rust-endor-stage10k-remeasure.md`:
evaluate-rejection worker-trace record; @daemon stub records; recent() multiple emissions; clear()
drops records; lookup unknown errorId; two-workers numbered-errorId collision).

## Precondition gate (check BEFORE substantive work; tada honestly if it fails)

- Get an isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base>
  endojs/endo-but-for-bots xs2rust-endor`; fetch and confirm the REAL remote tip (press may rebase).
- **Proven daemon env on endolin-garden: `/home/kris/garden/tmp/s9r`** (short AF_UNIX path). On
  endolin-garden2 adapt the s10k remeasure's recipe (`/home/kris/garden2/tmp/s10e`, same shape).
  If neither env is reachable on your host, STOP and tada with the gap named (outage class).
- Guard all three environment-artifact classes: AF_UNIX sun_path overflow (short path only),
  uniform provisioning-race asserts, stale seeded `target/` (fully resync `rust/` from the tip
  before building; the s10k remeasure proved tar-overwrite exact when the range has no deletions —
  verify deletions first).

## Procedure

1. Sync the env's `rust/` tree to the real remote tip. `cargo build --release -p endo --bin endor`;
   BUILD_EXIT by exit code, to a file. Regenerate the 3 XS bundles; expect byte-identical md5 unless
   the range touched JS. Smoke: `context.test.js` with
   `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`), default reporter — expect
   10/10.
2. **Drive the LIVE round trip:** run the error-trace daemon test file under
   `ENDO_WORKER_BIN='<abs>/endor worker -e rust'`, default reporter (ava's TAP reporter crashes in
   `dumpError` on a timed-out test), `--concurrency=1 --timeout=25s`, captured to a file. The 6
   pinned tests are THE question — report each by name: flipped-to-pass / still-pending / new
   failure shape (quote the engine halt).
3. **Live silent-ack check (BINDING):** on the live channel a command the handler completes must
   flow its REAL value — verify at least one live reply payload is a genuine frame (a trace-facet
   record / CapTP frame), not a synthetic `"undefined"` ack. The known seam: the live path drops a
   handler whose rendered return is the literal string `"undefined"` — if the live protocol trips
   this, report it with the frame evidence.
4. If a live test halts at a NEW named engine frontier: land **at most 2** frontier items
   (transliterate bit-exact from the pinned C-XS at `23b4d6b0a65f…`; result-exact dual-run tests;
   push-per-item), re-drive after each. More than 2 distinct frontiers → stop, name them all in the
   tada (an honest gap round).
5. On ANY pushed engine change, the no-boot-regression bars are BINDING (all by exit code, after
   `cargo clean -p endor-compile -p endor-vm -p endor-oracle`): engine workspace
   `--test-threads=1` EXIT=0 (counts grow only by your tests); compile-diff 1909/1909 + SYMB;
   boot gate 30/0; ROOT `-p endo --lib` 111/0 with both markers GREEN; 0 non-oracle warnings; no
   new `unsafe`; any new side table ledgered the SAME DAY.

## HARD STOP discipline (BINDING)

Reassess the clock after EVERY pushed item. Start a new frontier item only with ≥1200s remaining.
Never leave the branch mid-rebase. A tada at an honest checkpoint (round trip driven, pin answered,
frontier named) is SUCCESS even if not all 6 flipped. Artifacts to `$HOME/tmp/s10l-live/`
(mkdir `$HOME/tmp` first — it is per-host). Report via your tada completion report ONLY — never
inbox-send the parked supervisor. Metering doctrine: accuracy-over-parity; results gate, computrons
are advisory.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  worker_kind: gardener
  claimed_at: 2026-07-20T03:25:08Z
