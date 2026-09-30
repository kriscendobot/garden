# Fix round 2 for endojs/endo-but-for-bots PR #1380: fix pushed, CI still pending

I applied the round-2 panel's must-fix items and pushed them to the PR head as `fa3a96c21d`. CI had not finished when the one-hour deadline hit (`ci-wait-merge.sh` returned rc 4): 27 checks passed, 0 failed, and 7 were still running. The ones still running were test (24.x ubuntu), test (22.x and 24.x macos-15), format-ironhorse, test-ironhorse, test-ironhorse-release and test-ocapn-python.

## Must-fix items addressed
- **Failed crank commits no longer go unnoticed (assessor).** `host_ledger::end_delivery` now returns a `Result`. A suspend fails if the open crank does not commit. A failed commit also blocks every later heap publish, so no snapshot can get ahead of the log.
- **Resume checks the heap against the log (breaker, engine-realist, and wire-watcher's second finding).** Attaching a transcript is refused if the resumed heap's hash is not the transcript's published snapshot. It is also refused while committed host calls sit past the snapshot's watermark, found with a new `HostReplay::cranks()`. Test: `host_transcript_attach_refuses_a_heap_behind_the_log`.
- **Only the supervisor can send control verbs (locksmith).** `host-transcript` and `suspend` are accepted only when the envelope handle is 0, meaning the supervisor sent it. Test: `host_transcript_and_suspend_refuse_a_peer_sender`.
- **Worker identity is explicit (wire-watcher's first finding).** The `host-transcript` payload is now `path\nworker[\nheap-hash]`. The worker identity no longer comes from the transcript's file name.
- **Barrier test coverage (prover).** The aborted-delivery barrier test now also covers `appendFile`, `remove`, `rename`, `symlink` and `link`.
- **Naming (stylist).** `CasStore::dir`, `sync_dir` and `tmp` are now `directory`, `sync_directory` and `temporary`.
- **Performance claim (benchmarker).** The "linear, not quadratic" claim is withdrawn in the PR body and corrected in the new commit message. It was never measured, and each crank still restages all the bytes fed to a hasher so far.
- **Acceptance ledger (integrator).** The PR body ledger now says `Acceptance: partial` and names the supervisor-attach and replay-driver follow-ups as what gates full acceptance.
  - **Decision for you:** with `Disposition: deliverable`, a `partial` acceptance means `phase-evidence-gate.sh` will block un-drafting. That matches what the integrator asked for (the PR can't land ahead of #1379 and #1374 anyway), but it may stop the later un-draft stage.
- **Docs.** `designs/ironhorse-panic.md` now describes the supervisor-only verbs, the watermark and heap checks, and that the transcript file carries authority. I posted a summary comment on the PR (issuecomment-5906351401).

## Local verification
- `cargo test -p xsnap --lib`: 148 tests pass. I skipped `archive_text_endowments_provide_codecs`, which segfaults here because I copied in a stub generated bundle from another checkout. That is a local setup problem and not caused by this change.
- `cargo test -p slot-machine-transcript` passes, and `cargo check --workspace --tests` is clean.

## Not done this round (should-fix and comment-only items)
- Identity checks when re-seating a reader.
- Losing an open SQLite transaction on re-seat.
- The file-read callbacks marked as recorded that still skip the transcript.
- Keeping one crank per envelope.
- The cost of restaging each hasher's bytes every crank.
- Writing the heap twice on suspend.
- Property-based round-trip tests.
- Restacking linearly onto #1379 and #1374 to drop the merge commit.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5806493 cached reads)
- Output: 29080 tokens
- Cost: $2.8112985999999998
- Wall-clock: 4126s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
