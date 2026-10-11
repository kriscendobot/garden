**Fix round 6 for kriscendobot/minion.town PR #166 (panel round 6 must-fix items) is pushed, and CI is green.**

I pushed two follow-up commits to `feat/prod-objectives-probe` with `safe-push-pr-head.sh`, moving the head from `7d7085c` to `1b51f5b`.

1. **`88ae731` refactor(policy): drop the per-identity tool allowlist** (decomplector must-fix). I removed the mechanism instead of hardening it again:
   - **Code reverted to base:** `src/auth/policy.ts` (`PolicyIdentity.tools`, `checkTools`, `grantedTools`), `src/server.ts` (`allowedTools`), `src/endo/guest-tools.ts` (the 22 `mounts()` wrappers, about 1,000 lines of churn), and the allowlist tests in `test/policy.test.ts` and `test/endo-guest-http.test.ts`.
   - **Config and docs:** `config/policy.json` keeps the probe client entry (`mcp/tools`, `mcp/guest`, its own guest) without `tools`, and its top-level note is back to the original. I also took out the `tools` mentions in DEPLOYMENT.md (client table row, § Resolution algebra) and in the `deploy-cognito-probe-client.sh` header.
2. **`1b51f5b` style(probe): name helpers for what they do** (stylist must-fix, plus its two should-fixes):
   - `get` → `fetchWithoutRedirect`. It wasn't `request` because a local `request` variable in the WebSocket helper would have shadowed it.
   - `outIndex`/`--out` → `outputIndex`/`--output`, with `prod-probe.yml` and the script header updated to match.
   - `demand` → `requireCondition`.
   - `parseJsonBody(text, what)` → `parseJsonBody(text, subject)`.

I also edited the PR body. It had a bullet arguing for the `tools` allowlist; I removed it and now say the probe client maps to its own guest with `mcp/tools`/`mcp/guest` and calls only `status`, `writeText` and `readText`.

**Verification:**
- **Local:** `npm run typecheck` is clean. `node --test deploy/probe/prod-objectives.test.mjs` passed 16/16, and the vitest policy, guest-http and prod-probe-expectations suites passed 22/22.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 on head `1b51f5b`, with 3/3 checks passing ("CI GREEN"). My first call to it was cut off by the tool's 10-minute limit; the re-run with a short deadline gave that rc 0.

**Follow-up:**
- **Decision for you:** the PR now runs the probe with the full guest tool surface (it calls only three tools), bounded by its own identity, scopes and guest. If you want those other tools to be unreachable for this client, the decomplector suggests a separate PR that registers tools from a data table filtered once.
- **Not done:** the decomplector's should-fix about the copy of `IMMUTABLE_CACHE` in the probe and its parity test. Panel round 5 had judged that acceptable, and round 5 also said not to patch that mechanism again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1337810 cached reads)
- Output: 7339 tokens
- Cost: $1.057982
- Wall-clock: 867s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
