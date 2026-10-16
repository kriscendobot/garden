gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/garden-book/pull/15
repo: kriscendobot/garden-book
pr_number: 15
build_job: garden-book-illuminations-republish-20261014
kind: feature
stage: fix
iteration: 13
max_iterations: 13
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: producer
created_at: 2026-10-14T04:07:45Z
arc: garden-book
# gauntlet kriscendobot-garden-book-pr15-gauntlet — review budget reached

Applied 13 panel/fix round(s); fix round 13 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=13, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-garden-book-pr15-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 13/13 · cost so far: $27.65
Trend: r1 n/a; r2 n/a; r3 n/a; r4 n/a; r5 n/a; r6 n/a; r7 n/a; r8 raised 20; r9 n/a; r10 raised 8; r11 n/a; r12 raised 20; r13 raised 20 (fixed 20, carried 0)
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r13] archivist: (art/MANIFEST.md:3) should-fix: art/MANIFEST.md:3 says "The illuminated set is committed as same-origin WebP images with explicit d...
[new, since r13] archivist: should-fix: art/MANIFEST.md:line 40 (the "Illuminated chapter and section set" intro) says OPENAI-ILLUMINATIO...
[new, since r13] archivist: comment-only: build/README.md (test paragraph) says test/browser-check-chromium.test.mjs "is skipped otherwis...
[new, since r13] archivist: comment-only: build/README.md says publish.mjs publishes with garden-book-inert (POWERS_NAME). The consta...
[new, since r13] archivist: comment-only: build/README.md says publishing "refuses any declared plate that is not a .webp file in the out...
[new, since r13] archivist: comment-only: art/chapter-illustrations-brief.md:line 484 still reads as pre-integration ("The proposal contai...
[new, since r13] archivist: comment-only: art/OPENAI-ILLUMINATIONS.md records process details (the Chromium Canvas WebP encode at quality 0...
[new, since r13] breaker: should-fix: an MCP tool error from writeText doesn't stop the publish. The new comment at build/publish-book.m...
[new, since r13] breaker: comment-only: pythonJson doesn't quite mirror Python's json.dumps for DEL. The comment says it "mirrors the ...
[new, since r13] breaker: comment-only, mitigated: plate dimensions and ratios. illuminations.mjs declares width/height/ratio, and ...
[new, since r13] breaker: comment-only, out of scope: a caller-supplied plates list can omit a referenced plate. makePublishContent pub...
[new, since r13] breaker: comment-only, mitigated: plate names can't escape the output directory. The plate-name regex ^A-Za-z0-9A-Za-z...
… and 8 more
```
