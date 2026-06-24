---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 332
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 2901
created_at: 2026-05-21T05:59:00Z
last_appended_at: 2026-05-21T05:59:00Z
status: actioned
actioned_at: 2026-06-06T03:54:04Z
merge_event: 2026-05-22T00:56:48Z
actioned_via: jobs/open/20260606T035404Z--3f5455--endo-but-for-bots-332-bundle-lite-coverage.md
---

# Follow-ups for endojs/endo-but-for-bots#332

Created from the code-panel verdict (23 seats, in-band fallback) on the "refactor: Embrace default chaining" mirror PR. The PR is a 3-file +29/-31 operator-sweep refactor in `@endo/captp` and `@endo/compartment-mapper`. One follow-up warrants revisit at merge time.

## Items

- [ ] **bundle-lite.js test-coverage parity gap.**
  **Source juror(s)**: prover, follow-up rationale endorsed by the cleaner's prior coverage assessment.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR that imports `packages/compartment-mapper/src/bundle-lite.js` (and/or its `functor-lite.js` and `script-lite.js` shims) from a `packages/compartment-mapper/test/` fixture, exercising at minimum the alias-resolution branch in `makeFunctorFromMap` so the `-lite` surface gains the same regression-pinning protection that `bundle.js` enjoys via the existing test suite. This is a pre-existing structural gap (zero direct coverage on `bundle-lite.js` predates the default-chaining refactor) and was correctly out of scope for the operator-sweep PR. Actioning trigger: this PR merges, or its upstream mirror endojs/endo#2901 merges.
