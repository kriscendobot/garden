# Fix round 1 for endojs/endo-but-for-bots PR #1527: fix pushed, CI green

The one failing item from the style pre-pass is fixed, and CI on the new head finished green: all 35 checks passed and `ci-wait-merge` returned 0.

**What I did:**
- **The failing check (`typist-friendly-code-points`, `designs/daemon-xs-worker-snapshot.md:319`):** I replaced the Unicode `→` arrows with ASCII `->` in plan item 15 ("Integration test: full supervisor round-trip"). That covers lines 319 and 320, since the same sentence continues onto line 320 and that line is also part of this PR's diff. Other `→` characters elsewhere in the file come from the base branch and were not flagged, so I left them alone.
- **The non-blocking comment-length warning (`rust/endo/src/endo.rs:862`):** I kept the comment. It explains why the GC root is released on the first outbound frame (that frame proves the restore worked) and what happens if the worker dies first (the channel closes and the lease drops). That is reasoning the nearby code doesn't show, not a description of it.
- **Commit and push:** commit `49a6fd78c`, "docs(daemon): type ASCII arrows in the round-trip test item". I pushed it with `safe-push-pr-head.sh` in advance mode to the head branch `build-daemon-xs-worker-snapshot-supervisor-round-trip-test`, moving it from `610f15dfd` to `49a6fd78c`.
- **CI:** I waited with `ci-wait-merge.sh --no-merge` and a 3600s deadline. It went green after about 2800s.

**Follow-ups:** none from me. Per the gauntlet design, the driver re-posts the next panel round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1527-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (814999 cached reads)
- Output: 3495 tokens
- Cost: $0.6035797999999999
- Wall-clock: 3093s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
