Fix round 5 for kriscendobot/minion.town#150 is pushed and CI is green on the new head `fed9a62` (3 of 3 checks passed).

One thing to act on before the next deploy: the app now refuses to start in production if Claude is enabled and `ACCOUNT_GATE_SHARED_SECRET` is empty. DEPLOYMENT.md row 11 still lists that gate secret as "BUILT, NOT YET DEPLOYED". If `/etc/minion-mcp/account.env` doesn't hold the secret, the deploy will fail and roll back. That is the intended fail-closed behavior, but the secret has to be rendered first with `deploy-account-endpoint-secret.sh`. The PR body now says this under "Before deploying".

**Commits pushed** (via `safe-push-pr-head.sh`, `addd516` → `fed9a62`):

- **`a7a3f4b` — gate the Claude account route (wire-watcher, saboteur, surfacer):**
  - **App:** a new check, `assertClaudeAccountGate` in `src/endo/claude/wiring.ts`, called from `createApp`, stops the service from starting in that state. The reason is that `/account/claude` trusts the `X-Auth-Request-Sub` header, which is only safe behind the gate.
  - **Deploy smoke** (`assert_claude_production` in `deploy-app.sh`):
    - it requires the gate secret in `/etc/minion-mcp/account.env`;
    - a forged subject must get exactly 403, both with no gate token and with a wrong one. Before, it only rejected 404 and 5xx.
  - **Enable detection:** `deploy-app.sh` now accepts the same values as the app's switch (`1|on|true|yes`, any case). It stops the deploy on any `ENDO_CLAUDE_*` line that is quoted or has several assignments on one line.
  - **Unit file:** a comment now says the gate secret is required while Claude is enabled.
  - **Cleanup:** removed the unused `isValidChildName` re-export from `agents.ts`.
  - **Test:** a new case in `test/claude-wiring.test.ts` covers the gate check.
- **`fed9a62` — docs (integrator, pruner):**
  - The design's root-canary step (step 3 in `designs/claude-agents-capability.md`) now records an interim deviation: the root's tools are mounted as MCP tools, and the maintainer's `sub` stands in for the test identity.
  - The Claude section of DEPLOYMENT.md is cut down to what to set, the gate-secret requirement, and what the deploy checks.

**PR edits:**
- **Title:** now "feat(claude): enable the Claude CLI provider in production with root-only agent tools".
- **Body:**
  - the per-file "Changes" tour is replaced by a scope summary;
  - the tool counts are clarified: the reconciled manifest goes from 23 to 27 names, and the registered set gains 5 because `submit` is now registered;
  - a "Deviation from the design" section and a "Before deploying" note are added.
- **Summary comment:** posted for scribe, covering `fa7b114`, `731cdb2`, `addd516`, `a7a3f4b` and `fed9a62` (https://github.com/kriscendobot/minion.town/pull/150#issuecomment-5983219102).

**Checks run locally:** `tsc --noEmit` is clean, and the Claude wiring, agent-tools, account-endpoint and lockdown tests pass (37). In the full suite one test fails, `test/git-remote/capability.test.ts`. This PR doesn't touch that code, and the PR body says it also fails on `main` on this host.

**Not done:** two comment-only suggestions were left alone. One is renaming `ClaudeAgent` to `ClaudeAgents` in a `mcp-tool-names.ts` comment, which is ambiguous against the naming rule. The other is per-spawn deadlines on connect-time spawns. Per the job spec, I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2623438 cached reads)
- Output: 16399 tokens
- Cost: $1.6390356
- Wall-clock: 489s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
