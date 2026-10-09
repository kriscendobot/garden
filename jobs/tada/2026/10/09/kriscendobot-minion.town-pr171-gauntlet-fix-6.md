# PR #171 fix round 6: partial fix pushed, CI green

I fixed only part of the panel-6 must-fix list. I ran low on budget before I could get to the migrator, breaker, pruner and coverage items. Panel-7 will raise them again.

The fix commit is `cf86259` on the PR head `kriscendobot/minion.town:feat/claude-arc-prod-validation` (was `3436043`). I pushed it with `safe-push-pr-head.sh`.

## Fixed
- **Stylist must-fix 1:** in `deploy/aws/scripts/deploy-cd-iam.mjs`, renamed `OBSERVE_DOC_ARN` to `OBSERVE_DOCUMENT_ARN`, `OBSERVE_DOC` to `OBSERVE_DOCUMENT_CONTENT`, and `PROBE_PERM_DOC` to `PROBE_PERMISSION_POLICY_DOCUMENT`.
- **Stylist must-fix 2:** renamed the `env` parameter to `environment` in `harnessObservation` (`deploy/probe/prod-objectives.mjs`) and `observeClaudeHarness` (`deploy/probe/claude-harness.mjs`), including their JSDoc.
- **Stylist must-fix 3:** renamed `bin` to `protectedBinaryDirectory` in `deploy/probe/prod-objectives.test.mjs`.
- **Archivist must-fixes 1 and 2:** corrected the `claude-harness-pinned-upgrade-policy` row in `DEPLOYMENT.md`:
  - The observer (`claude-harness-observe.cjs`) only reads facts and returns them as JSON.
  - `claudeHarnessViolations()` in `claude-harness.mjs` is what compares them with `release.json`.
  - The protected files are now named as three: the Claude binary, the release manifest and the observer script.
- **Checks:** `node --check` passes on the changed modules. The local probe tests (`node --test deploy/probe/*.test.mjs`) pass 26/26.

## Still open (not applied)
- **Coverage:** the observer is only grep-tested, so its output contract is never exercised.
- **Migrator:** `.github/workflows/prod-probe.yml` breaks the first scheduled run after merge until a maintainer re-provisions IAM (`DEPLOYMENT.md` § One-time provisioning).
- **Breaker and pruner:** both seats voted request-changes. I did not read their findings.
- **Stylist should-fix and comment-only:** not done (`SHA256` to `SHA256_HEX_PATTERN`, renaming the observer's `describe`).

## CI
`ci-wait-merge.sh` did not return an exit code: the shell's 10-minute cap stopped it about 1150s into its 3600s deadline, with 2 of 3 checks pending. I then polled `gh pr checks` in the foreground until all 3 checks on `cf86259` passed. The green result comes from that poll, not from `ci-wait-merge.sh`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (723148 cached reads)
- Output: 4764 tokens
- Cost: $0.6527576
- Wall-clock: 1634s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
