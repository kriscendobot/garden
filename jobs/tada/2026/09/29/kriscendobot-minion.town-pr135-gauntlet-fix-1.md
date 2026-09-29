I fixed every must-fix item from the round-1 panel on PR #135 in one commit and pushed it. CI came back **green** (3 of 3 checks passed).

**What was fixed** (commit `24a9d63`, pushed from `e155214` with `safe-push-pr-head.sh`):
- **assessor (must-fix):** a restore that fails partway now puts the old state back and restarts the service, instead of leaving it stopped. `npm-registry-backup.sh restore` now has an exit trap around the stop → swap → start sequence. It also refuses to run if a `pre-restore` path from an earlier run is still there.
- **stylist (must-fix, plus the two should-fixes):** spelled out the abbreviated names:
  - `MINIMUM_FREE_KB`, and the setting `NPM_REGISTRY_MINIMUM_FREE_KB`
  - `ARTIFACT`, `RELEASE`, `PREVIOUS`, `UNIT_BASE64`, `PREFLIGHT_BASE64`
  - `DESTINATION`, `SOURCE`, and `source`/`destination` in the embedded Node code
  - `SERVICE_USER` and `ENVIRONMENT_FILE_URL`
- **breaker (must-fix; also raised by purist, locksmith, saboteur, wire-watcher):** the S3 object holding the publisher token is now deleted by the exit trap on every path, success or failure.
- **wire-watcher (must-fix):**
  - The source tarball's sha256 is computed on the garden host and checked on the box with `sha256sum -c` before anything is unpacked or built, as `deploy-app.sh` already does.
  - An existing release is reused only when its `ENDO_COMMIT` file matches the pin; otherwise it is rebuilt and replaced just before the rename.

**Should-fixes I also took, because they were cheap and in the same code:**
- **Secret delivery:**
  - The token no longer passes through a world-readable file in `/tmp`. It is streamed into `publisher.env.new` with permissions 0600, then renamed into place, so a failed fetch can't wipe out the installed grant.
  - The whoami check sends the bearer header over stdin, so the token no longer appears on curl's command line.
  - The header comment now says plainly that the SSM command text carries a 300-second presigned URL, which grants access to the token.
- **Tests:**
  - A new test covers the owner-mismatch preflight check. It puts a fake `stat` ahead of the real one on `PATH` so no root access is needed.
  - The test finds the script with a URL relative to the test file instead of `node:path`.

The preflight tests pass (4 of 4), shellcheck reports no warnings, and the typecheck is clean.

**Still open (should-fix or comment-only, not done in this round):**
- A failed deploy can roll back onto a database the new release has already migrated. The fix is to take a backup before switching.
- A restore brings back grants that were revoked after the backup was taken.
- The service unit doesn't block the EC2 metadata address (IMDS), so a compromised registry could fetch the instance's credentials.
- The Node download isn't checked against its published hash.
- The Endo pin can be overridden by an environment variable rather than being a committed value.
- The preflight's `stat -c` only works with GNU `stat`, so the test fails on macOS.
- The `→` arrows in the docs haven't been replaced with `->`.
- The PR's links point at `designs/npm-minion-town-registry.md`, which only exists on #134, so this PR should stay behind #134.

The next panel round may raise these again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1689343 cached reads)
- Output: 12809 tokens
- Cost: $1.3484646
- Wall-clock: 371s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
