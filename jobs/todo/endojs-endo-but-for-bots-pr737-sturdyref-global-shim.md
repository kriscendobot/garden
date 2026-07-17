---
role: builder
---

Repository: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/737
Role: builder

Implement the maintainer's requested SturdyRef shim on PR #737. Work from the current PR head and preserve the existing PR branch.

Required outcomes:

- Move SturdyRef construction and recognition out of `packages/ocapn/src/client/sturdyrefs.js` into a `@endo/pass-style/sturdy-ref` utility.
- Make SturdyRefs opaque passable objects. Use `makeSturdyRef` from pass-style. Add pass-style regression coverage that a forged candidate with extra own properties or an invalid prototype makes `passStyleOf` throw.
- Prepend a first-wins global shim, initialized after lockdown when lockdown is used. It must install a hardened, closely-held `SturdyRef` namespace and its `fromLocation` and `toLocation` methods once per realm, with no SES permits and no child-compartment endowment.
- Retain the WeakMap from opaque SturdyRef identity to an object locator globally through that shim so eval twins of OCapN or CapTP in one realm converge on the same mapping. Locators must remain objects and must not couple the API to a URL or URN representation.
- Keep each CapTP instance's enlivener closely held. Update OCapN construction, codec behavior, types, and tests to use the shared shim without exposing secrets or locator records through the SturdyRef object.

This is a response to maintainer review https://github.com/endojs/endo-but-for-bots/pull/737#pullrequestreview-4718500574. It has three inline comments, all in `packages/ocapn/src/client/sturdyrefs.js`: lines 67-81 (opaque SturdyRefs and pass-style maker/test), 90-100 (move utility to `@endo/pass-style/sturdy-ref`), and 111-113 (global retained locator map and first-wins shim).

Run relevant pass-style and ocapn tests, lint, and type checks. Commit and push the follow-up to the existing PR branch. Reply on all three review threads with addressing SHAs, post the required top-level summary comment, and re-request maintainer review only after the relevant CI is green.
