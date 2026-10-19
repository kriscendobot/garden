The gauntlet can start on PR #1510. It is open and not superseded, and the gap it was built to close is still there on the current base. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** open, draft, not merged. It was opened 2026-10-19 at 21:49Z by the job `build-endo-fs-from-git-phase-four-compose-interop-open-pr`. The base is `llm-92b91a7` (`92b91a7e93`) and the head is `endo-fs-from-git-phase-4-compose-interop` at `b1b2735f6c`. It has no comments and no reviews.

Deciding question: Is Phase 4 of `designs/endo-fs-from-git.md` ("Compose interop and integration") still unfinished on the current base, with no newer PR having delivered it?

Evidence:
- **Phase 4 is still open:** on the current `llm` tip, the Phase 4 checklist in `designs/endo-fs-from-git.md` (line 344 onward) is still unchecked. That covers `compose` working end-to-end and the cached-read check for `withCachedReads`. This PR is what ticks those items.
- **The base is current:** comparing the frozen base `92b91a7e93` with `llm` shows 0 commits ahead and 0 behind. No newer base history touches `exo-git`, `daemon/test/git`, the design doc, or `fs/extended`.
- **Nothing newer does the same work:** searching PRs for "filesystemAt compose" and "endo-fs-from-git phase 4" finds only older, merged work: #374 (Phases 1–3), #707 and #614 (agent-tools). The open #807 is a related design about reconciling `tree(ref)` and `filesystemAt(ref)`. The PR body records that #807 has no outstanding changes-requested review, and #807 does not implement these tests.
- **The PR's premise matches its contents:** it says Phase 4 needs only tests and docs because the existing path already supports every behavior. The diff fits that: only `packages/daemon/test/git.test.js`, `packages/exo-git/README.md` and the design doc change, with no `src/` edits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1510-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155477 cached reads)
- Output: 1666 tokens
- Cost: $0.3657114
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
