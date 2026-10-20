Fix round 1 for kriscendobot/minion.town#200 is done. I applied every finding from the style pre-pass block, pushed one follow-up commit to the PR head, and CI came back green on all 7 checks.

**Changes** (commit `6b01b3bd`, `ec53f36b..6b01b3bd` on `feat/beta-settings-simplify`):
- **prefer-endo-primitives:** I added a `prefer-endo-primitives-exempt` header to `test/accounts-dynamodb-bonds.test.ts`, `test/web/deletion-state-files.test.ts` and `test/web/guest-web-socket-faults.test.ts`. The reason given is that `@endo/sha256` isn't published on npm, the same marker and reason four repo files (three in `src/`, one test) already use.
- **spell-out-identifiers:**
  - `src/auth/accounts.ts`: a doc comment now says "The AWS-backed store" instead of "The DynamoDB store".
  - `test/web/deletion-state-files.test.ts`: renamed the `fs.open` spread `args` to `openArguments`.
  - `test/accounts.test.ts` and `test/web/guest-settings-http.test.ts`: added a `spell-out-exempt` header, because `numRuns` is fast-check's own parameter name. `test/waitlist.test.ts` already does the same.
- **Comment-concision note** (non-blocking): I left the comment at `deploy/aws/scripts/deploy-accounts-store.sh:7` alone. It explains why the IAM permissions are split and what order to deploy in, which the code alone doesn't make obvious.

**Checks:**
- Both failing probes now pass when re-run against `origin/main`.
- `tsc --noEmit` is clean.
- The 5 touched test files pass (50 tests).
- `ci-wait-merge.sh --no-merge` exited 0: CI green, 0 failed.

My first CI wait ran in the background and was stopped at the 10-minute limit. I re-ran it in the foreground, and that run is the green result above. I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1061127 cached reads)
- Output: 5589 tokens
- Cost: $0.7676614000000002
- Wall-clock: 1453s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
