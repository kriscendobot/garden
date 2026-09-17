---
role: gardener
tier: mentor
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T03:18:10Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
project: minion-town
orchestration: minion-town-clipometer-esbuild-orchestration (child 2 of 4, serial — runs after minion-town-clipometer-esbuild-pipeline lands)

Validate the esbuild/real-`@endo/captp` CLIPOMETER pipeline (child 1) against the **live production** `minion.town` deployment, then publish the result as the new CLIPOMETER, replacing the hand-rolled version. Maintainer directive (dckc), 2026-09-03.

## What to do

1. Check out child 1's PR and build the bundle with its own tooling. Confirm the bundle's actual size and whether `ses`/`@endo/init` dominates it (expected) or something unexpected is bloating it.
2. **Use the non-interactive client-credentials MCP path** for iteration (`DEPLOYMENT.md` § "Automated MCP verification (client credentials)" — a bearer token over Streamable HTTP to `https://minion.town/mcp`, no browser/human login). The shared test identity behind it (`minion-mcp-test-cc`) is explicitly disposable per that doc; unpublish anything you publish there once you're done iterating, so you don't litter shared test state.
3. Using child 1's **programmatic** build+publish script (not a hand-typed tool call), publish the new bundle as a clip and confirm, against the real running daemon:
   - Bootstrap succeeds and the visit count reads/increments/writes correctly.
   - The `followNameChanges()` live-push subscription works: open two browser contexts (Playwright, matching the methodology already established for the hand-rolled version — read window B's displayed count, bump it from window A, confirm B updates with **no reload**).
   - Behavior is indistinguishable from the currently-published hand-rolled CLIPOMETER (same increments-on-load, same live cross-window update).
4. If validation is clean: publish the new bundle as the **canonical replacement CLIPOMETER** and unpublish the current hand-rolled one (`3hpxdbowneryryeywwxceseb64n5n7rh4g5qder3zorex3hg6qsq` — verify this is still the live hash before touching it; it may have already been superseded). **This publish should go through the same guest identity the primer/CLIPOMETER work has been using**, not the disposable `minion-mcp-test-cc` test identity — if your job environment doesn't have access to that identity's MCP session, say so plainly in your completion report and hand this specific step to the liaison/maintainer rather than improvising with the test identity for a publicly-linked artifact.
5. If validation finds a real problem (bundle doesn't actually work live, `@endo/exo-stream` vendoring/git-dependency approach breaks on the real daemon's exact wire behavior, size is impractical, etc.): **do not paper over it.** Record exactly what broke and end this child's report with the orchestration-failure signal so the chain halts here rather than updating the primer to describe something that doesn't actually work:

   ```text
   <<<GARDEN-ORCHESTRATION-FAILED>>>
   <<<GARDEN-JOB-COMPLETE>>>
   ```

   (pass `--orchestration-failed` to `complete-job.sh`).

## Deliverable

A completion report with the concrete evidence (bundle size, the two-window test result, timestamps/transcript) and, if clean, the new clip's hash/URL plus confirmation the old one is unpublished.

<!-- garden-annotation: key=clipometer-reanchor-20260916 by=mentor at=2026-09-17T03:16:49Z -->

handler-timeout: 3600

Re-anchor addendum (maintainer decision 2026-09-16): the canonical replacement publish must use the real guest MCP identity, never the disposable minion-mcp-test-cc identity. If the real guest credential is absent, hand the canonical publish step to the liaison/maintainer and report the missing credential plainly. Do not improvise another identity.

The live daemon run is also the required checkpoint for child 1's npm inconsistency: published @endo/patterns@2.0.0 imports trivialComparator from @endo/marshal, while published @endo/marshal@1.10.0 does not export it. Child 1 avoided that broken dependency edge by vendoring iterate-reader.js. Report whether the real-daemon build, bootstrap, counter update, and two-window followNameChanges validation show that the vendored approach holds.
