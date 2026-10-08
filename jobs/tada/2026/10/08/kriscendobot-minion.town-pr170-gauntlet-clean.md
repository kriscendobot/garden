**Clean stage done for kriscendobot/minion.town#170** (`feat/locator-fragment-scrub`). I pushed one small cleanup commit, and CI is green on the new head (3 of 3 checks).

**Coverage pass (skills/coverage-driven-testing):** the change already has adequate tests, so I added none.
- **Parser:** `parseFragment` and `isValidFormulaIdentifier` moved into `deploy/aws/www/locator-fragment.js`. `src/web/invitation-envelope.ts` re-exports them, so the existing `test/web/invitation-envelope.test.ts` still exercises the parser rules (duplicate fields, ambiguous envelope, wrong version, bad identifier, unsafe label).
- **Bootstrap:** `test/web/locator-bootstrap.test.ts` checks that the bootstrap runs first, that the CSP sha256 hashes match, and the Caddy asset and header rules.
- **Browser storage:** the encrypted IndexedDB storage, the fragment scrub, migration of the old localStorage guest key, and the "nothing leaks into URLs or referrers" checks are covered by the Playwright spec `test/browser/locator-fragment.spec.js` (3 tests).
- **Local run:** `vitest run test/web` passed (51 passed, 2 skipped, which were already skipped before) and `tsc --noEmit` is clean.

**Dead code:** moving the parser left a stray doc comment for `isValidFormulaIdentifier` in `src/web/invitation-envelope.ts`, sitting directly on top of the next interface's comment. I removed it in commit `143a6249ce5` ("chore(web): drop doc comment orphaned by the parser move") and pushed it with `safe-push-pr-head.sh` as a fast-forward from `c0746f8`. Nothing else was left unused: the label constants are still used by the URL builders. `src/web/invitation-session.ts` is imported only by its own test, but that was already true on `main`, so this change didn't orphan it and I left it alone.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 on `143a624` after about 4 minutes.

**Follow-ups (not done here):**
- `locator-fragment.js` repeats the label length limit as a bare `128` instead of using `MAX_LABEL_LENGTH`. It's harmless, but the two could drift apart.
- Whether to delete the unused `invitation-session.ts` is a separate decision from this PR.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (592454 cached reads)
- Output: 4184 tokens
- Cost: $0.6212187999999998
- Wall-clock: 381s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
