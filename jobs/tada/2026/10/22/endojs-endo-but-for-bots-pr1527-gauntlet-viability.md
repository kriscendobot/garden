**Gauntlet viability: endojs/endo-but-for-bots#1527** (draft, "feat(endo): XS worker snapshot GC roots + supervisor round-trip test")

**Result:** the gauntlet may proceed. Nothing newer has displaced this PR, and the work it targets is still listed as unfinished on `llm`.

Deciding question: Does current `llm` still list "ephemeral GC root bookkeeping" and "full supervisor round-trip integration test" as unfinished Phase 2 work in `daemon-xs-worker-snapshot`, with no merged change that implements them?

Evidence:
- **PR state:** open, unmerged, draft. It was opened 2026-10-22T02:03Z by build job `build-daemon-xs-worker-snapshot-supervisor-round-trip-test`. It has no reviews or comments yet. Its base is the pinned snapshot `llm-54d3d2a`.
- **Base is current:** comparing `54d3d2a…` with `llm` shows `llm` is 0 commits ahead, so no newer base history touches the supervisor, the endo/inproc/proc sources, or the design doc.
- **The motivating gap still holds:** `designs/daemon-xs-worker-snapshot.md` on `llm` lists both items under "Phase 2 … #### Remaining". On `llm`, `rust/endo/src/supervisor.rs` has `mark_suspended`/`mark_suspended_store` but no `gc_root`, `is_gc_root` or `GcRootLease`. Its newest change (50f547f71a, 2026-09-30) only retired the store's integrity machinery and doesn't touch GC roots.
- **Overlapping older PR:** #281 ("ephemeral GC roots for suspended-worker snapshots", 2026-05-18) is still open and unmerged, with a stale CHANGES_REQUESTED review from kriskowal asking for a refresh. It covers only the GC-root half and doesn't supersede #1527. If #1527 lands, #281 most likely becomes the redundant one.
- **Known limitation, not a viability problem:** the round-trip test in #1527 is `#[ignore]`d. Locally the in-process worker segfaults right after its first `handleCommand`, and the PR says a successor job owns that crash.

Follow-up for the maintainer: once #1527 merges, consider closing #281 as superseded by it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1527-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (235677 cached reads)
- Output: 2234 tokens
- Cost: $0.4662154
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
