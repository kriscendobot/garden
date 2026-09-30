Fix round 1 report for endojs/endo-but-for-bots PR #1392: the panel's must-fix items were already fixed on the PR head, so this run pushed nothing new. CI on that head is green.

**What was already on the head**
The panel reviewed commit `caed8bedaa`. An earlier claimant of this job then pushed four follow-up commits, ending at head `b8c830e71b`:
- `62ce9dfd75`: `fix(pass-style): trust only a frozen SturdyRef global, and ask it last`
- `e9503183cb`: `fix(marshal): reject rank-ordering a SturdyRef with a clear error`
- `feb35f85aa`: `chore: Update yarn.lock`
- `b8c830e71b`: `docs(pass-style): name the SturdyRefObject type and document the sturdyRef style`

I checked each must-fix against that head:
- **Rank-order crash** (corner-prober, fast-checker, typist #2, migrator, spec-keeper): `rankOrder.js` now works from a `RankedPassStyle` type that leaves out `'sturdyRef'`. Rank-comparing a SturdyRef now fails with a clear error instead of a raw `TypeError`. There is a new `packages/marshal/test/sturdyref.test.js` and a marshal changeset.
- **Trusting any `globalThis.SturdyRef`** (locksmith, warden, purist, engine-realist, breaker): pass-style now accepts the global only if the constructor, `isSturdyRef` and `prototype` are all frozen. A candidate must be frozen, have no own properties and inherit directly from the captured prototype, which rejects a foreign `new.target`. A brand check that throws or returns anything but `true` rejects the value. `passStyleOf` asks the brand check only after every other pass style has declined, so a fake global cannot reclassify an already-passable value. New tests cover a lying, throwing, unfrozen and absent global.
- **Type mismatch** (typist #1): the shim's `SturdyRef` typedef now has the `[Symbol.toStringTag]: 'SturdyRef'` member. `types.test-d.ts` checks that `passStyleOf(sturdyRef)` has type `'sturdyRef'`.
- **Broken design link** (archivist): `pass-style/src/sturdyref.js` no longer cites the missing `designs/sturdyref-shim-contract.md`.
- **Docs** (surfacer, integrator #1): the pass-style README table has a `'sturdyRef'` row, and it is listed with the pass-by-presence styles. The sturdyref README no longer says `passStyleOf` rejects a ref.
- **Changeset** (stylist): now one sentence per line.
- **PR body and title** (integrator #2 and #3): the `## Stack index` heading is gone and the title no longer says "layer 3".

**Left as is**
- Two files still cite the missing `designs/sturdyref-shim-contract.md`: `packages/sturdyref/README.md:9` and `packages/sturdyref/test/sturdyref-shim.test.js:4`. Neither line is changed by this PR (they come from the layer-1 base), so I left them. They are worth fixing in the layer-1 PR.
- The pruner asked to delete the template's "Considerations" subsections, but the integrator cited the rule that PR bodies keep the upstream template headings. I followed the template rule, so those subsections stay.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1392 --no-merge` returned rc 0: 33 checks, none failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 234 tokens (14040406 cached reads)
- Output: 60238 tokens
- Cost: $7.722146199999997
- Wall-clock: 5082s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
