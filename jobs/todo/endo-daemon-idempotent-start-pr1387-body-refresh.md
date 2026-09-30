---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# PR #1387: refresh the body and post the follow-up summary comment

Repo: endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1387 (head `feat/daemon-idempotent-start`). The code is already pushed (dc9f9a251). Host oros-studio-garden-ce242c49's PAT gets a 403 on PR writes, so this job is pinned to endolin. Do not change any code.

1. Replace the PR body with the text between the BODY markers: `gh pr edit 1387 -R endojs/endo-but-for-bots --body-file <file>`. Keep the `<!-- garden-job: endo-daemon-idempotent-start-build -->` marker.
2. Post the text between the COMMENT markers as a top-level comment: `gh pr comment 1387 -R endojs/endo-but-for-bots --body-file <file>`.

----- BODY -----
Phase 1 of the daemon lifecycle idempotency design proposed in https://github.com/endojs/endo-but-for-bots/pull/1383, sections 1 and 2. Motivation: the deploy workarounds in kriscendobot/minion.town#130 and kriscendobot/minion.town#137.

## `start` is idempotent (section 1)

- `start()` in `packages/daemon/index.js` probes before it cleans. If a daemon is serving the socket, it prints `endo daemon already running (pid N)` and succeeds without touching anything.
- If a live process owns the new state lock but is not serving yet, that daemon is still booting. `start` waits for it, for up to 60 s, instead of replacing it. If only the older socket-lock marker names a live pid, `start` waits the window `socket-lock.js` already gives a silent owner (4 × 125 ms), then treats the marker as abandoned, which is how the lock treats it.
- If a concurrent `start` wins the race between this start's probe and its spawn, this start's daemon declines with `EX_UNAVAILABLE`. This start then waits for the winner to serve and succeeds.
- `clean()` leaves the socket, both lock markers, and `endo.pid` alone while their owner is alive or the socket answers.
- `endo start --force` and `endo clean --force` skip the socket probe and ignore a live socket-lock owner, as before. They never remove the files of a live daemon that holds the state lock, because doing so would only orphan it: a new daemon still could not claim its state. `start --force` against a live daemon therefore fails with `another Endo daemon (pid N) owns <state>`, and the first daemon keeps serving.
- A socket-lock marker whose pid is alive but not serving does not block a plain `clean`. The socket lock reclaims such a marker itself, since the pid may have been recycled.
- The probe runs before the `ENDO_BIN` branch, so the engo path shares it.

## Early single-instance lock (section 2)

- `manager-node.js` `main()` claims `<ephemeral>/endo.lock` before `makeDaemonicPowers`, `initializePersistence()`, and `killStaleWorkers()`. The lock is held for the life of the process and released by an `exit` handler. A daemon that is SIGKILLed leaves a marker whose owner is dead, and the next claim reclaims it.
- The marker is an exclusive `symlink`, like the socket lock, and records `<pid>:<start time>`. On Linux the start time comes from `/proc/<pid>/stat`, so a recycled pid does not make a dead owner look alive.
- The loser prints `another Endo daemon (pid N) owns <state>`, reports it to its parent, and exits 69 (`EX_UNAVAILABLE`) without touching workers or the database. `endo run-daemon` passes the 69 on.
- `endo.pid` is written right after the claim. `updateRecordedPid` no longer kills the pid it replaces.

## Tests

`packages/daemon/test/daemon-lifecycle-idempotency.test.js`:

- running `start` twice leaves one daemon: the same pid, still serving, and one `manager-node.js` against the state;
- `start` while the first daemon is booting waits for it;
- three concurrent `start`s leave one daemon;
- a second `run-daemon` against the same state exits 69 with the message, and the first daemon, its `endo.pid`, and its workers all survive.
- `start --force` against a live daemon fails with the decline message, and the first daemon, its `endo.pid`, and its socket all survive. This test fails against the first commit, whose `clean --force` removed the state lock.

`socket-lifecycle.test.js` and `daemon-teardown.test.js` still pass.

## Not in this PR

- The same claim in the Go `engo` supervisor, and the Node-vs-engo contention test the design lists for phase 1. `manager-go.js` and `bus-manager-*.js` do not run `killStaleWorkers` and do not kill the pid they replace. Implementing the Go side of the marker format is left as a follow-up.
- On Windows the symlink marker cannot be created without privileges, so the state lock is skipped there, as the socket lock already is.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endo-daemon-idempotent-start-build -->


----- END BODY -----

----- COMMENT -----
Follow-up in dc9f9a251:

- **Bug fix:** `clean({ force: true })` removed the state lock, so `endo start --force` against a live daemon let a second daemon claim the same state directory, which is the outcome section 2 exists to prevent. `clean` now leaves every file alone while a live process holds the state lock, with or without `--force`.
- A plain `clean` is no longer blocked forever by a socket-lock marker whose pid is alive but not serving (a recycled pid).
- New test: `start --force` against a live daemon declines, and the first daemon keeps its `endo.pid` and keeps serving. The test fails against b36b90d4b.
- Prettier fix for `packages/cli/src/endo.js`, which failed the lint job.

Local: `daemon-lifecycle-idempotency.test.js` (5/5), `socket-lifecycle.test.js`, and `daemon-teardown.test.js` pass. eslint reports no errors on the changed files, and `tsc` passes for `@endo/daemon`.

----- END COMMENT -----
