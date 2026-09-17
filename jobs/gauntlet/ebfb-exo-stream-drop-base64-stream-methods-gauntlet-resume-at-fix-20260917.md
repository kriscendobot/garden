---
pr: https://github.com/endojs/endo-but-for-bots/pull/1100
repo: endojs/endo-but-for-bots
pr_number: 1100
build_job: ebfb-exo-stream-drop-base64-stream-methods-gauntlet
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-3
state: running
created_by: gardener
created_at: 2026-09-17T00:57:47Z
---

# gauntlet ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917

Resume of the halted staged gauntlet over https://github.com/endojs/endo-but-for-bots/pull/1100 from FIX round 2 after
endojs/endo-but-for-bots#1100 was pinned and rebased onto current llm. The prior
fix-2 report halted only because base drift made the merge ref red; the weave
semantically ported the three newly entrained byte-reader limit call sites and
verified the rebased head green. This run deliberately resumes at fix-2, not at
viability, clean, or panel.
