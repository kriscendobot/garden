CI timed out at the deadline (rc 4) with two macOS legs still pending. The one failure, `test (22.x, ubuntu-latest)`, is `packages/sandbox` › `bwrap timeout and repeated cancellation reap process groups`. That is the known pre-existing bwrap flake, and this PR doesn't touch `packages/sandbox`.

## PR #1573, gauntlet fix round 7: fixes pushed, CI still pending

I applied the fixes from panel review 5730546476 and pushed two follow-up commits to `endojs/endo-but-for-bots` `feature/api-key-provider-registry` (`a70129db64` → `b71d3101f0`). I also posted a follow-up summary on the PR (issuecomment-6564841710).

**Fixed:**
- **`db0b6e4aa0` fix(daemon):**
  - Reading, replacing, or describing a secret that is still being imported (`provisioning`) now fails with a new `PROVISIONING` error. Before, reads and replacements reported `REVOKED`, and `setDescription` succeeded, which would break a retry because a retry must match the original description. A new test covers both admin paths (migrator 2, purist 3).
  - Four throw-inside-a-function guards in `provideBase64` now go through one `assertOrFixed` helper (purist 1).
  - The inline `splitRecord` in the interface is now a named `StableIdsShape` (purist 2). `@endo/patterns` has no string-pattern matcher, so the ID syntax check stays in the daemon.
- **`b71d3101f0` docs(hosted-agent):**
  - Added a new changeset, `@endo/hosted-agent: minor`. The repo's changeset config versions private packages too, so the earlier "it's private" reason for skipping it was wrong (migrator 1, changeset-auditor 1 and 2).
  - The daemon changeset now covers checks that only test `!== 'revoked'`, provisioning records showing up in the catalog, and custom backends that lack `recover` (migrator 2 and 3).
  - Trimmed the README and the `types.ts` header (pruner 2 and 3).

**Answered but not changed:**
- **decomplector 1 and 2 (replace `provideBase64` with a name lookup):** this repeats the round-6 point, and I gave the same answer. A crash between writing the grant and binding the pet name leaves a live grant with no name, which a lookup by name can't find. Removing the caller-chosen IDs would need a create that is atomic across both stores. That is a design call for the maintainer, not something for a fix round. The reviewer keeps raising it each round, so the maintainer may need to settle it.
- **pruner 1 (shorten the PR body's phase rows):** left as is, because `phase-evidence-gate` reads one row per phase.

**Checks run locally:**
- `secret-manager` and `secret-backend` tests pass, including the new one.
- `yarn lint:types` passes in `packages/daemon` and `packages/hosted-agent`, and prettier is clean.
- `secret-database.test.js` fails locally with `ERR_DLOPEN_FAILED`: the better-sqlite3 native module won't load here. I didn't touch that file.

**CI:** `ci-wait-merge` returned rc 4 after the 3300s deadline. Of 36 checks, `test (22.x, macos-15)` and `test (24.x, macos-15)` were still pending, and `test (22.x, ubuntu-latest)` failed on the bwrap flake above. Once the run finishes, the failed ubuntu leg should be rerun with `gh run rerun 41357395256 --failed`.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3090454 cached reads)
- Output: 15319 tokens
- Cost: $1.6083748
- Wall-clock: 4132s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
