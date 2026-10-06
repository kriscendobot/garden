I ran panel round 1 on PR #163 and it came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error.

- **Checkout and run:** I made an isolated checkout of `kriscendobot/minion.town` at the PR head, `fix/caddy-restart-on-env-change` @ `80ca7db`. I ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against the frozen base `main-9ac858d`, using the base SHA `9ac858df24`.
- **Seats were not re-run:** `panel.sh` reused the saved record `a863df25e5af` for this same head. That earlier run had 32 seats and 0 seat errors. Seven seats asked for changes: stylist, prover, curator, breaker, scribe, pruner and transplanter. There are 15 items in total, some of them comment-only.
- **Main must-fix findings:**
  - `caddy_environment_in_sync` in `deploy/aws/scripts/lib/caddy-environment-sync.sh:48-67` has a correctness problem (breaker).
  - `caddy_environment_ensure_if_running` takes a token name but checks every gate-token pair anyway. So an unrelated bad `billing.env` can make the account-secret deploy fail.
  - `caddy_environment_hash_of` (line 37) uses a pipe that won't port (transplanter).
  - Commit `80ca7db` is a corrective follow-up, and the scribe seat wants that commit history fixed.
  - `test/caddy-environment-sync.test.ts` has a variable-naming problem (`dir`).
  - The deploy-script test only checks that the helper is called, not what it does.
- **Review posted:** I posted it as a COMMENT review on https://github.com/kriscendobot/minion.town/pull/163 under the header "Garden panel — round 1 (single-round): **must-fix**". GitHub would not accept a request-changes review because the bot also authored the PR. The review links to the earlier full per-seat review for this head (`#pullrequestreview-5422207741`) rather than repeating 63 KB of findings.

**Follow-ups:**
- The PR already had a must-fix panel review for head `80ca7db`, posted at 00:06Z and titled "round 2". This gauntlet's round 1 matches it.
- The PR stays in draft. Fixing is left to the gauntlet's fix-loop stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (442688 cached reads)
- Output: 3206 tokens
- Cost: $0.5273616
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
