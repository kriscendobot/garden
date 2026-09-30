---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the draft PR for endo-daemon-idempotent-start-build

The builder job `endo-daemon-idempotent-start-build` (repo endojs/endo-but-for-bots; implements §§ 1–2 of the design proposed in https://github.com/endojs/endo-but-for-bots/pull/1383) finished and pushed its code, but the bot token on host oros-studio-garden-ce242c49 is refused on `createPullRequest`. Your ONLY task is to open the DRAFT PR from a host where the token can.

1. Confirm with `git ls-remote https://github.com/endojs/endo-but-for-bots.git` that `refs/heads/feat/daemon-idempotent-start` is at `b36b90d4b7c51cebc519fc964a58e42e4de8be09` and `refs/heads/llm-7ff30af` is at `7ff30afbce95f60d21ff3ae385bd9a17ed0850db`. If the head has moved, use the new tip anyway, but say so in your report.
2. Write the PR body below, between the BODY markers and word for word, to a file. Then run the following from an isolated project checkout (`scripts/jobs/ensure-project-worktree.sh endo-daemon-idempotent-start-open-pr endojs/endo-but-for-bots feat/daemon-idempotent-start`):
   `scripts/jobs/gardening/ensure-pr.sh endo-daemon-idempotent-start-build endojs/endo-but-for-bots feat/daemon-idempotent-start llm-7ff30af --title "feat(daemon): idempotent start and an early single-instance state lock" --body-file <file>`
   Use the ORIGINAL job base `endo-daemon-idempotent-start-build` as the first argument so the PR carries that job's marker, and so that a successful build stages the gauntlet against the right job.
3. Do not change any code, and do not rebuild. Report the PR URL.

----- BODY -----
Phase 1 of the daemon lifecycle idempotency design proposed in https://github.com/endojs/endo-but-for-bots/pull/1383, sections 1 and 2. Motivation: the deploy workarounds in kriscendobot/minion.town#130 and kriscendobot/minion.town#137.

## `start` is idempotent (section 1)

- `start()` in `packages/daemon/index.js` probes before it cleans. If a daemon is serving the socket, it prints `endo daemon already running (pid N)` and succeeds without touching anything.
- If a live process owns the new state lock but is not serving yet, that daemon is still booting. `start` waits for it, for up to 60 s, instead of replacing it. If only the older socket-lock marker names a live pid, `start` waits the window `socket-lock.js` already gives a silent owner (4 × 125 ms), then treats the marker as abandoned, which is how the lock treats it.
- If a concurrent `start` wins the race between this start's probe and its spawn, this start's daemon declines with `EX_UNAVAILABLE`. This start then waits for the winner to serve and succeeds.
- `clean()` leaves the socket, both lock markers, and `endo.pid` alone while their owner is alive or the socket answers.
- `endo start --force` and `endo clean --force` restore the old unconditional behavior. Under `--force`, a live daemon still holds its state lock, so the new daemon exits 69 and does not share the state.
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

`socket-lifecycle.test.js` and `daemon-teardown.test.js` still pass.

## Not in this PR

- The same claim in the Go `engo` supervisor, and the Node-vs-engo contention test the design lists for phase 1. `manager-go.js` and `bus-manager-*.js` do not run `killStaleWorkers` and do not kill the pid they replace. Implementing the Go side of the marker format is left as a follow-up.
- On Windows the symlink marker cannot be created without privileges, so the state lock is skipped there, as the socket lock already is.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
