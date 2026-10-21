I re-ran nothing and pushed nothing, because CI on PR #1483 is already green. Nothing failed for real; the CANCELLED checks are leftovers from a duplicate run that was cancelled when a second one started.

**What I found**
- The PR is `build/ocapn-noise-heartbeat-capability`, merging into `build/ocapn-noise-session-reconnect-crossed-hellos-acbaf00`. It is a draft, GitHub reports it as mergeable, and the latest commit is `362dd9eea9`.
- On 2026-10-20 at 00:25:40Z, that commit triggered two near-identical sets of workflow runs a second apart: CI, Workflow security audit, IronHorse oracle sanitizers, Test project mutual dependency versions and OCapN Guile interop.
- The first set (`39347572xxx`) was cancelled because the second set (`39347574xxx`) replaced it.
- All five workflows in the second set finished with **success**. That covers the test matrix (22.x and 24.x, ubuntu and macos), cover, lint, zizmor, viable-release, familiar-bundle, sandbox-drivers and build-xsnap. The ironhorse, xs, hermes and wasm jobs were skipped on purpose by the changes filter.

**What changed:** nothing. No re-runs, no commits to the PR or to the garden.

**Status:** CI is green and the PR is ready for the gauntlet. It is still a draft; the gauntlet takes it out of draft.

**Follow-ups:** The PR's combined check list still shows the 30 cancelled entries from the replaced runs. A tool reading that list without filtering may think CI is broken. Main2 commit `d68ce6d0317` makes `ci-wait-merge` drop cancelled checks from a replaced workflow run, so the merge path should handle this. Other tools that read the same list may not, which could produce more false "re-trigger CI" jobs like this one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endo-but-for-bots-pr1483-heartbeat-capability-bit-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118844 cached reads)
- Output: 1298 tokens
- Cost: $0.3874968
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
