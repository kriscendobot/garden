Fix round 3 for PR #1379 is done: both must-fix items from the round-3 panel are applied and pushed, and CI is green on 35 of 35 checks. I rechecked just now: the PR head is still `75b87ee90e`.

**What changed** (commit `75b87ee90e` on `llm-ironhorse-panic-host-call`, pushed from `e6a4002517` with `safe-push-pr-head.sh`):
- **stylist, abbreviated `seq`:** the transcript schema columns now use spelled-out names. `event.seq` became `event.sequence`, and `request_seq`, `reply_seq`, `created_by_seq`, `inbound_seq` and `watermark_seq` became their `*_sequence` forms. The public field `inbound_seq` and the local `live_seq` changed the same way, and every SQL statement in `src/lib.rs` and `src/host.rs` uses the new names.
- **stylist, single-letter names:** the one-letter SQL table aliases (`crank c`, `host_call h`) are gone. The event alias, which an earlier rename had left as a misleading `error`, is now `entry`. Single-letter loop and closure variables in non-test code are spelled out (`staged_effect`, `handle`, `transcript`, `active`, `snapshot` and similar).
- **pruner, PR body too long:** the body prose went from 347 to 211 words, with all seven template headings kept. The Documentation and Upgrade sections now just say "None user-facing." and "None."

**Verification:**
- The crate's tests pass, and `cargo fmt` and `clippy` report nothing.
- I couldn't run the `ironhorse_embargo_coverage` test locally because the xsnap build script fails here. That test uses none of the renamed names, and it passed in CI.

**CI:** the first wait ended red on one check, `test (22.x, macos-15)`. It was cancelled rather than failed, and it's a JS job this Rust-only change doesn't touch, so I reran it once. It passed, and `ci-wait-merge.sh` then returned rc 0.

**Follow-ups:**
- The panel's should-fix items are still open:
  - `ContentAddressedStore::reclaim` deletes every file it doesn't recognize in a directory it shares with xsnap.
  - Pending acknowledgments are lost when a transaction fails in `flush_acknowledgments`, `publish_snapshot` or `compact`.
  - The tests still use `t` for transcripts, and one concept has three names: `blob_store`, `cas_directory` and `ContentAddressedStore`.
- The PR stays draft whatever the code review says: the evidence ledger holds it until the maintainer reviews #1370. The successor job `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat` owns the rest of the work.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3146403 cached reads)
- Output: 14104 tokens
- Cost: $3.2538956
- Wall-clock: 4934s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
