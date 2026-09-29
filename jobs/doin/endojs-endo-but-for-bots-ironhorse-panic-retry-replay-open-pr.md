---
role: builder
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---
# Open the draft PR for the Ironhorse panic retry/replay leg

Repo: endojs/endo-but-for-bots. Predecessor: job `endojs-endo-but-for-bots-ironhorse-panic-retry-replay` (orchestration `endojs-endo-but-for-bots-pr1018-followups-20260929`), which built and pushed the head branch but could not open the PR: host oros-studio-garden-ce242c49's PAT gets 403 on `createPullRequest` for endojs.

Already pushed:
- head: `llm-ironhorse-panic-retry-replay` at `a1c0b00bd`, stacked on #1380 (`llm-ironhorse-panic-live-handle-reseat` @ `dcbd82cc1`)
- base: the frozen `llm-1706e63` (already on the fork)

Your only task: write the PR body between the BODY markers below to a file, then run, from any checkout:

    scripts/jobs/gardening/ensure-pr.sh endojs-endo-but-for-bots-ironhorse-panic-retry-replay-open-pr endojs/endo-but-for-bots llm-ironhorse-panic-retry-replay llm-1706e63 \
      --title 'feat(slot-machine,xsnap): terminate, restore, and replay after a panic, then retry under a fix' \
      --body-file <that file>

