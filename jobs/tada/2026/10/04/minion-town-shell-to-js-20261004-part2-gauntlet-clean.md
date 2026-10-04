Clean stage for kriscendobot/minion.town#152: no changes needed, nothing pushed, and CI is green at head `8712a29`.

**What I checked**
- **State:** the PR is an open draft. Its head is `chore/javascript-only-scripts-part-2a` on the kriscendobot fork, and its base is `chore/javascript-only-scripts-part-1-dcc2d64`.
- **Dead code:** the PR deletes 14 `.sh` scripts, and nothing in the repo still references any of them. Four exports in the new `deploy/aws/scripts/lib/*.js` modules have no outside callers (`addProviderToClient`, `instanceId`, `artifactsBucket`, `onExit`), but each is used inside the lib modules, so none of it is dead.
- **Coverage:** `test/deploy-provisioning-scripts.test.mjs` passes all 19 tests under vitest. They exercise the pure, testable parts of the lib modules: the ZIP writer, Cognito client-update shaping, argv parsing, the IAM/DNS policy shapes, and secret/env rendering. The code they don't reach only shells out to the AWS CLI and can't run in CI. I added no tests. I couldn't produce a line-coverage report because the `@vitest/coverage-v8` package isn't installed in the repo.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 3 checks green (test, Claude harness amd64 and arm64).

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (381228 cached reads)
- Output: 3088 tokens
- Cost: $0.49476559999999997
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
