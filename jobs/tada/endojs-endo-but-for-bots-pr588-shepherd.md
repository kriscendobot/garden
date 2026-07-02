CI is fully green (24 checks pass, 0 fail). The job is complete.

**Summary of what I did:**

Shepherded endojs/endo-but-for-bots PR #588 (base `llm`) to green CI.

- **Re-fetched live state:** PR #588 open, draft, base `llm`, head `lint/prefer-makeexo-over-far`.
- **Rebased twice onto `origin/llm`:** first onto `2b2e32006` (which carries the bucketed `scripts/eslint-repo.sh` lint-ceiling fix from #597), then again after `origin/llm` advanced to `113228924` (#590, the @endo/far→exo repoint). Both rebases applied the PR's single commit cleanly with no conflicts (final head `63c7b9f4f`). Pushed with `--force-with-lease` each time.
- **Lint ceiling confirmed cleared:** the `lint` check now passes (~10min) — the bucketed `eslint-repo.sh` fix does what the job predicted, so the original block is gone.
- **Drove out flaky test failures:** across runs the `test (22.x, macos-15)` / `test (24.x, ubuntu-latest)` jobs intermittently failed with the runner-infra signature (SIGINT + node24 binary "No such file or directory") and a `token-autocomplete` `waitFor: condition not met within 20000ms` DOM-render timeout — a *different* token-autocomplete test each time, sibling matrix cells passing, and the `llm` base itself green. Diagnosed as a macos timing flake, not a #588-introduced or out-of-scope regression, so I re-ran the failed jobs (twice) rather than escalating to a fixer. Each re-run cleared.
- **Final state:** all 24 checks green, head `63c7b9f4f`, no branch drift from `origin/llm`.

**What changed:** PR #588 head branch rebased onto current `origin/llm` and pushed; CI green.

**Follow-ups:**
- PR #588 remains DRAFT — un-drafting is the judge/panel's responsibility per the pipeline, not the shepherd's. It's now ready for that next stage.
- The `packages/chat/test/component/token-autocomplete.test.js` component tests are a recurring macos timing flake (20s `waitFor` timeouts, aggravated by the SIGINT/node-cache infra hiccup). Worth a hardening pass (longer/tunable `waitFor`, or marking macos-tolerant) so it stops reddening CI — out of shepherd scope, but flagging for a future fixer.
