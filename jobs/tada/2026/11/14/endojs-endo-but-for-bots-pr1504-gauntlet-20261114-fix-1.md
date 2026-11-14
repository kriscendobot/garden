---
orchestration-failed: true
---
orchestration-failed: true

# PR #1504 gauntlet, fix round 1: fixes pushed, CI is red on a failure this PR didn't cause

I applied the panel's must-fix item and the should-fix items it raised, and pushed them to the PR head (`a2e4309dc6` → `859c8d4e243`). CI finished red (`ci-wait-merge` rc 3). Only one check failed, `test-xs`, on hardened262 `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js`. That same test was already failing on this PR before the fix, and it fails the same way on the unrelated PR `daemon-worker-import-from-mount-phase-three`. The other 35 checks passed or were skipped.

**What changed**
- **Must-fix (prover):** `packages/daemon/test/endo.test.js` now has a test that starts a real daemon and creates a sandboxed shell with `provideShell`, using a stand-in sandbox factory (`test/_stub-sandbox-factory.js`). It checks:
  - both ways `provideShell` rejects a bad request;
  - the saved shell record keeps `sandboxId`, and the factory's own reference isn't stored with the policy;
  - the shell keeps the factory alive after the factory's name is removed;
  - after a restart the shell comes back sandboxed and gets a new sandbox slice.
- **Checking the new test:** it passes locally. I broke the code on purpose twice (removed `sandboxId` from the saved record, then removed the `['sandbox', …]` dependency), and the test failed both times.
- **Sandbox tests no longer pass silently:** if `ENDO_SANDBOX_REQUIRE_BWRAP=1` is set, the sandbox shell tests fail when bwrap is missing instead of quietly passing. The `@endo/sandbox` `test:drivers` script sets it, and CI's `sandbox-drivers` job runs that script; that job passed. Elsewhere the skip is now logged.
  - I first put this setting in `ci.yml`, but editing that file makes CI run every job, including unrelated ironhorse Rust jobs that were already failing. I reverted that edit with a revert commit (no force-push).
- **Migrator:** the two floot Shell test mocks now return `engine: 'host'`.
- **Pruner:**
  - Each repeated fact (the `'environment'` engine rule, the `ProcessLike` contract) is now stated in one place; the other places point to it.
  - Removed the comment that just repeated `SANDBOX_SHELL_WORKDIR` and the note about CI timing.
  - Wrapped the long line in `interfaces.js`.
  - Cut the PR body from about 573 words to about 275.
- **Releaser:** the changesets no longer cover internal details or explain the version bump.
  - I did not apply releaser's first item (remove the private packages). The repo's changeset config versions and tags private packages, and 41 existing changesets name `@endo/daemon`.
  - Private packages keep their entries, limited to the module move, the type rename, and the `wait()`/`kill()` behavior change.
- **Prover item 3:** no change needed. Both test suites run the whole shared `engineCases` list with no filter.
- I posted the reasoning for each item as PR comments `#issuecomment-6877045262` and `#issuecomment-6877385030`.

**Checked locally:** the new daemon test, all 9 sandbox shell tests with bwrap required, eslint, prettier, and the repo-wide type check (no errors).

**Follow-up:** the `test-xs` failure is in hardened262/SES and needs its own fix outside this PR. Once that lands, rerunning CI should turn this PR green. The panel-2 round can go ahead on head `859c8d4e243`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-20261114-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 200 tokens (12518187 cached reads)
- Output: 37461 tokens
- Cost: $4.548017400000001
- Wall-clock: 6741s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
