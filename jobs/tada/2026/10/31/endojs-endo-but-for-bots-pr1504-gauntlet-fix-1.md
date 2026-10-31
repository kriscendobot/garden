# Gauntlet fix round 1: endojs/endo-but-for-bots#1504

**Result: CI was still pending when the 3600 s deadline ran out.** 34 of 36 checks had passed and none had failed. `test (24.x, macos-15)` and `test (22.x, ubuntu-latest)` were still running. The driver should re-post this stage.

There was no deterministic pre-pass block, so I worked from the latest panel verdict (review 5724715339, "Must-fix before merge"). Five commits went to `build/daemon-agent-tools-sandbox-shell` (`17c61dd8e` → `93e411a4e51`) through `safe-push-pr-head.sh`:

1. **`fix(sandbox)`: the bwrap cleanup no longer signals a process group it might not own** (engine-realist, corner-prober, saboteur).
   - A new helper, `sweepLeaderlessGroup`, runs after bwrap's leader exits. It skips the kill if another process now holds that pid, probes the group with a null signal first, and only then sends SIGKILL.
   - "No such process" (ESRCH) is still ignored. Any other kill error, such as a permission error, now fails the exit instead of being swallowed. Unit tests cover each case.
2. **`refactor(host-spawner,sandbox)`: one slice adapter instead of two** (decomplector, integrator, saboteur, spec-keeper, wire-watcher, corner-prober, fast-checker).
   - `@endo/host-spawner` now holds the only `makeSandboxSpawner`; `@endo/sandbox/spawner.js` re-exports it. It keeps the shipped behavior: stdin gets EOF, no remote pid (`pid` is 0), and a construction-time output guard.
   - The adapter no longer guesses why a process ended from `Date.now()` or byte counts. Only a kill the caller asked for, once the slice has reaped the process, becomes a signal exit.
   - Slice timeouts, output-guard kills and containment failures now reject `wait()`, and `kill()` failures are passed through. `wait()` no longer hangs when nobody reads the output streams.
   - **Behavior change:** output past the cap is now truncated and drained like on the host, instead of the slice killing the process at cap+1.
   - New fast-check property tests cover how bounds are passed to the slice and arbitrary output chunking.
3. **`fix(daemon,exo-shell)`: the remaining findings.**
   - A saved shell formula with an unknown engine now refuses to restart instead of falling back to the host engine (warden).
   - The slice cleanup hook is registered before the slice is requested, so a cancellation during `make()` still disposes it; an already-cancelled context acquires nothing (saboteur).
   - `harden(SANDBOX_SHELL_WORKDIR)` (purist); captured array methods for the remote backend list (spec-keeper).
   - The environment shell now reports `engine: 'environment'` instead of claiming a sandbox it can't vouch for (breaker).
   - Duplicate `ShellPolicy`, `ShellEngine` and `Spawner` option types are now declared once and re-exported (curator).
   - `ShellProvisionPolicy` is a discriminated union, and `SandboxFactoryLike.make()` has a real return type (typist).
   - The engine test table moved to a public export, `@endo/exo-shell/engine-cases.js`, with type declarations and README docs (surfacer, packager).
   - README fixes (archivist, integrator); renames `opts`→`options`, `proc`→`childProcess`, `cap`→`capability`; banner removed; American spellings.
   - The sandbox tests now skip only on bwrap's own namespace-denial message (prover, spec-keeper). The no-network test connects to a local listener the host can reach, and skips if the host lacks bash (prover, transplanter).
   - The changeset now marks all five packages `minor` and puts each sentence on its own line (curator, migrator, changeset-auditor).
4. **`chore: Update yarn.lock`**
5. **`fix(sandbox)` for the first CI run:** lint and sandbox-drivers had failed.
   - Regenerated the composite tsconfigs.
   - The real-bwrap cap test now reuses one slice. It checks the `truncated` flag in one direction only, because bwrap writes its own messages to stderr and those count toward the cap.

**Local checks:** the host-spawner, exo-shell, sandbox spawner/child-process/shell-engine, daemon shell/environment and agent-tools tests pass, and the targeted bwrap process-group tests pass. `lint:types`, eslint and prettier are clean. The full `bwrap.test.js` file stalled past 500 s on this host in its real-bwrap tests; I didn't run the old code for comparison. The CI sandbox-drivers job, which runs that file, passed.

**Not done:**
- **The pruner's PR-body edits and the coverage-auditor's XS note** (documented as a known limitation rather than adding a new XS test). This host's token gets HTTP 403 on endojs PR edits. I posted job `endojs-endo-but-for-bots-pr1504-body-edit-20261031`, pinned to `endolin-garden-ece02cb4`, carrying the replacement body.
- **The real-bwrap property test runs at the Shell level**, not per-chunk as fast-checker asked; the per-chunk partitioning is covered against a fake slice.
- **The daemon's `./src/shell-engine.js` export is unchanged.** It is a should-fix, and it follows the package's existing `./src/*` export pattern.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 244 tokens (21783528 cached reads)
- Output: 103559 tokens
- Cost: $8.3892456
- Wall-clock: 8840s

<!-- garden-usage-end -->
