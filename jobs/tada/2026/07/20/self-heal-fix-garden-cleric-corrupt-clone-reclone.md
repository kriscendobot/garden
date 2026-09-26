Implemented and pushed `4465b7d45a` to `main2`.

- Canonicalized corruption signatures as `GARDEN_CORRUPT_SIGNATURES`.
- Added the required WARN before atomic recloning.
- Extended corrupt-fetch regression assertions for the warning.

Checks: `bash -n` and `git diff --check` passed. Full harness is blocked before clone tests by its existing identity-drift guard for `GARDEN=testhost`.

Self-improvement: nothing this time.
