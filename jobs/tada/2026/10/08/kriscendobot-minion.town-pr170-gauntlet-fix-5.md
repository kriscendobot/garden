PR #170 has all three round-5 must-fix items applied and pushed to the PR head (`5e32e67` → `ea0ec5e`). CI could not run: GitHub Actions refused to start the jobs because of an account payment/spending limit, and the maintainer has already been alerted.

**Changes (2 follow-up commits, plus a PR description edit):**
1. **stylist (`sockPath`):** renamed to `socketPath` in the `connect?:` option type and the `makeSocketGuestWebService` parameter in `src/web/guest-web-socket-service.ts`, and in the test local in `test/web/guest-web-daemon.test.ts`. I left `tmp.sockPath` and the `sockPath:` key passed to `startEndoDaemon` alone, because they belong to an existing test helper's API.
2. **saboteur (try block too wide):** in `deploy/aws/www/locator-fragment.js`, `migrateLegacyGuest` now has a narrow `try` around only the `storage ?? localStorage` access and the `getItem` reads. Its catch logs with `console.warn` and returns, so the next visit retries. I removed the wide `try`/`catch {}` in `captureLocatorFragment`.
   - **Behavior change:** an IndexedDB or crypto fault during migration now propagates instead of being swallowed. The bootstrap then sends the user to `?capture-error=1`, which shows "could not store the credential securely". The pending link has already been stored by that point, so it is not lost.
   - **Possible conflict with the old intent:** the removed comment said a failed migration "must not cost the link it arrived with", and the bootstrap now goes to the error page in that case. I followed the reviewer literally; the next panel may want to weigh in.
3. **pruner (PR description):** dropped the `Parser move` and `Browser tests` bullets and cut "Security model" to one sentence: the scrub is the main defense, and the encryption only keeps the credential out of plaintext storage.

**Local checks:** typecheck is clean, the vitest web tests pass (58 passed, 3 skipped), and the Playwright browser suite passes (14/14).

**CI:** `ci-wait-merge.sh` returned rc 5. Per the job instructions I did not re-run anything or push more. CI on the new head is still unverified, so the driver should park this stage until billing is restored.

**Follow-ups:** none of the panel's should-fix items were applied. They are left for later rounds, most notably that `isGuest` duck-types on method names so a daemon host passes as a guest; the decomplector suggests checking `type === "guest"` via `locate` instead.

<!-- gauntlet-stage-result: fix=ci-billing-blocked -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1092300 cached reads)
- Output: 6628 tokens
- Cost: $0.8079720000000001
- Wall-clock: 148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
