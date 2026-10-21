I implemented Phase 1 of `daemon-debug-worker-restart` (the Rust supervisor debug flag) and opened it as **draft PR endojs/endo-but-for-bots#1523**. It merges branch `daemon-debug-worker-restart-phase-1` into the frozen base `llm-f02cd81`, which is the current `llm` tip. The new supervisor tests pass locally. I did not wait for CI or run an end-to-end check that a resumed worker actually stops at `<login>`; that comes with Phase 2.

**What changed** (3 files, +70/−5):
- **`rust/endo/src/supervisor.rs`:** the supervisor now keeps a set of worker handles flagged for debug. Setting a flag twice is harmless, and the next resume clears it, so it applies to exactly one restart. A new test checks that the flag reads true once, false after that, and false for other handles.
- **`rust/endo/src/endo.rs`:**
  - A new `debug-flag` control verb takes `{"handle": …}` (decoded with the existing `codec::decode_handle_request`) and needs no reply.
  - On resume, in-process workers turn the debugger on before restoring, so XS should pause at `<login>`.
  - Workers that run in their own process clear the flag and resume without the debugger, and log that they did. The debugger switch only reaches workers in the same process, so carrying it to a child process is still to do.
- **`designs/daemon-debug-worker-restart.md`:** Status now reads "In Progress — Phase 1 implemented", with a note on the separate-process limit.

**Verification:** `cargo test --lib supervisor::` in `rust/endo` passed 4 of 4. To build locally I checked out the `c/moddable` submodule from the local moddable clone and created empty placeholder files for the four generated `.js` bundles in the project checkout. Nothing from that build setup was committed.

**Problems along the way:**
- I first pushed the branch as `llm-debug-worker-restart-phase-1`, then deleted it from the remote, because `llm-…` names are reserved for frozen bases.
- I left the roadmap row in `designs/README.md` unchanged (it still says Not Started). Editing it made the PR-opening script's phase/evidence check require a ledger for the whole roadmap, and dropping the edit kept the diff small. The groom role, which maintains the roadmap, or a later PR can update it.

**Follow-ups:**
- Phase 2: the JS `debugWorker` method plus the `debugFlag` entry in `controlPowers`.
- Phase 3: the Chat command.
- Debug restart for workers that run in their own process.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-debug-worker-restart-phase-1-rust-supervisor-debug-flag.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2211867 cached reads)
- Output: 13776 tokens
- Cost: $1.4172533999999997
- Wall-clock: 299s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
