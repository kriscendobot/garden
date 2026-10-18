Fix round 2 for kriscendobot/minion.town PR #206 (head `heal-cfafabe-deploy`) is pushed and CI is green.

**What I changed:** the style pre-pass had one blocking failure (spell-out-identifiers) in `test/deploy-www-staging.test.ts`. I fixed it in one follow-up commit, `8a188d6`, pushed with `safe-push-pr-head.sh` (`976e7d5..8a188d6`):
- Renamed `dir` to `directory` everywhere, including the `Harness.directory` field.
- Renamed `tempDir()` to `temporaryDirectory()`.
- `numRuns` is the option name fast-check itself requires, so it can't be renamed. Instead I added a `// spell-out-exempt` marker on line 1 saying why. This is the probe's built-in opt-out, and other test files in this repo already use it.

**Not changed:** the non-blocking pruner warning on the comment at `deploy/aws/scripts/deploy-www.sh:14`. I kept that comment because it explains something you can't see from the code: inlining every file into one SSM document goes over the ~100 KB SendCommand limit, which is why files are sent one at a time and in chunks.

**Checks:**
- The spell-out probe now passes.
- The test file passes locally (8/8 vitest tests), and `tsc --noEmit` reports no errors.
- CI: the one run, "test (typecheck + vitest)", finished with success. It sat queued for about 35 minutes before a runner picked it up. My first long `ci-wait-merge` call was cut off by the shell time limit, so I watched the run through the Actions runs API, then re-ran `ci-wait-merge.sh --no-merge`, which returned rc=0 (CI GREEN).

**Follow-ups:** none. I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1118876 cached reads)
- Output: 5772 tokens
- Cost: $0.7376312
- Wall-clock: 2949s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
