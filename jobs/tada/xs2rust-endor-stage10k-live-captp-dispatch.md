Clean tree, HEAD == origin/xs2rust-endor. Both items landed on PR #600's branch.

---

## Completion report

**Job:** stage-10k child 1 — flip the CapTP dispatch gate GREEN via `trace` + `dub_at` (PR #600, `endojs/endo-but-for-bots`, branch `xs2rust-endor`, DRAFT — untouched).

**What I did (two push-per-item commits, both landed on `origin/xs2rust-endor`):**

**Item (0) — bind `trace`** (`861cbdea0`). Bound `trace`, the C-XS `fx_trace` host global the fully-booted worker bundle calls on its route/log path. Followed the `hostSendRawFrame`/`hostGetDaemonHandle` ledger pattern exactly: side-table set `host_trace_fns` recognized at the RUN dispatch → `call_host_trace` (the `fx_trace` transliteration: render each arg, `fxReport` onto a drainable `host_trace_outbox` debug tap), registered per session via `PersistentRealm::register_host_trace`, bound at worker boot. Snapshot treatment recorded **same day** on the `HostReplyChannel` side-table row (SnapshotExcluded, GC-invisible) in `endor-snapshot/sidetable.rs`. This **closed the deliver-path frontier**: the real `handleCommand` now runs to completion. Promoted the self-updating marker to a GREEN assertion.

**Item (1) — implement `dub_at`** (`3b18435c4`). Implemented `XS_CODE_DUB_AT` (was `Unsupported`) — the this-preserving computed member call `obj[key](…)` opcode — transliterated bit-exact from `xsRun.c` (duplicate the top stack pair, order preserved). New dual-run test file (6 tests) RESULT-agrees with the C-XS oracle.

**Silent-ack-masking finding (found & fixed).** The moment the gate went GREEN I verified the reply channel: the real bundle `handleCommand` **always returns `undefined`** and replies out-of-band via `hostSendRawFrame`, never via its return value. So `dispatch_deliver` synthesizing a deliver-ack from the return value produced a spurious `"undefined"` ack — a masked/wrong completion the real CapTP protocol never emits. Fixed: on the live-handler path the deliver's replies are the drained host frames (no synthetic ack unless the handler returns a genuine non-`undefined` value); the fold-ack survives only on the degraded path. The four superseded fold-ack tests were rewritten as real-handler tests.

**Metering advisory (reported, not chased).** Computed method calls carry a small (+1) **systemic** computron advisory — context-dependent (the `DUB` static call `o.f()` shifts 0↔+1 with only an unrelated `''+`) and non-scaling with `dub_at` count (chained = +1 not +2). Consistent with endor's accuracy-over-parity doctrine; results are bit-exact. Also noted: `set_property_at` (computed-key *assignment* / numeric-keyed literal) is a separate still-unimplemented opcode I deliberately left out of scope.

**Bars, both pushes (real bundles):** engine workspace `--test-threads=1` **EXIT=0** (904→910/0); corpora compile-diff **1909/1909** identical + SYMB **1909/1909** (compiler untouched); ROOT `cargo test -p endo --lib` **111/0** with full-boot marker GREEN; **0 non-oracle warnings; no new `unsafe`**.

**BINDING gate: GREEN** — full-boot marker green AND `dispatch_command_to_handler` returns `Ok` on the representative command (no degrade, no fold-ack).

**LIVE round trip: deferred (honest gate-GREEN checkpoint).** Per HARD STOP discipline — the daemon recipe is proven only on a *different* host (endolin-garden vs this endolin-garden2) and needs a full `endor worker` binary build + daemon orchestration I couldn't confidently fit in a clean ≥1200s window after this session's build/test cycles. A gate-GREEN checkpoint short of the round trip is blessed as honest tada success.

**Follow-ups:** (1) the LIVE daemon round trip remains available now that the gate is GREEN; (2) `set_property_at` is the next runtime-opcode frontier (computed-key assignment); (3) the systemic method-call +1 computron advisory is unresolved telemetry (not `dub_at`-specific).
