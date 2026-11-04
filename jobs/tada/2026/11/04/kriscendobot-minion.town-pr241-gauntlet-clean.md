Clean stage is finished for kriscendobot/minion.town#241: I added one test commit, removed no code, and CI is green at the new head, `fb4ec1e4`. The PR is still a draft, since un-drafting comes later in the gauntlet.

**Idempotence check:** CI was already green at the old head, `12ff97f9`, but no coverage pass had been run, so I ran one instead of treating the stage as a no-op.

**Coverage on lines the PR added:**
- **`src/`:** I ran the 11 Claude-related vitest suites with `@vitest/coverage-v8`, installed with `--no-save` because the repo doesn't include it, and compared uncovered lines against the PR's added lines.
    - **No gaps:** `claude-account-endpoint.ts`, `account.ts`, `agents.ts`, `types.ts`, `wiring.ts` and `guest-tools.ts` have no uncovered added lines or branches.
    - **One gap:** the boot log in `src/http.ts`. `endo-guest-lockdown.test.ts`, which wasn't in that coverage run, boots the frozen arm but never asserts it, and nothing ran the "still open" arm.
- **`tools/claude-harness`:** with Node's built-in coverage on `install.test.mjs`, the uncovered lines it reports in `install.mjs` and `release-verifier.mjs` are all outside this PR's additions. I did not add harness tests.

**What changed:** commit `fb4ec1e4`, `test(claude): pin the onboarding boot log in both flag states (#241)`, pushed with `safe-push-pr-head.sh` in advance mode.
- It adds a case to `test/endo-guest-lockdown.test.ts` that boots `createApp` with the flag on and off and expects exactly one matching onboarding log line.
- Lockdown freezes `console`, so the test replaces the global with `vi.stubGlobal`.
- The new test failed both when I swapped the log's arms and when I deleted the log; I reverted both mutations before committing.

**Dead code:** none. The PR only adds code and orphans nothing, so I deleted nothing.

**Verification:**
- **Local:** the lockdown suite passes (5 tests) and `tsc --noEmit` is clean. I did not run the full suite locally and relied on CI for that.
- **CI:** `ci-wait-merge.sh` returned rc 0 for the head after a first bounded wait timed out while CI was still pending. [`test (typecheck + vitest)`](https://github.com/kriscendobot/minion.town/actions/runs/41781089351) succeeded at `fb4ec1e4`.
- **Limit on that signal:** this host's PAT can't read `statusCheckRollup`, so the script fell back to the Actions runs API. Commit statuses and non-Actions check runs were not visible.

**For the panel:** an existing child under `needs-auth` with the flag off gets no connect form, because `connect` returns `onboarding-frozen`. The `createClaudeAgent` description still says "needs-auth (a connect form is sent to your inbox)". The PR body already flags that flag-off has no reconnect, so I left this alone rather than change behavior in a coverage stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (969434 cached reads)
- Output: 10825 tokens
- Cost: $1.0305867999999998
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
