The botanist job for a minion.town `@anthropic-ai/claude-code` bump now tells the botanist to run and commit `npm run claude-harness:refresh` before shepherding CI. Previously it learned that step from a red CI run every time. The change is pushed to `main2` as `0229c5f42c5`. Both test suites pass on the pushed head: the watcher suite 65/0 and the new hook-runner suite 16/0.

**What changed**
- **New `scripts/jobs/dependabot-migration.sh`.** It holds a fixed table of hooks keyed on repo + package. The only row is `claude-harness-refresh`, for `kriscendobot/minion.town` + `@anthropic-ai/claude-code`. It has two modes:
  - `lookup <repo> <pkg>` is an exact string match on the package and repo the watcher already parses and validates, so no PR text reaches the job body through it.
  - `run <hook> <checkout> <base-sha>` applies the hook to the PR-head checkout. It commits only if every check passes and never pushes:
    - **rc 2:** the checkout has uncommitted changes, or the PR touches anything other than `tools/claude-harness/{package.json,package-lock.json,release.json}`. The refresh is never run.
    - **rc 4:** the refresh fails or times out (900s cap).
    - **rc 3:** the refresh changed or created any file other than `tools/claude-harness/release.json`. Nothing is committed.
    - **rc 4:** `npm run claude-harness:check` fails on the result. Nothing is committed.
    - **rc 0:** prints `committed <sha>`, or `already-current` when an earlier attempt already committed the refresh.

  npm runs with `npm_config_ignore_scripts=true`, so pre/post scripts are skipped.
- **`scripts/jobs/dependabot-watcher.sh`.** For a full-review PR whose repo and package match a hook, the job body gains a `MIGRATION HOOK` section with the exact command. It says to push on rc 0, and on any other exit code to push nothing by hand and treat it as an unrepaired CI failure. On a repo the bot doesn't own, the botanist names the hook in its recommendation instead of running it. The "superseded" and "incompatible" close-only job bodies are unchanged.
- **`roles/botanist/AGENT.md`, step 6.** A short paragraph explaining what a `MIGRATION HOOK` section means and how to act on each outcome.
- **Tests.** The new `scripts/jobs/test/dependabot-migration-test.sh` uses a stand-in `npm` to cover lookup and each of the checks above. The watcher test gained a case showing only the exact repo + package gets the hook: a different package on the same repo doesn't, and neither does the same package on another repo.

**Follow-ups**
- The watcher change takes effect on the next normal garden deploy.
- The real refresh needs `gpg`, network access to `downloads.claude.ai`, and Node 22.15 or later on the botanist's host. If any is missing, the hook exits with rc 4 and the botanist falls back to ordinary CI-failure handling.
- To add another known migration later, add a row to `hook_table()` in `dependabot-migration.sh`; it goes through normal review like any other code change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-claude-harness-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2865391 cached reads)
- Output: 25492 tokens
- Cost: $1.9513342
- Wall-clock: 537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
