CI on draft PR https://github.com/endojs/endo-but-for-bots/pull/1428 (head `fix-upstream-master-ci` → base `master-356d6e7`) is now green at `e1279b7939`. All 14 checks pass, including the CI, mutual-dependency-versions and zizmor workflows. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/37408899643.

**What I found.** The PR started with every job red, not just the three known failures. Each job died about 15 seconds in, during `yarn install --immutable`. There were two separate causes:

1. **Every job failed at install.** An upstream commit (`0aeac04b93`) hand-edited `yarn.lock` so that `configstore@^1.4.0` resolves to 5.0.1 and `nconf@^0.8.2` resolves to 0.13.0. Yarn turns on a stricter "hardened mode" for public pull requests, and it rejects those entries as invalid resolutions (error YN0078). Upstream's own push runs never hit this because hardened mode is off there.
   - **Fix:** I declared both overrides in the root `package.json` `resolutions` and regenerated the lockfile under hardened mode. The resolved versions are unchanged, and only two lockfile keys changed. The lockfile is in its own `chore: Update yarn.lock` commit.
2. **`lint` and `viable-release` failed after a clean step.** `yarn clean` and `scripts/pack-all.mjs` both run `git clean -fX -e node_modules`. That also deletes `.yarn/install-state.gz`, which is git-ignored. Without that file, Yarn treats the project as not installed and refuses the next `yarn run`. This broke the lint job's `yarn docs` step and pack-all's `yarn build` step (the viable-release log literally shows "Removing .yarn/install-state.gz" just before the error).
   - **Fix:** I added `-e '!.yarn/install-state.gz'` to the root clean script and to both clean steps in pack-all, and updated pack-all's doc comment to match. I compared the two forms with `git clean -n` dry runs: `node_modules`, the top-level `dist/` and everything else are handled the same way, and only the install state is now kept.

**`test (22.x, macos-15)`:** I made no code change for this one. Upstream's failure was a single CapTP rejection in the `@endo/daemon` `endo › lifecycle` test. It passed on this run, so it looks like a flake. If it shows up again, it's a daemon test-stability problem, not something this PR caused.

**Commits on `fix-upstream-master-ci`:**
- `b1ee689ee5` build: declare the configstore and nconf overrides as resolutions
- `chore: Update yarn.lock`
- `e1279b7939` fix(scripts): preserve yarn install state across `git clean`

I also posted a summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1428#issuecomment-6008782779

**Status:** this is parked on the frozen fork branch `master-356d6e7` on `endojs/endo-but-for-bots`. Nothing has been merged or ferried to `endojs/endo`.

**Follow-ups:**
- Carrying these fixes to upstream `endojs/endo` needs separate, explicit authorization (a ferry). The resolutions fix and the install-state fix would each make sense as their own upstream PR.
- No garden-library changes were needed for this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-upstream-master-ci-shepherd-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (2700200 cached reads)
- Output: 15018 tokens
- Cost: $1.4458640000000003
- Wall-clock: 1053s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
