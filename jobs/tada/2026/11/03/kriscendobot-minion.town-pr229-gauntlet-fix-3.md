Fix round 3 for PR #229 is pushed and CI is green. `ci-wait-merge` returned rc 0 with 2 of 2 runs passing. This host's PAT can't read `statusCheckRollup`, so that result comes from the Actions runs API, and commit statuses and non-Actions checks weren't visible.

**Pre-pass findings**
- **`src/auth/inference-provider-endpoint.ts` (hand-rolled SHA-256):** I added a `prefer-endo-primitives-exempt` marker on line 1. `@endo/sha256` isn't published (`npm view` returns 404), and other modules in the repo that hash with `node:crypto` carry the same exemption.
- **`test/inference-provider-service.test.ts` (hand-rolled base64):** the test now uses `encodeBase64` from `@endo/base64`, matching the endpoint it tests.
- **`deploy/aws/www/provider-ui.js:468` (pruner advisory, non-blocking):** I kept this comment. It explains something the code doesn't show: the operation record has no limits, so the registry refuses differing caps with `idempotency-conflict`. That error code does appear in the endpoint and in the tests, but I didn't trace the registry's refusal logic itself. The advisory still fires in the gate output as a warning.

**Commit:** `c0822505` on `feat/claude-api-provider-ui`, pushed with `safe-push-pr-head.sh` as a fast-forward from `736fb61c`; `ls-remote` confirms the new head.

**Checks before pushing**
- `pre-push-gates --probes-only` passed all 10 stages, including `prefer-endo-primitives` and `build-vs-buy`.
- `tsc --noEmit` reported nothing.
- `test/inference-provider-service.test.ts` passed its 8 tests on the final commit. An earlier run that also included `test/inference-provider-endpoint.test.ts` passed all 48, but that was before I moved the import line.

**Follow-ups:** none. I did not re-run the panel; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (418416 cached reads)
- Output: 5675 tokens
- Cost: $0.6362872
- Wall-clock: 734s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
