Implemented and pushed `fix: soft-skip triager fetch failures` to `main2`.

- Existing-clone fetch failures now warn, alert with per-slug dedup, and exit 0.
- Updated triager coverage; `scripts/jobs/test/triager-test.sh` passes (97/97).
