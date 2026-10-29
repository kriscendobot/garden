Fix round 1 for endojs/endo-but-for-bots#1573 is pushed and CI is green: `ci-wait-merge` returned rc 0, 36 checks, 0 failed, on head `7e32ce1a93`.

**What I changed.** I applied every must-fix item from the panel's latest review (review 5705359789) in one follow-up commit, `7e32ce1a93`. It was pushed with `safe-push-pr-head.sh` and only adds to the old head `71b9ab575b`.

- **Grant minting onto someone else's secret (wire-watcher):** `provideBase64` in `@endo/daemon` now accepts a retry on an existing secret only if it repeats the `operationId` and `grantId` that created it. It checks `REVOKED` before writing anything, and a retry can no longer bind the same grant under a second name.
  - To find the creating operation, the daemon database gains `listSecretAuditEventsFor(secretId)`.
  - That query also replaces the old scan of only the last 1000 audit events when checking for a prior `succeeded` record.
- **Error classification by message text (saboteur):** "no bytes yet" is now a returned summary with state `provisioning`, not a `KEY_NEEDED` error matched by regex across CapTP. This changes behaviour: a call with no bytes and nothing to recover now returns that summary instead of throwing, and the changeset documents it.
  - Backend failures are caught only around the backend call, so a malformed key now reports `INVALID_SECRET_BYTES` instead of `CREATE_FAILED`.
- **Swallowed `has` errors (saboteur):** the Endo participant's `has()` returns false only when the `secrets` directory is absent. Any other failure, such as a disconnect, now propagates.
- **Non-string inputs (corner-prober):** every validator in the hosted-agent registry checks `typeof value === 'string'` before `RegExp.test`. An empty `grantId` is now rejected instead of being replaced with a generated id.
- **`JSON.stringify` comparison (corner-prober):** `sameData` now uses the package's existing `canonicalJson`. Limits and caps with no canonical form (such as `NaN` or `undefined`) are refused when first submitted.
- **Pervasive `any` (typist):** the registry's records and ports are typed in a new `packages/hosted-agent/src/types.ts`.
- **Missing changeset (packager, curator, changeset-auditor, releaser):** added `.changeset/daemon-secret-provide-base64.md` as a minor bump for `@endo/daemon`. Following the changeset-auditor and releaser, it does not list `@endo/hosted-agent`, which is private.
- **Cheap should-fix items, also done:**
  - A fresh idempotency key no longer reopens a retired provider.
  - An endpoint that finishes opening after its grant was revoked is now revoked too.
  - I removed the redundant code comment and trimmed the PR body as the pruner asked.
- **Tests:** added cases for each of the above.

**Checks I ran locally.** The hosted-agent registry tests (21) and the daemon secret, backend, database and restart tests pass. Type checks pass for both packages and for the repo-root `tsc`, which CI runs and which the per-package checks miss. ESLint shows no errors, and Prettier formatting is applied.

**CI history.** The first run had two failures that are known flakes in other packages: the `sandbox-drivers` bwrap timeout test and `restore-context.test.js` on the 22.x macOS leg. I reran just those jobs, and the rerun finished green.

**Follow-ups (not done):**
- `powers` is still typed `ERef<any>` in the module and the participant (a should-fix).
- I did not extract a shared helper for the create and retire steps that `reconcile` duplicates (a should-fix).
- The pruner's optional trim of one test comment is still open.
- Panel round 2 is next; the gauntlet driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (578458 cached reads)
- Output: 1911 tokens
- Cost: $5.2538991999999975 (1 engagement(s) unpriced)
- Wall-clock: 7564s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
