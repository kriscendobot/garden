---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on `kriscendobot/minion.town` (worktree slug `kriscendobot-minion.town`). Design PR #30 just merged to `main` (merge commit `3e70e37`), landing `designs/remove-toy-tools-and-prune-minion-scopes.md` — explicitly **spec only, no live change**, with a § 7 "Handoff to a builder" section. Implement it as a single removal PR against `main`.

Read the design first (`designs/remove-toy-tools-and-prune-minion-scopes.md` on `main`); it is authoritative for the exact surface list. Summary of the mandate (kriskowal, PR #18 review 2026-08-09): remove the three toy `minion` tools and prune the demo-only `mcp/minions:read` / `mcp/minions:write` scopes. Keep `mcp/tools`, `mcp/guest`, `resolveEffectiveScopes`, `isToolAllowed`/`TOOL_SCOPES`, and the Cognito `mcp` resource server itself.

Follow the design's decomposition in dependency order: (1) code + config — `src/auth/scopes.ts`, `src/server.ts`, `src/auth/accounts.ts`, `src/config.ts`, `config/policy.json`, `dev/client.ts`; (2) IaC — `infra/lib/minion-town-stack.ts` (drop `scopeRead`/`scopeWrite` and their PKCE-client scope entries); (3) ops docs + web — `deploy/aws/systemd/minion-mcp.service`, `deploy/aws/www/{index,connect}.html`, `DEPLOYMENT.md`; (4) tests — prune every `minions:*` assertion, keep the `mcp/tools` route-gate and `mcp/guest` admission tests.

The design leaves three open questions (§ 6) that the maintainer has not answered. Take the design's own recommended defaults so the PR is not blocked, and state each choice plainly in the PR body as a decision open to reversal in review: (1) replace `minion_status` with a minimal non-toy `whoami` baseline tool mapped to `SCOPES.TOOLS`, returning the caller's resolved identity/role/effective scopes; (2) collapse the role ladder to `guest`-only, leaving `resident -> [mcp/tools, mcp/guest]` to increment B4 of `mcp-daemon-guest-tools.md` — do **not** add any `mcp/guest` grant here, this change only removes; (3) leave the `default.scopes: []` note in `config/policy.json`.

Do not deploy. The Cognito/IaC change requires `cdk deploy` **before** the app roll (§ 5 ordering: resource server + client scopes first, then systemd unit + policy) so no client requests a scope the resource server no longer knows. Flag that ordering prominently in the PR body and add the tracking note to DEPLOYMENT.md's phase table rather than performing the deploy.

Verify locally per [`local-verify`] (`npm test` + lint) before pushing, and net-diff-check that no `mcp/tools` or `mcp/guest` enforcement point was removed by accident.
