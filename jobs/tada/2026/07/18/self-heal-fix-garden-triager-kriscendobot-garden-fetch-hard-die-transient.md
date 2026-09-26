Implemented and pushed `2fc8532937` to `main2`.

- Triager fetch now captures stderr, uses a bounded timeout, and skips transient/terminated failures with exit 0 without advancing the cursor.
- Structural fetch failures still die loudly.
- Extended triager guards for transient, timeout, structural, missing, and corrupt-clone paths.

Verified: `scripts/jobs/test/triager-test.sh` — 90 passed, 0 failed.
