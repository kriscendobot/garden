# Completion report: `daemon-agent-tools-design-build`

I built Phase 2c, the sandbox shell engine from § Next Slice of `designs/daemon-agent-tools.md` (design PR #1497), and opened it as **draft PR [endojs/endo-but-for-bots#1504](https://github.com/endojs/endo-but-for-bots/pull/1504)**. A shell provisioned with `engine: 'sandbox'` now runs its commands inside an `@endo/sandbox` slice that sees only its own mount, with no network. The tests that use a real sandbox could not run here, so CI will be the first time they actually run.

- **Branch:** `build/daemon-agent-tools-sandbox-shell`, based on the frozen base `llm-330cf99` (the current `llm` tip).
- **Commits:** the feature, plus a separate `chore: Update yarn.lock`.
- **Packages touched:** `@endo/host-spawner`, `@endo/exo-shell`, `@endo/daemon`, `@endo/agent-tools`, and `@endo/sandbox` (tests only).

## What changed
- **`@endo/host-spawner`:** new `makeSandboxSpawner(slice)`, imported by its own path rather than through the package index, because the re-export gate forbids barrel re-exports.
  - It runs each command in the slice and refuses shell mode.
  - It hands the shell's timeout and output cap to the slice as the slice's own limits.
  - When a process is killed or hits a limit, it reports `{ code: null, signal }` the way a killed host process would. Any other slice failure, such as a containment failure, is still an error.
- **`@endo/exo-shell`:** the policy gains `engine: 'host' | 'sandbox'` (default `'host'`), and `inspect()` reports it. `exec` now tells the spawner the hard deadline and the output cap.
- **`@endo/daemon`:**
  - `provideShell` takes `engine` plus `sandbox`, the sandbox factory capability. The factory is recorded as a dependency of the shell rather than stored in the policy.
  - If no sandbox backend is usable, `provideShell` rejects instead of falling back to the host.
  - New `src/shell-engine.js` creates the slice: no network, default seccomp, host system directories read-only, the mount read-write at `/work`.
  - Each slice lasts one incarnation: it is disposed on cancellation and recreated after a restart.
  - Shells saved before this change still come back as host shells.
- **`@endo/agent-tools`:** the `inspect` tool description mentions the engine, and the generated code-mode declarations are regenerated.
- **Changeset:** `.changeset/shell-sandbox-engine.md`, plus a README section for the new spawner.

## Where I departed from the design
The PR body lists all three.
1. **The design's `E(slice).mount(...)` call would not have worked.** In the bwrap driver, mounting after the slice exists only records the mount; it never reaches the running sandbox. I pass the same mount through `make({ mounts })` instead, so the worktree really is bound.
2. **The shell's search path is not used inside the sandbox.** Host directories may not exist there, so the slice works out its own `PATH`.
3. **A process that writes past the output cap is killed in the sandbox.** On the host it keeps running. The captured output and the `truncated` flag are the same either way, but the exit status can differ.

## Verification
- **Passing:**
  - host-spawner tests (12), exo-shell tests (18), the daemon's `shell.test.js` (10), and the agent-tools shell tests.
  - `tsc` for all five packages, the repo-root type check, and the pre-push gates.
  - I confirmed that the timing fix in the spawner (waiting for output to be read before classifying a kill) is needed: its test fails without it.
- **Not run:** the real-sandbox tests in `packages/sandbox/test/shell-engine.test.js` only skipped locally, because this container doesn't allow user namespaces. I added them to `test:drivers`, which the CI job with bubblewrap installed runs. They are:
  - a file outside the mount is unreadable in the sandbox but readable on the host;
  - a write under `/work` shows up through the mount;
  - no network;
  - a shared table of timeout and output-cap cases that both engines must pass.
- **Only partly tested:** that a sandboxed shell stays sandboxed across a daemon restart. The saved formula keeps the engine and the factory, and I tested the rebuild step with a stub factory. A full restart test needs the native sqlite build, which the existing shell tests also avoid.
- **One local failure in a test I didn't touch:** `agent-tools › git-flow › makeGitTool derives the rewriter-facet catalog…` fails with a Git repository-identity error. It is a git test unrelated to the shell, and I didn't check whether it also fails on `llm` without my changes.

## Follow-ups
- Once #1497 lands, tick Phase 2c in the design document. I didn't edit it here so this branch wouldn't conflict with the open design PR.
- Phase 7 (the endo-claude acceptance loop) is unblocked for its build step.
- Phase 8 still needs your decision on Open Question 4: a daemon `provideHttpClient` formula or the `@endo/fetch` plugin.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-agent-tools-design-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 210 tokens (17722429 cached reads)
- Output: 77441 tokens
- Cost: $6.977561800000001
- Wall-clock: 1788s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
