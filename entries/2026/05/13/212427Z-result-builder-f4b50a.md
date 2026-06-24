---
ts: 2026-05-13T21:24:27Z
kind: result
role: builder
project: endo-but-for-bots
prs:
  - repo: endojs/endo
    pr: 1967
    role: source
refs:
  - entries/2026/05/13/211936Z-dispatch-liaison-c57714.md
---

# Result: builder — mirror endojs/endo#1967 (CONFLICT, no PR opened)

Verdict: **conflict at packages/compartment-mapper/test/scaffold.js, packages/compartment-mapper/test/test-policy.js, packages/compartment-mapper/test/snapshots/test-policy.js.snap.** No PR opened. No branch pushed. Next stage is **weaver**, not shepherd.

## Source PR

- `endojs/endo#1967` — "test(compartment-mapper): check for resistance to bundled dependency name collision" by naugtur.
- Base: `endojs/endo@master`. Head: `naugtur/test-policy-identifier-bypass` at `5e009ad51e8bdad95ec83547a2c08e85fdd97ead`.
- Merge-base against endo `master`: `1ff3c4b45a4f9f6bf723d3200548db37df46989f`. Single commit, 9 changed files.

## Procedure run

1. Added `endo-upstream` remote in `project/` (https://github.com/endojs/endo.git) and fetched `pull/1967/head:endo-pr-1967` plus `endo-upstream/master`.
2. Computed diff `<merge-base>..endo-pr-1967` and saved to `/tmp/endo-1967.patch`.
3. Created branch `mirror/endo-1967` off endo-but-for-bots' local `master` (commit `c2fc02eb8`).
4. `git apply --index --check /tmp/endo-1967.patch` failed.
5. Per dispatch instructions, did **not** speculatively resolve. Branch deleted; tree clean.

## Diff summary

The PR adds a regression test against a "bundled dependency name collision" attack: a fixture tree (`fixtures-policy/node_modules/eve/...` and `node_modules/app/attack-name.js`) where `eve` bundles a nested `alice` whose name collides with a sibling under app. The PR adds a new ava test case (`test-policy.js`), updates the matching snapshot, and extends `scaffold.js` with a small hook so the new test's archive emission is exercised.

Files (from PR):

- New (would apply cleanly): `fixtures-policy/node_modules/app/attack-name.js`, `fixtures-policy/node_modules/eve/{getalice.js,index.js,package.json}`, `fixtures-policy/node_modules/eve/node_modules/alice/{index.js,package.json}`.
- Modified, conflict: `test/scaffold.js` (PR patches around line 291; the fork's `scaffold.js` has diverged enough that the context block fails to match).
- Modified, missing in fork: `test/snapshots/test-policy.js.snap` (does not exist in index).
- New, missing rename target in fork: `test/test-policy.js` (does not exist in index).

## Why this is a structural conflict, not a hand-fixable one

The endo-but-for-bots fork has migrated test naming from `test-<feature>.js` plus `snapshots/test-<feature>.js.snap` to `<feature>.test.js` plus `snapshots/<feature>.test.js.{md,snap}`. Concretely, the upstream PR's `test-policy.js` corresponds to the fork's `policy.test.js`, and the snapshot file is named differently and emitted in a different format (`.md` + `.snap` rather than a single `.snap`). `scaffold.js` has also drifted; the upstream PR's context at line 291 does not match the fork's text.

This is a real divergence (renames + content drift + snapshot-format change), exactly the kind of work weaver is for. The conflict is not "two patches touched adjacent lines"; it is "the file the patch creates already exists under a different name with different conventions."

## Artifacts

- Branch pushed: **none**.
- PR opened: **none**.
- Patch saved at `/tmp/endo-1967.patch` (will be torn down with the dispatch); the merge-base SHA above is the durable handle for weaver to regenerate it.

## Self-improvement

Self-improvement: the dispatch brief's "if apply fails, stop" rule worked exactly as designed: I caught the rename/snapshot-format divergence in a single dry-run and surfaced the three conflict files cleanly, without burning effort trying to hand-fix a structural mismatch. One small ergonomic friction is worth a note for the next builder doing a cross-fork mirror: the dispatch said "branch off `origin/master`" but the per-dispatch project worktree has no remote-tracking `origin/master` ref (only a local `master` at the fork tip). Branch off the local `master` instead, or off the explicit commit SHA. Nothing to change in `roles/builder/AGENT.md`; this is a small note for the dispatch-prompt author. Self-improvement: nothing role-level this time.
