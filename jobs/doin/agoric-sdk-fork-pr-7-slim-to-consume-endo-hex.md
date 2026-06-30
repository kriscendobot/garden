# Slim agoric-sdk #7 to consume `@endo/hex` (drop the in-tree hex.js codec body)

**Role:** builder/fixer (agoric-sdk-fork PR work). **Repo:** `kriscendobot/agoric-sdk` (the bot's
agoric-sdk fork; bot identity; direct push). **PR:** #7, branch
`fix/internal-hex-bufferish-validation`. **Base must stay on the fork.**

**HARD SCOPE LINE:** all artifacts base+head on `kriscendobot/agoric-sdk`. **No** links to,
comments on, reviews of, or pushes against **upstream `agoric/agoric-sdk`** (no upstream issue/PR
references at all). Experimentation on the bot fork is authorized; upstream stays untouched.

**Origin:** maintainer directive 2026-06-30T23:41Z (reply to the `endo-hex-tiered-codec-port` scope
question, dead-lettered and carried forward by job `deadmail-20260630T234117Z-85be2b`). The
coordination target `agoric-sdk-fork-pr-7-apply-richard-gibson-feedback` has COMPLETED (in tada/),
and its own follow-ups defer exactly this slim-down to a fresh job now that `@endo/hex` exists — so
this is that fresh job, not a duplicate. `@endo/hex@1.1.1` is published upstream and mirrored on
`endo-but-for-bots/master`; it is tiered (native `Uint8Array.fromHex`/`toHex` → pure-JS char-code
polyfill floor, bounded loops, no `flatMap`/no module-scope Map) and pin-complete. Do NOT modify
`@endo/hex`; #7 becomes a CONSUMER of it.

**Work:**
1. Make `packages/internal` depend on `@endo/hex` (add the dependency; update `yarn.lock`
   deterministically in a SEPARATE `chore: Update yarn.lock` commit per garden lockfile discipline).
2. Slim `packages/internal/src/hex.js`: drop the in-tree codec body and re-export / delegate to
   `@endo/hex`'s `encodeHex`/`decodeHex` (or `fromHex`/`toHex` as exported). #7 becomes a thin
   consumer, not a re-implementation. Keep the public surface `packages/internal` currently exports
   stable for its callers.
3. **Reconcile the error-message pins.** #7 asserts the exact string `Invalid hex string: ${hex}`;
   `@endo/hex` throws a hex/odd-length message carrying offset + name. **Prefer adopting
   `@endo/hex`'s semantics** and updating #7's test text to match. Only wrap to preserve the literal
   `Invalid hex string: ${hex}` string if a concrete caller depends on that exact text — check the
   tree before wrapping; default is adopt-and-update-tests.
4. Update `packages/internal`'s hex tests to reflect the delegated implementation and the
   reconciled error text. All #7 correctness pins (full 0..255 round-trip, case handling, empty,
   odd-length rejection, invalid-char rejection incl. `@`/backtick guards) must still pass against
   `@endo/hex`.
5. Run local-verify (format/lint/build/test for the touched packages) and drive CI green on #7.

**Benchmark justification in the PR description:** include the platform/size/speed/approach table
(native vs char-code vs Buffer vs map-table across Node-new/Node-old/XS) as the justification for
consuming `@endo/hex`'s native→char-code tiering. The standalone benchmark REPORT is owned by the
live job `ebfb-build-endo-hex-package-platform-benchmark-table` (re-scoped to a report, not a mirror
edit) — coordinate with it / reuse its table rather than re-deriving. Empirical baseline already on
record (job `benchmark-endo-hex-vs-agoric-internal-decode-node-xs`): Node — Buffer fastest, map
slowest pure-JS (~8–9× slower than char-code arithmetic); XS — map wins on metered compute
(2.3–2.6×). This confirms tiering native→char-code is sound and that no Buffer/map tier belongs in
the published `@endo/hex`.

**Deliverable:** #7 updated so `packages/internal` consumes `@endo/hex` with the in-tree codec body
removed, error pins reconciled, tests green, CI progressing, and the benchmark table in the PR
description as justification. Report the pushed SHA and CI state.

---
claim:
  host: endolinbot2
  gardener: 89
  claimed_at: 2026-06-30T23:47:48Z
