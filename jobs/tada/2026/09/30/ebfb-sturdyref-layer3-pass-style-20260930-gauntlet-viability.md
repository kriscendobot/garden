**Viability for endojs/endo-but-for-bots#1392: proceed.** The gauntlet may begin. I made no changes and spent no clean, panel, fix, CI-wait or un-draft budget. The check itself finished last session; it came back only because the completion signal wasn't on the very last line. This time the signal is last and the stage marker sits just above it.

PR facts: the PR is OPEN, draft and unmerged. It was opened 2026-09-30T06:36Z from head `build/sturdyref-pass-style-recognition`. Its base is `build/sturdyref-ses-accommodation-a0ef0c4`, which is layer 2 (#1391). It has no reviews and no comments yet.

Deciding question: Is SturdyRef pass-style recognition (layer 3) still unimplemented on `llm`, and does the maintainer still want it as a layer of the SturdyRef stack?

Evidence:
- **The need still holds.** kriskowal's comment on #695 (5903472512, 2026-09-30T03:28Z) lists this exact item as step 3 of 9: "an accommodation for SturdyRef in pass style, analogous to presences, such that SturdyRefs can be recognized as such and admitted to the domain of passable values."
- **Nothing on `llm` does this yet.** `packages/pass-style/src` on `llm` has no `sturdyref.js`. The recent pass-style commits there (the latest is 2026-09-29) have nothing to do with SturdyRef.
- **No newer PR displaces it.** The only other open pass-style SturdyRef PR is #737, from July. #1392 takes #737's test framing and pass-style name, and drops #737's tag-record shape because it conflicts with the layer-1 handler contract (#1389/#774). So #1392 replaces #737, not the other way round. #521 is already closed.
- **Its lower layers are live.** #774, #1389 and #1391 are all open, and #1392 is correctly stacked on #1391.

Follow-up for the maintainer: #737 now looks superseded by #1392. That is for them to decide; this job does not close it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (226679 cached reads)
- Output: 2338 tokens
- Cost: $0.9079674
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
