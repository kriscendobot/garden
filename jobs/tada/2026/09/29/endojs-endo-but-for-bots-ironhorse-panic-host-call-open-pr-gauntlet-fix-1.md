Fix round 1 for endojs/endo-but-for-bots#1379 is pushed and CI is green: 35 of 35 checks pass on the new head `363cf8b3ac`.

The first CI run had one red leg, `test (24.x, ubuntu-latest)`. It failed in the JS package `packages/space-nixos-admin`, in the `deploy-performer` test: it read `apply-status.json` while that file was still being written ("Unexpected end of JSON input"). This PR only changes Rust and the same leg passed on the previous head, so I treated it as a flake. I reran only that job; it passed, and `ci-wait-merge.sh --no-merge` then returned rc 0.

**Commits pushed** with `safe-push-pr-head.sh` (`42b0564357..363cf8b3ac`, fast-forward, nothing rewound):

1. `92d2b1a090` — `refactor(slot-machine): spell out names, resolve design references, share directory sync`
   - **stylist:** spelled out abbreviated names in the new crate, its tests and xsnap:
     - `dir` → `directory`, including `CasStore::directory()`, `cas_directory()` and `sync_directory`; the `cas:sync-dir` fault label became `cas:sync-directory`.
     - `tmp` → `temporary`, and `TMP_SEQ` → `TEMPORARY_SEQ`.
     - `sup` → `supervisor` (a should-fix item).
   - **archivist:** the `(Q3)/(Q5)/(Q6)/(Q7)` citations named sections that don't exist in `designs/ironhorse-panic.md`. Each now cites `§ Open Questions` plus a phrase that appears word for word in that question.
   - **curator** (the engine-realist raised the same point as a comment): xsnap's `suspend_to_cas` now calls `slot_machine_transcript::sync_directory` instead of its own Unix-only copy. xsnap gains the path dependency, and `Cargo.lock` has one new line. This creates no dependency cycle.
   - **orthographer:** changed all 21 "acknowledgement(s)" to "acknowledgment(s)".
2. `363cf8b3ac` — `fix(slot-machine): run transactional host effects inside the crank commit`
   - **breaker:** a `transactional` host call used to run its effect immediately, so a crank that panicked and was retried applied it twice. Now it goes through a new `Transcript::host_call_transactional`. The callback returns its reply plus a `TransactionalWrite`, which runs inside the crank's commit transaction. An aborted crank applies nothing, and a retry applies the effect exactly once.
   - Calling the wrong entry point for a callback's class is refused with a new error, `HostCallError::WrongEntryPoint`.
   - Two new tests cover abort, restart and a single application on retry, plus the entry-point refusals.
   - I also did two cheap should-fix items: a debug assertion that a `pure` callback reports no handle effect, and checked addition for the per-crank outbound byte limit, so an oversized payload is refused instead of wrapping.

**PR body (integrator):** added the phase-and-evidence ledger block. It cites `designs/ironhorse-panic.md` with `Disposition: deliverable` and `Acceptance: satisfied`. The FFI-abort-guard item is marked as delivered by merged #1150 (tested in `xsnap/tests/ffi_wiring.rs`), not claimed again here. Run locally, the gate script now gives `attention` (rc 10: integrator compares the ledger to the design) instead of `blocked`. I also updated the body's test counts, the transactional description and the question labels.

**Local checks:**
- `cargo test -p slot-machine-transcript` passes: crash matrix 1, embargo 8, host 14, protocol 15.
- `ironhorse_embargo_coverage` passes (10 tests). To compile xsnap locally I filled in the `c/moddable` submodule and used empty placeholder JS bundles, which are gitignored and not committed.
- `rustfmt` 1.88 check and clippy on the crate are clean.

**Not done (should-fix / comment-only):**
- `compact()` never prunes closed `host_handle` rows.
- `Embargo::transcript_mut` hands out the full `Transcript`, so a caller can bypass the embargo.
- `recovery_gate` can report an escaped barrier for a crank that is still running.
- `outbound_audit` returns a bare tuple instead of a named struct.
- `conn`, and the `req`/`rep` aliases in SQL text, are still abbreviated.
- The claim that Windows needs no directory sync ("NTFS journals the rename") has no cited source.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (8997056 cached reads)
- Output: 35677 tokens
- Cost: $3.7601592000000004
- Wall-clock: 4506s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
