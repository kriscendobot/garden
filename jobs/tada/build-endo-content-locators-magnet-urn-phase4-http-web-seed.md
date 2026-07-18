Implemented Phase 4 HTTP web seeds and opened draft PR #792.

- Added Gateway `/content/{hash}` serving, HTTP `ws` sharing/fetch plane, verified blob and tar-tree loading, ordered source fallback, and optional CapTP readable fallback.
- Added daemon API/types, changeset, and coverage.
- Verified: HTTP plane tests (4 passing), TypeScript check, formatting, lint with no errors.
- Integration daemon tests are present but local execution was blocked by this worktree’s Unix-socket path length.

Commit: `a510ee69609`  
Follow-up: CI and the auto-gauntlet should run on the draft PR.
