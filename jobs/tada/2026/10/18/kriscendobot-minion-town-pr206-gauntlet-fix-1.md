# Fix round 1 report: kriscendobot/minion.town PR #206

I pushed one follow-up commit, `976e7d5c`, to `heal-cfafabe-deploy` that applies panel-1's must-fix items. CI is green: `ci-wait-merge` returned rc 0 with 3 of 3 checks passing.

**Changes:**
- **`deploy/aws/scripts/deploy-www.sh`**
  - **Staging moved out of the served root.** Every file is now built in `/srv/minion-town/www-stage/<run-id>/`. Before, partial files were written as `.<name>.new` inside the folder Caddy serves. The run id is unique to each deploy (UTC timestamp, process id, random number). The command that carries a file's last chunk also renames it over the live file. A partial file is never served, and two overlapping deploys no longer share a staging file (raised by purist, wire-watcher, saboteur and corner-prober).
  - **Cleanup in the final reconcile step.** It now also deletes dotfiles in the served folder, which catches leftover `.<name>.new` files from the previous version of this PR. It also removes this run's staging folder and any staging folder older than a day (breaker, engine-realist, integrator).
  - **One write path for all sizes.** Small files and large files now go through the same chunk loop, 60,000 base64 characters per command. A small file is a single command.
  - **Comments.** The per-file and failure-behaviour comments now describe the chunked path and what a failed chunk leaves behind (archivist). The non-ASCII arrow is now plain ASCII (typist).
- **`DEPLOYMENT.md`**: the old "one command per file, fails above ~56 KB" text is replaced with a description of chunking, staging, cleanup and how a re-run catches up (migrator, breaker).
- **New `test/deploy-www-staging.test.ts`** (prover, breaker, fast-checker, corner-prober). It runs the real `deploy-www.sh` against a stub `common.sh`, whose `ssm_run` executes each remote script against a temporary directory standing in for the server. It covers:
  - a fast-check property: any binary file from 0 to 180 KB comes out byte-for-byte identical, and every command stays under the ~100 KB SSM limit;
  - chunk-boundary cases at 45,000 / 45,001 / 90,000 / 90,001 bytes;
  - failure injected at any chunk: the live file is unchanged, nothing partial appears in the served folder, and a re-run fixes the deploy;
  - cleanup of leftover dotfiles and staging folders older than a day, while a recent one is kept;
  - two deploys run at once: the result is exactly one of the two inputs.
- **`test/shell-clip.test.ts`**: the test that matched source text now only checks the filename character filter, and points to the new test.

**Local checks:** the new test passes (8 tests), the two existing deploy test files pass (99 tests), and `tsc --noEmit` is clean. As a rough check that the new test can catch the old bugs, I ran it against the previous script. It did not pass, but it hung until the timeout rather than failing with a message.

**Not done:** pruner's should-fix notes on the PR description (trim the Verification checklist and the inline test count) are untouched; panel-2 can raise them again if they matter. Coverage-auditor's note that no c8 coverage report exists is still open.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2036433 cached reads)
- Output: 17736 tokens
- Cost: $1.4373185999999993
- Wall-clock: 4101s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
