Fix round 11 for kriscendobot/minion.town PR #216 is pushed and CI is green.

The PR head moved from `6e99a367` to `6f978071` with five follow-up commits, pushed with `safe-push-pr-head.sh`. Both CI checks pass: `test (typecheck + vitest)` and `clip frame browser gate`. `ci-wait-merge.sh` returned rc 0. My first full-deadline run of it was killed by the 10-minute background limit, so I polled the Actions runs API in the foreground until both runs finished, then re-ran the script; it returned at once.

**Fixed, from the 05:24Z panel review:**
- **Account deletion during the rollout (migrator) and the stale readiness marker (saboteur), `3252bb32`:**
  - Each `deploy-accounts-store.sh` run now removes both ledger markers before it backfills. A run that fails partway leaves neither marker, and `deploy-app.sh` won't deploy until a run succeeds.
  - A new `reconciled` marker is written only by a run with `LEGACY_BOND_WRITERS=retired`, once the new app build is the one serving.
  - Until that marker exists, the DynamoDB store refuses to close a guest's recovery bonds. A deletion still deletes the guest but answers "deletion pending", and the browser's retry finishes it after the second run.
  - DEPLOYMENT.md's rollout and rollback steps are updated, and there are new tests.
- **Deletion racing a send or an accept (wire-watcher, corner-prober), `6ff28f31`:**
  - Within one process, a deletion now waits for sends and invitations already under way, and an act checks for a pending deletion just before it acts.
  - `send` and `inviteRemote` check the daemon again before acting.
  - After its accept, `connectLocal` checks whether another process deleted either guest; if so, it removes both names it bound.
  - Four new tests. A deletion in another process can still land between the daemon check and the act, because the daemon has no atomic check-and-act. The check after the act reports that case.
- **Sign-out redirect (fast-checker), `c4413173`:** a fast-check property shows that any path the router accepts redirects within `https://minion.town`.
- **Invitation types (typist), `400c0066`:** moved to a new `deploy/aws/www/settings-types.d.ts`, imported with `@import`.
- **Design status (archivist), `6f978071`:** `ocap-site-clip-isolation.md` now says "partially implemented" (edge live, PSL submission pending), and `clip-shell-framework.md` matches.

**Declined, with reasons in the PR comment:**
- **assessor, `dynamodb:TransactWriteItems`:** IAM has no such action. AWS checks each item in a transaction against its underlying action, and `test/accounts-store-iam.test.ts` checks every request the store sends against the deployed policy.
- **breaker, sign-out CSRF:** our endpoint only redirects to the OAuth proxy's `/oauth2/sign_out`, which any page can already reach with a plain GET. Protecting the redirect wouldn't stop a forced logout.
- **purist, SHA-256:** the code uses `node:crypto`; there is no local implementation, and `@endo/sha256` isn't published.
- **releaser, changeset:** the repository has no Changesets setup, the same answer as round 9.

**Verification:** `tsc --noEmit` is clean. Locally, 1522 tests pass and 2 fail, both git-environment tests in `test/git-remote/` that this diff doesn't touch. I posted the round summary at https://github.com/kriscendobot/minion.town/pull/216#issuecomment-6358222503.

**Follow-up:** after this lands, the operator must run `LEGACY_BOND_WRITERS=retired deploy-accounts-store.sh` once the new app is serving. Until then every account deletion stays pending.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (5101184 cached reads)
- Output: 40654 tokens
- Cost: $2.947532800000001
- Wall-clock: 1820s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
