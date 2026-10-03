# Completion report: build-minion-town-claude-cli-provider-20261003

I opened draft PR **kriscendobot/minion.town#148**, "feat(claude): run confined inference through the Claude CLI backend". It targets the frozen base `main-ec8db3f` from head `build/claude-cli-provider`, and all three CI checks pass (test, Claude harness amd64 and arm64). Nothing was verified with a real credential, the real daemon, or the deployed host; that production evidence is the canary child's job.

**What it does.** With `ENDO_CLAUDE_ENABLED=1` and the binary, release manifest, daemon socket and model list all present, `makeClaudeDeployment` now gets real production seams. If any of those is missing, the old fail-closed defaults stay and the boot log says why. The unit file still leaves `ENDO_CLAUDE_ENABLED` unset, so nothing is enabled in production.

1. **Provider.** One `@endo/claude` provider per subscription, using the deployed binary `/opt/minion-town/bin/claude`.
   - The credential is re-checked on every `infer`; with none, it returns `needs-auth` without spawning.
   - Results map onto the minion union, including `needs-auth` and `usage-exhausted`.
   - The required CLI version comes from `release.json` (2.1.278), not the package's `PINNED_CLI_VERSION` (2.1.232), so any other binary is refused.
2. **Credential store.** One owner-only (`0600`) file per `iss+sub` under `/var/lib/minion-town/claude-credentials`, durable across restarts, with no token reader on the account side.
   - The token reaches each spawn only through that spawn's own `0600` settings file, as `env.ANTHROPIC_AUTH_TOKEN`.
   - That replaces the package's `apiKeyHelper` path, which the #1371 live turns showed is rejected for subscription tokens.
3. **Probe and derivations.**
   - `runConfinementProbe` runs live after `store`. The positive half writes through the guest and checks the guest's store directly. The negative half plants `CLAUDE.md`, skills, hooks and MCP-server configs, and checks that none of them took effect.
   - `claude auth status --json` turned out to be local-only, with no plan or expiry for a token. So `derivePlanModels` returns the deployment model list once the binary accepts the token's form. `deriveCredentialExpiry` is the connect time plus `ENDO_CLAUDE_CREDENTIAL_LIFETIME_DAYS`.
4. **Child guests.** Children are real daemon guests the host provides, kept under `claude-agents/<caller-key>/<name>`. Endo has no indelible `introducedSpecialNames` yet, so two gaps remain and are documented in the code: children aren't bound into the caller's directory, and they carry no special names.
5. **#1369 gaps.**
   - **Token scrub:** the guest's MCP server is a byte relay launched with `env -i`, so it never inherits the token. A test shows the token *does* leak if `-i` is removed.
   - **401 storm:** the first `api_retry` 401 now ends the run as `needs-auth` instead of ten retries.
   - **No `evaluate`:** the tool server itself refuses `evaluate` rather than relying on `--allowedTools`.
6. **How minion.town gets `@endo/claude`.** I vendored it from the daemon's pinned Endo commit (1706e63) into `vendor/endo-claude`. The package is `private` upstream and isn't on npmjs.com or npm.minion.town, so publishing wasn't an option. The copy is verbatim except one recorded import change. `tools/vendor-endo-claude.sh` refreshes it, and a test checks every file against upstream. The deploy script and Dockerfile now ship `vendor/`.
7. **Tests.** There are 45 new tests with `GARDEN_YARN=npm`: 745 pass locally, and typecheck and the pre-push gates pass.
   - The one local failure, a git-remote test, fails identically on `main` on this host and passes in CI.
   - A one-off, uncommitted smoke run against the real Claude Code 2.1.280 with a bogus token returned `needs-auth` in 391 ms.
8. **#105.** The PR body says #105 is superseded; I didn't close it.

**Conflicts with the job body:**
- **Gauntlet.** The job says completion stages the gauntlet, but the design has ordered stop gates and phases 3–6 (the production canaries) are still open. The phase-evidence gate only passes with the ledger marked `non-deliverable-probe` (the builder brief says the same), so #148 is labelled that way and will stay draft until the canary supplies evidence.
- **Credential path.** The job says to feed the `apiKeyHelper` path. I used the harness's credentials pool but delivered the token through the settings `env` instead, because the evidence shows `apiKeyHelper` fails for subscription tokens.

**Follow-ups for the canary child:**
- In `minion-mcp.service`, set `ENDO_CLAUDE_ENABLED`, `ENDO_CLAUDE_ROOT_SUBJECTS` and `ENDO_CLAUDE_MODELS`, and **raise `MemoryMax`**: 256M can't hold a Claude Code process.
- Optionally pin failure shapes via `ENDO_CLAUDE_RESPONSE_SHAPES_PATH`.
- `agentsFor` isn't used anywhere in `src/`, so the root guest isn't actually given the factory yet; that endowment path is still needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-cli-provider-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 186 tokens (20059952 cached reads)
- Output: 121758 tokens
- Cost: $9.032590400000004
- Wall-clock: 1491s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
