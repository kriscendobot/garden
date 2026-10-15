gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/garden-book/pull/15
repo: kriscendobot/garden-book
pr_number: 15
build_job: garden-book-illuminations-republish-20261014
kind: feature
stage: fix
iteration: 8
max_iterations: 8
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: producer
created_at: 2026-10-14T04:07:45Z
arc: garden-book
# gauntlet kriscendobot-garden-book-pr15-gauntlet — review budget reached

Applied 8 panel/fix round(s); fix round 8 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=8, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-garden-book-pr15-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 8/8 · cost so far: $16.93
Trend: r1 n/a; r2 n/a; r3 n/a; r4 n/a; r5 n/a; r6 n/a; r7 n/a; r8 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r8] archivist: (art/chapter-illustrations-brief.md:5) Must-fix — art/chapter-illustrations-brief.md:5-7 still says filenames, SVG construction, responsive markup, and ...
[new, since r8] breaker: must-fix — makePublishContent’s regex ignores valid unquoted src attributes. With index.html containing i...
[new, since r8] corner-prober: (build/publish-book.mjs:20) must-fix-loop build/publish-book.mjs:20-36 only recognizes quoted src attributes and stops an img tag a...
[new, since r8] coverage-auditor: tools/browser-check.mjs adds a browser-platform arm, but no browser-test/ Playwright case executes it under the ...
[new, since r8] decomplector: (build/publish-book.mjs:14) Must-fix: build/publish-book.mjs:14-76 reparses rendered HTML to reconstruct an asset manifest, introducing URL...
[new, since r8] fast-checker: (test/build.test.mjs:368) test/build.test.mjs:368 spot-checks only three normalized relative-image spellings. Add fc.assert(fc.asyncProperty...
[new, since r8] gateway: (package.json:22) package.json:22 adds root-level fast-check, with its lockfile entries in package-lock.json. The commit message ...
[new, since r8] integrator: Must-fix: PR title describes only the artwork replacement, but the diff also introduces a breaking binary-tre...
[new, since r8] integrator: (package.json:3) Must-fix: package.json:3 declares version 2.0.0, while build/publish-book.mjs:152 still identifies the MCP ...
[new, since r8] integrator: (art/chapter-illustrations-brief.md:6) Must-fix: art/chapter-illustrations-brief.md:6 still assigns “SVG construction” to the next production stag...
[new, since r8] locksmith: (build/publish-book.mjs:30) must-fix — build/publish-book.mjs:30-86 lets index.html choose which sibling WebP files the privileged bui...
[new, since r8] packager: (package.json:3) must-fix — Commit 1890df4 is labeled test-only but also bumps package.json:3 and package-lock.json:3,9 fr...
… and 8 more
```
