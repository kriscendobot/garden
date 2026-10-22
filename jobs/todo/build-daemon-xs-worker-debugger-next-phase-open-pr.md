---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the draft PR for Phase 7 (host hot-attach over CapTP) of the daemon-xs-worker-debugger design in endojs/endo-but-for-bots. The predecessor job `build-daemon-xs-worker-debugger-next-phase` did the work, but its host (oros-studio-garden-ce242c49) gets a 403 on `createPullRequest` for endojs. Do NOT change any code. Both branches are already pushed to endojs/endo-but-for-bots:

- head `daemon-xs-worker-debugger-host-attach` at `df5ac6d2c`, three commits on the base: "feat(daemon): host attachDebugger and detachDebugger hot-attach the XS debugger", "fix(spaces-util): pass the /debug worker path to attachDebugger as one argument", "docs(daemon): type ASCII arrows in the XS debugger design and help"
- base `daemon-debug-worker-restart-phase-2-6579612`, a frozen snapshot of #1524's head `65796129c`

Steps:
1. Get a project checkout keyed by THIS job's base: `scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots daemon-xs-worker-debugger-host-attach`. Confirm `git rev-parse origin/daemon-xs-worker-debugger-host-attach` starts with `df5ac6d2c` and `git merge-base` with `origin/daemon-debug-worker-restart-phase-2-6579612` is `65796129c`. If the branch has moved, stop and report.
2. Write the PR body below, everything between the BODY markers, to a file. With cwd set to that checkout, run:
   `scripts/jobs/gardening/ensure-pr.sh build-daemon-xs-worker-debugger-next-phase endojs/endo-but-for-bots daemon-xs-worker-debugger-host-attach daemon-debug-worker-restart-phase-2-6579612 --title 'feat(daemon): host attachDebugger hot-attaches the XS debugger (XS worker debugger, Phase 7)' --body-file <file>`
   Pass the PREDECESSOR's base as the first argument so the body carries its `garden-job` marker and a retry adopts the PR instead of duplicating it.
3. Confirm the PR is a draft with the right head and base. Name the PR URL in your completion report so the gauntlet stages.

-----BEGIN BODY-----
Refs: #1524

## Description

Chat's `/debug <worker>` command calls `E(powers).attachDebugger(...)`, but the host never exposed that method, so the command failed with a CapTP method-not-found error. This was the first "Remaining" item after Phase 6 of `designs/daemon-xs-worker-debugger.md`.

This PR adds the host entry point that Layer 6 of the design describes (`E(daemon).attachDebugger('my-worker')`), recorded in the design as **Phase 7: Host hot-attach over CapTP**:

- `EndoHost.attachDebugger(workerNameOrPath)` resolves a pet name to a worker, starts the worker if it is not running, sends `debug-attach`, and resolves to the existing `Debugger` exo once the worker acknowledges.
- `EndoHost.detachDebugger(workerNameOrPath)` returns the worker's debug hooks to dormant. It does nothing if the worker is not running or has no debugger.
- Under the Rust/XS supervisor, the `attachDebugger` / `detachDebugger` control powers now take a worker formula number instead of a bus handle, the same as #1524's `debugWorker`. The host never sees bus handles. They had no callers before this PR.
- The new `packages/daemon/src/debug-attach.js` holds the attach state that used to live inline in `bus-manager-rust-xs.js`:
  - concurrent attaches to one worker share a single `debug-attach`;
  - attaching to a worker that already has a session reuses that session;
  - an acknowledgement is accepted only from the worker that was asked;
  - a worker whose connection closes rejects its pending attach and drops its session, so the caller no longer waits forever.
- A Node.js worker has no XS debugger, so the attach rejects up front instead of waiting for an acknowledgement that never arrives.
- A name that does not designate a worker is refused by `attachDebugger`, `detachDebugger`, and `debugWorker`. `provide` ignores its expected-type argument, so the "refuses a name that does not designate a worker" comment carried over from #1524 did not hold. The check now runs explicitly in a shared `identifyWorker`.
- Chat's `/debug` passes the worker path as one name-path argument instead of spreading it, so `/debug a/b` matches the `NameOrPath` interface guard.

**Stacking.** This PR is stacked on #1524 (`debugWorker`, debug-worker-restart Phase 2), which is itself stacked on #1523. The base `daemon-debug-worker-restart-phase-2-6579612` is a frozen snapshot of #1524's head. Hot-attach reuses #1524's worker-id → bus-handle map and its host / manager plumbing pattern. Building it on `llm` would duplicate that plumbing and conflict in `bus-manager-rust-xs.js`, `host.js`, and `manager.js`. Re-pin this PR once #1524 lands.

**Phase ledger** (`designs/daemon-xs-worker-debugger.md`):

- Phases 1–6: already landed on `llm` (marked done in the design).
- **Phase 7 (this PR):** host hot-attach over CapTP.
- Still open, not in this PR: `followBreaks`, the source view with breakpoint gutters, `.cpuprofile` profiling output, and storing each Debugger as a `@debug:<worker>` formula (Layer 4).

### Security Considerations

`attachDebugger` and `detachDebugger` are on `EndoHost` only, not on `EndoGuest`. The Debugger they return can inspect and evaluate in the target worker, which the host can already do through `evaluate`. Possession of the host capability is the authority; no identity check is introduced. A guest gets debugging only if a host hands it a Debugger.

### Scaling Considerations

None. A dormant worker pays nothing. An attached worker pays the xsbug overhead the design already accepts, and only for the worker that was asked.

### Documentation Considerations

`help.md` (and the generated `help-text-data.js`) documents both methods, and the design records Phase 7.

### Testing Considerations

- `packages/daemon/test/debug-attach.test.js` (10 tests): attach/acknowledge, driving the Debugger over the session, shared concurrent attach, session reuse, acknowledgement from the wrong worker or with an unknown nonce, detach, and close during or after an attach.
- `packages/daemon/test/endo.test.js`: on the Node daemon, `attachDebugger` and `detachDebugger` reject with "requires a platform with an XS worker supervisor". Unknown names and non-worker names are refused, including by `debugWorker`.
- `debug-worker-restart.test.js` and `debugger-captp.test.js` still pass (35 tests total across the three unit files).
- A real XS hot-attach round trip is covered at the Rust level by the existing `debug_attach_via_envelope` test in `rust/endo/xsnap/src/lib.rs`. There is no JS-level endor end-to-end test of `E(host).attachDebugger` yet, the same gap as `debugWorker` in #1524.

### Compatibility Considerations

The host interface only gains methods. The `attachDebugger` / `detachDebugger` control powers change from a bus handle to a worker formula number; they had no callers.

### Upgrade Considerations

Nothing to migrate: debug sessions are ephemeral and nothing persists.
-----END BODY-----
