I applied all the round-3 must-fix items on PR #1408 (https://github.com/endojs/endo-but-for-bots/pull/1408). The new head is `e9d568da3e`, and CI is green after rerunning two failed jobs that weren't caused by these changes.

**Code fixes** (four follow-up commits, pushed with `safe-push-pr-head.sh` in advance mode, `f150d71c9d..e9d568da3e`):
- **`23e7b0f336` (breaker, saboteur, purist, corner-prober, warden):**
  - The `bwrap` slice now passes `--unshare-user --disable-userns`, so the confined process can't create a nested user namespace to regain capabilities.
  - `resolveSystemMounts` now treats only `ENOENT` as "path absent"; a permission or I/O error is raised instead of silently dropping the mount.
  - The assembled argv is hardened.
  - Two new tests cover these.
- **`19bcee8d76` (breaker, stylist, transplanter):**
  - `claude`'s directory is granted only when it is a package directory holding `package.json`. Otherwise only the real binary is granted, so a `claude` sitting in `/usr/local/bin` no longer exposes its neighbors.
  - A new test covers the package-install case, and the symlink test now expects only the file to be granted.
  - The README is updated to match.
  - The `ect-*` test temp directories are spelled out and placed under `os.tmpdir()`.
- **`176f90cec8` (integrator):** rewrote the two remaining `@endo/claude-sandbox` DD6 claims in `designs/endo-claude.md` (around lines 795 and 803).
- **`e9d568da3e` (changeset-auditor):** folded the bwrap changeset into `add-endo-claude.md`, one sentence per line.

**PR body (pruner, coverage-auditor):** I removed the empty Scaling and Upgrade sections, trimmed Testing Considerations, and added a statement that `@endo/claude` is Node-only, so it has no XS or browser tests.

**PR comment (scribe):** a summary comment (https://github.com/endojs/endo-but-for-bots/pull/1408#issuecomment-5942667035) maps each commit to the findings it closes. It also corrects two earlier comments:
- The round-2 summary wrongly said nothing was declined. Round 1 declined curator's should-fix about `--bwrap` being a second way into confinement.
- The 17:41Z "maintainer action required" notice was a false alarm. It was an unrelated macOS flake that a rerun cleared.

**Declined, and listed as declined in the PR comment:**
- Renaming the `sandbox-drivers` CI job (integrator, should-fix). An inline comment in `ci.yml` already explains why the job is shared.
- Removing the `reexport-policy-exempt` comment (pruner, acknowledge-only). The re-export audit reads that marker.
- The fast-check property tests (fast-checker) and binding only the broker socket instead of its directory (wire-watcher) are deferred to follow-ups.

**Verification:** locally, the `bwrap-slice` and `confined-turn` tests pass (17 tests) with a real bubblewrap 0.9.0 and `ENDO_CLAUDE_REQUIRE_BWRAP=1`. eslint, `tsc`, and prettier are clean.

**CI:** the first run had two failures unrelated to this diff:
- `test (24.x, ubuntu-latest)` crashed inside yarn during `yarn install` ("The `onCancel` handler was attached after the promise settled").
- `cover (24.x, ubuntu-latest)` hit a random fast-check counterexample in `@endo/patterns` copySet `setIsSuperset`.

The first `ci-wait-merge` reported RED from those results before the rerun registered. After `gh run rerun --failed`, a second `ci-wait-merge` returned rc=0: 35 checks, 0 failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4474993 cached reads)
- Output: 17575 tokens
- Cost: $2.1908666
- Wall-clock: 5069s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
