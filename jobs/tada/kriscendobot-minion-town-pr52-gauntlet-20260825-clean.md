CI is GREEN (rc 0) at the new head. The clean stage is complete.

## Completion report

**Stage:** CLEAN — `kriscendobot/minion.town` PR #52 (gauntlet iteration 0)

**What I did:**
- Confirmed baseline: PR draft, all 261 tests passing at head `3dd1ac3`.
- Ran a v8 coverage pass on the PR-touched gateway files (installed `@vitest/coverage-v8` with `--no-save` so package.json is untouched).
- Found the one substantial gap in the PR's **new** code: `daemon-weblet-wiring.ts` at **51% statements** — the successful connect+install+wiring path (lines 89–125) was untested; only the timeout path was.

**What changed (2 test files, no source changes):**
- `test/gateway/daemon-weblet-wiring.test.ts` — added a test driving the successful install through the injectable `connect` seam with a fake daemon top host: asserts the exo is installed under the `sites` pet name over the `store` endowment, the returned registry carries the real `formulaId` and forwards `list`, `authorityFor` yields the unit-3 not-yet upgrade error, and `close` is idempotent. **`daemon-weblet-wiring.ts`: 51% → 100% statements.**
- `test/gateway/publish.test.ts` — covered the degraded guest authority's previously-untested `writeDirectory` (in-place front/back rewrite + the "not held by this guest" rejection) and its ephemeral receipt's no-op `unregister`. **`site-registry.ts`: 79.6% → 84.5%.**

**Verification:** `npm run typecheck` clean; full suite 264 passed / 4 skipped; committed `50a3207`, safe-pushed to `feat/daemon-sites-exo`, and CI came back **GREEN** at the new head (rc 0).

**Dead code:** none orphaned by the change — the PR's rename `makeGuestSiteAuthority` → `makeDegradedGuestSiteAuthority` remains live in `src/http.ts`. Remaining minor coverage gaps (site-registry.ts memory-scaffold branches, config.ts env-switch defaults) are pre-existing, not PR-added.

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr52-gauntlet-20260825-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 89 tokens (3260467 cached reads)
- Output: 18162 tokens
- Cost: $2.8267245000000005
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
