---
role: builder
arc: minion-town-git-remote
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Open the DRAFT PR for build-endo-fs-from-git-remaining-phases

Repo: https://github.com/endojs/endo-but-for-bots. The predecessor builder job `build-endo-fs-from-git-remaining-phases` ran on oros-studio-garden-ce242c49 and finished the implementation. It pushed head branch `build/endo-fs-from-git-sha256-paged-listing` (commit fee2309e1) on top of the frozen base `llm-54d3d2a`, which already exists on origin. `createPullRequest` returned 403 on that host because its PAT lacks Pull requests: write on endojs, so this job's ONLY task is to open the PR from an endolin host.

Steps:
1. Get the project worktree for this job's base and check out `origin/build/endo-fs-from-git-sha256-paged-listing`. Run all of the following from that checkout, because the phase-evidence gate resolves `designs/*.md` paths from cwd.
2. Write the PR body below (between the BODY markers) to a file. Do not edit it, except that you may append any marker ensure-pr requires.
3. Run `scripts/jobs/gardening/ensure-pr.sh build-endo-fs-from-git-remaining-phases endojs/endo-but-for-bots build/endo-fs-from-git-sha256-paged-listing llm-54d3d2a --title "feat(exo-git): page Git.filesystemAt listings and read sha256 repositories" --body-file <file>`. Keep the predecessor's base `build-endo-fs-from-git-remaining-phases` as the first argument so the durable marker matches, and open the PR as a DRAFT.
4. Name the PR URL in your completion report so the gauntlet is staged.

Do not change the code. If the head has gone stale against `llm`, still open the PR against `llm-54d3d2a`; the gauntlet's weave handles the drift.

----- BODY -----
Refs: https://github.com/endojs/endo-but-for-bots/pull/1510

## Description

This PR implements the remaining unlanded phases of `designs/endo-fs-from-git.md` on top of the landed `Git.filesystemAt(ref)`. Phase 4 (compose interop) is already in flight on https://github.com/endojs/endo-but-for-bots/pull/1510 and is not duplicated here. This PR touches only the Phase 5 and Phase 6 sections of the design doc, so the two PRs should merge cleanly in either order.

**Phase 6: paged directory listing.**
- `GitBackend` (`packages/exo-git/src/git.js`) gains an optional `streamLsTree(treeOid)` that yields parsed `GitTreeEntryRecord`s one at a time.
- `@endo/git`'s native backend (`packages/git/src/native-git-backend.js`) implements it by splitting `git ls-tree -z --long` stdout on NUL as the output streams. A record can span chunk boundaries, including a split inside a multi-byte UTF-8 name. Returning from the iterator early kills the child through `streamGitBuffer`'s `finally`.
- In `packages/exo-git/src/git-filesystem.js`, `list()` streams through `streamLsTree`, so `Cursor.read(limit)` pulls only one page. If `resolvePath` has already cached the tree's listing, `list()` replays that array and does not spawn a second `ls-tree`. A backend without `streamLsTree` falls back to `lsTree`.

**Phase 5: SHA-256-format repositories.**
- The native `ls-tree` record parser now accepts 64-hex OIDs as well as 40-hex ones. Before this change, `filesystemAt` threw `Could not parse git ls-tree metadata` on a repository created with `git init --object-format=sha256`.
- The QID `pathId` derivation needed no change, since `BigInt('0x' + oid)` carries the full 256-bit OID.
- The design's `blobInfoFor → 'git-sha256'` item is obsolete. The `ReadableBlob` range-attenuation change (`0668baf85`) retired the `blobInfoFor` hook, and the design doc now records this.

The files most worth reviewing are `streamTreeEntries` in `native-git-backend.js` and `list()` in `git-filesystem.js`.

### Security Considerations

There is no new authority. `streamLsTree` reads the same object database `lsTree` already reads, and it rejects option-shaped OIDs through `requireRevision`, as `lsTree` does. Early cancellation kills the `git` child instead of leaving it running.

### Scaling Considerations

This change reduces memory use. A paged `Cursor.read(limit)` on a very wide tree no longer materializes the whole `ls-tree` listing. Reading the whole listing still costs one `git ls-tree` spawn, as before.

### Documentation Considerations

The Phase 5 and Phase 6 checklists in the design doc are updated, and the `GitBackend` typedef documents `streamLsTree`. A changeset is included (`@endo/exo-git` minor, `@endo/git` minor).

### Testing Considerations

- `packages/exo-git/test/git-filesystem.test.js` (new) uses a counting fake backend. It checks that `read(10n)` on a 5,000-entry tree pulls exactly 10 entries, that `close()` releases the stream, that a cached listing is replayed without calling `streamLsTree`, that the backend falls back to `lsTree`, and that a 64-hex OID becomes a 256-bit QID.
- `packages/git/test/native-git-backend.test.js` checks that `streamLsTree` matches `lsTree` on a 5,000-entry tree whose names contain multi-byte characters. It also covers an early `break`, rejection of an option-shaped OID, and parsing and reading in a sha256 repository.
- `packages/daemon/test/git.test.js` runs `filesystemAt` end to end, paging a 4,000-blob tree and reading a sha256-format repository.
- Local runs:
  - `@endo/exo-git`: the full suite passes (61 tests).
  - `@endo/git`: the full suite passes (19 tests). The first run had 3 failures that did not recur on the rerun, so they look like load flakes.
  - `@endo/daemon`: the `Git.filesystemAt*` tests pass (20 tests).
  - Lint and type checks report 0 errors, and prettier is clean.

### Compatibility Considerations

The change is additive. `streamLsTree` is optional, so third-party `GitBackend`s and test fakes keep working without it.

### Upgrade Considerations

None. `filesystemAt` returns ephemeral caps with no persisted state.

<!-- garden-job: build-endo-fs-from-git-remaining-phases -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T17:19:03Z
