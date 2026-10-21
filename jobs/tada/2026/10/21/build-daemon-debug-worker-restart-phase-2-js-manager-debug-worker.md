I built Phase 2 of `daemon-debug-worker-restart` (the JS manager `debugWorker`) and opened it as draft PR **endojs/endo-but-for-bots#1524**. It is stacked on the Phase 1 PR #1523 through a frozen base, `daemon-debug-worker-restart-phase-1-38f0e94`, because `ensure-pr.sh` would not accept a floating branch as the base. The unit tests pass, but nothing was run against a live `endor` daemon.

**What changed** (branch `daemon-debug-worker-restart-phase-2`, 2 commits):
- **Host method:** `debugWorker(petNamePath)` is in the `HostInterface` guard, the host object, the `EndoHost` types, and the help text (`help.md`, with `help-text-data.js` regenerated). It resolves the name and starts the worker with `provide(id, 'worker')`, which rejects names that aren't workers. A manager-side `debugWorkerById` then passes the worker's formula number to the control powers.
- **Control powers:** there is no hand-written `daemon_bootstrap.js`; it is the bundle built from `bus-manager-rust-xs.js`, so the change went there. That file gains `debugWorker(workerId)` and `debugFlag(handle)`, plus a map from worker to bus handle. The restart sequence lives in a new `debug-worker-restart.js`:
  1. suspend and wait for `suspended`
  2. send `debug-flag`
  3. register a debug session
  4. `ping` the worker to resume it
  5. wait for `<login>`
  6. return the `Debugger`

  A failed suspend rejects before any flag is set. The debug session gains `waitForLogin()`.
- **Rust fix this needed:** worker replies on the debug and suspend paths (`debug`, `debug-attached`, `debug-detached`, `suspended`, `suspend-error`) were being dropped by the supervisor as unknown control verbs, so the JS manager never saw them. That likely breaks the existing hot-attach debugger end to end as well. The supervisor now records the manager's handle at its first `spawn` (first caller wins) and forwards those replies to it.
- **Other:** the design doc marks Phase 2 implemented and describes the forwarding. I added a `minor` changeset for `@endo/daemon`.

**Verification:**
- **Unit test:** the new test (`packages/daemon/test/debug-worker-restart.test.js`) passes alongside the existing debugger tests. A fake supervisor checks the envelope order, that the returned debugger is connected with the worker paused until `go()`, that a failed suspend is handled, that a second debugger is refused, and the encoding of the handle payload.
- **Rust:** `cargo check -p endo` shows only warnings that were already there. To get it to compile I fetched the `c/moddable` submodule and used temporary empty stand-ins for the four generated JS bundles, which I removed afterwards.
- **JS:** eslint and the daemon's `tsc` report nothing new on the changed files.
- **Not checked:** the Rust forwarding has only been compiled, not run.

**Follow-ups:**
- As in Phase 1, only shared (in-process) XS workers honor the flag. For a process worker, `debugWorker` never returns, because that worker resumes without the debugger. Carrying the flag across the process boundary is still open.
- Retarget #1524 to `llm` once #1523 merges.
- Phase 3, the Chat `/debug-restart` command, is not started.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-debug-worker-restart-phase-2-js-manager-debug-worker.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (5530355 cached reads)
- Output: 31875 tokens
- Cost: $2.6903070000000002
- Wall-clock: 519s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
