Fix round 5 for kriscendobot/minion.town PR #166 is pushed and CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 3 of 3 checks passing.

**Must-fix (decomplector): the per-identity tool allowlist is kept, but rebuilt as data.** I kept it rather than dropping it. The round-3 locksmith must-fix asked for exactly this: the probe's long-lived CI secret should not be able to reach `evaluate`, `send`, `adopt` or the `claudeAgents` tools. Scopes can't do that, because `mcp/guest` admits every guest tool. A dedicated guest only limits *where* tools act, not *which* tools the secret can call. The PR body now says this.
- I removed the `withToolAllowlist` Proxy from `src/server.ts`. `createMcpServer` is back to a single `server` and passes `allowedTools` in `guestDeps`.
- In `src/endo/guest-tools.ts`, `GuestToolDeps.allowedTools` is now a `ReadonlySet<string>`. All 21 tool registrations across the four register functions go through a `mounts(deps, name)` check, so the call site shows the narrowing. Because nothing wraps the server any more, the should-fixes about other registration paths and the `undefined` return also go away.
- In `src/auth/policy.ts`, loading the policy now fails on:
  - an empty `tools` list (an identity that should reach no tool drops `mcp/guest` instead);
  - a non-string entry;
  - any name not in `REGISTERED_MCP_TOOL_NAMES`, so a renamed tool fails the load instead of silently disappearing.
- `grantedTools` now returns a Set, and I added tests in `test/policy.test.ts` for the empty, unknown and non-string cases.

**Should-fixes applied:**
- **Secret in argv (breaker):** `deploy-cognito-probe-client.sh` now pipes the secret to the AWS CLI with `--secret-string file:///dev/stdin`, so it no longer shows in `ps`.
- **First page only (saboteur):** I dropped `--max-results` so the CLI reads every page of Cognito clients before filtering.
- **Docs (integrator):** the `OAUTH_ALLOWED_CLIENT_IDS` comment in `minion-mcp.service` and the DEPLOYMENT.md secrets sentence now name `minion/prod-probe-client`.
- **304 check (spec-keeper):** a 304 is now checked only for the headers RFC 9110 §15.4.5 says it must repeat (ETag and Cache-Control).

**Should-fixes skipped:**
- **Node pin (packager):** `node-version: "22"` already resolves to a version above the engines floor of 22.15.0. The panel's pre-pass said not to patch the Node-version mechanism again.
- **Pool id default (transplanter):** the `POOL` default is the same one the sibling `deploy-cognito-*.sh` scripts use. Moving it for one script would break that pattern.

Four follow-up commits went on top of `e092028` through `safe-push-pr-head.sh`, ending at head `7d7085c`.

Locally, typecheck passed, the policy and guest-http vitest suites passed (44 tests), and the probe's node tests passed (16). The full vitest run had failures in two `tools/claude-harness` files and one `test/git-remote/capability.test.ts` test (`projectPartition`). These changes don't touch those files, and `npm test` excludes the harness tests. I didn't run the git-remote test against the base branch, so I can only say it looks environmental.

The panel was not re-run; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2488623 cached reads)
- Output: 15425 tokens
- Cost: $1.5261046
- Wall-clock: 965s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
