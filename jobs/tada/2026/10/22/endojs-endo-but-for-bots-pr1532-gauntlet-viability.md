## PR #1532 viability: overtaken

PR #1532 has been displaced by #1527, which is earlier, does more, and is already further through its own gauntlet. I spent no clean, panel, fix, CI-wait or un-draft budget on #1532.

**Deciding question:** Is #1532 the only live implementation of the Phase 2 "ephemeral GC root bookkeeping for CAS-stored snapshots" item, and does that item still need doing on its base? **Answer: no.** The item does still need doing, but #1532 is not its only live implementation.

**Evidence:**
- **#1532:** it is open, a draft, created 2026-10-22T04:37Z and has no reviews. Its base is `llm-54d3d2a`, which is level with `llm` (0 commits ahead). It changes `rust/endo/src/supervisor.rs` (+121), `rust/endo/src/endo.rs` and `designs/daemon-xs-worker-snapshot.md`. The builder job `build-daemon-xs-worker-snapshot-next-phase-open-pr` opened it.
- **The need is real:** on `llm`, the design doc still lists "Ephemeral GC root bookkeeping for CAS-stored snapshots" as a remaining Phase 2 item.
- **#1527 already covers it.** It was opened 2026-10-22T02:03Z by `build-daemon-xs-worker-snapshot-supervisor-round-trip-test`, on the same base `llm-54d3d2a`.
  - It does the same thing: `mark_suspended` pins the snapshot SHA-256 in a ref-counted root set (`gc_roots()`, `is_gc_root()`), and a `GcRootLease` releases the root after the restore has read the blob.
  - It also adds the supervisor round-trip integration test. That test is currently `#[ignore]`d because of a SIGSEGV, and a successor job owns the crash.
  - It touches the same files, `supervisor.rs`, `endo.rs` and the design doc, so the two PRs would conflict.
  - Its gauntlet is already under way: `jobs/gauntlet/endojs-endo-but-for-bots-pr1527-gauntlet.md` is on the board and `jobs/todo/endojs-endo-but-for-bots-pr1527-gauntlet-clean.md` is queued.
- **#281 is a third, older version** of the same feature ("ephemeral GC roots for suspended-worker snapshots", based on `llm`). It is stale, with kriskowal's "Please refresh" CHANGES_REQUESTED.
- **The approaches differ in one way.** #1532 holds the root until the restored incarnation exits. #1527 releases it once the restore has read the blob (on the first frame or exit, or at hand-off for a child process). That difference is a design choice for review of #1527, not a reason to run two parallel gauntlets.

Option: close as superseded

**Follow-ups for the maintainer:**
1. Close #1532 as a duplicate of #1527.
2. If you prefer #1532's hold-until-exit lifetime, fold it into #1527 during its fix loop. #1532's `cas_gc_keeps_suspended_snapshot` test, which runs real `ContentStore` GC, is worth carrying over.
3. Separately, #281 is a third, stale copy of this feature and is a candidate to close as well.
4. The "next-phase" builder chose this item without checking for #1527, an open draft PR on the same item, so it built a duplicate.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1532-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (294717 cached reads)
- Output: 3135 tokens
- Cost: $0.5045794
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
