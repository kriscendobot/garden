Review body was empty. Addressed both inline comments:

- `packages/exo-unzip/src/unzip.js:155` — “I agree.”
- `packages/exo-unzip/src/unzip.js:175` — move `blobFromBytes` to `@endo/platform/blob`.

Rebased PR #160 on `llm`, added public `@endo/platform/blob`, migrated unzip to it, added coverage, and pushed `1bf8a6eec0`. Posted both thread replies and a PR summary.

Verified: platform blob test passed; exo-unzip suite passed (30 tests); platform and exo-unzip TypeScript checks passed; Prettier passed. CI remains in progress, so reviewer re-request is pending green CI.
