---
ts: 2026-05-14T22:30:46Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
prs:
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: source
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: target
---

# Dispatch: fixer resets kriscendobot/agoric-sdk#1 to current Agoric#12659 + applies kriskowal's catalog.yml feedback

Dispatch root: `dispatches/fixer--43c1f9/`. Project worktree on `kriscendobot/agoric-sdk@feat/migrate-eslint-plugin-import-x` (detached at `638a578f`, the head from our earlier mirror dispatch `0d4cad`).

Maintainer directive (2026-05-14): *"Please dispatch a fixer to reset the mirror for https://github.com/Agoric/agoric-sdk/pull/12659 and respond to feedback in our copy."*

"Our copy" is `kriscendobot/agoric-sdk#1` (the bot-side mirror opened earlier today). "Reset the mirror" means re-pull the current state of upstream `Agoric/agoric-sdk#12659` and re-apply the bot-side changes (the aliasing approach + the stricter-resolver lint fixes). Then apply kriskowal's feedback.

## Feedback to address

[`kriscendobot/agoric-sdk#1`](https://github.com/kriscendobot/agoric-sdk/pull/1) carries one inline review comment from kriskowal at `package.json:36`:

> Does this repository have a catalog.yml?

This is a question / pointer comment. The fixer needs to:

1. Look at the project's `package.json:36` context to understand what's at that line.
2. Check whether the repository has a `catalog.yml` (or `pnpm-workspace.yaml`-style catalog file).
3. If yes, the fix is likely to move the aliasing entry into the catalog rather than the root `package.json`.
4. If no, surface the answer back to the maintainer as a comment on `kriscendobot/agoric-sdk#1` and stop (don't speculate on what the right move is — the maintainer asked a question, the fixer answers it).

## Reset the mirror

Upstream `Agoric/agoric-sdk#12659` may have moved since we mirrored. Re-fetch its current head, replay onto a fresh branch off upstream-master, then re-apply the bot-side commits (aliasing in `package.json` or `catalog.yml`, the lint cleanups, yarn.lock). Force-push to `kriscendobot/agoric-sdk:feat/migrate-eslint-plugin-import-x`.

## Per-action authorization

Per-action push to `kriscendobot/agoric-sdk`. READ-ONLY on `Agoric/agoric-sdk`. **No comment on `Agoric/agoric-sdk#12659`**. Standing comment authorization does NOT apply to agoric-sdk; per-action comment authorization is granted for `kriscendobot/agoric-sdk#1` only (to answer kriskowal's feedback question).

## Task

1. **Fetch upstream current state**. `git fetch https://github.com/Agoric/agoric-sdk.git feat/migrate-eslint-plugin-import-x` from the worktree. Note the new tip and the merge-base with the fork's existing branch.

2. **Inspect kriskowal's feedback**. Read `package.json:36` on the current fork branch. Look for catalog file existence — `catalog.yml`, `pnpm-workspace.yaml`'s catalog block, etc. The agoric monorepo uses Yarn 4 with `package.json#workspaces`; a "catalog" feature may exist as Yarn 4's `packageExtensions` or as a custom file.

3. **If a catalog file exists** and the aliasing belongs there (instead of root `package.json`), move it. The earlier mirror put `eslint-plugin-import: 'npm:eslint-plugin-import-x@4.16.2'` in root package.json's `resolutions` field; if a catalog is the right home, relocate.

4. **If no catalog file exists**, answer kriskowal's question on `kriscendobot/agoric-sdk#1` with the inline-thread reply: "No catalog.yml in this repo; the aliasing is in root `package.json`'s `resolutions` field at line N." Stop there; do not speculate on what should change.

5. **Reset to current upstream** in either case: rebase / replay the local commits onto the latest upstream head; force-push the fork's branch with `--force-with-lease`.

6. **Verify locally**: `pnpm install` (or `yarn`); `pnpm run lint:eslint` (or `yarn lint`). Confirm 0 errors. Note any pre-existing warning count for the report.

## Out of scope

- No upstream PR opened or commented on `Agoric/agoric-sdk#12659`.
- No un-draft of the fork PR (judge un-drafts under the new flow; this is a fixer-loop iteration).
- No reviewer requested.

## Report

≤ 300 words: fork PR head SHA after push, the answer to kriskowal's catalog.yml question, the action taken (catalog-relocate or comment-only), CI status after push, one-line `Self-improvement: ...`.
