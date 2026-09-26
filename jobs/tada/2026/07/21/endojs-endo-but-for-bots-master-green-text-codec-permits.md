## Completion report

**Job:** Designer step — decide the correct SES permit shape for the tamed `%TextDecoderPrototype%` universal intrinsic (commit `536f82d18`), reconcile 3 failing text-codec tests to green master, and fold in trivial jsdoc lint fixes. Repo `endojs/endo-but-for-bots`, base `master`.

### The design decision (both answers)
The `hardened-text-codecs-shim.md` design (on `llm`) already prescribed the correct shape; commit `536f82d18` deviated from it in two ways. I realigned the implementation rather than authoring a new design.

1. **`fatal`/`ignoreBOM` → `getter`, yes.** Verified `TextDecoder.prototype.{fatal,ignoreBOM,encoding}` are all accessor properties (getters), identical to the already-correct `encoding`. The commit permitted `fatal`/`ignoreBOM` as `false` (a data-property removal), so the permits pass pruned the getters and `new TextDecoder().fatal` read `undefined`. They now carry the `getter` permit, matching the standard-property whitelist and the design's permits table (all three marked ✓ / pure). Also dropped the spurious prototype-only entries (`encode`/`encoding` on the `TextEncoder` ctor; `encoding`/`fatal`/`ignoreBOM` on the `TextDecoder` ctor) that were wrongly placed on the *constructor* permits — constructors expose only `[[Proto]]` + `prototype`; `length`/`name` come from the `FunctionInstance` base permit (confirmed via `getSubPermit`).

2. **The "absent when not on host" test contradicts the universal-intrinsic design because it tests the wrong boundary.** It simulated host-absence by filtering a *post-lockdown* Compartment's `globalNames`, which can't work — universal intrinsics are installed on every compartment regardless of `globalNames`. The genuine degradation happens at intrinsics-collection time (verified: deleting the globals before `lockdown()` yields absence). Reconciled by moving it to a dedicated worker file `text-encoder-decoder-missing.test.js` that deletes the globals before `lockdown()`, mirroring `url-shim-missing.test.js` from PR #719 — the project's established idiom for exactly this shape.

### Changes (pushed to `origin/master`, `536f82d18..adae30a97`)
- `af1b8bb0d` — `packages/ses/src/permits.js` (permit fix), `test/text-encoder-decoder.test.js` (removed the flawed test + its pre-existing `no-undef`/quote lint errors the same commit introduced), new `test/text-encoder-decoder-missing.test.js`.
- `adae30a97` — jsdoc lint fixes: added missing generator `@param` declarations (`daemon/src/{directory.js,pet-sitter.js,pet-store.js}`, matching the `EndoDirectory`/`PetStore` signatures) and dropped the unrecognized `@remarks` block tag (`compartment-mapper/src/types/policy-schema.ts`), folding its prose into the description.

### Verification
- Codec tests: **17/17 pass** (13 in the main file + the 2 genuine degradation tests + 2 iterator tests).
- Full `ses` suite: **530 passed, 2 known failures (pre-existing `test.failing`), 2 skipped** — no new failures.
- `tsc` clean on `ses`, `daemon`, `compartment-mapper`.
- `eslint` clean on every touched file (previously 4 daemon warnings + 1 compartment-mapper warning + 4 errors in the codec test).

### Follow-ups
- PR #719 (`feat/hardened-url-vetted-shim`)'s shepherd can now rebase onto green master — the blocker (red master from `536f82d18`) is cleared. No action taken on #719 itself; that's the shepherd's next step.
- `@@toStringTag` on both codec prototypes is intentionally left unpermitted (removed at lockdown, matching the design's explicit whitelist); no test depends on it. Not a regression.
