---
pr: https://github.com/endojs/endo-but-for-bots/pull/1575
repo: endojs/endo-but-for-bots
pr_number: 1575
build_job: 
kind: feature
max_iterations: 9
max_resumes: 6
max_stage_retries: 2
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-27T07:12:24Z
arc: 
added_rounds: 3
stage: fix
iteration: 9
resumes: 0
stage_retries: 0
current_child: endojs-endo-but-for-bots-pr1575-gauntlet-fix-9
state: running
resumed_at: 2026-10-31T00:46:46Z
resumed_from_stage: fix
---

# gauntlet endojs-endo-but-for-bots-pr1575-gauntlet — resumed

Resumed at panel (iteration 6, max_iterations 8) from terminal halted report jobs/tada/2026/10/30/endojs-endo-but-for-bots-pr1575-gauntlet.md.

Re-staged 2026-10-31 by endojs-endo-but-for-bots-pr1575-shepherd-20261031: the record was wedged at
current_child panel-6 (done, must-fix) with the driver failing every tick to post fix-6, whose basename
was already in tada/. Out-of-record rounds panel-7, fix-7, and fix-8 had already run; fix-8 pushed head
50871bc2cf with exact-head CI green. The resume jumps to iteration 9 (max_iterations 9) so the remaining
panel/fix pair gets fresh basenames that don't collide with the existing panel-7/fix-8 reports. That is
one more review round, the same budget panel-8/fix-8 would have had.
