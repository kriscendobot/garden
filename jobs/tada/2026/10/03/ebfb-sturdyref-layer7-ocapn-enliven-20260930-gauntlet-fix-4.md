# Gauntlet fix round 4: endojs/endo-but-for-bots PR #1397

I fixed both blocking items and all the should-fix items from the round-4 panel except two optional ones (listed below). I pushed the fix as commit `ed37d3c9c5` onto `build/sturdyref-ocapn-enliven` (was `7af07e2320`). CI on the new head is green: 33 checks, 0 failed.

## Blocking items
- **archivist:** `enlivenAtHome` now has `@returns {Promise<unknown>}`.
- **engine-realist:** I took the panel's second option and stated the limit in the changeset rather than adding an XS test. The changeset now says the `frozenBytes` byte round trip is tested only on Node, because `@endo/ocapn` has no XS test run yet. Native immutable `ArrayBuffer` on XS is still unverified.

## Should-fix items folded in
- **purist, integrator:** the public `NonceLocator.get` now accepts `string | Uint8Array`, and the separate `SecretLocator` type is gone. I wrote it as a method signature so a string-keyed `Map` is still a valid locator. The test helper's locator option is now typed `() => NonceLocator`, so the tests no longer need the `/** @type {any} */` locators.
- **spec-keeper, assessor:** the `catch` in `lookupSecretBytes` now only handles `RangeError` and rethrows anything else.
- **stylist:** `enlivenAtHome` now takes `(locator, secret)`, the same order as `lookupSecretBytes`.
- **corner-prober:** three new tests:
  - An unknown non-ASCII byte secret is rejected, both at home and at a remote peer, and the message contains neither the bytes nor the decoder's `RangeError` text.
  - An empty secret (string and bytes) works at a remote peer.
  - A non-ASCII string secret at home reaches the locator unchanged.

## Checks run locally
- Package `lint:types` passes. A repo-root `tsc` check shows no errors in `packages/ocapn`.
- `yarn lint` shows warnings only, no errors.
- The full `@endo/ocapn` test suite passes: 577 tests.

## Not done
- **fast-checker:** the property-based test needs `fast-check` added as a devDependency, so I left it as the follow-up the panel suggested.
- **integrator:** I did not squash the "Address the round-N panel" commits, because that means rewriting the PR branch's history. Better done once before merge. I also did not update the PR body to note that #1396's later must-fix doesn't affect this layer.

Per the stage instructions I did not re-run the panel; the driver posts panel round 5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2069272 cached reads)
- Output: 10681 tokens
- Cost: $1.2952664000000003
- Wall-clock: 2498s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
