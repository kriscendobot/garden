## Gauntlet fix round 3: kriscendobot/minion.town#176

I applied the panel-3 must-fix items in one commit, `be86339`, pushed on top of `24866b2` with `safe-push-pr-head.sh`. CI is green: `ci-wait-merge.sh --no-merge` returned rc=0, and all three checks passed (test, Claude harness amd64 and arm64).

**Must-fix items:**
- **stylist (renames):**
  - In `common.sh`, `ssm_invoke`'s `b64`, `param` and `cmd_id` are now `encoded_script`, `parameters` and `command_id`, and its header comment documents the `description` and `script` arguments.
  - In the partition script's `PRELUDE`, `root` and `base` are now `partitionsDirectory` and `publicBaseUrl`.
  - In the test, `params`, `parametersMatch`, `sent`, `relative` and `scratch` are now `awsParameters`, `encodedParameters`, `reachedSsm`, `relativePath` and `scratchDirectories`.
- **engine-realist (box needed root):** `box_node` now pipes the module to `sudo -u minion-git node --input-type=module -` on stdin. There is no longer a `mktemp` file, a `chown`, or an assumption that the SSM agent runs as root, and the box-side script sets `pipefail`.
- **corner-prober (mint URL file):**
  - `mint` now rejects an empty `url-file`, and a `url-file` whose directory doesn't exist, before any SSM call. Both cases have tests.
  - A new test covers a file write that fails after the token is minted (a read-only directory) and checks that stderr names `revoke <hash>`. This test passes vacuously when run as root.
- **saboteur/integrator (unbacked claim):** the Phase 13 row in `DEPLOYMENT.md` and the PR body now link the journal run record for `minion-town-git-remote-live-validation`. The commit message lists what was observed: clone and push, content root set, a 403 on a read-token push, a 401 after revoke, and the health check passing before and after.

**Cheap should-fix items, also done:**
- `destroy` now removes the bare repo before the sidecar, so an interrupted destroy can be retried, and the usage text says so.
- `show` now handles a record with no token list (`record.tokens ?? {}`).

**Tests:** the partition-script suite passes locally (22 tests). In the full local run, one test failed: `capability.test.ts`, "propagates a git failure rather than reporting the ref absent". The PR doesn't touch that file, and it passes in CI.

**Follow-ups, not done:**
- The other should-fix items: documenting recovery after a poll timeout, executing the box-side modules in a test, the remaining parsing corner cases, and the `git clone "$(cat readwrite.url)"` example, which exposes the URL in the process list.
- The scribe asked for a summary comment naming the round-1 fix push `adacedd`; this report is where that recap belongs.
- The driver re-posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr176-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2013867 cached reads)
- Output: 12008 tokens
- Cost: $1.2674854
- Wall-clock: 872s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
