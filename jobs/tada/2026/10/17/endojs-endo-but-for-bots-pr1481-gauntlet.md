---
pr: https://github.com/endojs/endo-but-for-bots/pull/1481
repo: endojs/endo-but-for-bots
pr_number: 1481
build_job: endo-but-for-bots-ocapn-noise-session-reconnect-open-prs
kind: feature
stage: fix
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: producer
created_at: 2026-10-16T20:03:11Z
arc: minion-town-mcp-ocapn
current_child: endojs-endo-but-for-bots-pr1481-gauntlet-fix-6
state: halted
orchestration-status: halted
gauntlet-status: halted
halted_at: 2026-10-17T12:29:02Z
---
# gauntlet endojs-endo-but-for-bots-pr1481-gauntlet — HALTED

stage 'endojs-endo-but-for-bots-pr1481-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 6/6 · cost so far: $15.23
Trend: r1 n/a; r2 raised 20; r3 n/a; r4 n/a; r5 raised 20; r6 raised 20 (fixed 20, carried 0)
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r6] archivist: (packages/ocapn-noise/src/types.d.ts:159) should-fix: stale peerAckedRecvNonce doc. packages/ocapn-noise/src/types.d.ts:159-163 says the value is "und...
[new, since r6] archivist: should-fix: "resume" means two different things. The design reserves "Reconnect with Resume" for Phase 4, which c...
[new, since r6] archivist: should-fix: the heartbeat release note drops the "pending review" caveat. .changeset/ocapn-heartbeat-operations....
[new, since r6] archivist: should-fix: packages/ocapn-noise/README.md documents none of the new behavior. The reconnect option, the get...
[new, since r6] archivist: (types.d.ts:165) comment-only: lastSentNonce doc is incomplete. types.d.ts:165-167 says the value is undefined "without hear...
[new, since r6] archivist: comment-only: ReconnectOptions.backoffMaxMs wording. types.d.ts says the default is "capped by hardTimeoutMs...
[new, since r6] breaker: should-fix — A flapping peer defeats both reconnect bounds (packages/ocapn-noise/src/network.js, attach, l...
[new, since r6] breaker: Claimed invariants: the 10-minute hard timeout bounds the time spent without a live transport, and backoff paces redi...
[new, since r6] breaker: Attack: the peer completes the Noise handshake and op:session-hello, then resets the connection at once.
[new, since r6] breaker: Effect:
[new, since r6] breaker: attach calls stopReconnecting(), which clears hardTimer, so every successful dial restarts the clock.
[new, since r6] breaker: loseInstance then runs scheduleRedial(0), and backoffMs is only advanced after a failed dial.
… and 8 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
