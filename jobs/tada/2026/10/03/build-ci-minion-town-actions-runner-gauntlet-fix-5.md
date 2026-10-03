## Fix round 5: kriscendobot/minion.town PR #145

I applied the round-5 panel's must-fix items and the inexpensive should-fix items, pushed them to the PR head as one follow-up commit, and CI is green (`ci-wait-merge` exited 0). The commit is `a3c861f`, on top of `37b05e8`, pushed with `safe-push-pr-head.sh`. CI run 37110843000 passed `test` and both Claude harness jobs (amd64 and arm64).

**Must-fix items:**
- **prover:** A new test sends an event that sets `labels`, `runner_group_id` and `work_folder`, and checks that the posted body keeps the fixed values. I applied the prover's own patch (`labels: event?.labels ?? labels`) as a mutation check, and the new test fails under it.
- **saboteur:** The spared-entry list is now written NUL-delimited, loaded into a bash associative array, and matched exactly instead of with `grep -qxF`.
- **breaker:** The scrub keeps the spared world-writable directories (`/tmp/.X11-unix` and the like) but now removes anything inside them that root does not own. The selftest plants `/tmp/.X11-unix/ci-residue-probe` and checks that it is gone. I checked the scrub logic locally against a mock directory tree.

**Should-fix items also applied:**
- **Name stamps:** The minter now adds its own UTC timestamp to every runner name, and the caller supplies only a label of up to 32 characters. When deciding what to prune, it treats a stamp that isn't a real date, falls before 2000, or lies in the future as stale. The millisecond-suffix name format is gone.
- **Prune:** It now re-checks that the repo is private. If the repo has become public, it deletes every idle `ci-minion-town-*` runner, online ones included. It skips a runner another host already deleted (404). A page with no `runners` array, or a GitHub response that isn't JSON, now fails with an error naming the request.
- **Controller:** `pkill` repeats until no runner-user process is left. The runner user writes its own `.jitconfig`, so a symlink planted in its home can't redirect a root write. A shared `invoke_minter` helper now serves both mint and prune.
- **Small items:** JSDoc on `makeHandler` and `handler`. The SSM wait loop falls back to `|| echo Pending` instead of aborting on a transient AWS error. Abbreviated names spelled out (`res`, `meta`, `sec`, `lg`). `DEPLOYMENT.md` updated to match, including a sentence on why the Lambda sits under `ci-runner/`.
- **Tests:** The local suite went from 9 to 15 tests, all passing. New cases cover a sweep over name lengths and character classes, `mintedAt` range checks, public-repo prune, a 404 during prune, malformed pages, and `0`/`false` as the name.
- **PR title and body:** The title now ends in `[skip deploy]`. The body explains that run 36775062292 had `probe` and `verify` pass and only the deliberate `fail` job go red. It also notes that the validation runs were on `ddd2418`, before the review rounds, and asks for a squash-merge.

**Not done:**
- **`/var/tmp` residue surviving a reboot (breaker):** This needs a static allowlist or a snapshot taken during bootstrap. It's a design change I left for later.
- **Property tests (fast-checker):** I wrote a fixed sweep over name lengths and character classes instead of `fast-check` properties.
- **Coverage report:** No c8 coverage report was produced.

**Follow-ups:**
- The live host is still running the old controller and minter. To roll out, **redeploy the minter Lambda first** (`provision-ci-runner.sh`), then re-converge the host (`deploy-ci-runner-host.sh`) and run the selftest. In the other order, the old minter would create names without stamps, and its own prune would treat them as stale at once. This is also in the PR body.
- I didn't confirm that the CI that just passed runs the Lambda `node --test` suite; I ran it locally.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2282192 cached reads)
- Output: 26570 tokens
- Cost: $1.8222383999999998
- Wall-clock: 921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
