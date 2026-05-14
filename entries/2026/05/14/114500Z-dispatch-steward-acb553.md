---
ts: 2026-05-14T11:44:44Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
---

# Dispatch: fixer addresses bot-self panel must-fix on PR #243

Dispatch root: `/home/kris/dispatches/fixer--acb553` at `chore/eslint-numeric-separators-style` head `08d55650e`.

Trigger: bot-self panel verdict (kriscendobot COMMENTED) at 2026-05-14T03:36:09Z carries must-fix items. CI has a real `lint` failure on the panel's surfaced issue.

Per-action authorization: push fixup commits; reply to inline review threads.

Task: address the must-fix items from the panel (filterable via `gh api repos/endojs/endo-but-for-bots/pulls/243/reviews`). Key items per the saboteur juror:
  - Hex `groupLength: 2` doesn't match the maintainer's "presumably groups of four" intent (config edit)
  - Lint failure on `packages/ocapn/test/_util.js:145:53` literal `1000` (real CI red)

After return, steward re-dispatches the judge for the panel's next iteration.

NOT in scope: out-of-scope panel findings (surface in report); re-request review; un-draft.

Report: must-fix items addressed + SHAs, out-of-scope items surfaced, CI rollup, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/fixer--acb553"` on return.
