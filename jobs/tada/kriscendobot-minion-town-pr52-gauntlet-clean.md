The clean stage is complete.

## Gauntlet stage: CLEAN — kriscendobot/minion.town PR #52

**Result: coverage clean, CI green.**

### What I did
- Confirmed PR #52 shape: OPEN draft, single feature commit adding the daemon-hosted `@sites` exo (§9 units 1–2). CI was already green on the base commit.
- Ran a coverage pass (`@vitest/coverage-v8`, installed `--no-save` so `package.json`/lockfile stayed untouched) on the touched gateway sources. Baseline gaps:
  - `daemon-site-registry.ts` — **23.27%** stmts. Its install/authority/registry seams are, by design, the `E`-free layer meant to be unit-tested (the sole HardenedJS `E` application lives one level up in `daemon-weblet-wiring.ts`), yet they shipped with only the two source-shape helpers covered.
  - `site-registry-exo.ts` — 97.5%; the inlined malformed-formula-id guard was uncovered.

### What changed (1 commit, `8c5910b`, pushed to `feat/daemon-sites-exo`)
- **New** `test/gateway/daemon-site-registry.test.ts` (8 tests): fakes for the daemon top host / guest / exo drive `installSiteRegistry`, `makeDaemonGuestSiteAuthority`, and `makeDaemonSiteRegistry`. Real failure modes asserted: evaluate slot binding (`guest`+`sites`, never a host-authority name), the guest register-source shape, override pet names, the loud `weblet_upgrade`-not-yet error, `list`/`unregister` forwarding, and `register()` refusing direct use.
- **Amended** `test/gateway/site-registry-exo.test.ts` (+1 test): a non-hex / odd-length formula id must be rejected, not encoded into a garbage vhost label.
- Coverage after: `daemon-site-registry.ts` **100%**, `site-registry-exo.ts` **100%** stmts. Full suite `232 passed | 4 skipped` (was 223), typecheck clean, `npm test` == CI green at head `8c5910b`.

### Notes / no-ops
- **No dead code to remove.** The change is purely additive; the in-memory `makeSiteRegistry` scaffold is deliberately retained as the no-daemon boot fallback in `http.ts`, so nothing was orphaned.
- **Deliberate residual gap:** `daemon-weblet-wiring.ts` stays at 3.22% — it is the single `E`-application layer requiring a live Endo daemon, exercised only by the skip-gated B1 integration suite (`test/endo-daemon-integration.test.ts`, needs `ENDO_CHECKOUT`). This is a platform-conditional gap documented in the module header, correctly out of scope for unit tests on a box that cannot build the native `better-sqlite3` daemon store.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr52-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2207737 cached reads)
- Output: 17655 tokens
- Cost: $2.2171305
- Wall-clock: 360s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
