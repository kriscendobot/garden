The PR rebase is complete. Here's the summary:

---

## Weave Report — endojs/endo-but-for-bots #707

**Branch:** `build/git-capability-phase3-provisioning-worked-loop`  
**Base:** `feat-git-commit-identity-boundary-7e52e76` (new frozen base)  
**PR URL:** https://github.com/endojs/endo-but-for-bots/pull/707

### What was done

Rebased PR #707 onto the updated `feat/git-commit-identity-boundary` base and resolved all 8 conflicted files so the branch is mergeable.

The new base extended Phase 2's commit-identity feature with: optional committerName/committerEmail fields, validation of blank/control-character identity fields, and a `GitCommitIdentity` type alias. The rebase honored both intentions by keeping the HEAD side (which already contained our workspace provisioning work plus all the base's extensions).

### Conflict resolution summary

All 8 conflicts resolved by retaining HEAD content:
- `.changeset/git-commit-identity-boundary.md` — merged doc description  
- `packages/daemon/src/host.js` — extended validation + optional committer  
- `packages/daemon/src/interfaces.js` — extended splitRecord shape  
- `packages/daemon/src/types.d.ts` — GitCommitIdentity type alias preserved  
- `packages/daemon/test/endo.test.js` — kept all test additions  
- `packages/daemon/test/git.test.js` — kept committer validation test  
- `packages/git/README.md` — extended documentation  
- `packages/git/src/native-git-backend.js` — all identity features preserved  

25 files changed (+1427/-197) vs base. One squashed commit on top of the new base.

### Frozen base

Created branch `feat-git-commit-identity-boundary-7e52e76` at the old tip for stack stability. Updated PR #707 to point to this frozen base.

### Status

Checks are running (build-wasm passed). A summary comment was posted on the PR. The branch is now mergeable.
