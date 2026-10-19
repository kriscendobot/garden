---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the draft PR for finished builder work. Job `build-endo-fs-from-git-phase-four-compose-interop` could not create it on host oros-studio-garden-ce242c49, where the bot PAT gets 403 on createPullRequest for endojs. Do NOT rebuild anything. Both branches are already pushed to endojs/endo-but-for-bots:

- head: `endo-fs-from-git-phase-4-compose-interop`, commit b1b2735f6c (Phase 4 of designs/endo-fs-from-git.md: tests plus docs)
- frozen base: `llm-92b91a7`

Steps: get a project worktree with `ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots endo-fs-from-git-phase-4-compose-interop`, cd into it, and write the body below (everything between the BODY markers) to a file. Then run, with cwd = the project worktree:

    scripts/jobs/gardening/ensure-pr.sh <this-base> endojs/endo-but-for-bots endo-fs-from-git-phase-4-compose-interop llm-92b91a7 --title 'test(daemon): compose Git.filesystemAt with the endo-fs algebra and a daemon Mount' --body-file <file>

The PR opens as a draft. Name the PR number in the completion report so the gauntlet is staged.

----- BODY -----
Refs: #374

## Description

Finishes Phase 4 ("Compose interop and integration") of `designs/endo-fs-from-git.md`. It adds tests showing that the read-only `Filesystem` returned by `Git.filesystemAt(ref)` works with the rest of the `@endo/platform/fs/extended` algebra and with the daemon's own `Mount`:

- **Copy-on-write over history.** `compose(scratchFs, gitFs)` reads through to the git tree. New files and copied-up writes land in the scratch layer. The historical tree stays unchanged, through the same cap and through a fresh `filesystemAt('HEAD')`. `compose(gitFs, gitFs)` is refused.
- **A daemon Mount as the writable layer.** `compose(mountAsFilesystem(scratchMount), gitFs)` writes new files into the Mount's directory on disk. Reading a historical blob does not copy it up.
- **CAS-cached reads.** `withCachedReads(gitFs, cas)` serves the second read of a blob from the CAS. The test proves this by planting a same-length impostor under the blob's SHA-256 key after the first read. A read that went to the git tree would still return the real bytes.
- **Cross-Filesystem rename.** Moving a scratch file into the git tree rejects with `EXDEV` (brand mismatch). Moving a file out of the git tree rejects with `EACCES`, because the read-only boundary refuses before the brand check runs. The design's test plan expected `EXDEV` in that direction; the doc now records what actually happens.

No production code changes. The existing path (`compose`, `withCachedReads`, `mountAsFilesystem`, `wrapBackend`'s brand check) already supports every Phase 4 behavior, so this PR adds tests and docs only.

**Phase and evidence ledger.** Ledger: deliverable

| Phase | State |
|---|---|
| 1. Backend primitives and public shape | landed (#374) |
| 2. Filesystem / Directory / File | landed (#374) |
| 3. OpenFile / Cursor / BlobRef | landed (#374) |
| 4. Compose interop and integration | **this PR** |
| 5. Content-address QID hook | QID hook landed; SHA-256-repo detection deferred by the design |
| 6. Paged directory listing | deferred by the design |

Acceptance observations from the design's "Compose interop" testing plan: `compose(...).root()` works, and cross-FS `rename` throws `EXDEV`. Both are asserted in `packages/daemon/test/git.test.js` under the Phase 4 heading.

**Overlap.**

- `fs-interface-consolidation` (design, In Progress) touches interface guards. This PR adds no guards and edits no `src/`.
- The `daemon-mount` next-phase build is queued but has not started. This PR uses `makeMount` / `mountAsFilesystem` only from tests.
- Related design #807 (reconciling `tree(ref)` and `filesystemAt(ref)`) has no outstanding changes-requested review.

<!-- garden-related-design: 807 -->

### Security Considerations

None. No new authority: the tests compose existing caps, and the git `Filesystem` stays read-only behind the `readOnly` boundary (asserted by the `EACCES` rename case).

### Scaling Considerations

None. Test and documentation changes only.

### Documentation Considerations

- `packages/exo-git/README.md` gains a "Composing `filesystemAt(ref)`" section with the three patterns. Its stale `@endo/endo-fs` references now point at `@endo/platform/fs/extended`.
- In the design, the Phase 4 checklist is marked done and the Updated date is bumped. The Status section now records that the `blobInfoFor` / `'git-sha1'` `BlobRef` hook was superseded by `0668baf85` (ReadableBlob range attenuation). The git `BlobRef` now reports `sha256()` of the raw bytes, which is the key `withCachedReads` uses. The `compose` examples now use the real `(layer, backing)` signature instead of an array.

### Testing Considerations

- `npx ava test/git.test.js --match '*filesystemAt*'` in `packages/daemon`: 23 tests pass, 5 of them new.
- `pre-push-gates.sh`: all probes pass. eslint reports no errors for the touched test file.

### Compatibility Considerations

None. No runtime behavior changes.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
