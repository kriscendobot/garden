I applied the panel's must-fix item and folded in every should-fix item on kriscendobot/minion.town#151. The PR head moved from `dcc2d64` to `7cb1b76`, and CI is green (3/3 checks).

**Must-fix: the credential check in `tools/claude-harness/inspect-image.js` (commit `84508fe`)**
- The image smoke again matches credential names anywhere in the entry, the way the old shell `grep -E` did. Names with extra text before or after, like `ANTHROPIC_API_KEY_FILE=`, `CLAUDE_CODE_OAUTH_TOKEN_V2=` and `X_ANTHROPIC_API_KEY=`, fail the smoke again.
- The check now lives in an exported `findCredentialEnvironment`, which treats a `null` environment list as empty.
- The `IMAGE` check moved inside `main()`, so importing the module no longer exits.
- New `test/inspect-image.test.mjs` checks this against the old shell behavior: exact names, prefixed and suffixed names, `_FILE` names, a clean image, and a `null` environment.

**Should-fix: `tools/check-javascript-only-scripts.js` (commit `7975328`)**
- Any shebang that doesn't name `node` now has to be on the allowlist. That covers csh, tcsh, mksh, fish, ksh93 and python. Files ending in `.bash`, `.zsh`, `.ksh`, `.csh`, `.tcsh`, `.mksh` or `.fish` are caught even without a shebang.
- A new `readFirstLine` returns an empty line for deleted files, gitlinks and symlinks instead of crashing.
- A broken allowlist file now produces an error that names it.
- Tests cover all of this. The repo itself still passes the policy check.

**Should-fix: deploy scripts and vendoring (commit `7cb1b76`)**
- Wherever the shell used `${VAR:-default}`, the port now uses `||` instead of `??`, so an empty variable still gets the default. This applies to `AWS`, `AWS_REGION`, `INSTANCE_ID`, `ACCOUNT_ID`, `ARTIFACTS_BUCKET`, `ROUTE53_MODULE_VERSION`, the two preflight settings and `ENDO_REPO`.
- `SSM_POLL_TRIES` is checked by a new `parsePollTries` before `aws ssm send-command` runs, so a bad value never starts the remote program. It has its own test.
- `lib/common.js` no longer sets `process.env.AWS_REGION` when it is imported. It passes the region to each `aws` command instead.
- The registry preflight only runs `main()` when executed directly, not when imported.
- `vendor-endo-claude.js` throws an error instead of calling `process.exit` inside `try/finally`, so the temporary clone gets cleaned up.
- A broken `config/policy.json` now produces an error that names the file.

**Checks**
- `npm run typecheck` passes.
- One local test fails: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". This diff doesn't touch that file, and it still failed after I unset `GIT_CEILING_DIRECTORIES`, so I didn't find the cause. It doesn't fail in CI.
- All other tests pass locally (830 passed, 10 skipped).
- Pushed with `safe-push-pr-head.sh`, then `ci-wait-merge.sh --no-merge` returned 0 (green).

**Follow-ups:** I didn't act on the comment-only items: validating `ROUTE53_MODULE_VERSION`, shipping the preflight as `.mjs`, and a test for `vendor-endo-claude.js`. The panel-2 stage will review the new head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1561981 cached reads)
- Output: 13638 tokens
- Cost: $1.2160601999999998
- Wall-clock: 471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
