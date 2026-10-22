---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the draft PR for Phase 3 (chat integration) of the daemon-debug-worker-restart design in endojs/endo-but-for-bots. The predecessor job `build-daemon-debug-worker-restart-phase-3-chat-integration` did the work, but its host (oros-studio-garden-ce242c49) gets a 403 on `createPullRequest` for endojs. Do NOT change any code. Both branches are already pushed to endojs/endo-but-for-bots:

- head `daemon-debug-worker-restart-phase-3` at `73d34f7e6`, one commit "feat(chat): /debug-restart restarts a worker paused under the debugger (debug worker restart, Phase 3)"
- base `daemon-debug-worker-restart-phase-2-6579612`, a frozen snapshot of #1524's head `65796129c`

Steps:
1. Get a project checkout keyed by THIS job's base: `scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots daemon-debug-worker-restart-phase-3`. Confirm `git rev-parse origin/daemon-debug-worker-restart-phase-3` starts with `73d34f7e6` and its parent is `65796129c`. If the branch has moved, stop and report.
2. Write the PR body below, everything between the BODY markers, to a file. With cwd set to that checkout, run:
   `scripts/jobs/gardening/ensure-pr.sh build-daemon-debug-worker-restart-phase-3-chat-integration endojs/endo-but-for-bots daemon-debug-worker-restart-phase-3 daemon-debug-worker-restart-phase-2-6579612 --title 'feat(chat): /debug-restart restarts a worker paused under the debugger (debug worker restart, Phase 3)' --body-file <file>`
   Pass the PREDECESSOR's base as the first argument so the body carries its `garden-job` marker and a retry adopts the PR instead of duplicating it.
3. Confirm the PR is a draft with the right head and base. Name the PR URL in your completion report so the gauntlet stages.

-----BEGIN BODY-----
Refs: #1524 (Phase 2, `debugWorker`), #1523 (Phase 1, the supervisor debug flag)

## Description

Adds Phase 3 (chat integration) of `designs/daemon-debug-worker-restart.md`.
Typing `/debug-restart <worker>` in Chat now restarts the worker paused under
the XS debugger and opens the debugger panel on it. The worker stops at
`<login>` before it runs any code, so the developer can set breakpoints before
module initialization and the first message dispatch. Then they press Go or
Step.

The command calls `E(host).debugWorker(workerPath)`, the host method from #1524,
and passes the returned `Debugger` to the existing `openDebugger` callback.
That is the same panel `/debug` opens. A nested name such as `apps/worker1`
reaches the daemon as a path (`['apps', 'worker1']`), as the other path-taking
commands do. When `debugWorker` rejects (unknown name, a worker that is not a
shared XS worker, or a platform without the debugger), the command fails
through the executor's ordinary error path and does not open a panel.

The design allowed either a new command or an extension of `/debug`. This PR
adds a separate command. `/debug` attaches to a running worker without
disturbing it, while `/debug-restart` suspends the worker and breaks its live
CapTP references. That difference is worth an explicit verb. The new command
lives in the same `workers` category.

Files to review:
- `packages/spaces-util/src/command-registry.js`: the `debug-restart` entry,
  with one required `petNamePath` field.
- `packages/spaces-util/src/command-executor.js`: the `debug-restart` case.
- `designs/daemon-debug-worker-restart.md`: Phase 3 marked implemented, with
  the manual check still pending.

This PR is stacked on #1524. Its base is the frozen snapshot
`daemon-debug-worker-restart-phase-2-6579612` of that PR's head.

### Phase status

| Phase | State |
|---|---|
| 1. Supervisor debug flag | #1523, open (draft) |
| 2. `debugWorker` on the host | #1524, open (draft), the base of this stack |
| 3. Chat integration | this PR; unit-tested, manual check (`/debug-restart @main` opens the panel paused at login) not yet performed |

### Security Considerations

No new authority. The command uses `debugWorker`, which is already on the
host's interface in #1524. A Chat session can reach it only if it already holds
that host.

### Scaling Considerations

None. A single eventual send happens per command invocation.

### Documentation Considerations

The command appears in the command selector and help modal under Workers
through the registry entry. No separate docs are needed.

### Testing Considerations

`packages/chat/test/unit/command-executor.test.js` adds two tests:
- `/debug-restart` calls `debugWorker` with the split path and opens the
  debugger panel on the returned reference, labeled with the worker name.
- When `debugWorker` rejects, the command reports the error and opens no panel.

`packages/chat/test/unit/command-registry.test.js` checks the registry entry.
I confirmed the first executor test fails when the executor passes the raw
`"apps/worker1"` string instead of the path.

The design asks for one manual check, which has not been performed here:
running `/debug-restart @main` against a daemon on the Rust/XS supervisor
should open the panel with the worker paused at login.

### Compatibility Considerations

This is additive. Existing commands are unchanged.

### Upgrade Considerations

None. `@endo/chat` and `@endo/spaces-util` are private, so this PR has no
changeset.
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T03:14:11Z
