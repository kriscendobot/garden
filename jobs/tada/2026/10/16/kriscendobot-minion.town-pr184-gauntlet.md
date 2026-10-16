gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/minion.town/pull/184
repo: kriscendobot/minion.town
pr_number: 184
kind: feature
stage: fix
iteration: 16
max_iterations: 16
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-13T00:17:42Z
# gauntlet kriscendobot-minion.town-pr184-gauntlet — review budget reached

Applied 16 panel/fix round(s); fix round 16 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=16, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr184-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 19** · verdict: moving target · rounds spent: 16/16 · cost so far: $34.02
Trend: r1 raised 20; r2 n/a; r3 raised 20; r4 raised 20 (fixed 20, carried 0); r5 n/a; r6 n/a; r7 raised 20; r8 n/a; r9 n/a; r10 n/a; r11 raised 20; r12 n/a; r13 n/a; r14 n/a; r15 n/a; r16 raised 19
Classes: 0 persistent, 19 new in last round, 0 addressed-then-reintroduced
```text
[new, since r16] breaker: should-fix: the seed check accepts secrets that tokenFromSecret rejects, which breaks the invariant the seed ch...
[new, since r16] breaker: (deploy/aws/ci-runner/provision-ci-runner.sh:75) The comment at deploy/aws/ci-runner/provision-ci-runner.sh:75-76 says a seed "cannot replace a working secret with ...
[new, since r16] breaker: I checked with jq 1.7 and node. jq -e exits 0 on all of these, but JSON.parse rejects each one:
[new, since r16] breaker: {"token":"a"}{"token":"b"} (two JSON texts in one stream)
[new, since r16] breaker: {"token":"ab","x":nan}
[new, since r16] breaker: How it fails: a rotation via --seed-token-stdin (or the probe variant) with stdin holding two concatenated objects ...
[new, since r16] breaker: Fix: validate with the same parser the Lambda uses. Either run node -e importing lambda/github.mjs's tokenFromSe...
[new, since r16] breaker: proposed-rule: when a provisioning-time check guards a run-time invariant, run the run-time parser or validator, not...
[new, since r16] breaker: comment-only (mitigated): "resource policy admits only its EventBridge rule" (DEPLOYMENT.md § Credentials).
[new, since r16] breaker: (provision-ci-runner.sh:182) Attack: plant a stray statement with any Sid. The reconcile loop at provision-ci-runner.sh:182-190 removes every Si...
[new, since r16] breaker: The host role's policy (:203-204) names only $FUNCTION_ARN, so the CI host can't reach the probe credential. The ...
[new, since r16] breaker: The window between remove and add only denies access; it never grants it.
… and 7 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
