I applied the round-3 panel fixes to PR #1595 and pushed them, but CI didn't finish before the deadline. 35 of 36 checks passed. The last one, `test (24.x, macos-15)`, was still pending at 3600s, so `ci-wait-merge` exited with rc 4 and the driver should re-post this stage.

There was no deterministic pre-pass block, so I worked from the latest panel review (5725033195). The head moved from `535394412` to `a630f3b8d`, pushed with `safe-push-pr-head.sh` in three follow-up commits:

- **`b9a671b89` (daemon):**
  - `endo inspect` on a git-remote now reports the push refspecs the remote actually enforces. Before, a profile granted through `allowedBranches` showed `pushRefspecs: []` (breaker).
  - The `provideGitRemote` options type now has one name, `GitRemoteProvisionOptions`, which the CLI's types build on (curator).
  - Added a formula-record test with `allowLocalFileTransport: true` (corner-prober).
- **`f7bc04220` (cli):**
  - `--branch` names are now checked against the `git check-ref-format` rules. Names with a leading `.`, a `.lock` suffix, a trailing `.`, or control characters are rejected, with regression cases (spec-keeper, saboteur, corner-prober).
  - The URL and credential name now reject control characters and bidirectional-override characters, so they can't rewrite the approval preview on a terminal (saboteur).
  - The preview and prompts now go to stderr, so `--json` output on stdout parses as one document. Both prompts share one input reader, so piped answers aren't lost (breaker).
  - Inspecting a revoked remote now reports its policy and says the credential was not checked. It used to fail, because revocation shuts off the credential-health call. The integration test now revokes a remote and inspects it (wire-watcher).
  - The integration test now provisions without `--url`, types a mixed-case URL, and checks that the case is kept (prover).
  - The profile fields are now readonly arrays (typist), the new exports are hardened (warden and others), errors use `Fail`/`q` from `@endo/errors` (purist), and `ch` is renamed to `character` (stylist).
  - The README is updated to match.
- **`a630f3b8d`:** the two changesets are merged into one (packager, curator).

**Declined, with reasons in the PR comment:**
- **locksmith, drop the controller and use the remote's own `inspect()`:** the CLI already acts with the host's authority, and the controller is the only thing that can still report a revoked remote. Removing it would undo the wire-watcher fix.
- **locksmith, a separate fetch-only object with no `push()`:** that needs a new interface in exo-git and the daemon, which is beyond this PR. Fetch-only is still enforced by the daemon's direction check on every operation.
- **purist, build the preview with exo-git's normalizer:** that would add a new `@endo/exo-git` dependency to the CLI. The preview uses the same `<ref>:<ref>` derivation, and the inspection printed after provisioning shows the daemon's normalized policy.

**Verification:** the CLI git-remote unit and integration tests (25) and the daemon formula-record tests (14) pass locally. eslint, the package `tsc` runs and the repo-root `tsc` show no new errors in the changed packages.

I posted a summary of what was fixed and declined on the PR, as scribe asked: https://github.com/endojs/endo-but-for-bots/pull/1595#issuecomment-6549665976

**Follow-ups:**
- The driver should re-post this fix stage to finish waiting on the macOS leg.
- If the maintainer wants the separate fetch-only object, it needs its own exo-git/daemon design job.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (6676321 cached reads)
- Output: 36284 tokens
- Cost: $3.1467282000000005
- Wall-clock: 4088s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
