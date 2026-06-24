---
ts: 2026-05-14T20:59:17Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 126
    role: source
---

# Dispatch: builder creates master-base mirror of PR #126

Dispatch root: `/home/kris/dispatches/builder--94d5f5`.

Trigger: kriskowal at endojs/endo-but-for-bots#126 (2026-05-14T20:58:49Z): "Please also create a clone of this change based on master." Same pattern as PR #244 (master-base mirror of #243) and #246 (master-base mirror of #232).

Per-action authorization: create a new branch off master with #126's substantive changes; open a new draft PR targeting master.

Task: per the builder role and `skills/pr-creation-flow/SKILL.md`:
1. Identify #126's substantive commits (the workflow file changes to disable npm lifecycle scripts).
2. Create a new branch off master (suggested name: `ci/no-npm-lifecycle-master` or similar).
3. Cherry-pick / port the changes onto that branch.
4. Open a draft PR targeting master, title formatted per pr-formation skill (suggested: `ci: disable npm lifecycle scripts in workflows (master-base mirror of #126)`).
5. Body follows the GitHub PR template per pr-formation skill.

NOT in scope: address review feedback on the original #126; un-draft the new PR (judge's job after panel runs); back-port to llm (already exists as #126).

Report: new branch name, new PR number, head SHA, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/builder--94d5f5"` on return.
