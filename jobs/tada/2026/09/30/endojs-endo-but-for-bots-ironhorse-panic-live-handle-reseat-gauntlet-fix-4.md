**Fix round 4 on endojs/endo-but-for-bots PR #1380 is done: the fixes are on the PR head and CI is green (35/35 checks).**

**What I found.** I pushed no new code this round. An earlier claimant of this job had already pushed fixes for the panel-4 must-fix items. That push is `1995aab22b..0d244a84d2`, and they posted a follow-up comment on the PR. I checked each must-fix item against the current head:
- **Random values and keygen (assessor):** `randomHex256`, `randomFillBytes` and `ed25519Keygen` now go through the host transcript, so replay returns the recorded value (`0958f063fd`).
- **One crank per delivery and refused deliveries (saboteur, breaker, wire-watcher, prover):** each crank is bounded to one delivery, and a delivery the transcript refuses now stops the worker with an error instead of being dropped (`ab1e8b9a9c`).
- **`fxAbort` during a host call (engine-realist):** the ledger borrow and file-map borrow are released before XS allocates, so an abort there no longer turns into a Rust panic (`ab1e8b9a9c`).
- **Unchecked heap name (wire-watcher):** `resume_from_cas` now checks that the heap's bytes hash to its name before XS loads them (`ab1e8b9a9c`).
- **Abbreviated names (stylist):** `conn`, `stmt`, `arg_handle` and `directory_arg` are spelled out (`1995aab22b`, `0d244a84d2`).
- **`Descriptor` codec test:** `every_descriptor_round_trips_through_its_encoding` in `host_ledger.rs` covers all six variants and the hasher size limit.
- **PR body:** it now has the Documentation and Testing Considerations headings.
- **Probe status:** the PR is still a draft, as the probe rule requires.

**CI.** The first wait came back red on one cell, `test (22.x, macos-15)`:
1. The first failure was an unhandled rejection ("Termination requested") in `packages/daemon/test/endo.test.js`.
2. After a rerun of that job, a different test in the same cell failed: `daemon-teardown › an orphaned daemon shuts itself down…`, a timing check on a pid.

Both are JavaScript daemon tests. The PR changes nothing under `packages/`, and that CI job doesn't build Rust, so I treated both as flakes and reran the job once more. The second rerun passed.

**Follow-ups.**
- The macOS / Node 22.x daemon tests (`endo.test.js` and `daemon-teardown`) look flaky and may be worth their own issue.
- Should-fix and comment-only findings were outside this round's scope, including the embargo sender-identity check, reader file-identity checks on re-seat, and hash-format validation in the content store. The next panel round can pick them up.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 204 tokens (10671879 cached reads)
- Output: 50204 tokens
- Cost: $4.7932478
- Wall-clock: 10901s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
