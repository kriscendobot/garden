The job is complete. Final report follows.

---

## Completion report: `ratchet-jsdoc-check-tag-names-error-endo`

**Outcome:** PR opened — https://github.com/endojs/endo-but-for-bots/pull/554 (base `master`, head `ratchet-jsdoc-check-tag-names`, commit `961206932`).

**What I did**
- **Ratcheted the rule.** Added `'jsdoc/check-tag-names': 'error'` to the main `rules:` block of `packages/eslint-plugin/lib/configs/style.js` (the `plugin:@endo/style` preset, which `strict` extends), upgrading it from the warning inherited via `plugin:jsdoc/recommended-typescript-flavor`.
- **Fixed the one defect — chose option (b), rewrite.** `packages/compartment-mapper/src/types/policy-schema.ts:64` used the TSDoc-only `@remarks` block tag. I confirmed `@remarks` appears **exactly once** in the whole repo and that the repo runs JSDoc-typescript-flavor (not TSDoc), so legitimizing it set-wide via `definedTags` would be over-broad. I folded the remarks prose into the type's description instead, leaving the rule's tag set unchanged. No prose lost.
- **Added a changeset** (`@endo/eslint-plugin`: **minor**), mirroring the precedent for the analogous numeric-separators ratchet (`c423ed37b`), since consumers of `plugin:@endo/style`/`plugin:@endo/strict` will now see the stricter error.

**Verification (local, exact repo toolchain — yarn 4.13 / node 22)**
- `eslint .` exits **0** repo-wide with **zero** `check-tag-names` reports (confirmed this was the only instance; remaining 4 lint warnings are unrelated `jsdoc/require-param`).
- `prettier --check` clean on both edited files.

**Gauntlet status:** CI is in flight on #554 (zizmor already green; lint + the test matrix pending). The change is mechanical (an eslint-config flag plus a doc-comment edit, no runtime behavior), so I let CI run asynchronously rather than block the gardener. The PR is ready for the review/merge stage of the gauntlet.

**Follow-ups**
- The sibling jobs under the `lint-ratchet-endo-master` roadmap should follow the same shape proven here: bundle the config change + its surfaced defect fixes in one commit, and carry a `@endo/eslint-plugin` changeset (`minor` when the ratchet creates new errors for preset consumers). The precedent commit is `c423ed37b`.
- If a maintainer would rather *keep* `@remarks` (option a), it's a one-line follow-up to add `remarks` to `definedTags` and revert the prose fold; I judged rewrite the better house-style call given the single repo-wide use.

Inbox drained (empty throughout); scratch worktree torn down.

Self-improvement: nothing this time.
