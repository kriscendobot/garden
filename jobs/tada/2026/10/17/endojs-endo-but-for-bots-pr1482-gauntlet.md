gauntlet-status: review-budget-reached
pr: https://github.com/endojs/endo-but-for-bots/pull/1482
repo: endojs/endo-but-for-bots
pr_number: 1482
kind: feature
stage: fix
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-16T20:17:36Z
# gauntlet endojs-endo-but-for-bots-pr1482-gauntlet — review budget reached

Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1482-gauntlet panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 6/6 · cost so far: $17.03
Trend: r1 n/a; r2 n/a; r3 n/a; r4 n/a; r5 raised 20; r6 raised 20 (fixed 20, carried 0)
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r6] breaker: should-fix: the deference bound resets on every redial, so a winner whose dials keep failing can hold the session d...
[new, since r6] breaker: (src/network.js:395) The claim: the typedef at src/network.js:395-398 says the first dropped dial "in a run of redials starts the window...
[new, since r6] breaker: The problem: the finally at :1372 clears deferringSince whenever dialing === 0, and that happens after every ...
[new, since r6] breaker: Attack 1: the winner W's transport.connect rejects after time T, with T shorter than sessionTimeoutMs (for exampl...
[new, since r6] breaker: Attack 2: W's connect succeeds but the handshake stalls (data dropped after the SYN). connectedDials 0 makes W de...
[new, since r6] breaker: In both cases, once handshakeTimeoutMs is at least backoffMaxMs, W is dialing for most of each cycle. L's backed-...
[new, since r6] breaker: (test/reconnect.test.js:302) The only test, test/reconnect.test.js:302, covers a connect that never returns, so neither attack is exercised.
[new, since r6] breaker: Fix: keep deferringSince until attach or current == undefined, not until dialing === 0. Also start the windo...
[new, since r6] breaker: proposed-rule: a time bound described as covering "a run" must be reset only where the run ends (here, attach or abo...
[new, since r6] breaker: comment-only: a dial that connects late can make the two sides attach different instances at the same epoch.
[new, since r6] breaker: Attack: W's deference expires, so W accepts L's dial A and attaches it at epoch e+1. At the same moment, W's hung con...
[new, since r6] breaker: Each side then closes the other's instance through the current == undefined branch at :1380. Both lose their ins...
… and 8 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
