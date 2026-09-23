Implemented and pushed `85c51a3ef6` to `main2`.

- Normalizes a last nonblank Kimi marker with two-space indentation or bullet decoration only.
- Added fixtures for two-space, bullet, trailing blanks, embedded, and suffixed markers.
- Passed Mystic harness (29) and completion-signal tests (17).
- Deploy ready. Note: unrelated `gardener-worktree-test.sh` currently fails because its fixture lacks `quota-panel.sh`.
