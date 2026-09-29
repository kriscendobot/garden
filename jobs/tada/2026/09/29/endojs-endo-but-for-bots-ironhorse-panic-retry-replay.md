---
handed-off: endojs-endo-but-for-bots-ironhorse-panic-retry-replay-open-pr
deliverable-complete: false
---
I built this leg and pushed it, but the draft PR is not open yet. This host's bot token gets a 403 when it tries to create a PR on endojs. I posted a successor job, `endojs-endo-but-for-bots-ironhorse-panic-retry-replay-open-pr`, pinned to `endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` with the PR body, which is embedded in the job and has `Refs: #1018`, as a draft. So this run is a handoff, not a clean completion.

**Branch:** head `llm-ironhorse-panic-retry-replay` at `a1c0b00bd`, against the frozen base `llm-1706e63`. It is stacked on #1380 (live handle re-seat), which sits on #1379, #1377, #1376 and #1374. Only the top commit is this leg's work.

**What I built:**
- **Supervisor side** (`slot-machine-transcript`, new `retry.rs`):
  - When a delivery does not finish normally, `Supervisor` drops the worker and throws away that delivery's outbound frames.
  - `recover` re-opens native handles from their saved state, restores the last snapshot, and replays the committed deliveries after it. Recorded outbound frames are checked and suppressed rather than sent again, and host calls get their recorded replies. Any mismatch stops recovery.
  - The failed delivery is then held for `retry` or `discard_pending`. Retry only goes ahead under a fix that suits the panic source:

    | Panic source | Fixes accepted |
    |---|---|
    | Guest or engine bug | New snapshot only |
    | Meter abort | Config change or new snapshot |
    | Stack overflow | External condition or new snapshot |
    | Escaped throw | External condition or new snapshot |

  - Retry is also refused while a barrier effect may have escaped or a handle is broken.
- **Escaped throws:** I followed the mentat's answer (#1370 and the comment on #1018). A throw that escapes the delivery adapter discards the delivery and ends the worker, like a panic, and is never redelivered automatically.
- **Live XS worker** (`xsnap`):
  - With a transcript attached, outbound frames are recorded in the delivery's crank.
  - `host_ledger::published_heap` and `host_ledger::replay` restore the worker and re-run the committed deliveries.
  - The file, directory and hasher callbacks now record a tagged guest result. Replay can then hand back the same value without touching a real file or hasher.
- **Design doc:** `designs/ironhorse-panic.md` now describes the implementation.

**Acceptance test (replay equals live):** a live XS worker opens, reads and hashes through three handles and sends frames. It then dies in a delivery that is aborted. A fresh worker restores and replays, and:
- The heap is byte-identical to the live one, except for the 2-byte XS `CREA` field. That field records allocator chunk sizes rather than heap contents; a probe showed it was the only difference.
- The same frames come out and are suppressed; nothing is sent during replay.
- On retry, the re-opened reader and hasher carry on from where they were when the last delivery committed.
- Two deliberate breakages each make the test fail: letting host calls run live during replay, and letting frames be sent during replay.

**Test results:**
- `slot-machine-transcript`: all suites pass, including 8 new retry tests; clippy and rustfmt (1.91) are clean.
- `xsnap` library tests: 144 pass. I skipped two that need generated JS bundles; they were stubbed locally and one crashes on the stub.
- `ffi_wiring`: passes.
- CI only runs `cargo check` on xsnap, so the XS test runs locally, not in CI.

**Not in this PR:**
- **Daemon wiring:** nothing in the daemon attaches a transcript or calls `recover`/`retry` yet.
- **Live release after commit:** frames on the live XS path are still sent as soon as they are written. Holding them until commit belongs to the embargo leg's live wiring.
- **SQLite reads during replay:** they have no reply encoding yet, so a replay that reaches one stops.

The PR body lists the open-question decisions this depends on (Q5, Q2, Q3) plus three design leanings as review items.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-retry-replay.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (15203938 cached reads)
- Output: 86583 tokens
- Cost: $6.726287600000001
- Wall-clock: 6161s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
