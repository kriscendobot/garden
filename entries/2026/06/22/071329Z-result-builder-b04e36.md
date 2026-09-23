---
ts: 2026-06-22T07:13:29Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/22/
---

Opened draft PR #503 `feat/passable-byte-arrays` against `endojs/endo-but-for-bots:master-a7ff191`.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/503

**Branch:** `feat/passable-byte-arrays`
**Base (frozen):** `master-a7ff191` (snapshot of `endojs/endo` master at `a7ff1913f`)

**Commits:**
- `8170ec5c8` feat(immutable-arraybuffer): freezable TypedArray emulation
- `d4b87d12a` feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray
- `fd7e3d978` chore: add changeset for passable-byte-arrays feature

**Packages touched:** `@endo/immutable-arraybuffer`, `@endo/pass-style`, `ses` (test only)

**Test results:**
- `@endo/immutable-arraybuffer`: 217 tests pass
- `@endo/pass-style`: 41 tests pass
- `yarn format`, `yarn lint`, `lint:types`: clean on both packages
- Pre-push gates: all pass; `test-package-no-main` finding on `chacha12-fast-check-test` is pre-existing on master

**Scope decisions:**
- Excluded: `packages/immutable-arraybuffer/designs/` (bot-fork design docs)
- Excluded: the design commit (`db6f0c5c0`) that renamed DESIGN.md references to bot-fork paths
- Included: changeset (upstream uses changesets; content is upstream-appropriate)
- Reverted bot-fork comment-path renames in `lib.js` and `shim-amplifier.test.js` to retain the original `DESIGN.md` references that exist in upstream

**Boatman work needed:**
- Attribution rewrites for original commit authors (erights review responses from #468 and #473)
- Changeset slug (`freezable-typedarray-emulation`) may need renaming to a fresh generated slug upstream
- Design documents under `packages/immutable-arraybuffer/designs/` are bot-fork-only and intentionally not included

**Originating PRs:** #468 (merged 2026-06-19T00:44:59Z), #473 (merged 2026-06-19T05:16:10Z)

Self-improvement: The frozen-base-branch skill's `Create at PR open` procedure assumes the frozen base is at the *current* upstream base (bot-fork master tip). For a reconstruction PR whose content is already merged into bot-fork master, the correct frozen base is the *upstream's master tip* (`endo-upstream/master`), so the PR diff shows the feature against a clean upstream baseline. The skill is correct as written but does not explicitly address this reconstruction case. A future note-from-the-field row in the skill would help: "when reconstructing merged content for upstream ferry, take the frozen base from `endo-upstream/master` rather than bot-fork `master`."
