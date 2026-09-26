Round-2 fix stage complete. CI is green after applying the panel's must-fix items.

## What I did

Applied panel round-2 must-fixes to PR #52 (`feat/daemon-sites-exo`) as follow-up commit `ee049a4`, pushed to the PR head, and watched CI to **GREEN** (rc 0). Typecheck + vitest pass: **247 tests / 4 skipped (+5 new)**.

**Correctness fixes**
- **Degraded fallback no longer throws** (assessor): dropped the doomed `E(sites).register` evaluate against the `"5".repeat(64)` placeholder, so a degraded publish returns `serving:false` + `warning` instead of `Unknown pet name 5555…`; warning text corrected to *restart* (latched mode).
- **harden() the exo's per-call results** (warden, purist) — endowed `harden` in the install source and test fakes; frozen-result regression test.
- **Non-canonical base32 label rejection** (spec-keeper, corner-prober, fast-checker) in both codecs + hash canonicalization in `evaluateRegister` — closes the 16-origins aliasing.
- **Install-timeout crash fixed** (breaker F2) — terminal `catch` on the race's losing promise.
- **`weblet_upgrade` rejects before charging** (prover, curator, migrator) via a new `assertUpgradable()` gate.
- **`sites`/`@sites` name unified** (archivist, integrator, migrator, saboteur) to one exported binding `GUEST_SITES_NAME` shared by introduction and evaluate.

**Honesty/surface fixes**
- MCP tool descriptions de-cited + serving/warning disclosed (surfacer, releaser, pruner); exo `owner` doc marked unverified (typist); code points fixed.
- R1 / design §9 / DEPLOYMENT.md now state plainly the live cross-tenant exposure and CI-unverified status, with an explicit "not for untrusted multi-tenant guests until the attenuated facet lands" gate (locksmith, warden, wire-watcher, purist, packager, saboteur); design Status/deviations reconciled (scribe).
- Posted a top-level summary comment.

**Deliberately deferred (documented as blockers, not tidiness):** the attenuated register-only per-guest facet (unit 3) and live daemon-path verification under `ENDO_CHECKOUT` — these are large, endo-daemon-semantic, CI-unverifiable changes beyond a single fix stage; the docs now name them as merge blockers rather than claiming the live path works.

**Follow-up for the driver:** the panel re-run (panel-3) may still request-changes on the deferred security facet — that's expected; it's genuine unit-3 architectural work requiring a live-daemon test harness.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr52-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 170 tokens (14449406 cached reads)
- Output: 71571 tokens
- Cost: $11.122308000000002
- Wall-clock: 1109s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
