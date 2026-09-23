Implemented and published the hardened URL shim on PR #719 (`9dcdc2412`).

- Added `%URL%` / `%SharedURL%`, universal `URLSearchParams`, hardened iterator sampling, XS degradation, docs, types, and tests.
- Rebased to a clean URL-only diff on current `master`.
- Verified: targeted 21 tests, full SES suite (551 passed), typecheck, ESLint, Prettier, and XS smoke test.
- CI is running; `zizmor` currently fails on inherited action-pin warnings.
