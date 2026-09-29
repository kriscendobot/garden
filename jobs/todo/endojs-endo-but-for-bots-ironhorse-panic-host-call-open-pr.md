---
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Open the draft PR for the Ironhorse host-call transcript leg

Repo: endojs/endo-but-for-bots. Predecessor job `endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript` built and pushed the head branch `llm-ironhorse-panic-host-call` (commit `5989fe4aa`, stacked on #1377's `llm-ironhorse-panic-embargo`), against the frozen base `llm-1706e63`. It could not open the PR because host oros-studio-garden-ce242c49's bot PAT gets a 403 on createPullRequest for endojs, so this job is pinned to an endolin host.

Your only task: open the DRAFT PR through ensure-pr.sh, keyed to THIS job's base, with the body below verbatim (it already carries `Refs: #1018`):

    scripts/jobs/gardening/ensure-pr.sh <this-job-base> endojs/endo-but-for-bots llm-ironhorse-panic-host-call llm-1706e63 --title "feat(slot-machine): host calls as transcript events, logical handles, and barriers" --body-file <file holding the body below>

Do not change the code. If the head branch has moved, still open the PR against it. The successful completion hands off to the gauntlet automatically.

----- PR BODY -----
Implements the host-call leg of `designs/ironhorse-panic.md` (§ Host functions are messages too) in the `slot-machine-transcript` crate. Stacked on #1377 (outbound embargo), which is stacked on #1376 (transcript). The base is the frozen `llm-1706e63`, so the diff also shows those two commits until they merge; this leg's commit is `feat(slot-machine): host calls as transcript events, logical handles, and barriers`.

Refs: #1018

## What changed

- **Callback admission (`CallbackRegistry::admit`).** Every host callback gets one of the design's five classifications: `pure`, `read`, `transactional`, `outbound { idempotent }`, `barrier`. For a retryable worker, startup refuses an unclassified callback and an outbound provider that has no idempotency protocol. Such a provider has to gain one or be declared a `barrier`. A worker that is never retried admits everything and treats an unclassified callback as a barrier.
- **Host calls as transcript events (`Transcript::host_call`).** A `read` or `transactional` call's request and reply are staged as `host-request` / `host-reply` events. They are written in the crank's single commit transaction, so an aborted crank leaves none and a crank that makes no barrier call still costs two syncs. A `pure` call is not recorded.
- **Post-commit effects.** An `outbound` call is not run during the crank. It is staged as a `host-effect` event and becomes releasable only after commit (`releasable_effects`). The provider receives the idempotency key `<worker>:<seq>`, and the acknowledgement goes through the existing `mark_released` / `flush_acks` path. After a crash between invoking the provider and saving the acknowledgement, the effect is offered again under the same key.
- **Barriers.** A `barrier` call's request is written durably in its own transaction *before* the effect runs. If the crank then commits, replay halts at the barrier rather than running the effect again. If the crank never commits, `recovery_gate` reports an `EscapedBarrier` until an operator runs `clear_barrier`.
- **Logical handles (`host_handle`).** A reply that opens a resource gets a durable logical id plus an optional reconstruction descriptor. The row is written in the same transaction as the event that opens or closes the handle. On restart, `reseat_handles` rebuilds each open handle from its descriptor. A handle with no descriptor, or one whose rebuild fails, is durably re-seated as **broken**:
  - a live `host_call` on it returns `HostCallError::BrokenHandle` without calling the adapter;
  - `HostReplay` stops with `ReplayStop::BrokenHandle`;
  - `recovery_gate` stays stopped until either `supply_replacement` (same logical id, and the new descriptor is recorded only if it rebuilds) or `acknowledge_loss` inside the crank that delivers the loss notice (commit closes the handle; abort records nothing).
- **Replay (`HostReplay`).** Covers the committed suffix after the latest snapshot. It returns recorded replies and opened handle ids without calling any adapter, and checks the callback, target handle and request bytes. Any divergence, including a recorded call that is never replayed, is a `Mismatch` replay fault.
- **Compaction** keeps unacknowledged `host-effect` events and every `host_handle` row, so open handles stay reachable after the events that created them are compacted. Schema version goes to 2.

## Verification (§ Verification, host-handle / effect contract)

`tests/host.rs`, 12 tests:

- (a) A non-idempotent provider is refused at startup, and so is an unclassified callback. Adding an idempotency protocol or declaring a barrier admits it.
- (a) A declared barrier halts replay at the barrier. The test counts invocations and shows the effect never runs a second time.
- (a) A barrier that ran in a crank that crashed stops retry until an operator clears it.
- An outbound effect never runs during a crank. An aborted crank releases nothing. A committed crank's effect is offered again after a crash under the same key.
- (b) A handle with no descriptor is re-seated as broken. Recovery stays stopped, including across a restart. Replay stops at a use of the handle, and a live use is refused without calling the adapter, so it never runs against a fabricated resource.
- (b) Recovery resumes after a replacement under the same logical id. A failed replacement changes nothing, and the replacement's descriptor survives the next restart.
- (b) Recovery resumes after the application commits a delivery that acknowledges the loss. The handle is then closed and a later use is refused.
- Handles with descriptors re-seat, and replay reproduces the live reply stream.
- A replay that diverges from the record is a fault.
- An aborted crank records no host events or handles.
- Compaction keeps open handles and unacknowledged effects.

Locally, the whole crate passes: crash matrix 1, embargo 8, host 12, protocol 15. `rustfmt` 1.88 check and `clippy -D warnings` (1.88, all targets) are clean.

## Not in this PR

- **Lifting #1150's live refusal to suspend while native handles are open is not done.** xsnap's fs, SQLite and hasher tables do not yet produce reconstruction descriptors, and the XS worker does not yet send host calls through the transcript (the same missing live wiring that #1377 records for `send_frame`). Lifting the refusal before re-seating is wired in would let a resumed worker use a handle that is not there, which is exactly what this contract forbids. So the refusal stays in place. The transcript side it depends on is here: `open_handles`, `reseat_handles` and `recovery_gate`. The live wiring is posted as the follow-up job `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat`.
- A `transactional` callback's local effect is modeled as the reply row in the crank commit. Joining a real adapter's SQLite writes to that transaction is part of the live wiring.

## Review items: open-question decisions this leg depends on

The mentat answers are on #1018 (https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5886418488) and in design-amendment PR #1370, which is not yet merged.

- **Q6:** a storage failure during a host call is a supervisor-owned `TranscriptFault` (the call returns `HostCallError::Transcript`), not an engine panic.
- **Q7:** FULL durability, with host calls accounted separately. Only barrier calls add a transaction inside the crank. Read, transactional and outbound events ride the existing commit.
- **Q3:** XS/CAS watermark ordering is the backend. `host_replay` starts from the latest published snapshot's watermark.
- **Q5:** normal rejections commit and continue; escaped throws discard. A discarded crank drops its staged host events and deferred effects exactly as it drops outbound frames.
- **Design leaning (not a numbered question):** a non-retryable worker admits an unclassified callback and treats it as a barrier rather than refusing it. The design only requires rejection for retryable workers.
- **Design leaning:** an escaped barrier needs an explicit operator `clear_barrier`. The design says recovery "stops for operator intervention" but does not name the clearing act.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
