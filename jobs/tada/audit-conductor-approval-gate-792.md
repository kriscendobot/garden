Confirmed #792 root cause: ready-to-land and final merge paths checked CI/mergeability, but no independent maintainer approval; #792’s restored merge job then squash-merged with zero reviews.

Pushed `a7e082497e` to `main2`:
- Added current maintainer approval gate to upstream conduct posting and final merge spine.
- Rejects absent, dismissed, stale, and non-maintainer approvals.
- Updated conductor and Dependabot botanist norms. No auto-merge exemptions.
- Tests passed: approval unit 5/0, CI merge 29/0, comment watcher, full run-test, shellcheck.

Activation requires the next deliberate leader-supervised deploy of `main2` to each root.
