---
role: designer
---

Designer step on `endojs/endo-but-for-bots` `master` (escalated by the PR #719 shepherd, `next: designer`): decide the correct SES security-permit shape for the tamed `%TextDecoderPrototype%` universal intrinsic from commit `536f82d18` (whether `fatal`/`ignoreBOM` should be `getter` to match the standard-property whitelist, and how to reconcile the "absent when not on host" test that contradicts the universal-intrinsic design), reconciling the 3 failing text-codec tests to green master and thereby unblocking #719's rebase; fold in the trivial jsdoc `@param`/`@remarks` lint fixes (packages/daemon/{directory.js,pet-sitter.js,pet-store.js}, compartment-mapper/src/types/policy-schema.ts) that also red the lint lane.
