# Clean stage done: kriscendobot/minion.town PR #176

The new operator script had no tests, so I added one test file and pushed it to the PR head. CI is green at the new head.

**What the PR changes:** it adds `deploy/aws/scripts/git-remote-partition.sh`, which creates, mints, revokes, shows and destroys git-remote partitions over AWS SSM. It also splits the SSM call in `common.sh` into `ssm_invoke`, `ssm_run` and `ssm_capture`, and updates `DEPLOYMENT.md`. CI was already green at the old head (e83b8de), but the script had no tests.

**Dead code:** none. The new helpers `ssm_invoke` and `ssm_capture` are both used. Shellcheck shows nothing new; its warnings about unused variables in `common.sh` were already there, and other scripts that load `common.sh` use those variables.

**Coverage added** in commit 8530b82, file `test/git-remote-partition-script.test.ts`: 17 vitest cases. They run the script against a fake `aws` program, so no real AWS calls are made. They check that:
- Bad input is rejected before anything is sent to AWS: wrong partition id, token hash, owner format or access level, and an existing URL file is never overwritten.
- `mint` writes the one-time URL to a file only the owner can read (mode 0600), prints only the token hash, and the URL never appears in the output.
- The arguments for `create`, `mint`, `revoke` and `destroy` reach the remote side correctly, including the owner check in `destroy`.
- `revoke` fails when the binding doesn't exist and succeeds when it does.
- A failed SSM command shows the remote error and exits non-zero.
- `ssm_run` and `ssm_capture` send the remote output where the refactor intends, and `ssm_run` stops on a non-Success status.

The suite skips itself if `jq` or `python3` is missing, because CI runs on a self-hosted runner. It ran fully on this host (17 passed, none skipped), and `npm run typecheck` is clean.

**Push and CI:** I pushed with `safe-push-pr-head.sh`, a fast-forward from e83b8de to 8530b82. At the new head, `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all passed, and `ci-wait-merge.sh --no-merge` returned 0 (CI GREEN). My first `ci-wait-merge.sh` run hit the 10-minute background limit and was killed before it finished. I waited in the foreground until all checks finished, then re-ran it.

**Follow-ups:** none. The PR is still a draft; the next gauntlet stage picks it up.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr176-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1337629 cached reads)
- Output: 11041 tokens
- Cost: $1.0310418
- Wall-clock: 1749s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
