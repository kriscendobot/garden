---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Relay: post the gauntlet fix-4 completion summary on endojs/endo-but-for-bots#1538

Job `endojs-endo-but-for-bots-pr1538-gauntlet-fix-4` pushed head `af7d9638d` to
https://github.com/endojs/endo-but-for-bots/pull/1538 from host
oros-studio-garden-ce242c49. That host's bot PAT gets 403 on `addComment`, so this job
only posts the summary below as a top-level PR comment. Run:

    gh pr comment https://github.com/endojs/endo-but-for-bots/pull/1538 --body-file <file holding the text between the markers>

Do nothing else. If a comment beginning "**Gauntlet fix round 4**" already exists on the
PR, do not post a duplicate.

----- COMMENT BODY -----
**Gauntlet fix round 4** · CI: pending · next: panel round 5 after CI

Head `af7d9638d`, following `35f7e32f`.

**Previous push, `35f7e32f`** (style directives from review 5624079301): spelled out abbreviated identifiers and hoisted JSDoc `@import` tags. No behavior change.

**This push answers the panel-4 must-fix items:**

- `4cd945545` fix(daemon): publish and discard clone entries by recorded identity. This answers the assessor, locksmith, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator and corner-prober findings.
  - A clone staging directory is now recorded, with its `dev:ino`, in daemon state outside every mount (`state/mount-staging/`). After a restart, the daemon discards only a recorded directory that is still the recorded object. A staging-shaped name the daemon did not record is never touched, so the mount counts as non-empty and the clone refuses.
  - Entries are published with a new `FilePowers.renameNoReplace`. A directory gets an exclusive `mkdir` followed by a rename over that empty directory. Any other entry gets `link` then `unlink`. An entry created at the target concurrently is never replaced.
  - Discard first renames each published entry aside, which captures whatever object holds the name at that moment. It then checks the entry's identity: a match is removed, and a mismatch is renamed back without replacing anything. If the name has been taken again, the mismatched entry is kept in the holding directory and the call reports where.
  - `origin.petName` is now a single pet name in the host's own pet store. Capturing the prior binding with the store, and the restore's check with its mutation, each run in one turn with no gap for a concurrent rebind, because the pet store applies a store synchronously when called.
  - New tests: a caller-created staging-shaped directory is kept, and a recorded stale staging directory is removed after a restart. In a third test, a far-object name hub holds the last naming step open while the test replaces the published `.git` and rebinds the origin's name. The replacement and the rebind both survive the discard. `rename-no-replace.test.js` covers the new power.
- `690f0504a` fix(daemon): `provideGitClone` now returns an exact `M.splitRecord({ git, remote })` (spec-keeper).
- `e822f3c6b` fix(git): remote git termination now escalates to `SIGKILL` after a grace period. On Windows, `taskkill /T /F` ends the process tree. A new test uses a stand-in git whose descendant ignores `SIGTERM` (saboteur, spec-keeper, corner-prober, transplanter).
- `a52821b4f` fix(sandbox): the launcher's children are now read from `/proc/<pid>/task/<tid>/children`, falling back to the full scan only without `CONFIG_PROC_CHILDREN` (engine-realist). The timing-dependent setup-race test is dropped in favor of the deterministic stand-in launcher test (prover).
- `af7d9638d` docs:
  - The "Landed" paragraph in `designs/daemon-git-remotes.md` now matches the current contract, and the identity boundary is described as landed (archivist).
  - The changeset now describes the git kill change as a liveness correction rather than a latency claim (benchmarker).
  - The typist-hostile `…` in the Floot prompt is replaced with `...` (typist).

**Declined, with reasons:**

- archivist, `designs/cli-http-client.md` status: the links at `daemon-git-remotes.md:32/:97` predate this PR and are not part of the clone section. Reconciling that design's status is outside this change.
- integrator, amending `eafcef12b`'s message: the gauntlet adds review-feedback follow-up commits and never rewrites pushed history.
- coverage-auditor, XS test for `removeDirectory` on a symlink: `@endo/daemon` has no XS test harness, and the XS powers run only under the Rust host. The same applies to the XS `entryIdentity` and `removeEmptyDirectory` added here. `provideGitClone` refuses on XS anyway, because the XS powers omit `renameNoReplace`.
- decomplector, splitting cloning from naming: callers cannot compose `gitClone` + `provideGit` + `provideGitRemote` with all-or-nothing naming and a discard that keeps other holders' content. The one-call shape is what this PR's API delivers. The `DaemonCore` surface for it is still five functions.

**Remaining limit:** removal after the identity check is path-based, so in principle a holder who moves an object into the daemon's freshly made holding directory between the check and the removal can still have it removed. Doing that takes the same write authority that could delete the object directly, so it grants no new authority.

**Verification (local):**

- `@endo/daemon`: `tsc` and eslint report no errors. All 16 `provideGitClone` tests in `git-remote.test.js` pass, and `rename-no-replace.test.js` passes.
- `@endo/git`: lint is clean, and the process-group and `SIGKILL` tests pass.
- `@endo/sandbox`: all 42 `bwrap.test.js` tests pass.
----- END COMMENT BODY -----
