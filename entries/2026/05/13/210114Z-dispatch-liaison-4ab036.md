---
ts: 2026-05-13T21:01:14Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener updates the journalist's bulletin lead-ordering rule

Dispatch root: `dispatches/gardener--journalist-base-branch-order--20260513-210114--4ab036/`.

The maintainer's directive: the review-queue bulletin section should **lead** with PRs whose base is `endojs/endo:master`, then PRs whose base is `endojs/endo-but-for-bots:llm`, then the remaining PRs. Within each of those three outer groups, keep the existing milestone bin + per-repo fallback ordering.

Task: edit `roles/journalist/AGENT.md` to encode this outer grouping rule. The journalist consumes `/tmp/garden-review-queue/current.json`, which carries per-PR data; the base ref is available via the existing `gh search prs --json` field set (and if not, add `baseRefName` to the daemon's query). The rule reads naturally as a section-layout sub-rule under whichever existing operating norm covers the review-queue render. The two named base branches lead the section; everything else falls through to the existing milestone classification.

Out of scope:

- Do NOT re-render the bulletin in this dispatch; the next journalist dispatch will pick up the new rule.
- Do NOT touch other role files.
- Do NOT modify the review-queue daemon's query unless the `baseRefName` field is genuinely missing from `current.json`; check first by reading `/tmp/garden-review-queue/current.json` from outside your detached worktree if helpful (it is host-level state, not in any worktree).
- Do NOT touch the PR-creation-flow rework (sister gardener dispatch handles that).

Report on return: commit SHA on `main`, one-line on whether the daemon already carries `baseRefName` or whether you also had to extend the daemon's query, self-improvement.
