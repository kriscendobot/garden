Implemented and pushed `0c940939e7` to `main2`.

- Moved shared `bounded_fetch` into `common.sh`.
- Triager now uses it for `--all --prune`; failures warn, alert, and exit cleanly.
- Removed clone-keeper’s duplicate helper.

Verified: `triager-test.sh` (98 passed) and `clone-keeper-test.sh` (47 passed).

Self-improvement: nothing this time.
