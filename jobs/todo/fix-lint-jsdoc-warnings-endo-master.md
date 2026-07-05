<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T21:49:29Z -->

# SUPERSEDED — fix-lint: jsdoc warnings on endo master

**Do not promote or work this plan.** It is retained only as a pointer.

This consolidated plan merely *cleared* the 5 jsdoc warnings. On 2026-06-28 the
maintainer (via the `classify-lint-endo-master` thread) directed a stronger
approach: *ratchet each warning rule up to **error** and fix the resulting
defects*, so the classes can never regress. That directive is now covered by two
ready `todo` jobs, one per warning rule class:

- **`ratchet-jsdoc-require-param-error-endo`** — set `jsdoc/require-param: 'error'`
  in `packages/eslint-plugin/lib/configs/style.js`; autofix-then-fill the 4
  `packages/daemon` `@param` defects.
- **`ratchet-jsdoc-check-tag-names-error-endo`** — set
  `jsdoc/check-tag-names: 'error'` in the same config; resolve the 1
  `compartment-mapper/src/types/policy-schema.ts:64` `@remarks` defect (allow the
  tag, or rewrite the block).

Each ratchet job carries the full config location, the exact defect list (master
`364d69ba1`, unchanged since the classification), the fix approach, and a
definition of done. The original classification lives in
`entries/2026/06/27/120231Z-result-gardener-b2471d.md`.
