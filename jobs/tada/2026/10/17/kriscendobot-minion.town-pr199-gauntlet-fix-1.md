orchestration status: CI still pending at the deadline. The round-1 fixes are pushed to the PR, but none of the runner-hosted CI jobs started within the hour.

## Fix round 1 for kriscendobot/minion.town#199

I pushed four follow-up commits to `feat/guest-coupons`, taking the head from `94c4943` to `4c239f9` through `safe-push-pr-head.sh`, which only fast-forwards. I also rewrote the PR body.

**Must-fix items:**
- **`GUEST_ADMISSION` accepted typos as "open" (saboteur):** a misspelling like `Coupon` silently left `POST /api/guest` open to anyone. A new function, `parseCouponAdmission` in `src/config.ts`, now refuses unknown `GUEST_ADMISSION` and `COUPON_STORE` values at startup, and uses the defaults only when a setting is unset. `loadConfig` also refuses `coupon` admission with no coupon store. Tests for the defaults and each refusal are in `test/config.test.ts`; this also covers prover's "startup refusal is untested" point.
- **Stale and overlong PR body (integrator):** I rewrote it from 1,307 words to about 460. It now matches the three earlier commits (the real-daemon test, plus the adapter bug it found and fixed), says plainly that this is a partial slice and lists what is unbuilt, and drops the obsolete follow-up-job paragraph. It also covers pruner's cuts.
- **Missing design doc (archivist, integrator):** `designs/guest-coupons.md` exists only in draft PR #144. The body now says this PR must merge after #144, which clears the finding on that merge per the archivist.

**Should-fix items also applied:**
- **Sweep stops at the first failing row (breaker, saboteur):** `sweep()` now handles each row on its own and reports failures in a new `failed` field, so one bad row no longer blocks expiry for the rest. The 5-minute timer in `src/http.ts` logs each failed row with its serial.
- **`issue()` lost coupons when the pool ran out partway (assessor):** it now records each coupon in its book as soon as it is reserved, so a partial failure leaves every coupon listable and revocable. There is a test for this.
- **DynamoDB writes could overwrite concurrent changes (saboteur, breaker):** `lease`, `recordIdentifier` and `attach` now only write if the row is still exactly as they read it, and `lease` and `recordIdentifier` re-read and retry on a conflict (up to 3 tries). A test covers this, and the existing condition-string tests are updated.
- **No operator docs (archivist):** there is a new "Guest coupons" section in `deploy/aws/README.md` covering the three settings, the five-step switch to closed beta (with a smoke check first), rollback, and how coupon state works.
- **Narrating comments (pruner):** I trimmed the deploy script's header and removed the numbered step comments in the daemon test. That test's final no-op sweep now asserts `failed` is empty.

**Testing:** `npx tsc --noEmit` is clean. Locally, `npm test` passed 1209 tests; the one failure is `test/git-remote/capability.test.ts`, which this PR doesn't touch and which the original body already reported as failing because of the local git setup. The Endo daemon test (`guest-coupons-daemon.test.ts`) did not run locally, so its edited assertion is checked only by CI.

**CI:** `ci-wait-merge.sh` returned rc 4 when the hour ran out. The "Claude harness (amd64)" check passed, but "test" and "Claude harness (arm64)" never left the queue for about an hour after the 16:00Z push. That matches the known `ci.minion.town` runner stall from the GitHub rate limit, which clears on the hourly reset. I cancelled the run for the superseded commit `179d533`. The driver should re-post this stage to collect the CI result.

**Not addressed:**
- Assessor's "sweep never marks a removed coupon": the reported cost is a repeated daemon round trip per old row on every sweep. Fixing it needs a ledger schema field in both adapters.
- Prover's request to run the ledger tests against DynamoDB Local: the gap is stated in the PR body instead.
- `attachForHolder` scans the whole ledger on every invitation, and attached coupons are never released.
- `deliver()` may send a book twice after a crash.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3724439 cached reads)
- Output: 22775 tokens
- Cost: $2.1224757999999992
- Wall-clock: 3911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
