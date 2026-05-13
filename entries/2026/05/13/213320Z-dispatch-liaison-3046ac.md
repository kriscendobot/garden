---
ts: 2026-05-13T21:33:20Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
refs:
  - entries/2026/05/13/212419Z-result-builder-c4fa1a.md
prs:
  - repo: kriscendobot/xsnap-pub
    pr: 1
    role: related
---

# Dispatch: builder pins agoric-sdk's xsnap submodule at kriscendobot/xsnap-pub mirror branch

Dispatch root: `dispatches/builder--xsnap-pin-agoric-sdk--20260513-213320--3046ac/`. Sister to the xsnap-endo integration dispatch; same source mirror PR (`kriscendobot/xsnap-pub#1`, head `388c356c44969f78ca2f6fc6fa64dcbbceabed68`).

Task: propose a PR against our fork of agoric-sdk that bumps the xsnap submodule pin (or equivalent integration shape) to `388c356`.

Procedure:

1. Check kriscendobot's permissions on `Agoric/agoric-sdk` (note: canonical case is `Agoric`, not `agoric`): `gh api repos/Agoric/agoric-sdk --jq .permissions`. If `push: true`, work there. Otherwise fork and push to `kriscendobot/agoric-sdk`.
2. Inspect the project worktree (detached at master) for xsnap relationship: `git -C project submodule status`, `cat project/.gitmodules`, `find project -name 'xsnap*' -maxdepth 3`. agoric-sdk's xsnap usage may be different from endo's (it may carry xsnap as a vendored package or as a dependency).
3. Bump the pin (or equivalent integration) to `388c356`.
4. Identity kriscendobot. Open in **draft**. Topic branch: `integrate/xsnap-pub-pr-50`. Title: `chore(xsnap): pin xsnap submodule at agoric-labs/xsnap-pub#50 mirror for evaluation`. Body cites `kriscendobot/xsnap-pub#1` and `agoric-labs/xsnap-pub#50` plainly (these are in scope).

Out of scope: shepherd CI watching; modifying xsnap-pub; touching endo (sister dispatch).

Report: PR URL, integration shape, file stats, "exercises xsnap#50 against agoric-sdk's usage" verdict.
