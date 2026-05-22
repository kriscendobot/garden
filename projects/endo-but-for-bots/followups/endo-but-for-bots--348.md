---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 348
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 2902
created_at: 2026-05-22T01:55:00Z
last_appended_at: 2026-05-22T01:55:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#348

Created from the barrister panel verdict (26-seat code panel, in-band fallback) on the bundle-lite dedup mirror PR (mirror of endojs/endo#2902). Two follow-up items warrant revisit at merge time; rest of the panel's findings resolved as acknowledge or drop.

## Items

- [ ] **`packages/compartment-mapper/src/bundle-lite.js:316-325` is the only enumeration of `BundleOptions` against the live `link()` call; a future option addition can silently regress the same way `syncModuleTransforms` did this round.**
  **Source juror(s)**: assessor, integrator, wire-watcher.
  **Round**: 1.
  **Recommended action**: open a follow-up issue or PR on `endojs/endo` (this PR is a mirror of `endojs/endo#2902`) proposing either (a) extracting a `linkOptionsFromBundleOptions` helper whose return shape is type-checked against the `link()` parameter type, or (b) adding a comment block at the destructure naming each option's role and the test that exercises it. Reference the cleaner's `entries/2026/05/22/013900Z-result-cleaner-53a5ce.md` as the case study showing the joinery-point hardening payoff.

- [ ] **`packages/compartment-mapper/src/bundle-lite.js:425-440` alias-vs-no-alias error-message split has no test coverage on either branch (both uncovered pre-PR as well).**
  **Source juror(s)**: prover, breaker.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR on `endojs/endo` once this dedup mirror merges. The alias path is reachable by constructing a compartment-map descriptor whose `aliasCompartmentName` resolves to a non-existent module specifier. A dedicated test fixture exercising the alias-mis-resolution path would convert the defensive throw into checked code and would also catch a future regression that mis-handles the alias-vs-key narrowing.
