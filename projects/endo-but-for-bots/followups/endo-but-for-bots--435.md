---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 435
created_at: 2026-06-09T05:52:00Z
last_appended_at: 2026-06-09T05:52:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#435

## Items

- [ ] `packages/pass-style/src/byteArray.js` `immutableGetter` silent-always-false load-order risk.
  **Source juror(s)**: warden, saboteur
  **Round**: 1 (barrister)
  **Recommended action**: open follow-up PR with a JSDoc comment on the new immutableGetter capture documenting the load-order constraint, OR a first-call assertion that throws when the captured getter is the `(() => false)` fallback. The same constraint existed in master (the old `adaptImmutableArrayBuffer` would throw at import if the shim was not loaded); the new shape silently denies all byte-arrays for the realm's lifetime, which is harder to diagnose.

- [ ] `packages/immutable-arraybuffer/DESIGN.md` § Move 2 paragraph 7 and § Out of scope item "Retiring the concordance purposeful-violation note in the README" require post-merge update.
  **Source juror(s)**: archivist, scribe
  **Round**: 1 (barrister)
  **Recommended action**: open follow-up PR amending DESIGN.md to record the actual decision the fixer-loop reaches (either the toStringTag-on-own-property restoration, or a different shape if the fixer / justice / appellate iteration lands on something else). The DESIGN should reflect the as-shipped behaviour; the README's *Purposeful Violation* section's claim that "concordance handles the TypeError as unrenderable" should be removed or rewritten in the same PR.

- [ ] `packages/ses/src/get-anonymous-intrinsics.js` dead-import sweep.
  **Source juror(s)**: pruner, packager
  **Round**: 1 (barrister)
  **Recommended action**: after merge, run a lint sweep verifying no other use of `getPrototypeOf` remains in `get-anonymous-intrinsics.js` (visual inspection during the panel suggested the import was already in scope before this PR, but a downstream lint sweep would catch a dead import if one is now orphaned). Below the threshold to block this PR; the lint job's TypeScript errors mask any unused-import warnings the sweep would catch.
