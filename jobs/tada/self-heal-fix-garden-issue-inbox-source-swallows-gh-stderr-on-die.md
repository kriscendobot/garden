Implemented and pushed `c63e65860b` to `main2`.

- Captured stderr for both issue and comment enumerations, surfacing the final gh diagnostic only on failure.
- Added clean-path and both-enumeration regression coverage.
- Verified syntax plus targeted failure and clean-noise checks.

Follow-up: full `run-test.sh 4 2` exits early at pre-existing Subtest 4 with rc=2, before the new coverage runs.
