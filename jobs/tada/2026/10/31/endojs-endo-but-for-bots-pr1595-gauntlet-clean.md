Clean stage done for endojs/endo-but-for-bots#1595 ("feat(cli): provision bounded Git remote profiles", draft): I added coverage tests and fixed a type-build error the PR introduced. CI is now green on the new head `86afe57e1a7` (36 checks, 0 failed; `ci-wait-merge.sh` returned 0).

**Pushed to the PR branch** `kriscendobot:build-daemon-git-remotes-interactive-provisioning` through `safe-push-pr-head.sh`:

1. **`25bedca93` — test: cover Git remote profile and record edge cases.**
   - `packages/cli/test/git-remote-command.test.js`: tests for the unknown-profile error message, and for the inspection output when a remote is revoked, has no fetch or push targets, allows force push, has an unavailable credential, or needs no credential.
   - `packages/daemon/test/formula-record.test.js`: a git-remote record with no credential, `defaultPullRef` set, and the policy flags omitted (they fall back to `false`).
   - Both files pass locally (10 and 12 tests), and prettier and eslint are clean.
2. **`86afe57e1` — fix(cli): add `src/**/*.ts` to `packages/cli/tsconfig.json` `include`.**
   - On the PR's original head, the `lint` job's `yarn build:types` failed with TS6307: `git-remote.js` imports types from `git-remote-types.ts`, and the composite project didn't list that file.
   - I reproduced the error from a clean tree, and with the fix `tsc -b tsconfig.composite.json` and `tsc` both pass. `packages/agentry` uses the same include.

**Dead code:** none found that the change orphaned, so nothing was removed.

**Notes:**
- On the first CI run, `cover (24.x)` also failed, in `packages/sandbox`: "bwrap timeout and repeated cancellation reap process groups". That code isn't touched by this PR, it matches the known bwrap CI flake (fix tracked in #1566), and it passed on the rerun.
- The PR stays draft; the panel stage handles un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2965575 cached reads)
- Output: 12063 tokens
- Cost: $1.4893509999999999
- Wall-clock: 4067s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
