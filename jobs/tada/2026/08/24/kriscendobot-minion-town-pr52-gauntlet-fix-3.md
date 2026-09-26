The fix stage is complete: the round-3 must-fixes are pushed to the PR head and CI is green.

## Completion report

Applied the highest-consensus panel round-3 must-fixes to `kriscendobot/minion.town` PR #52 in one pass, pushed as follow-up commit `1f378d9` to `feat/daemon-sites-exo`, and confirmed CI green (the single `test` check passed).

**What changed (code + tests, typecheck + 249 tests green locally, CI green):**
- **Config gate `WEBLET_SITES_LIVE` (default OFF)** — the mechanical off-switch the panel asked for across ~10 seats (assessor, locksmith, warden, breaker, purist, engine-realist, gateway, releaser, wire-watcher). Threaded config → `http.ts` → `makeSocketGuestService` → `guestPowers` → `guestPowersFromDaemon`. While off, `http.ts` runs the non-serving scaffold **and** no guest receives the `sites` introduction, so the unattenuated multi-tenant exposure (R1) cannot occur. Opt-in only for trusted single-tenant deployments.
- **Rename** `makeGuestSiteAuthority` → `makeDegradedGuestSiteAuthority` (stylist/curator/migrator; warranted per rename-discipline).
- **Saboteur #1**: `unpublish` now normalizes to the canonical label before forwarding, so a case-varied copy of a serving URL still takes down the owner's own site; pinned with a capturing-registry regression test.
- **Missing canonicality-branch test** (prover F1 / fast-checker F1): a pad-bit alias that clears the shape check but fails `labelToId` is rejected with nothing written; renamed the misleading sibling test.
- **Typist code points** on added lines: `<->`, `...`, `1-2`/`3-4` (typist/packager/integrator) in `base32.ts`, `DEPLOYMENT.md`, the test title, and the `units N–M` ranges.
- **Abbreviated identifiers**: `opts`→`options`, `dir`→`directory`, `storeDir`→`storeDirectory` (stylist).
- **Archivist**: fixed the dangling "this module's test" doc pointer to name `site-registry-exo.test.ts`; added the non-canonical case to `labelToId`'s JSDoc.
- **Docs**: `DEPLOYMENT.md`, the R1 residual, and the PR body now name the `WEBLET_SITES_LIVE` lever; PR "## What"/"## How"/R1 rewritten to the landed `register(directoryId, owner)` shape and the honest cross-tenant exposure (integrator/gateway/releaser).

**Deliberately left for the next round (not attempted here, to keep the pass coherent and CI-green):** the deeper security refactor for the locksmith/wire-watcher ownership-read-back (now gated behind opt-in), migrator M1 pre-existing-guest re-introduction semantics (daemon-behavior, ENDO_CHECKOUT-only), and the broader prose-pruning (pruner) and surfacer tool-description items. Per stage instructions I did not re-run the panel; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr52-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 172 tokens (13924407 cached reads)
- Output: 55857 tokens
- Cost: $10.3604885
- Wall-clock: 851s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
