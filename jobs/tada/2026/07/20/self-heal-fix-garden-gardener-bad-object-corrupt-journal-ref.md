Implemented and pushed `fbba4983bb` to `main2`.

- Added in-place corrupt-clone repair: removes stale `gc.log`, prunes zero-byte `origin` tracking refs, then re-fetches before falling back to atomic re-clone.
- Added/updated corruption regression coverage.
- Verified with `fetch-timeout-test.sh`: 15 passed, 0 failed.
- Repaired live gardener 11 journal clone and confirmed `origin/journal2` fetches successfully.
