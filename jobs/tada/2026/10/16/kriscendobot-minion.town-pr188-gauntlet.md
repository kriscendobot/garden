gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/minion.town/pull/188
repo: kriscendobot/minion.town
pr_number: 188
build_job: minion-town-ui-gutter-live-refresh
kind: feature
stage: fix
iteration: 8
max_iterations: 8
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: producer
created_at: 2026-10-15T06:11:54Z
arc: minion-town-ui
# gauntlet kriscendobot-minion.town-pr188-gauntlet — review budget reached

Applied 8 panel/fix round(s); fix round 8 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=8, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr188-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 8/8 · cost so far: $13.35
Trend: r1 n/a; r2 n/a; r3 n/a; r4 n/a; r5 raised 20; r6 n/a; r7 n/a; r8 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r8] engine-realist: should-fix: a window focus hides the gutter mid-click and swallows the click.
[new, since r8] engine-realist: (deploy/aws/www/shell.js:375) Where: deploy/aws/www/shell.js:375 wires a refresh on window focus. shell.js:934 runs onRequest, which ...
[new, since r8] engine-realist: Engine reality: in Chromium, WebKit and Gecko, the top-level window gets focus again whenever focus moves back ...
[new, since r8] engine-realist: What breaks: the button is hidden before mouseup. Elements with visibility: hidden are not hit-test targets, ...
[new, since r8] engine-realist: Why tests miss it: the tests dispatch a synthetic focus on a bare EventTarget, which has no hit-testing.
[new, since r8] engine-realist: Fix: keep focus from concealing the gutter. Either drop the focus trigger and rely on visibilitychange (whi...
[new, since r8] engine-realist: should-fix: every iframe-to-parent focus round-trip fires a network read. Once live clips are framed, normal use ...
[new, since r8] engine-realist: (shell.js:315) comment-only: sameClipRecord depends on key order. It uses JSON.stringify equality (shell.js:315), which ho...
[new, since r8] engine-realist: comment-only: the timer type is engine-specific. The setTimeoutImplementation contract returns a number, whic...
[new, since r8] integrator: (designs/clip-shell-framework.md:7) should-fix — The design's API listing doesn't match the gutter's new method. designs/clip-shell-framework.md:7...
[new, since r8] integrator: should-fix — The PR description leaves out a behavior users will see. The last commit (4a452a7, "hide stale c...
[new, since r8] integrator: should-fix — The commit history is review churn. There are nine commits: one feat and one test, then seven ...
… and 8 more
```
