I applied all three must-fix items from the round-6 panel on PR #151 (https://github.com/kriscendobot/minion.town/pull/151). The PR head is now `b3cacfe` and CI is green (3 of 3 checks, `ci-wait-merge` rc 0).

**History rewrite.** This needed a force-push, done with `safe-push-pr-head.sh --mode rewrite` from `0955bf9`. Before adding any new commits I checked that the rewritten history produces exactly the same files as `0955bf9`.
- **Must-fix #2:** the rename of `npm-registry-preflight.js` to `.mjs` now happens in the same commit that updates its callers ("fix(npm-registry): ship the preflight as .mjs"). No intermediate commit points the deploy script at a file that doesn't exist.
- The packager also flagged `b74c55e` for bundling two unrelated fixes. It is now two commits: "lowercase ASCII only in gen-allowed-emails" and "rewrite every vendored import in vendor-endo-claude".
- I did not do the integrator's optional larger cleanup (one commit per conversion instead of the 12 review-round fix commits).

**New follow-up commits**
1. **Must-fix #3 (symlink guard):** all seven executables now compare `import.meta.url` against the real path of `argv[1]`, so a script run through a symlink still runs `main()`. The seven are the preflight, `deploy-caddy-route53`, `gen-allowed-emails`, `check-javascript-only-scripts`, `vendor-endo-claude`, `install.mjs` and `inspect-image`. A new test runs `deploy-caddy-route53.js` through a symlink; I confirmed it fails with the old guard and passes with the new one.
2. **Must-fix #1 (`replaceAll` test):** the import rewrite is now an exported helper, `rewriteAgentToolsImport`. The new `test/vendor-endo-claude.test.mjs` covers a file with two occurrences and both "import rewrite did not apply" refusals. Reverting `replaceAll` to `replace` now fails the test. The provenance round-trip check in the existing vendor test also uses `replaceAll` now.
3. **Should-fixes also applied:**
   - `deploy-caddy-route53` keeps a single `v1.6.2` default and no longer exports the raw, unvalidated version; `main()` uses the parsed version for both the script and the SSM description.
   - The in-container credential check in `inspect-image` now uses the same broad pattern as the image-config check.
   - `inspect-image` refuses an empty `requiredHelpFlags` list.
   - AGENTS.md now says when to use `.js` and when `.mjs`.
   - The PR description's Review focus names the npm-registry `ExecStartPre` change and `deploy-cd-iam`'s new import from `lib/common.js`.

**Local checks:**
- Typecheck, the JS-only gate and the claude-harness tests (30 of 30) pass.
- The main suite has one failure: the `git-remote/capability` test. It is in code this PR doesn't touch and is recorded as already failing on this host, so I left it.

I left the comment-only items for a later round: the property tests, the `df --output` parse, the operator note about moved entry points, and the c8 coverage report. The panel itself is for the driver to re-run (panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2603428 cached reads)
- Output: 17183 tokens
- Cost: $1.5454016000000006
- Wall-clock: 491s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
