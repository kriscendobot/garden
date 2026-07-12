---
role: builder
---

Build the Phase 5 follow-up of `endo-fs-from-git` in `endojs/endo-but-for-bots` (base `llm`): add a backend-supplied QID/hash hook to `@endo/endo-fs`'s `wrapBackend` (e.g. a `synthQidFromOid` / backend-QID option) and wire the daemon's `makeGitFsBackend` (`packages/daemon/src/git-filesystem.js`) to supply the git blob OID as the `Filesystem` view's QID and the `git-sha1` OID as the `BlobRef` hash, restoring content-address identity to `Git.filesystemAt(ref)` (design Goal 2, currently dropped to path-based `synthQid`/`sha256`), with tests proving same-blob QID/hash equivalence across paths and refs.
