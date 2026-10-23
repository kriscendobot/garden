# Gauntlet FIX round 4: kriscendobot/minion.town PR #218

I applied the must-fix items from panel-4's latest review (5631266181) and pushed them to the PR head as four follow-up commits. PR head is now `8619e78`. CI is green (`ci-wait-merge` rc 0, 1/1 run passed).

**Fixed:**
- **Rollback past the ledger** (saboteur, breaker, engine-realist, wire-watcher), commit `58fa126`.
  - `deploy-accounts-store.sh` now requires `LEGACY_BOND_WRITERS` to be `retired` or `active`. If it is unset, empty, or anything else, the script stops before touching the table.
  - Every run deletes the reconciliation marker and writes it again from its own scan. An `active` run refuses once the marker exists.
  - Guests can only be closed after reconciliation, so an old (pre-ledger) app can no longer be serving while a guest is closed. Rollback is allowed only before rollout step 3; after that, the only way out of a bad release is forward.
  - DEPLOYMENT.md describes the new procedure, and the backfill tests cover each of these cases.
- **Wrong attribute type** (spec-keeper), commit `c2a59f4`: if `bonded_accounts` is present but is not a string set, the close now rejects with `GuestBondLedgerMalformedError` instead of treating it as empty.
- **Retries make progress** (engine-realist), commit `c2a59f4`: each entry is removed from the ledger once its account row is unbonded, so a close that fails partway resumes where it stopped. The app role's existing ledger permission already allows that removal.
- **Key collision** (corner-prober), commit `c2a59f4`: the in-memory store's account key is now `JSON.stringify([iss, sub])`, so `("a b", "c")` and `("a", "b c")` no longer collide. There is a test for it.
- **New tests**:
  - A bond racing a close, in both orders (corner-prober).
  - Four malformed cancellation shapes from the deploy IAM probe, each of which must stop the rollout (corner-prober).
  - A fast-check property over ledger entries, 100 runs (fast-checker).
  - A close that fails partway, then is retried.
- **Design doc** (archivist), commit `59588bf`: the threat model now lists what a compromised app process can actually change, instead of saying it is limited to "read access".
- **Pruner and transplanter**: removed the long module comment and the comments that only labelled the marker commands, removed the comment that restated its assertions along with its test, and changed the test stub to `#!/usr/bin/env bash`.

**Declined, with reasons in the PR summary:**
- **Decomplector's request to remove the whole ledger mechanism**: adding it is the point of this split from #216, so keeping it or not is a maintainer decision.
- **Releaser's changeset**: the repo has no changeset tooling. The migration steps are already in DEPLOYMENT.md.
- **Saboteur's should-fix on very large ledgers**: I only partly addressed it. Retries now always make progress, but I didn't add a cap or concurrency limit; I left that for the PR that adds the deletion route.

I posted the summary comment the scribe asked for: https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6369984000

**Verification:** the typecheck is clean, and the account and deploy test files pass locally (84 tests). In the full local suite, two `test/git-remote` tests fail; that code isn't part of this change, and CI passed.

**Next:** the driver re-posts panel-5. The open question for the maintainer is whether the ledger mechanism should stay at all.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3559074 cached reads)
- Output: 26133 tokens
- Cost: $2.1816268
- Wall-clock: 1329s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
