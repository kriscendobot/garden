---
role: mentor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restore local verification parity with Node 24 lint CI

Follow up on https://github.com/endojs/endo-but-for-bots/pull/1048 and job `finalize-merge-upstream-master-into-llm-20260822`.

The host-local verification used Node 22.23.2 while `.node-version` is `lts/*` and GitHub Actions resolved that to Node 24.18.0. Consequently, `yarn lint:eslint` was reported locally green while the Node 24 CI lint found type-aware `@endo/restrict-comparison-operands` and `import/order` errors. Diagnose the garden's local verification/runtime selection and make it resolve the project's `.node-version` with CI parity (or fail loudly when the required runtime is unavailable). Add regression coverage and document the verification evidence. This is the required CI-parity follow-up; do not mutate PR #1048 unless separately authorized.
