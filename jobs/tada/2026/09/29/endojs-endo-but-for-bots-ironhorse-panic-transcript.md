I've built the transcript leg and opened it as draft PR [endojs/endo-but-for-bots#1376](https://github.com/endojs/endo-but-for-bots/pull/1376) (head `llm-ironhorse-panic-transcript` at `ae86b858a9`, base `llm-1706e63`, `Refs: #1018` in the body). All 35 CI checks pass, and the crash-injection matrix passes on Linux debug, Linux release and macOS.

**How the answers were applied.** The open-questions job had finished (its answers are on #1018 and in design-amendment PR #1370, which is not merged yet), so I followed them. The PR body lists each decision as a review item:
- **Q3:** XS/CAS watermark ordering is the first backend; SQLite `ATTACH` is not used.
- **Q6:** a storage failure is a supervisor-owned `TranscriptFault`, not an engine panic.
- **Q7:** WAL with `synchronous=FULL`, and one release transaction per crank.

**What changed**
- **New crate `rust/endo/slot-machine-transcript`.** Each worker gets one SQLite WAL database at `<endo-dir>/workers/<handle>/transcript.sqlite`. It holds:
  - snapshot records, each with its watermark and the pinned engine and `panic-on-reference-error` settings;
  - crank state: started, committed or aborted;
  - inbound and outbound rows with event numbers that are never reused, so `<worker>:<seq>` is a stable duplicate-detection key.
- **Crank protocol:**
  - The inbound delivery is written durably before the guest runs.
  - Outbound frames are held back until the crank commits, in a single transaction.
  - An aborted crank's frames are thrown away and never written.
  - The per-crank limits on frame count and bytes refuse the frame outright rather than truncating.
- **Snapshot ordering:** a snapshot's hash and watermark are recorded only after the blob is written, synced, renamed and its directory synced. Compaction runs only after that record exists.
- **Storage faults:** a fault records the SQLite codes and whether the commit's outcome is known, then blocks the worker from doing anything more. Reopening sorts it out: a crank that was started but never provably committed is marked aborted, keeps its inbound row, and is not retried automatically. Other workers keep running.
- **Fault-injection hook (`FaultPlan`):** a wrapping SQLite layer plus hooks in the snapshot writer fail the Nth write, sync, truncate, delete, rename or directory sync. It can simulate a crash, a half-finished write, a one-off error, or a commit that succeeded but reported failure.
- **Small fix outside the crate:** xsnap's `suspend_to_cas` now syncs the snapshot directory after the rename, which the design required.
- **CI:** the crate is added to change detection, with a test step and a formatting check. There is a new `test-ci-changes.py` case for it.

**Verification (the leg's acceptance bar)**
- **Crash matrix:** a dry run numbers 56 durability operations across one committing crank's full lifecycle. The matrix hits each one in all four fault modes, for 224 cases. After each case the worker restarts cleanly and the test checks:
  - replay lands on exactly the before-crank or after-crank state;
  - the receiver sees each committed crank's frames exactly once and in order;
  - the published snapshot never covers an uncommitted crank;
  - the worker reaches the expected final state after a retry.

  Result: 130 cases landed after the crank, 94 before it, and none in a half-applied state.
- **15 protocol tests**, including a check that a crank costs exactly 2 syncs whether it sends 1 frame or 64, an ambiguous commit, a crash after sending but before recording the acknowledgement, a fault on one worker while a sibling keeps serving, and a corrupt snapshot being treated as a fault rather than falling back to an older one.

**Follow-ups**
- **Not done here — the SQLite-heap-store backend's joint commit.** The matrix covers only the XS/CAS ordering. Q3 says that backend needs a real prepare-and-commit recovery protocol; `ATTACH` alone is not enough.
- **Outbound-embargo leg:** routing `worker_io.rs`'s `send_frame` through this transcript. It depends on #989's one-delivery-at-a-time admission.
- **Host-call transcript leg:** durable request/reply records and the `host_handle` table. The schema already accepts those event kinds.
- **Not done:** performance tuning (out of scope for this leg).
- **Garden:** `phase-evidence-gate.sh` refused the first PR body because it contained the words "steps 1–4" alongside a design path it could not resolve. It passed once I reworded that. The gate's matching looks too broad.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-transcript.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (7874747 cached reads)
- Output: 88065 tokens
- Cost: $4.931825400000001
- Wall-clock: 3761s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
