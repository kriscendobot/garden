---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-07T20:28:53Z
job: improve-bound-recursive-deadline-splits
claim: e0997da02c0ae0d0
---
Bounded indivisible deadline-split lineage at one expanded successor. post-plan now records root/parent/depth/max-depth metadata, promotion preserves it, and reaper parks a second wall-hit under the deduplicated expanded-window-overrun signature with an actionable notice instead of recursively minting another orchestrator/child. The held plan and notice preserve the original work body; legacy indivisible children are dual-read from split-indivisible-reason.

Delivered: 56e994d1bcde0d843764386aa75fb5d2da5d71c7 on origin/main2.
Verification: retry-narrowing-test.sh 24/24; reaper-doom-park-test.sh 12/12; promote-plan-doom-reset-test.sh 35/35; timeout-classifier-test.sh 42/42; bash -n, git diff --check, and shellcheck completed with no errors (informational pre-existing source/single-quote notices only).
Self-improvement: nothing this time.
