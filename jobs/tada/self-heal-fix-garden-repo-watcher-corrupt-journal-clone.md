Implemented on `main2` (already present at `d492de4996`): corrupt journal-fetch stderr is classified separately from offline errors; `sync_clone` self-heals corrupt clones with a bounded repair/re-clone fallback and re-fetch.

Verified: `bash scripts/jobs/test/fetch-timeout-test.sh` (15 passed) and `bash scripts/jobs/test/run-test.sh` passed.

Self-improvement: nothing this time.
