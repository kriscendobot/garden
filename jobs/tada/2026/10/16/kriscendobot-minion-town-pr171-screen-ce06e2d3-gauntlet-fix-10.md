# Fix round 10 report: kriscendobot/minion.town PR #171

I applied both must-fix items from the round-10 panel and pushed them to the PR head (`22ca484..3b2146c`, through `safe-push-pr-head.sh`). CI is green at `3b2146c`: `ci-wait-merge` returned rc 0, with 1 run and 0 failed.

## Fixes

1. **Staging race in `deploy-app.sh` (breaker #1), commit `962e5d7`.** During staging, the whole new tree was handed to `minion-mcp` before root took back the files it runs. In that window a `minion-mcp` process could have swapped in its own observer, which root would then run.
   - I removed `chown -R minion-mcp:minion-mcp /opt/minion-town.new`. The archive already unpacks as `root:root` (`create-app-artifact.sh --owner=0`), so the protected paths are now root-owned and read-only first.
   - Only the rest of the tree goes to `minion-mcp`, through a scoped `find`. It skips `bin/` and each protected file and directory, and uses `chown -h` so a symlink can't redirect the change onto a protected file.
   - A new test in `test/deploy-app-artifact.test.ts` fails if the whole tree is chowned to `minion-mcp` again, or if the scoped step runs before the protection, or stops skipping a protected file.
   - I simulated the `find` on a temp tree to confirm it skips the right paths.

2. **The observer's `claude --version` run (decomplector/integrator #1), commit `3b2146c`.** The binary only ran when its digest already matched the pin, so the version run told us nothing the digest hadn't.
   - **`claude-harness-observe.cjs`:** takes no input and runs no command; it only hashes and inspects files.
   - **SSM document (`cd-iam-documents.mjs`):** has no parameters now, so the probe sends none.
   - **`claude-harness.mjs`:** the separate version check is gone. A digest mismatch now names the pinned version in its message.
   - **Tests and docs:** `prod-objectives.test.mjs`, `cd-iam-documents.test.mjs`, a comment in `deploy-cd-iam.mjs`, and `DEPLOYMENT.md` match the new behaviour.

## Checks

- `node --test` on the probe and IAM-document tests: 36/36 pass.
- `vitest` on `test/deploy-app-artifact.test.ts`: 7/7 pass.
- `npm run typecheck` passes.
- `bash -n deploy-app.sh` passes.

## Follow-ups

- **Round-10 items still open:** I didn't address the should-fix or comment-only items:
  - old SSM document versions are kept and stay runnable;
  - the summary has both `issue` and `issues`;
  - `DEPLOYMENT.md` still lists the observer's report on its own files as a check.
- **CI watcher stopped and restarted:** the first watch hit the background time limit and was stopped while CI was still pending. GitHub API rate limits had also hit the bot account during that watch. I restarted the watch and it reached green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3667772 cached reads)
- Output: 20843 tokens
- Cost: $2.0322143999999995
- Wall-clock: 2537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
