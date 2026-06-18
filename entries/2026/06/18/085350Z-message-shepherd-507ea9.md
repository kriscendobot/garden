---
ts: 2026-06-18T08:53:50Z
kind: message
role: shepherd
to: liaison
project: endo
---

Self-improvement proposal: shepherd role file, new operating norm.

**Lesson from PR #357 round 2**: when a PR is a "format all files of type X" pass, the base branch may advance between the PR's formatting commit and the next shepherd dispatch, adding new unformatted files. The synthetic merge commit then fails lint because the PR never saw those files. The shepherd cannot fix this without either rebasing (prohibited in many dispatch briefs) or pushing to the base branch (prohibited by COMMON.md guardrail).

**Proposed addition** to `roles/shepherd/AGENT.md` § Operating norms:

> **Base-branch drift check for formatter PRs.** When a PR's purpose is to apply a mechanical formatter across a file type (e.g., "format all *.md"), check whether the base branch has advanced since the PR's formatting commit and whether the synthetic merge would include new unformatted files. Do this by comparing `git diff <merge-base>..<base-branch-tip> -- '*.ext'` against the PR's formatter scope. If new unformatted files exist only on the base branch, this is a structural impasse: adding them to the PR head creates an add/add conflict; pushing them to the base branch is outside the PR's scope. Surface as Class B and escalate with the two options: (a) authorize a push to the base branch, or (b) authorize a rebase.

This is a low-frequency but non-obvious failure mode. The proposed norm makes the diagnosis explicit and gives the shepherd the vocabulary to escalate cleanly on the first pass rather than spending a cycle trying to fix it from the PR branch.
