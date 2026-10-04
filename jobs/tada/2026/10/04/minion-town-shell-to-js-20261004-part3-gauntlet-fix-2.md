Round-2 fixes for PR #154 are pushed as follow-up commit `36b972c` on `chore/javascript-only-scripts-part-3`, and CI is green (3 of 3 checks, `ci-wait-merge` exited 0).

**Must-fix items (all seven addressed)**
1. **Phase/evidence ledger:** added to the PR body with `Disposition: deliverable`, both design paths, Phases 1–6 marked `not-applicable | path-reference update only`, and a satisfied `Acceptance` line. Run against the new body, the phase-evidence gate (`panel` mode) returns "attention" (rc 10), not "blocked". The integrator still compares the ledger to the designs.
2. **Node version gate:** all three remote programs now require Node 22.15 or later (the repo's `engines` floor) instead of any v22. The check uses `node -e`.
3. **Reaper start hook:** `endo-daemon.service` now uses `ExecStartPre=-+`, so a reaper that fails to load can never block the daemon's start. The drift test and the comments are updated to match.
4. **`renderRemoteProgram`:** now throws on any unescaped `${` that isn't a plain or sliced upper-case name. That covers `${#X}`, `${!X}`, `${lower}`, `${}` and unterminated braces. New tests cover these forms and render each real `.remote.txt` file.
5. **`/tmp` drop-in:** `endo-federation-box.js` now pipes the drop-in through stdin to `sudo tee`, then `chmod 0644`. No `/tmp` file is involved.
6. **`--locked` bypass:** the argument is gone. `npm-registry-backup.js` now runs `flock -n` on a file descriptor the process holds open for its lifetime, with no re-exec. A new test confirms `--locked` is now a usage error.
7. **PR body:** removed the per-file tour and the "no command was sent to the live box" disclaimer. The body now passes the pruner probe (`skip pruner`) and lists what reviewers should watch.

**Should-fix items also done**
- **Backup script:**
  - The SQLite backup is copied out of the temp directory instead of renamed, which avoids the cross-filesystem (EXDEV) failure.
  - `NPM_REGISTRY_READY_TIMEOUT` must be whole seconds and is checked before the service is touched.
  - The script only runs `main` when executed directly, as does `endo-federation-box.js`.
- **Headers:** the header docs from the shell originals are back in both scripts.
- **`readEndoCommit`:** now uses the anchored, exactly-one parse like the other two readers; the stale `ENDO_COMMIT="abc"` fixture is replaced.
- **`deploy-npm-registry.js`:** the SHASUMS line match is anchored to the full checksum-and-filename pattern again.
- **`endo-root-host.js`:** single-quotes the control path and daemon user, with a test that checks the output with `bash -n`.
- **Small fixes:** the duplicate reaper assertion now checks the install path, the two spellings are fixed (colors, signaled), and `DEPLOYMENT.md` no longer claims the JS files were "shellchecked".

**Verification:** typecheck is clean. The four affected test files pass (68 tests). In the full local `npm test`, one test fails, `test/git-remote/capability.test.ts:464`; this diff doesn't touch that area, and it passed in CI.

**Not done (should-fix, left for later):**
- Reusing `lib/artifacts.js` in `deploy-siwe-thunk.js` instead of duplicating its helpers.
- Naming the secret or path when `JSON.parse` fails in `deploy-siwe-thunk.js` and `deploy-app.js`.
- Documenting the `programs/*.remote.txt` convention in `deploy/aws/README.md`.

The comment-only suggestions (property tests, MemoryMax boundary tests, `ENDO_DAEMON_PORT` validation) were also left alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5267349 cached reads)
- Output: 25775 tokens
- Cost: $2.5540578000000003
- Wall-clock: 452s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
