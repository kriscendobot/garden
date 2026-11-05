Fix round 3 for PR #249 is pushed and CI is green, with `ci-wait-merge.sh` exiting 0 on the new head. The PAT can't read `statusCheckRollup`, so that result comes from the Actions runs API (2 of 2 runs, 0 failed). Commit statuses and non-Actions check runs weren't visible.

**Pre-pass findings**
- **`prefer-endo-primitives` (blocking), fixed:** `test/inference-provider-service.test.ts` recomputes the endpoint's reattachment keys with `node:crypto` SHA-256.
  - I added a `prefer-endo-primitives-exempt` marker on line 1 instead of switching to `@endo/sha256`, because that package returns a 404 from npm.
  - `src/auth/inference-provider-endpoint.ts` already carries the same exemption for the hash this test recomputes.
  - The probe now passes against `origin/main-7a0bcc9...HEAD`.
- **Comment concision at `deploy/aws/www/provider-ui.js:37` (advisory), kept with no change:** the comment explains why only some errors count as outcome-unknown. A lost connection or session says nothing about whether the request committed, while a domain refusal is final. The adjacent code doesn't state that.

**What changed**
- **Commit:** `2c724a9a`, `test(agents): mark the reattachment key recomputation exempt (#249)`, adds one comment line.
- **Push:** `safe-push-pr-head.sh` advanced `fix/api-key-agent-panel3` from `2560b10a` to `2c724a9a`, and `ls-remote` confirms the new head.
- **Tests:** I didn't run the test suite locally because the change is only a comment; CI covered it.

No follow-ups from this stage; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (391239 cached reads)
- Output: 4117 tokens
- Cost: $0.5507958
- Wall-clock: 429s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
