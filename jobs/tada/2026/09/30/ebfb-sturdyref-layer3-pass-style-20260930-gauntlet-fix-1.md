I applied the panel's must-fix items to PR #1392 and pushed them, but CI hadn't finished when the 3600s wait ran out (rc 4), so this round ends as still-pending. One job, `test (24.x, ubuntu-latest)`, has already failed. The failing test is in `@endo/patterns` and also fails on the stack base from before this PR, so the PR didn't cause it.

**What I changed** (four follow-up commits, head moved from `caed8bedaa` to `b8c830e71b`):

1. **Trusting a fake `globalThis.SturdyRef`** (raised by the assessor, warden, purist, spec-keeper, wire-watcher, breaker and saboteur seats), in `pass-style/src/sturdyref.js` and `passStyleOf.js`:
   - Pass-style now trusts the global only if the constructor, its `isSturdyRef` and its `prototype` are all frozen.
   - The brand check is only asked about a frozen object with no own properties whose prototype is exactly `SturdyRef.prototype`. A check that throws, or returns anything other than `true`, rejects the object.
   - The check now runs after every other pass style has turned the value down, just before the remotable fallback. A fake global can no longer relabel or even see values of other styles; the most it can do is make its own empty objects passable.
   - Refs built with a foreign `new.target` or through a subclass are now rejected.
   - I did not require the global's property to be non-writable, because a child compartment's copy of a shared intrinsic is writable. The reason is written in the module docs.
   - New tests cover a lying global, a throwing global, a global that returns `1` instead of `true`, an unfrozen global, and the foreign `new.target` and subclass cases.
2. **Raw `TypeError` when rank-ordering a SturdyRef** (assessor, typist, migrator, purist, corner-prober): in `marshal/src/rankOrder.js` the rank table is now typed without `'sturdyRef'`, and lookups fail with a clear message ("… cannot be rank-ordered"). A new `marshal/test/sturdyref.test.js` pins that error and the encoding error. This added `@endo/sturdyref` as a dev dependency of marshal, so there is a separate `chore: Update yarn.lock` commit. `yarn install --immutable` accepts it.
3. **Types** (typist, purist): the pass-style type is renamed `SturdyRefObject`, and the `@endo/sturdyref` `SturdyRef` type now declares the `Symbol.toStringTag` so the two match. There is a new type test that `passStyleOf` returns `'sturdyRef'` for it.
4. **Docs** (archivist, integrator, surfacer, changeset-auditor):
   - The comment pointing at the missing design doc and the "layer" stack wording are gone.
   - The sturdyref README no longer says `passStyleOf` rejects a ref.
   - The pass-style README table now has a `'sturdyRef'` row.
   - The changeset is one sentence per line and now says that passing a ref hands over the authority to enliven it.
   - A marshal patch changeset was added.
   - The PR body's invented "Stack index" heading is folded into the Description.
   - The title no longer says "layer 3": it is now "feat(pass-style): recognize a SturdyRef as passable".

**Verification:** locally, the pass-style, marshal, sturdyref and patterns test suites pass in every ses-ava config, and lint and type checks pass for all four packages.

**The CI red:** the failing test is `copySet › setIsSuperset`, a randomized property test that hit a counterexample on CI's random seed. With that seed forced, it fails the same way on both the pre-fix head (`caed8bedaa`) and the stack base (`a0ef0c4320`). At the deadline, five jobs were still pending (the 22.x ubuntu and both macOS test runs, `test-xs` and `viable-release`).

**Follow-ups:**
- Once the current run finishes, rerun the failed `test (24.x, ubuntu-latest)` job.
- Open a separate job for the `copySet › setIsSuperset` failure (seed `-1417775664`, path `99:9:8:13:19:16:16:16`).
- Unaddressed should-fix items:
  - Regroup the commits so no commit carries the dependency cycle.
  - Add a `sturdyRef` leaf to `arb-passable.js`.
  - Pin the error messages in the older rejection tests.
  - Test pass-style inside a child compartment.
  - Decide whether a SturdyRef belongs in `PassableCap`; the PR body leaves that to the marshal step.
- Minor: the first fix commit uses the `SturdyRefObject` name before the commit that renames it, so type checks fail at that one commit. The branch tip is clean.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 148 tokens (9723081 cached reads)
- Output: 40179 tokens
- Cost: $4.089332199999998
- Wall-clock: 4059s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
