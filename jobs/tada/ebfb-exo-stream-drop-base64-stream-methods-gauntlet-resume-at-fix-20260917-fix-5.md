FIX round 5 complete for endojs/endo-but-for-bots PR #1100.

**What I found on resume:** The round-5 fix was already committed and pushed by a prior attempt as `00c2733522` "docs(exo-stream,platform,daemon): address panel round-5 doc/comment consistency". It addresses every item in the latest panel verdict (all archivist/benchmarker **should-fix / comment-only** doc-consistency items) across 10 files: aligns prose with `looksLikeReadableBlob`, documents the `byteLengthLimit` reader default, corrects the wire-cost/benchmark wording after the base64→direct-bytes switch, and de-circularizes the reader-vs-bytes rationale. Nothing must-fix remained unapplied.

**CI drive to green:** The head CI was RED solely from `test (22.x, ubuntu-latest)` — an intermittent `1 unhandled rejection` in the `@endo/daemon` ws-relay test *"connect fails gracefully when peer is unknown to relay"* (a CapTP "Timed out opening relay channel" leak). It reproduced twice but is a node-22/ubuntu-cell-only flake: 24.x ubuntu and both macOS cells passed, and the one-commit-earlier head `e47a1af3` passed green — networking code untouched by this doc-only PR. I re-ran the failed job; it passed. Final run `35186281598` is fully green (25 pass / 7 skipping / 0 fail / 0 pending).

**Changes this attempt:** no code changes (fix already pushed); re-ran the flaky CI job to green. Recorded the recurring ws-relay flake in memory for future gauntlet stages.

**Follow-ups:** none — driver will re-post panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s)
- Input: 348 tokens (13866372 cached reads)
- Output: 73809 tokens
- Cost: $11.267071
- Wall-clock: 3744s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
