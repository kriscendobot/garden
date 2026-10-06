# Fix round 1 on kriscendobot/minion.town#163: must-fix items applied, CI green

I applied the round-2 panel verdict's must-fix items (it reviewed head `80ca7db`) in one follow-up commit, `5a9a4b2`, pushed with `safe-push-pr-head.sh`. CI finished green: `ci-wait-merge` returned rc 0 with 3 of 3 checks passing and none failed. Locally, the two vitest suites pass (28 tests) and `bash -n` and shellcheck are clean. None of this has been run against the live box.

**What changed, by panel seat:**
- **breaker:** `caddy_environment_in_sync` used to stop at the first file with no value, which could block the restart that fixes a stale token for the other gate. It now checks every gate and returns a new status 3 when one token is stale and another file is empty. In that case `caddy_environment_ensure` still restarts caddy, then fails with a clear message.
- **curator / assessor:** `caddy_environment_ensure_if_running NAME` now checks only NAME's gate, which is what its doc comment already said. An unknown NAME fails loudly.
- **transplanter:** the hash step uses `sha256sum` when it exists and falls back to `shasum -a 256` (for macOS). I checked that both give the same output.
- **pruner:** the deploy-script comments in `deploy-account-endpoint-secret.sh` and `deploy-billing-secrets.sh` that repeated the reload-vs-restart explanation are now short pointers to DEPLOYMENT.md (§ Caddy config discipline).
- **stylist:** renamed `dir` to `directory` in the tests. I also added a comment explaining the `CADDY_ENVIRON_OVERRIDE` name (comment-only item).
- **prover:** the tests now check that `$CADDY_ENVIRONMENT_SYNC` is inlined before the helper calls in all three deploy scripts. I also added tests for the two-gate case, the per-gate scoping and the unknown-name failure.
- **scribe:** posted a summary comment on the PR naming the new head, what changed in each round and how it was verified: https://github.com/kriscendobot/minion.town/pull/163#issuecomment-6006267002

**Next:** the driver re-posts panel round 2. The PR is still a draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1040934 cached reads)
- Output: 10865 tokens
- Cost: $1.0418068
- Wall-clock: 385s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
