**Clean stage for endojs/endo-but-for-bots#1349: done, no changes needed, CI green.**

- **PR state:** open and not a draft. The head is `991f8af47e` on `build/hardened-text-codecs-shim`, and the base is the frozen branch `master-ebc7904`.
- **Coverage:** none added. Earlier review rounds already pushed a lot of test commits covering the codec taming edges, restricted-property shapes, primitive prototypes, the absent-codec path on XS, zero-length `encodeInto`, XS lockdown-time removal and the browser assertions. The newest commit only changes docs.
- **Dead code:** none found. I checked the source changes against the merge base (`src/encapsulate-host-constructor.js`, `src/tame-text-codecs.js`, `src/lockdown.js`, `src-xs/lockdown-shim.js`, `src-xs/compartment.js`):
  - The new exports `encapsulateHostConstructor` and `tameTextCodecs` are both used.
  - `lockdown-shim.js` dropped its imports of `ShimStartCompartment` and `adaptCompartmentConstructors`, but those are still used in `src-xs/compartment-shim.js`, so nothing was left orphaned.
- **Pushes:** none.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0: all 15 checks passed, including browser-tests, cover, test-xs and test262.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (358973 cached reads)
- Output: 2543 tokens
- Cost: $0.5096866000000001
- Wall-clock: 50s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
