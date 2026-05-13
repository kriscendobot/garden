---
ts: 2026-05-13T21:33:20Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/13/212419Z-result-builder-c4fa1a.md
prs:
  - repo: kriscendobot/xsnap-pub
    pr: 1
    role: related
---

# Dispatch: builder pins endo's xsnap submodule at kriscendobot/xsnap-pub mirror branch

Dispatch root: `dispatches/builder--xsnap-pin-endo--20260513-213319--9c1ae8/`. Follow-on to the xsnap-pub mirror dispatch that landed `kriscendobot/xsnap-pub#1` (head `388c356c44969f78ca2f6fc6fa64dcbbceabed68` on branch `mirror/pr-50`). The maintainer asked for PRs against our forks of endo and agoric-sdk that integrate the xsnap submodule with that branch and validate CI.

Task: propose a PR against `kriscendobot/endo` (or `endojs/endo` if kriscendobot has direct push — check first) that bumps the xsnap submodule pin to `388c356`. If endo does not actually carry an xsnap submodule, inspect the repo's relationship with xsnap (vendored sources, dependency, etc.) and propose the equivalent integration shape.

Procedure:

1. Check kriscendobot's permissions on `endojs/endo`: `gh api repos/endojs/endo --jq .permissions`. If `push: true`, work directly on `endojs/endo`. Otherwise, fork to `kriscendobot/endo` and push to the fork.
2. Inspect the project worktree (checked out at endo master) for xsnap submodule presence: `git -C project submodule status`, or `cat project/.gitmodules`. If xsnap is a submodule, note the current pin and the submodule path.
3. If xsnap is a submodule:
   - Update the submodule pin to `388c356c44969f78ca2f6fc6fa64dcbbceabed68`.
   - The submodule's origin needs to know the SHA; since it lives on `kriscendobot/xsnap-pub`, the submodule's `.gitmodules` URL may need a temporary point at `kriscendobot/xsnap-pub.git` (vs the agoric-labs upstream) so a clean checkout of endo can resolve the pin. Be careful here: changing the submodule URL upstream is more disruptive than changing the pin. Discuss in the PR body.
4. If xsnap is NOT a submodule (vendored, dependency, etc.), produce the equivalent integration that exercises the mirrored branch's content against endo's existing usage. The PR's purpose is "validate that xsnap-pub#50 plays nicely with endo"; pick the shape that proves or disproves that.
5. Identity kriscendobot. Open in **draft** per pr-creation-flow.
6. Topic branch: `integrate/xsnap-pub-pr-50`. PR title: conventional-commits, e.g. `chore(xsnap): pin xsnap submodule at agoric-labs/xsnap-pub#50 mirror for evaluation`.
7. PR body: cite `kriscendobot/xsnap-pub#1` and `agoric-labs/xsnap-pub#50`. State that the PR is for evaluation only; the maintainer is checking whether the upstream xsnap change is compatible.
8. After opening the PR, do not watch CI in this dispatch; shepherd handles that as a follow-up.

Out of scope: shepherd CI watching; modifying xsnap-pub itself; touching agoric-sdk (separate sister dispatch).

Report: PR URL, the integration shape you picked (submodule pin / vendored update / other), file count + line stats, an honest "this should exercise xsnap#50 against endo's usage" verdict.
