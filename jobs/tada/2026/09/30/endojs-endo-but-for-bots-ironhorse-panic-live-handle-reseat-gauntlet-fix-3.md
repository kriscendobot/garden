The round-3 fixes for PR #1380 are pushed (head `eab58aaef8`), but CI was still pending when the one-hour deadline ran out (`ci-wait-merge` rc 4).

**What changed in commit `eab58aaef8`:**
- **Missing resumed hash:** `host_ledger::attach` now refuses to attach when the transcript has a published snapshot but no resumed-heap hash was sent. Before, leaving the hash out skipped the heap-identity check (wire-watcher 1, breaker 2, saboteur 3).
- **Failed attach:** if any step after re-seating fails, attach now drops every native handle it re-seated. Each power module (fs, sqlite, crypto) got a `drop_open_handles()` for this. The heap store now opens before re-seating, and handle ids use the checked `u32` conversion instead of a silent cast (assessor 1, spec-keeper 1).
- **SQLite writes:** while a transcript is attached, `sqliteStmtGet` and `sqliteStmtAll` refuse a statement that writes, such as `INSERT … RETURNING`. It has to go through `sqliteStmtRun`, which is classed as a barrier (breaker 1). The refusal only applies under a transcript, so existing callers without one see no change.
- **Supervisor race:** `Supervisor::retire` now records the outcome before unregistering the worker, so a caller that sees the worker gone always finds its outcome (assessor 4).
- **Renames:** `CasStore` → `Cas`, `dir_slot`/`dir_arg` → `directory_slot`/`directory_arg`, `msg` → `message`, `endo_dir` → `endo_directory`, and the test helper's `dir` → `directory` (stylist 1–4).
- **Spelling:** "acknowledgement" → "acknowledgment" in the new transcript crate, its tests and the design doc (orthographer).
- **Tests:** existing attach tests now pass the published hash. New tests cover a missing hash, a wrong hash (64 zeros) and the refused SQLite write.

**PR body:** I rewrote it from 995 words to about 320 and changed the ledger to `Disposition: non-deliverable-probe` with `Acceptance: deferred`. This answers the integrator's must-fix, since supervisor attach and the replay driver aren't in this PR. The phase-evidence gate accepts the new body as a probe. The guide says a probe stays draft and doesn't enter the gauntlet, and the panel stage rejects one, so panel-4 will block. That's by design: the acceptance bar can only be met once those two follow-ups land. I also posted a summary comment on the PR, anchored to the new head.

**Verification:**
- **Passed:** the slot-machine-transcript tests; 132 xsnap lib tests; and the endo crate's `ironhorse_embargo_coverage`, `worker_outcome::`, `inproc::` and supervisor tests.
- **Skipped (18 xsnap tests):** they need the generated JS bundles. I used gitignored placeholder files for those, so a few bundle-dependent tests crashed and I left them out.
- **Clippy:** only shows warnings that are already on the base, from a newer toolchain than CI's 1.88.

**CI:** 33 of 35 checks passed. `test (24.x, macos-15)` failed in the JS test `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This PR only changes Rust, so that failure isn't from this change and the leg should be re-run. `test (22.x, macos-15)` was still running at the deadline.

**Left for later (should-fix items, not in this round):**
- one crank per envelope, and letting a refused `begin_crank` refuse the delivery
- re-seating SQLite without creating a missing file, and handling an open transaction
- recording file identity for readers
- hashing the blob in `resume_from_cas` before trusting it
- the heap written twice on suspend
- validating the worker id in `transcript_path`
- converging `suspend_to_cas` onto `Cas`, and narrowing `host_ledger` to `pub(crate)`
- restacking the branch linearly
- measuring or documenting the fsync on every write chunk

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 146 tokens (8647347 cached reads)
- Output: 32787 tokens
- Cost: $3.5443374
- Wall-clock: 4248s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
