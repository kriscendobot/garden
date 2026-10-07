Implemented and pushed commit `c37488c` to draft PR https://github.com/kriscendobot/minion.town/pull/169.

Changes:
- Added a target-host preflight that refuses to promote or restart `minion-mcp` when `GUEST_RECOVERY_KEY` is absent or unreadable, without logging its value.
- Added CD provisioning from AWS Secrets Manager through the existing private-S3/root-only EnvironmentFile path.
- Scoped CD IAM read access to `minion/guest-recovery-key-*`.
- Added stubbed absent, unreadable, present, non-disclosure, and ordering tests.
- Updated deployment documentation.

Verification:
- `npm test`: 942 passed, 11 skipped.
- Typecheck and all 11 pre-push stages passed.
- `GARDEN_YARN=npm` local verification passed.
- Regression test failed as expected when the assignment check was bypassed, then passed after restoration.
- PR CI is green: test plus amd64/arm64 Claude harness jobs.

Follow-up parked: `kriscendobot-minion.town-pr169-conduct-prod-validate`, blocked on `kriscendobot-minion.town-pr169-gauntlet`, to land and validate CD and production.

Self-improvement: reported a local-verify PATH/git-wrapper parity defect to the liaison inbox.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-deploy-secret-preflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 956s

<!-- garden-usage-end -->
