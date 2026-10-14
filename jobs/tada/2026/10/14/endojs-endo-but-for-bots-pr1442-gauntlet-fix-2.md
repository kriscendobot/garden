# Gauntlet fix round 2: endojs/endo-but-for-bots#1442

I applied the round-2 panel fixes and force-pushed the new head `eec274bad8`. CI is green: 14 of 14 checks pass.

**Must-fix**
- **`fixup!` commit:** I squashed `4395ad9a6e` into the SES commit.

**Should-fix**
- **"address panel review" commit:** I folded `26b4d946cf` into the same SES commit. The history is now three logical commits on `master-356d6e7`:
  - `9ba26fb69a` fix(ses), the frozen null pill tolerance
  - `d0fa31a3e5` chore(deps), the configstore/nconf resolutions
  - `eec274bad8` fix(scripts), which keeps Yarn's install state across `git clean`
- **Test setup file `_prepare-with-frozen-null-pills.js`:**
  - Fixed the garbled opening comment ("that permit removal will visit" now reads "that lockdown's property removal visits").
  - Renamed `shapes`/`pill` to `pillDescriptors`/`pillDescriptor`, and the local `shape` to `pillShape` so it matches `globalThis.pillShape`.
- **Drift check on the `clean` script:** the test the panel asked for already exists. "the root clean script uses the shared arguments" checks that the `clean` script in `package.json` matches the shared argument list, so no code change was needed.
- **PR body:**
  - It now says `eshost-cli` is the package that pulls in configstore and nconf.
  - I cut the file paths it mentions from 5 to 0, and it still names all three changes in the PR.

**Verification**
- The 4 frozen-null-pill tests pass locally, and prettier and eslint are clean on the edited file.
- The final tree differs from the old head only in the renamed test setup file.
- The first CI run failed on `build`, `cover` and `test-ocapn-python`. All three failed while installing Node, because GitHub's Node version manifest returned HTTP 500 or couldn't resolve `lts/*`. That is a GitHub infrastructure error, not the PR. I reran only the failed jobs, and `ci-wait-merge` then returned rc 0 (green).

**Follow-up**
- Rewriting the SES commit means `d0fa31a3e5` and `eec274bad8` are new SHAs. The PR no longer shares commits with the `upstream/pr-3372` mirror ref, though the content is the same.
- The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (978238 cached reads)
- Output: 6154 tokens
- Cost: $0.8479196
- Wall-clock: 868s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
