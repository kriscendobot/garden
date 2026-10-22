I opened draft PR endojs/endo-but-for-bots#1532. It adds the next missing piece of the XS worker snapshot design's Phase 2: snapshots of suspended workers are now protected from CAS garbage collection. The supervisor unit tests pass (6/6). I did not run the full test suite or CI.

**Phase boundary:** the snapshot files are already written to the CAS (the content-addressed store), so this PR only adds the GC-root handling. The PR body says what it covers and what is left. One Phase 2 item remains: the full end-to-end integration test (suspend → snapshot to CAS → worker exits → a message triggers resume → check the restored JS state). Phase 3 has not started.

**What changed** (branch `daemon-xs-snapshot-gc-roots`, commit `429745c433`, base `llm-54d3d2a`, which is the current `llm` tip):
- **The bug it fixes:** the `cas-gc` control verb used to run with an empty set of live roots. It could therefore delete a suspended worker's only snapshot. It now treats every pinned snapshot as live.
- **`rust/endo/src/supervisor.rs`:** the supervisor keeps one snapshot root per worker handle, exposed as `snapshot_roots()`.
  - A suspend pins the snapshot's hash. Store-backed Ironhorse workers pin nothing, since they have no CAS key.
  - The root stays pinned while the restored worker runs, not just until resume. The restore reads the snapshot file on a separate thread, so releasing it at resume would let a GC delete the file before it is read.
  - When a worker exits for any reason other than suspending, the root is released. A new suspend replaces it.
- **`rust/endo/src/endo.rs`:** `cas-gc` now passes these roots as live.
- **Design doc:** updated to describe this. It differs slightly from the original plan, which released the root at resume.
- **Tests:** three new ones. One runs a real `ContentStore` GC to check that a pinned snapshot is kept and is collected after the restored worker exits.

**Follow-ups:**
- The remaining Phase 2 integration test.
- Feeding the JS daemon's own live set into `cas-gc` (Phase 3).
- Roots are kept in memory only, so a daemon restart forgets suspended workers along with their roots. This is how it already behaved before the change.

**Build notes:** building `xsnap` locally needed the `c/moddable` submodule checked out and empty placeholder files for four generated JS bundles. Neither was committed. The touched files already had `rustfmt` differences before this change, so I didn't reformat them and matched the existing style instead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-xs-worker-snapshot-next-phase-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2599353 cached reads)
- Output: 16730 tokens
- Cost: $1.5473425999999995
- Wall-clock: 332s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
