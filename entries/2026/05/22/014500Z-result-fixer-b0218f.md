---
ts: 2026-05-22T01:45:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

PR #348 (mirror of endojs/endo#2902, `refactor(bundle-lite): Deduplicate bundle-lite`): applied the 2-line fix the cleaner diagnosed for the `syncModuleTransforms` regression in `packages/compartment-mapper/src/bundle-lite.js#makeFunctorFromMap`. Added `syncModuleTransforms` to the option destructure (L317) and to the `link()` call (L391-L392).

Verification: `yarn build:hermes` and `yarn test:hermes` in `packages/ses` both pass on the fix head. `yarn test` in `packages/compartment-mapper` passes (876 tests, 6 known failures unrelated). `test-hermes` CI was FAILURE on 38bd5ba4d for this reason; expect green on the new head once CI runs.

Pre-push gate: ran the gate; it surfaced two pre-existing non-auto-fixable findings (`no-inline-import-jsdoc` in `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergence across `immutable-arraybuffer`, `bytes`, `hex`, `panic`). Both are pre-existing master drift unrelated to this fix; per the fixer's-lane norm they are out of scope for this dispatch. Auto-fix touched two unrelated files (`evasive-transform/src/index.js`, `ses/src/compartment.js`) which were discarded for the same reason; only the 2-line `bundle-lite.js` fix was committed.

Commit: `b2005c2db fix(compartment-mapper): Restore syncModuleTransforms in bundle-lite`, pushed to `mirror/2902-dedup-bundle-lite`.

Top-level comment posted on PR #348 explaining the regression-in-mirrored-upstream-commit framing so the upstream ferry carries the fix forward into endojs/endo#2902: https://github.com/endojs/endo-but-for-bots/pull/348#issuecomment-4514226370 (cc @kriskowal).

Self-improvement: nothing this time.
