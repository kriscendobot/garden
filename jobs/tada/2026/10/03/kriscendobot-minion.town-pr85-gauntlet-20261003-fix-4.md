Fix round 4 for kriscendobot/minion.town PR #85 is pushed as one follow-up commit, `2c35098`, and CI is green. `ci-wait-merge` returned rc 0 with 3 of 3 checks passing.

**What changed, against the panel-4 review:**
- **Grants outliving their registration** (breaker, saboteur, wire-watcher, purist, locksmith):
  - A grant is now tied to a random registration nonce that `publish` stamps on the clip's vhost record, not to the owner.
  - `upgrade` refuses a grant unless the live record carries the same nonce.
  - Any re-registration, by the same owner or another, rewrites the record without the old nonce, so leftover grants can't upgrade the new registration.
  - The fs `deleteClip` now deletes every grant it can read and then fails if any grant was unreadable. `unpublish` reports that failure.
  - New tests: re-registration by the same owner and by a different one, and grants that survive an unpublish when deleting them fails.
- **Revoke and attenuate races:**
  - `upgrade` now checks its capability again inside the per-clip queue.
  - `revokeUpgrade` and `attenuateUpgrade` run in that same queue.
  - A new test covers a revoke that lands between an upgrade's first check and its write. I confirmed the test fails when the second check is removed.
- **Forged ancestor (prover):** new test where a grant names a real ancestor that belongs to a different clip or registration. It must not resolve.
- **Torn writes (engine-realist):** grant files and vhost records are now written to a temp file and then renamed into place.
- **Daemon power references (breaker, purist):**
  - `resolvePowerReference` now fails closed when the guest has no `has` method.
  - Power references are now tracked in a private WeakMap, so a look-alike object is rejected. A test covers this.
- **Result types (purist):** `PublishResult` (which carries `upgradeCapability`) now extends `ClipSummary`, not the other way round, so list results no longer carry that field.
- **Wording (locksmith, migrator):**
  - The `attenuateUpgrade` description and the module header now say a content-only capability limits what `upgrade` will do, but doesn't stop a guest from rebinding powers directly through the daemon (residual R3).
  - The upgrade tool description and PR body now flag the breaking `hash` → `capability` input change.
  - Clips published before this PR have no capability and no backfill; this is now listed as a residual.
- **Smaller fixes:** `guestRedesignateBackSource` now throws if the guest's own ID has no node suffix. The PR body's Tests section is cut to one paragraph with links, and the module header's property list is trimmed.

**Tests:** typecheck is clean and the gateway and clip suites pass (204 tests). In the full suite one test fails, `test/git-remote/capability.test.ts > propagates a git failure`, which was already failing in this environment before this PR. Two suites under `tools/claude-harness/` also fail; `npm test` excludes that directory.

**Not done (now listed in the PR body):**
- The grant store is still one flat directory, so `unpublish` scans every grant on the host. Splitting it by clip is left for later.
- The module-wide writable-directory map is unchanged.
- There is no owner-gated way to mint a capability for clips published before this PR; their owners have to unpublish and republish, which changes the hash.

The panel is not re-run in this stage; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3209149 cached reads)
- Output: 28749 tokens
- Cost: $2.1402098
- Wall-clock: 566s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
