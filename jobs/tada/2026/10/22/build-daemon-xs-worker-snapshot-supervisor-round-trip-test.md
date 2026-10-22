---
handed-off: build-daemon-xs-worker-snapshot-round-trip-segfault
deliverable-complete: false
---
## Completion report: build-daemon-xs-worker-snapshot-supervisor-round-trip-test

**Partly done, handed off.** The GC-root bookkeeping works and the design status is updated. The full round-trip integration test is written but doesn't pass: the in-process XS worker crashes (SIGSEGV) after its first message, so the test is marked `#[ignore]`. A successor job now owns that crash.

**PR:** endojs/endo-but-for-bots#1527, draft, head `build-daemon-xs-worker-snapshot-supervisor-round-trip-test`, base `llm-54d3d2a` (a new frozen snapshot of `llm` at 54d3d2a682).

**What changed**
- **GC roots for CAS-stored snapshots (`rust/endo/src/supervisor.rs`):**
  - The supervisor now keeps a reference-counted set of snapshot hashes that a future CAS garbage collector must treat as live (`gc_roots`, with `pin_gc_root`, `release_gc_root`, `is_gc_root` and `gc_roots()`).
  - `mark_suspended` adds the snapshot's SHA-256 to that set.
  - A new `GcRootLease` takes over that entry on resume and releases it when dropped.
- **Resume path (`rust/endo/src/endo.rs`):** `handle_resume` creates the lease.
  - In-process workers: it is dropped on the restored worker's first outgoing message (proof it read the snapshot), or when the worker exits.
  - Child-process workers: it is dropped once the restore payload has been handed to the child.
- **Integration test `supervisor_suspend_resume_round_trip` (ignored):** it runs the real control and resume handlers with a small JS bundle that counts pings. It checks:
  - suspend is sent through the control verb;
  - the snapshot file is in the CAS and its name matches its SHA-256;
  - the hash is held as a GC root while the worker is suspended;
  - the worker's registration is gone;
  - the next ping resumes the worker and the count carries on (0003, then 0004);
  - the GC root is released after resume.
- **Design doc (`designs/daemon-xs-worker-snapshot.md`):** Phase 2 now marks the GC roots done and the test as written but ignored. It also records a race I found: when a suspended worker thread exits, its cleanup unregisters the handle, which can wipe out a suspend or resume that happened just before.

**Test results:** `cargo test --lib supervisor` gives 4 passed, 1 ignored. Getting the XS build to run locally took two setup steps:
- initialising the `c/moddable` submodule from `worktrees/kriscendobot-moddable.git`;
- creating stub versions of the generated `xsnap/src/*.js` bundles (they're gitignored).

The crash showed up in that setup. Its exact location is unknown because there was no debugger on the host. Tracing shows the worker's `handleCommand` returns normally after `sendRawFrame`, and the process dies before the first reply reaches the test. It could be a real bug in the in-process worker main loop, which no test exercised before, or the stub SES bundle could be the cause.

**Successor job:** `build-daemon-xs-worker-snapshot-round-trip-segfault`. It covers finding and fixing the crash, un-ignoring the test, fixing the exit-path unregister race (which lets the test drop its 200 ms sleep), and updating the Phase 2 status. The ignored test's comment points to that job by name.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-xs-worker-snapshot-supervisor-round-trip-test.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4227700 cached reads)
- Output: 28602 tokens
- Cost: $2.3306600000000013
- Wall-clock: 546s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
