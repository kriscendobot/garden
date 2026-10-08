Fix round 4 for endojs/endo-but-for-bots#1379 is done: all four must-fix items from the round-4 panel are applied and pushed, and CI is green. `ci-wait-merge.sh --no-merge` returned rc 0 with all 35 checks passing.

**What changed** (follow-up commits on `llm-ironhorse-panic-host-call`, head now `2c43a058c06`, pushed with `safe-push-pr-head.sh`):

1. **CAS reclaim (breaker; also flagged by assessor and corner-prober).** `ContentAddressedStore::reclaim` now deletes only two kinds of file:
   - blobs with valid hash names that are not in `keep`;
   - `.transcript-blob.<pid>.<seq>.tmp` temporaries whose writer is provably dead.
   - It skips subdirectories, foreign files, `.snapshot.*` temporaries and live writers' temporaries. If the file is already gone when it tries to delete it, that is not an error.
   - The doc comment now says `reclaim` must not run while a writer in the same process is publishing.
   - Liveness is checked with `libc::kill(pid, 0)` on Unix. My first push checked `/proc` instead, which made `test-ironhorse-macos` go red because macOS has no `/proc`. The second push fixed that, adding `libc` as a Unix-only dependency plus a separate `chore: Update Cargo.lock` commit.
   - Tests: the orphan-temporary test now uses pid 4294967295, which no process can hold (the old pid 1 is a live process). A new test covers a live temporary, a heap snapshot temporary, foreign files and a subdirectory.
2. **Embargo accessor (breaker).** I removed `Embargo::transcript_mut`, which let callers bypass the release queue. In its place are two narrow pass-throughs, `Embargo::publish_snapshot` and `Embargo::compact`. Nothing in the repo used `transcript_mut`.
3. **Citation (archivist).** `check_resume` now cites the real heading, `designs/ironhorse-panic.md` § Coda: An Option to Panic on Reference Errors.
4. **PR body (pruner).** I dropped the empty Documentation and Upgrade sections and tightened the prose to 291 words by `wc` (was over 300). I also added the CI-wiring line gateway asked for.

Locally, `cargo test -p slot-machine-transcript` and `cargo fmt` pass.

**Not addressed** (should-fix items from comment-only seats, left for the panel-5 round):
- assessor's `check_healthy` question about a failed commit or abort losing the crank;
- corner-prober's exact-boundary and empty-payload tests;
- surfacer's crate-docs and README suggestion.

The PR stays draft, as this phase of the design requires.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2460671 cached reads)
- Output: 14676 tokens
- Cost: $1.3734302
- Wall-clock: 4113s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
