---
ts: 2026-05-13T21:33:20Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/212427Z-result-builder-f4b50a.md
prs:
  - repo: endojs/endo
    pr: 1967
    role: source
---

# Dispatch: weaver rebases endo#1967 mirror onto endo-but-for-bots master

Dispatch root: `dispatches/weaver--endo-1967-rebase--20260513-213318--4c7051/`. Second stage of the endo#1967 chain. The builder reported a clean conflict at `entries/2026/05/13/212427Z-result-builder-f4b50a.md`:

- `packages/compartment-mapper/test/scaffold.js` — patch context near line 291 fails to match fork's drift.
- `packages/compartment-mapper/test/test-policy.js` — does not exist; fork renamed to `policy.test.js`.
- `packages/compartment-mapper/test/snapshots/test-policy.js.snap` — does not exist; fork migrated snapshot scheme to `<feature>.test.js.{md,snap}`.

Six fixture files (the new `eve`/`alice` nested packages) apply cleanly.

The merge-base SHA is `1ff3c4b45a4f9f6bf723d3200548db37df46989f` (endo's master at the time of #1967's authoring); the head SHA is `5e009ad51e8bdad95ec83547a2c08e85fdd97ead`.

Task: rebase #1967's intent onto endo-but-for-bots master, handling the three drifted files. Specifically:

1. Apply the 6 clean fixture files via `git apply --index`.
2. For `scaffold.js`: open both versions (the source's `scaffold.js` at SHA `5e009ad5` and the fork's current); apply the substance of the upstream patch onto the fork's drifted body manually (a targeted edit, not a context-matched apply).
3. For `test-policy.js` → `policy.test.js`: apply the upstream test additions into the renamed fork file using the project's `<feature>.test.js` naming convention.
4. For the snapshot file: translate to the fork's `<feature>.test.js.{md,snap}` scheme. The upstream `.snap` content needs to be expressed in the fork's snapshot format. If you cannot translate it cleanly (e.g., the format requires running ava to regenerate), open the PR without the snapshot file and note in the body that the snapshot must be regenerated locally.

Use the project worktree (detached at endo-but-for-bots master). The endo-upstream remote is not yet present; add it: `git -C project remote add endo-upstream https://github.com/endojs/endo.git && git -C project fetch endo-upstream` to get the source SHAs.

Identity kriscendobot. Per pr-creation-flow: open in **draft**. Title: `mirror: endojs/endo#1967 (rebased; <original-title>)`. Body cites the source PR plus a "weaver rebased onto endo-but-for-bots master because of renamed test-policy → policy.test.js plus snapshot scheme migration" note. Mentions that a follow-up shepherd dispatch will evaluate CI.

Push topic branch `mirror/endo-1967` (overriding any prior partial push, if relevant) to `endojs/endo-but-for-bots` and open the PR against `master`.

If the rebase reveals further drift you cannot resolve confidently, stop and report a `message` to liaison with the specifics; do not speculatively guess. The maintainer's intent is to evaluate the test; an incomplete or wrong rebase serves the evaluation poorly.

Out of scope: shepherd-style CI watching (separate follow-up); upstream endo edits.

Report: PR URL, mirror branch head SHA, what was done for each of the three drifted files, an honest verdict on whether the test as rebased should still exercise the same regression.
