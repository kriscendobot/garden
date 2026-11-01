Fix round 3 for PR #1504 is pushed and CI is green: all 36 checks finished with no failures (26 passed, 10 skipped), and `ci-wait-merge.sh` returned rc 0.

The job had no pre-pass block, so I worked from the latest panel verdict, review 5726107898. The curator, migrator and pruner seats all asked for changes. I applied every must-fix and should-fix item, and the cuts the pruner asked for.

**Commit `9de456c0af` — `fix(exo-shell,host-spawner): keep exo-shell off the private host-spawner`**
- **Private dependency (must-fix, curator and migrator):** `@endo/exo-shell` is published but listed the private `@endo/host-spawner` as a runtime dependency. I put back exo-shell's own local definitions of `Spawner`, `ProcessLike` and `SpawnerOptions` and dropped the re-export from host-spawner. host-spawner is back in `devDependencies`.
- **Type rename:** host-spawner's renamed `SpawnerOpts` type is kept as a deprecated alias of `SpawnerOptions`, so existing users don't break.
- **Changeset:** it now states:
  - `inspect()` must return `engine`, which applies to every `Shell` exo, mock and `ShellToolCapability` implementation.
  - The `SpawnerOpts` → `SpawnerOptions` rename.
  - `makeSandboxSpawner` has one entry point, `@endo/host-spawner/src/sandbox-spawner.js`, and `@endo/sandbox/spawner.js` is deprecated.
  - A bolded behavior change: `wait()` and `kill()` now reject on a kill the caller didn't request or a containment failure.
  - exo-shell no longer depends on host-spawner.
- **Duplicate explanations cut (pruner):**
  - The text on who owns the adapter now appears once, in the host-spawner README.
  - The `maxOutputBytes` rule is stated once, in `types.ts`, and the adapter's JSDoc links to it.
  - The README's long sandbox paragraph is down to two sentences.
  - The numbered steps in the `sweepLeaderlessGroup` JSDoc are gone; the sentences on the race window and `ESRCH` stay.
  - I removed two comments that only described the next line.
- **PR body:** trimmed from 469 to 367 words. Documentation Considerations is gone; Security, Compatibility and Upgrade are condensed. The `garden-job` marker is untouched.

**Commit `3a250c0f43` — composite tsconfig regenerated.** The first push failed CI lint because exo-shell's composite tsconfig still pointed at host-spawner. Running `yarn build:types:gen` fixed it.

**Checks:**
- Locally, `tsc --noEmit` passed for exo-shell, host-spawner, sandbox and daemon, eslint passed on the touched files, and the composite tsconfig check passed. I couldn't run exo-shell's ava tests locally because the ava entry point wasn't found; CI's test legs passed.
- On the first CI wait my 3000-second deadline ran out with one test leg still running. That leg then passed, and a second run of `ci-wait-merge.sh` confirmed green.

**Follow-ups:**
- Panel-4 is next and the driver posts it.
- Curator and migrator both proposed a rule: a public package must not depend on or re-export types from a `private: true` workspace package. It isn't encoded anywhere yet.
- The pruner reported that the pre-pass file-count signal it was given came from the wrong diff.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3785624 cached reads)
- Output: 18107 tokens
- Cost: $1.8845368000000002
- Wall-clock: 5663s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
