# Gauntlet fix round 3 — endojs/endo-but-for-bots#1391

The fix for round 3's must-fix item is pushed, and CI is green: `ci-wait-merge` returned rc 0 with 33 checks and 0 failures at head `1a5ed2ee0f`. I did not re-run the panel; the driver posts panel-4.

**Commits pushed to `build/sturdyref-ses-accommodation`** (both through `safe-push-pr-head.sh` in advance mode, no rewrite):
- `8ca237d3a0` test(ses): pins lockdown's refusal messages and checks that code evaluated in a child compartment on XS resolves `SturdyRef`.
  - **coverage-auditor (the must-fix-loop item):** the XS smoke now asserts `c.evaluate('SturdyRef') === shimmed`.
  - **wire-watcher / scribe:** `sturdyref-misshapen` and `global-locked-universal` now check the error message as well as `TypeError`.
  - **purist / integrator:** the `assertSturdyRefShape` JSDoc and the changeset now call the shape check a misconfiguration guard, not an authority boundary. The JSDoc also says how it differs from the shim's `isSturdyRefConstructor`. The `firstWinsPropertyNames` comment notes that `SturdyRef` is the only universal global whose start-compartment binding stays locked.
- `1a5ed2ee0f` adds a new `sturdyref-writable.test.js` (a writable, non-configurable `SturdyRef` makes lockdown throw). It also corrects the `isFirstWinsDescriptor` comment: the value check always holds in the start compartment, so it cannot catch a competing shim.

**PR body:** I removed the per-file tour the pruner flagged. I also rewrote four sections:
- **Security:** the shape check is now described as a misconfiguration guard.
- **Documentation:** it now says no SES doc lists the universal globals.
- **Testing:** it now states exactly what the XS smoke covers.
- **Compatibility:** "is the constructor" is now "has the constructor's shape".

**Completion summary comment:** posted at https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-5913151599. It corrects the round-2 summary's mistaken claim that review 5364797967 "has the wrong body" — that review was for this PR. It then gives a disposition for every item from rounds 2 and 3 that an earlier summary skipped: wire-watcher, fast-checker, corner-prober, gateway, prover, migrator, purist, engine-realist and scribe. The comment ends with "CI result below", but I did not post the CI result afterwards; the result is green, as above.

**Verification before pushing:** 11 Node tests pass (`npx ava test/sturdyref-*.test.js test/global-locked-universal.test.js`), `yarn build && yarn test:xs` exits 0, and Prettier and eslint report no errors on the touched files. Eslint shows two `Function`-type warnings in `global-object.js`; neither is on a line these commits touched.

**Declined or deferred, with reasons in the comment:**
- **Integrator's three-commit regroup:** deferred to a retcon before merge. This stage only adds commits, so the PR history still has fix-up commits.
- **A single per-global policy hook** (purist, integrator): declined while there is only one first-wins global.
- **fast-check property tests:** left as a follow-up, since `ses` has no fast-check dependency and `isFirstWinsDescriptor` is module-private.
- **Minting refs across compartments on XS, and Hermes coverage:** left as follow-ups; `packages/sturdyref` has no XS or Hermes harness.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1720416 cached reads)
- Output: 13079 tokens
- Cost: $1.2297752
- Wall-clock: 2734s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
