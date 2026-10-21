I applied every panel-8 must-fix item on PR #200 (review 5593803571) and pushed head `498bd553`. CI is green: `ci-wait-merge` returned rc 0 with both workflows passing, and the real-daemon suite ran in CI, all 4 tests including the new restart test.

**Must-fix items**
- **Sign-out open redirect (saboteur, breaker, spec-keeper):** `WEB_SIGN_OUT_PATH` is now resolved against the public origin the way a browser would. Any value that leaves the origin is refused at startup, including backslash, tab and newline forms. The redirect uses the resolved path. Tests cover those forms.
- **Audit-file docs (archivist):** DEPLOYMENT.md now says the audit file falls back to `$STATE_DIRECTORY`. Production therefore writes both the file and the journal copy.
- **settings.js check (prover):** the browser gate counts `/settings.js` fetches and fails if the shell stops loading it. It passes 30/30 on chromium locally.
- **Attenuator (locksmith):** the guest web backend's restricted daemon view no longer passes root names through.
  - It reports only browser-guest names, plus a yes/no flag when a guest is also named elsewhere.
  - It binds only formulas the root names as a guest's agent, and looks up only the service's own temporary and marker names.
  - A test shows a formula named only `sites-host` is never reported, bound or reached.
- **Revival after restart (engine-realist):** deletion now clears the guest's mail and contacts before cancelling it. Anything a peer revives through its retained name is empty. The new real-daemon test restarts the daemon, revives the deleted guest, and finds no contacts or mail.
- **Bond race and index lag (integrator):** each guest now has a bond ledger row in the accounts table.
  - A bond writes the account row and the ledger entry in one transaction, which fails if the ledger is closed.
  - Deletion closes the ledger and reads it in one strongly consistent update. It removes bonds the index hasn't listed yet, and a bond racing the deletion gets a 401.
  - The app's IAM grant gains two attributes, and `set-account-role.sh list` skips ledger rows.
- **Property tests (fast-checker):** out-of-grammar names are refused by every method without touching the host. Any single daemon fault, followed by a retry, always ends with the guest fully deleted.

**Should-fix and summary items done:** one name grammar for creation, opening and deletion (wire-watcher); the in-process deleted cache keeps digests, capped at 1024 (engine-realist); the `deleteGuest` contract wording (breaker); a `hasGuestBond` pagination test (corner-prober); three comments trimmed (pruner); "uncanceled" (orthographer); the U+2026 comment is gone (typist). The SHA-anchored summary comment the scribe asked for is posted as issuecomment-6305903093.

**Declined:** purist's `@endo/sha256` request. Adding a dependency on an unpublished package belongs in its own change, so the exemption stays.

Locally, typecheck is clean and `npm test` passes 1473 tests. The one failure is in `test/git-remote/capability.test.ts`: the PR doesn't touch that file, and the failure comes from the local git environment.

**Follow-ups:**
- **Operator step before deploying:** re-run `deploy/aws/scripts/deploy-accounts-store.sh` so the app may write `bonded_accounts` and `guest_bonds_closed`. Without it, recovery bonding will be denied.
- **Still open from engine-realist:** the empty agent and handle stay in the daemon's storage while a peer names them. Removing them needs durable revocation in the daemon itself. The design doc and the delete panel now describe deletion as leaving an empty guest, not as deleting it "for good". The panel-9 reviewers may raise this again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 202 tokens (14606227 cached reads)
- Output: 73754 tokens
- Cost: $6.113693400000001
- Wall-clock: 2405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
