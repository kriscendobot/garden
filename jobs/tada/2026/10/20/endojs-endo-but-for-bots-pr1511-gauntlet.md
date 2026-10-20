---
pr: https://github.com/endojs/endo-but-for-bots/pull/1511
repo: endojs/endo-but-for-bots
pr_number: 1511
build_job: build-ocapn-noise-session-reconnect-phase-two-open-pr
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 2
max_stage_retries: 2
created_by: producer
created_at: 2026-10-19T22:42:21Z
arc: endo-ocapn-background
current_child: endojs-endo-but-for-bots-pr1511-gauntlet-panel-2
state: halted
orchestration-status: halted
gauntlet-status: halted
halted_at: 2026-10-20T02:02:03Z
---
# gauntlet endojs-endo-but-for-bots-pr1511-gauntlet — HALTED

stage 'endojs-endo-but-for-bots-pr1511-gauntlet-panel-2' (panel) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: panel stage reported panel-error (seat/decider error or interruption — a sensor failure, not a review verdict)

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 2/6 · cost so far: $2.71
Trend: r1 n/a; r2 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r2] archivist: should-fix: packages/ocapn/src/client/send-queue.js (header paragraph beginning "A transport instance may inste...
[new, since r2] archivist: Verified not a problem: the rule: packages/ocapn/AGENTS.md JSDoc and typedef claims about advanceEpoch, close...
[new, since r2] archivist: comment-only: designs/ocapn-noise-session-reconnect.md § Phase 2 status (around line 670) says "Every serializ...
[new, since r2] archivist: The design doc's § 4 cross-reference resolves to ### 4. Noise Sequence Continuity Across Reconnects, which covers ...
[new, since r2] archivist: The "20 s stall queues and replays" and "35 s stall declared lost" claims match send-queue.test.js (advanceAll 20...
[new, since r2] archivist: The interposeWriter / _stall-injector.js description matches the test harness.
[new, since r2] archivist: The heartbeat epoch-from-session change, the ocapn.js JSDoc on sendQueue, and the changeset text are consistent w...
[new, since r2] coverage-auditor: (packages/ocapn/src/client/send-queue.js:118) packages/ocapn/src/client/send-queue.js:118, non-Error rejection path. error instanceof Error ? error : Error(...
[new, since r2] coverage-auditor: (packages/ocapn/src/client/send-queue.js:149) packages/ocapn/src/client/send-queue.js:149, advanceEpoch after close() throws. No test calls advanceEpoch...
[new, since r2] coverage-auditor: (send-queue.js:150) send-queue.js:150, epoch-exhaustion RangeError: accepted. Reaching 2n 64n - 1n advances needs 2^64 trans...
[new, since r2] coverage-auditor: Platform arm: no action required. The C-platform-arm probe fired on the test:xs: "exit 0" stub in packages/o...
[new, since r2] coverage-auditor: proposed-rule: when the gate dispatches a coverage-auditor with "no c8 coverage report", it should not spend a ...
… and 8 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
