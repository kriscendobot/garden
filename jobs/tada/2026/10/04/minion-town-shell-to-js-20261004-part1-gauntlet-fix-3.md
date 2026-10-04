Fix round 3 for PR #151 (https://github.com/kriscendobot/minion.town/pull/151) is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing. The panel was not re-run; the driver posts panel-4.

**Must-fix: two ways around the JavaScript-only gate (commit `35e60f7`).** Three panel seats found that `tools/check-javascript-only-scripts.js` could be bypassed by a tracked symlink or by an extensionless file with no shebang.
- The checker now reads each file's git index mode via `git ls-files --stage -z`.
- **Symlinks:** every tracked symlink now needs an allowlist entry. The checker does not follow links, so a symlink to a shell script can no longer slip through.
- **Extensionless files:** an executable file without a Node shebang now counts as a shell script. A non-executable file with no shell extension and no shebang is treated as data, because nothing tells a script run as `bash foo` apart from a file like LICENSE. Test rows pin this decision.
- **Mid-conversion files:** a shell extension wins over a Node shebang, so a `.sh` file with a Node shebang still needs an allowlist entry. A test row covers this.
- `checkRepository` now takes optional root and allowlist arguments. A new test builds a temporary git repo with a symlink, a bare executable, a LICENSE file and a Node script, and checks the whole path from reading the index to the result.
- The checker still passes on the real repo: nothing unexpected and no stale allowlist entries.

**Should-fix: tests for empty variables falling back to defaults (commit `29c7541`).** Commit `7cb1b76` changed eight defaults from `??` to `||` so an empty variable falls back like the shell's `${VAR:-default}`, but only one had a test.
- New tests set `AWS_REGION`, `INSTANCE_ID`, `ACCOUNT_ID`, `ARTIFACTS_BUCKET`, `ROUTE53_MODULE_VERSION`, `REGISTRY_STATE_DIRECTORY` and `NPM_REGISTRY_MINIMUM_FREE_KB` to empty values and check that the defaults apply.
- I switched the production code back to `??` temporarily and confirmed the new tests fail, then restored it.
- Also added the empty-policy case for `collectAllowedEmails`, which is what makes `gen-allowed-emails` fall back to the break-glass email.

**Not addressed, left for the author:**
- The packager seat noted that the vendored files were edited by hand; the panel asked for either regenerating them or naming the exception in the commit body.
- The purist seat asked for `new URL(…, import.meta.url)` instead of `path.join` in `tools/vendor-endo-claude.js`; this was already declined as a follow-up in round 2.
- All comment-only items, such as stating the SSM exception in AGENTS.md and the BSD `stat` fallback crashing with a raw stack trace instead of the formatted error.

**Local runs:** the three test files I touched pass (49 tests). A bare `npx vitest run` shows three failing files, all unrelated to this change:
- Two `tools/claude-harness/*.test.mjs` files fail with "No test suite found"; `npm test` excludes that directory.
- `test/git-remote/capability.test.ts` has one failing test. It is a known failure that depends on this host's environment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1423262 cached reads)
- Output: 12949 tokens
- Cost: $1.1039764
- Wall-clock: 451s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
