---
handed-off: build-daemon-xs-worker-debugger-next-phase-open-pr
deliverable-complete: false
---
# Completion report: build-daemon-xs-worker-debugger-next-phase

The next phase is built and pushed, but the draft PR is not open yet. This host's bot token gets a 403 on `createPullRequest` for endojs. I posted a successor job, pinned to the endolin host, whose only task is to open the PR.

## Which phase was next
Phases 1–6 of `designs/daemon-xs-worker-debugger.md` are done on `llm`. The first item on the design's "Remaining" list was that the host never exposed `attachDebugger` over CapTP, so Chat's `/debug <worker>` failed with method-not-found. Nothing open or merged covered it: #1523 and #1524 belong to the separate debug-worker-restart design and add `debugWorker`, not hot-attach. I built it and recorded it in the design as **Phase 7: Host hot-attach over CapTP**.

## What changed
Head branch is `daemon-xs-worker-debugger-host-attach` at `df5ac6d2c`, pushed to endojs/endo-but-for-bots. It is stacked on `daemon-debug-worker-restart-phase-2-6579612`, a frozen snapshot of #1524's head. Stacking reuses #1524's worker-id → handle map and host/manager wiring; building on `llm` would have duplicated it and conflicted in three files.

- **New host methods:** `EndoHost.attachDebugger(workerNameOrPath)` and `detachDebugger(workerNameOrPath)`. The interface guards, types, manager wiring, help text and a changeset (`@endo/daemon` minor) are included.
- **Control powers:** these now take a worker formula number instead of a bus handle. They had no callers before.
- **New `debug-attach.js`:** holds the attach state that used to be inline in the bus manager.
  - Two attaches to the same worker share one request, and an already-attached worker reuses its session.
  - An acknowledgement is accepted only from the worker that was asked.
  - If the worker closes mid-attach, the attach rejects and the session is dropped, instead of hanging.
- **Refusals:** a Node.js worker is refused up front rather than waiting for an acknowledgement that never comes. Names that aren't workers are now refused by all three methods, including #1524's `debugWorker`. That code's comment said `provide` enforced this, but `provide` ignores its expected-type argument.
- **Chat fix:** `/debug` now passes the worker path as one argument, so a nested name like `a/b` works.

## Verification
- 10 new unit tests plus the existing debug-worker-restart and debugger-captp suites: 35 passed.
- 2 new daemon tests in `endo.test.js`: on the Node daemon both methods reject, and unknown or non-worker names are refused. Both pass.
- The pre-push probes pass, the phase-evidence gate is clear, `tsc` for the daemon reports no errors, and eslint has no errors.
- The full pre-push gate run timed out at 10 minutes, so I ran its probe-only mode plus package-scoped prettier, eslint and tsc instead.
- There is no JS end-to-end test of a real XS hot-attach. The existing Rust test `debug_attach_via_envelope` covers the round trip; #1524's `debugWorker` has the same gap.
- To run the daemon tests here I had to rebuild `better-sqlite3`: this worktree's copy was built for Node 24 and this host runs Node 22. I saved the fix as a memory.

## Follow-ups
- **Successor job:** `build-daemon-xs-worker-debugger-next-phase-open-pr` (requires `host=endolin-garden-ece02cb4`) is on `origin/journal2` and opens the PR with `ensure-pr.sh` under this job's marker. If endolin is over its token cap, it may sit unclaimed for a while.
- **#1524 still has an open must-fix panel review.** Once it lands, this PR needs re-pinning.
- **Likely small conflict:** the sibling `build-daemon-debug-worker-restart-phase-3-chat-integration` also edits the `/debug` area of `command-executor.js`, so whichever lands second will need a rebase there.
- **Still open in the design:** `followBreaks`, the source view with breakpoint gutters, `.cpuprofile` output, and storing each Debugger as a `@debug:<worker>` formula.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-xs-worker-debugger-next-phase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (9133328 cached reads)
- Output: 42412 tokens
- Cost: $3.9632576000000013
- Wall-clock: 2909s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
