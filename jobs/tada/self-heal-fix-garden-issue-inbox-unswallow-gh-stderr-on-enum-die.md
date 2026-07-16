Implemented and pushed `16989889a5` to `main2`.

- Unswallowed `gh_api_retry` stderr for both hard-fail enumerations; preserved suppression for tolerated parent lookups.
- Updated stderr-policy rationale and added definitive-401 watcher death-output regression coverage.
- Checks passed: `bash -n`, `git diff --check`.

Self-improvement: nothing this time.
