gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/garden-book/pull/15
repo: kriscendobot/garden-book
pr_number: 15
build_job: garden-book-illuminations-republish-20261014
kind: feature
stage: fix
iteration: 10
max_iterations: 10
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: producer
created_at: 2026-10-14T04:07:45Z
arc: garden-book
# gauntlet kriscendobot-garden-book-pr15-gauntlet — review budget reached

Applied 10 panel/fix round(s); fix round 10 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=10, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-garden-book-pr15-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 8** · verdict: moving target · rounds spent: 10/10 · cost so far: $20.82
Trend: r1 n/a; r2 n/a; r3 n/a; r4 n/a; r5 n/a; r6 n/a; r7 n/a; r8 raised 20; r9 n/a; r10 raised 8
Classes: 0 persistent, 8 new in last round, 0 addressed-then-reintroduced
```text
[new, since r10] pruner: PR body, Verification paragraph recites test tallies. The paragraph gives scroll widths (390/390, 1440/1440), a f...
[new, since r10] pruner: PR body, Playwright and fast-check paragraphs repeat the README and test headers. "Playwright is not a dependency...
[new, since r10] pruner: tools/browser-check.mjs, file header restates the measureEdition JSDoc. Header lines 4–6 ("A local edition ...
[new, since r10] pruner: tools/browser-check.mjs, JSDoc (at)param lines restate names. options.browser Playwright browser. adds nothing...
[new, since r10] pruner: (tools/browser-check.mjs:47) Borderline, acknowledge: tools/browser-check.mjs:47, "Playwright's headless-shell directory and executable for ...
[new, since r10] spec-keeper: (tools/browser-check.mjs:271) should-fix — tools/browser-check.mjs:271: CSP violations are found by matching /Content Security Policy/ ag...
[new, since r10] spec-keeper: (build/publish-book.mjs:76) comment-only — build/publish-book.mjs:76: ^\x00-\x7f leaves DEL (U+007F) unescaped. CPython's json esca...
[new, since r10] spec-keeper: (test/illustrations.test.mjs:21) comment-only — test/illustrations.test.mjs:21-23: the VP8L branch does not check the 0x2f signature byte at...
```
