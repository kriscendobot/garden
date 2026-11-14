I fixed all of PR #1504's outstanding round-3 must-fix findings, pushed the branch, and recorded a fresh gauntlet for it. CI has two red checks, neither caused by this PR, and one macOS leg was still running when I stopped.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1504 (still draft, base `llm-9a14ddf`, mergeable). New head is `cfa346534e`, five commits on top of `3a250c0f43`.

**Must-fix items fixed** (from panel review 5726405552):
- **Debug logging (prover):** removed the leftover `DBG` `console.log` calls from `packages/sandbox/test/spawner.test.js` (bd3e51e8f3).
- **Bump level for the new `inspect()` field (curator, migrator):** `inspect()` now returns a required `engine`, which is a breaking change. It has its own changeset, `.changeset/shell-inspect-engine-required.md` (`@endo/exo-shell` and `@endo/agent-tools`, minor). The entry explains why minor is right: both packages are below 1.0, and exo-shell has never been released. `@endo/agent-tools` is no longer in the main changeset (a684996109).
- **Private packages in the changeset (curator, migrator):** `@endo/sandbox` and `@endo/host-spawner` both stay private. I kept their changeset entries because `.changeset/config.json` sets `privatePackages.version: true`. The PR body now notes that host-spawner must be made public before sandbox can be.
- **PR body (integrator):** refilled through `gh pr edit`. It now has the template's Documentation Considerations section in order, lists the new dependency edges (they add no cycle), and moves the `Refs:` line into Description. Compatibility Considerations now lists the `wait()`/`kill()` rejection change, the `@endo/sandbox/spawner.js` deprecation, and the `SpawnerOpts` alias.

**Should-fix items also done:**
- **`'environment'` engine:** marked as report-only beside the guard, in the README, and in the `makeShell` and `provideShell` refusal messages.
- **Spawner docs:** `ProcessLike` in both packages now says the sandbox spawner's `wait()` and `kill()` reject on a kill the caller didn't request or a containment failure.
- **Conformance table:** `engine-cases.js` now says it tests Shell-level limits, not whether an engine itself enforces the timeout and output cap (ee11eaec31).
- **Deprecated import path:** the panel missed that `@endo/hosted-agent` (`setup-environments.js`, `src/environment-runner.js`) and sandbox's own `factory.js` and tests still imported the deprecated `@endo/sandbox/spawner.js`. They now import from `@endo/host-spawner`, and hosted-agent gained that dependency (e76999e004, `yarn.lock` in its own commit).

**Verification:**
- **Local:** tests pass and tsc is clean for exo-shell (25/25), host-spawner (16/16), sandbox `spawner.test.js` (11/11) and the hosted-agent environment tests (9/9). eslint and prettier are clean on touched files. Daemon tests didn't run locally because the better-sqlite3 native build failed.
- **CI on the new head:** 20 checks pass, including both Ubuntu test legs and node 22 on macOS. `test (24.x, macos-15)` was still running when I stopped. The two reds:
  - `zizmor` flags a pin-comment mismatch in `update-action-pins*.yml`, files this PR doesn't touch.
  - `test-xs` fails in `packages/hardened262`, also untouched. The same failure appears on the unrelated `feat/genie-stdio-jsonl-rpc-bridge` branch.

**PR comment:** I posted a summary of the round at https://github.com/endojs/endo-but-for-bots/pull/1504#issuecomment-6875506068.

**Fresh gauntlet:** the old gauntlet record is gone and its `panel-4` stage sits doom-parked in `plan/`. I recorded a new gauntlet with `post-gauntlet.sh` under a dated name, `endojs-endo-but-for-bots-pr1504-gauntlet-20261114` (default limit of 6 review rounds). That old `panel-4` job could be cleaned up.

**Follow-ups:**
- **Deferred to the next review round:** the prover asked for a test showing the bwrap exit-handler sweep matters, and one that cancels during `make()`. The curator suggested a cross-package type-compatibility test for the duplicated spawner types.
- **Cross-PR:**
  - The zizmor pin-comment drift needs its own fix (a branch named `fix/zizmor-create-pull-request-pin-comment` exists, which may already cover it).
  - The hardened262 `test:xs` red is unexplained and needs its own look.
  - `hosted-agent`'s `environment-runner` builds its Shell without an `engine`, so it reports `'host'`; that was flagged earlier and isn't changed here.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4fd495067966e5f7a45bf1aa3e9e49dac9b2bad0`; this job presented `cfa346534eb3dcd5465d83e4bf5b8f56b39ac552`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket accepted a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1504.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (7180735 cached reads)
- Output: 28224 tokens
- Cost: $2.937539
- Wall-clock: 4485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