Open it as a DRAFT (ensure-pr.sh's default). Do not change code or the body's content. Report the PR number. If ensure-pr.sh finds an existing PR for this job, adopt it.

----- BODY -----
Refs: #1018

## Description

This PR builds the retry path from `designs/ironhorse-panic.md` § Slot Machine Termination and Retry. When a crank does not quiesce, the supervisor ends the worker. It then restores the last published snapshot and replays the committed transcript suffix, stopping just before the delivery that failed. That delivery can be retried under one of the three "fixed" cases.

**Stack.** This is stacked (skills/stacked-pr-build) on #1380 (`llm-ironhorse-panic-live-handle-reseat` @ `dcbd82cc1`). #1380 in turn sits on #1379, #1377, #1376 and #1374, all against the frozen base `llm-1706e63`. Only the last commit belongs to this PR: `feat(slot-machine,xsnap): terminate, restore, and replay after a panic, then retry under a fix`.

### Supervisor side (`rust/endo/slot-machine-transcript/src/retry.rs`)

- **`Supervisor<F: WorkerFactory, S: FrameSink>`** runs one worker through its transcript under the `Embargo`.
  - `deliver` settles each crank by its verdict. On anything but `Quiesced`, the staged frames are discarded and the incarnation is dropped. Nothing new is admitted until the aborted delivery is retried or discarded.
  - `recover` works in this order:
    1. It checks the configuration pinned by the snapshot (`check_resume`).
    2. It re-seats handles through the factory.
    3. It restores the latest published snapshot.
    4. It replays every committed crank after the watermark.

    Recovery leaves the worker at the state immediately before the aborted delivery, and returns that delivery as `pending`.
  - `retry(PanicSource, RetryFix)` re-delivers the pending crank, but only under a fix that the panic source admits:

    | `PanicSource` | Admitted fixes |
    |---|---|
    | `GuestBug`, `EngineBug` | `NewSnapshot` only |
    | `MeterAbort` | `ConfigChange`, `NewSnapshot` |
    | `StackOverflow` | `ExternalCondition`, `NewSnapshot` |
    | `UncaughtThrow` | `ExternalCondition`, `NewSnapshot` |

    `NewSnapshot` publishes the fixed build's heap and meta as the new snapshot. Retry is also refused while `recovery_gate` reports an escaped barrier or a broken handle. `discard_pending` gives up on the delivery instead: it stays `aborted` on record and the worker serves the next delivery.
- **`Replay`** (from `Transcript::replay`) holds the verified snapshot, the committed suffix, its recorded host calls, and the pending aborted crank.
  - Each replayed frame must equal the next recorded frame. It is suppressed, never released.
  - Host calls are answered from the record, and no adapter runs.
  - A replayed crank must quiesce and must consume every recorded frame and call.
  - Any divergence is a `ReplayStop`, and a committed barrier halts replay.
- A handle that is re-seated as broken stops replay only if a replayed call uses it. Retry stays gated on it until a replacement arrives or the loss is acknowledged. That acknowledgement needs a live delivery, which needs a recovered worker.

### Live XS worker (`rust/endo/xsnap`)

- Under an attached host transcript, `sendFrame` / `issueCommand` / `sendRawFrame` stage each frame in the delivery's crank (`host_ledger::outbound`). Frames are still transmitted as they are sent, and commit marks them released. So the record serves replay, and live release timing is unchanged (see Not in this PR).
- `host_ledger::published_heap(path, worker)` returns the verified heap to restore from. After restoring, `attach` re-seats the handles. `host_ledger::replay(deliver)` then re-runs the committed suffix, matching and suppressing frames, and reports the pending delivery.
- The file, directory, and hasher callbacks now go through `host_ledger::call_in`, and their replies are a tagged `GuestValue` encoding of the guest's result (unset / null / text / bytes, plus any opened handle id). During replay the recorded reply sets the result and no native resource is touched. A callback without that encoding still uses `call`, which stops replay rather than guessing. Today those are the SQLite reads. Barrier callbacks stop at the barrier before this point.

### Uncaught-throw disposition

Per the Q5 answer (#1018 comment and #1370), a throw that escapes the delivery adapter discards and terminates, with no automatic redelivery. `CrankVerdict::Uncaught` drops the incarnation exactly as `Panicked` does. The delivery comes back only through an explicit `retry` under an admitted fix, or it is discarded. Ordinary rejections remain `Quiesced` and commit.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ironhorse-panic.md`
Disposition: deliverable
Acceptance: satisfied | § Verification "Metamorphic equivalence: replay == live", driven against a live XS worker by `replay_after_an_aborted_delivery_equals_live_and_reseats_handles` (heap byte-identical outside the XS `CREA` allocation-size atom; identical frame sequence, suppressed; re-seated reader, directory, and hasher continue from committed positions on retry). The three "fixed" retry cases, the Q5 disposition, and the replay-stop branches are covered by `slot-machine-transcript/tests/retry.rs`.
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

Replay never invokes a host adapter. The XS replay test moves a directory out of reach after re-seating to show this. A barrier recorded in the committed suffix halts replay rather than re-running its effect. Retry is refused while a barrier escaped or a handle is broken. No new authority is introduced.

### Scaling Considerations

A worker with an attached host transcript now stages its outbound frames in the crank's commit transaction. This does not add a transaction, but it does add row bytes, bounded by `TranscriptLimits` (a staging refusal is logged, and the frame is still transmitted). Replay runs once per recovery.

### Documentation Considerations

`designs/ironhorse-panic.md` § Slot Machine Termination and Retry now describes the implementation.

### Testing Considerations

**XS worker** (`xsnap/src/lib.rs`, `replay_after_an_aborted_delivery_equals_live_and_reseats_handles`):
- A live worker runs three committed deliveries that open, read, EOF-read, and close a reader, hash through an incremental hasher, open a reader below a directory handle, and send a frame each. It then dies in a fourth delivery whose crank aborts.
- A fresh worker thread restores `published_heap`, attaches (which re-seats handles 1, 2 and 3), and replays.
- Asserted:
  - 3 cranks replayed, and the pending delivery is the aborted one.
  - 3 frames suppressed, and 0 sent.
  - The heap is byte-identical to the live heap before the abort, excluding the `CREA` atom. `CREA` records the allocator's current chunk sizes, which reflect the incarnation's allocation history rather than heap contents. A probe run showed those 2 bytes as the only difference between a live heap and a replayed one, and every other byte identical.
  - Retrying the aborted delivery reads `fghi` from the re-seated reader, and the hasher finishes to `sha256('abc')`.
- Regression evidence:
  - Making `call_in` run live during replay fails with a replay `Mismatch` on the first read.
  - Transmitting frames during replay fails with `replay sent a frame`.

**Supervisor** (`slot-machine-transcript/tests/retry.rs`, 8 tests), using a toy worker whose host calls reach a factory-owned native reader table:
- Replay equals live: byte-identical heap; suppressed sequences equal the live suffix; native read count unchanged by replay; re-seated readers continue from committed positions. The receiver's `DuplicateSuppressor` drops the one frame re-released because its acknowledgement was not durable at the crash. The result also matches a no-crash oracle run.
- `MeterAbort` + `ConfigChange` succeeds, and `ExternalCondition` is refused.
- `GuestBug` retries only under `NewSnapshot`. A later recovery restores the fixed snapshot, and recovering under the superseded meta is refused.
- Input-driven `StackOverflow` + `ExternalCondition` succeeds, and `ConfigChange` is refused.
- Escaped throw: its frame and heap mutation are discarded, `ConfigChange` is refused, and `discard_pending` lets the worker continue. A later recovery no longer offers the delivery.
- A diverging replay stops recovery with `Mismatch`.
- A committed barrier halts replay.
- Retry is stopped by an escaped barrier, and by a broken handle whose re-seat failed.

Local runs:
- `cargo test -p slot-machine-transcript`: every suite passes (crash matrix, embargo 8, host 15, protocol 15, retry 8). `clippy -D warnings --all-targets` and `rustfmt` are clean.
- `cargo test -p xsnap --lib`: 144 pass, skipping `archive_text_endowments_provide_codecs` and `eval_worker_bootstrap`, which need the generated JS bundles (stubbed locally, as noted in #1380).
- `cargo test -p xsnap --test ffi_wiring`: 2 pass.

As #1380 notes, CI only runs `cargo check` for xsnap, so the XS test runs locally, not in CI.

### Compatibility Considerations

The recorded reply bytes for `read`, `sha256Finish`, and error replies from the routed file/hasher callbacks change to the tagged encoding. These rows exist only in transcripts written by #1380, which has not merged, so no merged format changes.

### Upgrade Considerations

None. No daemon path attaches a transcript yet.

## Review items: open-question decisions this leg depends on

The mentat's answers are on #1018 (https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5886418488) and in design-amendment PR #1370, which is not yet merged.

- **Q5:** an escaped adapter throw discards and terminates, with no automatic redelivery. This PR also puts it on the restore-and-replay path, because that is the only way back to a heap without its mutations. The `CrankVerdict::Uncaught` doc from #1377 ("not placed on the restore-and-replay path") refers to automatic redelivery, and this PR keeps that.
- **Q2:** `MeterAbort` terminates. Retry comes only through an explicit operator `ConfigChange` (or a new snapshot) and never resumes a half-run machine.
- **Q3:** XS/CAS watermark ordering. Recovery starts from the latest published snapshot and never falls back to an older one.
- **Design leaning, not a numbered question:** the admission table above encodes § What "fixed" means in practice. `UncaughtThrow` admitting `ExternalCondition` is my extrapolation, since a throw can be input-driven.
- **Design leaning:** a broken handle gates retry but not replay, because acknowledging the loss requires a live delivery.
- **Design leaning:** heap equality excludes the XS `CREA` allocation-size atom (see Testing).

## Not in this PR

- **Supervisor wiring in the daemon.** No daemon path attaches a transcript or drives `recover`/`retry` for a live worker yet. The XS path is exercised through `host_ledger`, and the policy through `Supervisor`.
- **Release after commit on the live XS path.** Frames are recorded for replay but still transmitted as they are sent. Holding them until commit is the embargo leg's live wiring (#1377), which depends on #989.
- **Replay encodings for the SQLite read callbacks.** They stop replay with a `Mismatch` until their replies get a `GuestValue` encoding.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T23:15:55Z
