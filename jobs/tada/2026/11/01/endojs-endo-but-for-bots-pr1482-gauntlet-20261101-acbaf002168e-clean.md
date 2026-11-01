The clean stage for endojs/endo-but-for-bots#1482 (crossed-hellos tiebreaker on reconnect) is done: I made no changes, and CI is green at head `acbaf002168e`.

**Coverage pass.** I ran the reconnect, crossed-hellos, session-queue, network, heartbeat and integration tests under c8 with ses-ava. All 74 tests passed. The worktree's `node_modules` was stale, so I reinstalled it with the classic node-modules linker first.
- `src/crossed-hellos.js` has 100% coverage, including the case where both sides have the same ephemeral key.
- `src/network.js` is at 94% of statements. Of the lines this PR adds, only one branch is never run: the redial-with-backoff case at lines 1392–1396. It handles a dial that finishes after the session has already moved past that epoch and the newer instance has also dropped. Reaching it needs a several-step timing race between the two sides. A test for it would likely be flaky, so I didn't add one.
- One other branch at line 2222 isn't fully exercised. It's an existing guard against the session's reconnector being replaced mid-handshake (the base branch already had it), so it isn't new or orphaned code.

**Dead code.** The change orphaned nothing. The old `resumes` check was reworked into `known` plus the epoch and own-dial-preference test, and the first handshake's `settle` comparison is still in use alongside the new reconnect tiebreaker.

**Push.** None, since nothing changed. I reverted a file-mode change to `packages/relay-server/src/index.js` that the reinstall made.

**CI.** `ci-wait-merge.sh --no-merge` exited 0: 35 checks, none failed (17 passed, 18 skipped).

**Follow-up (optional).** If the panel wants coverage of the redial path at lines 1392–1396, it would need a test helper that can lose a dial's completion and then cut the line again while a stale dial is still in flight.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-20261101-acbaf002168e-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1245896 cached reads)
- Output: 7513 tokens
- Cost: $0.9853191999999998
- Wall-clock: 191s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
