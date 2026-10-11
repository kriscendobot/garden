I applied panel-7's must-fix items to PR #174 and pushed them as head `0b15028`. CI is green. I confirmed that with the Actions runs API, because `ci-wait-merge.sh` can't read PR status on this host.

**What I did**
- **Concurrent-publish overdraft (saboteur):** before, the publish check only read the balance, so many simultaneous publishes could all pass it and overdraw the account without limit.
  - `makeMeteredPaymentProcessor` in `src/endo/clip-payment.ts` now holds each publish's price when it is authorized. It refuses a publish when the balance minus prices already held can't cover it. The check and the hold happen in one step, so simultaneous publishes see each other's holds.
  - I added an optional `releasePublish` to `PaymentProcessor`. The publisher (`src/endo/gateway/publish.ts`) calls it when storing content, registering the site, or an upgrade's directory write fails. The charge releases the hold after it settles.
  - New test: three simultaneous publishes against a balance of 10 → two pass, the third is refused. A released hold frees the funds again.
  - The existing registration-failure test now also checks that the hold is released.
  - I updated the matching text in `credit-ledger.ts` (the `AccountCharge` doc), `designs/ertp-credits.md` (§ "Hold, then charge after success") and `DEPLOYMENT.md`.
- **CLI docstring (pruner):** I removed the paragraph about implementation details from `src/credits-cli.ts`. It now has one operator line: restart the gateway after a grant.
- **PR description (integrator):** I rewrote the body. It no longer claims failed publishes are refunded, and it describes the hold. It now says which design phase this covers (`designs/ertp-credits.md` § 6a). It also says the ERTP v2 phases and the Stripe bridge stay open under garden#58, and that this ledger is kept separate from the Stripe one.
- **Archivist's broken-link finding:** no change made. `designs/clip-usage-metering.md` exists, and its § 3 defines the versioned `PriceSchedule`, so the link is valid.

**Testing**
- `tsc --noEmit` is clean, and the credit-metering and gateway publish test files pass (50 tests).
- A full local `vitest run` had 9 failures, all in files this PR doesn't touch: `git-remote/capability`, `endo-guest-lockdown`, and `tools/claude-harness`, which `npm test` excludes anyway. I put them down to the local environment but didn't check against main. CI on the new head (`test (typecheck + vitest)`) passed.

**Follow-ups**
- I did not apply the should-fix items, which the next panel may raise again:
  - content-root settlement lets identical republishes create extra sites for one charge;
  - a charge that fails after a successful publish is only logged;
  - the ledger has no `fsync` and no cross-process lock;
  - a failed rollback can drop another writer's line;
  - memory grows without bound;
  - the "ledger" naming overlaps the Stripe ledger;
  - the commits should be squashed.
- On host oros-studio, `ci-wait-merge.sh` returned rc 4: every `gh pr view` failed, matching the known limit that the bot token can't read PR check status. The combined commit-status API also returned 403. The Actions runs API worked.
- I couldn't read my inbox: the journal clone timed out.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1990923 cached reads)
- Output: 14508 tokens
- Cost: $1.3637285999999997
- Wall-clock: 1695s

<!-- garden-usage-end -->
