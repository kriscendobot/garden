---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1573
panel_kind: code
provider: anthropic
base_ref: 9a14ddf660912ed624e2d9047671d43e3a2f0cec
pr_body_hash: 937d8974975d0d9208d36e93a565ba699d9ac9534e231dc463b223f0d92bb290
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: ecfbdb2ac96d7d10c592b6421213d73da96f73fb
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 327cadabf58b
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1573 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `ecfbdb2a`

seat verdicts (34): archivist=comment assessor=must-fix benchmarker=pass breaker=comment changeset-auditor=must-fix corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=must-fix migrator=comment orthographer=pass packager=comment procurer=comment prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=must-fix saboteur=must-fix scribe=must-fix spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- assessor: **should-fix, `packages/daemon/src/manager-database.js` (`writeSecretRecordWithGrant`).**
- assessor: If `stmtRollbackTransaction.run()` throws inside the `catch`, for example because SQLite already auto-rolled back on ...
- assessor: Guard the rollback with a nested `try`/`catch`, or rethrow the original error. [proposed-rule: a `catch` that cleans ...
- assessor: **should-fix, `packages/daemon/src/secret-manager.js` (`provideBase64`, `installBackend`).**
- assessor: The bare `catch {}` maps every install failure to `CREATE_FAILED`, including a decode failure from `withDecodedSecret...
- assessor: This is safe, because a retry resumes it. Validating the base64 before the `writeSecretRecordWithGrant` call would av...
- assessor: **comment-only, `packages/daemon/src/secret-backend.js` (`create`).**
- assessor: A replayed `create` with different bytes now silently keeps the first installed bytes and returns the same ref. The J...
- assessor: The consequence is that a caller who re-enters a different key after a lost response gets success, but the old key st...
- assessor: **comment-only, `packages/daemon/src/secret-manager.js` (revoke path).**
- assessor: I traced the new `before.backendRef || recover?.()` path. It writes the recovered ref back to the record before calli...
- assessor: The delete path skips `backend.revoke` when `backendRef === ''`. The record is already `revoked` by then, so nothing ...
- assessor: **verified, no defect.**
- assessor: The `provideBase64` ordering is sound:
- assessor: The nested queues are `' stable import'` then `secretId`.
- assessor: A name or grant conflict throws before any write.
- assessor: A `provisioning` record is only resumed by the holder of the matching grant.
- assessor: A `revoked` record throws `REVOKED`.
- assessor: A `provisioning` record with no recoverable ref returns the summary without binding the grant.
- assessor: `makeEndoSecretParticipant.provideStable` turns that `provisioning` state into `key-needed`, so the registry never ad...
