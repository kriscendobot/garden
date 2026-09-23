---
ts: 2026-05-18T09:18:31Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/shepherd--9d2f88/project
refs:
  - entries/2026/05/18/091616Z-dispatch-shepherd-9d2f88.md
  - entries/2026/05/18/091222Z-result-cleaner-638ea4.md
---

## Outcome

Hard escalation: PR #286 is **CONFLICTING** against base `llm`.
No remediation a shepherd can take.
Hand off to weaver.

## Root cause

`pull_request` workflows run on the synthetic merge ref.
GitHub does not create the merge ref while a PR is in conflict, and therefore dispatches no workflow run on pushes to the PR head.
This is documented in `roles/shepherd/AGENT.md` § *Conflicting PRs block CI dispatch*; PR #286 is the exact symptom: pushes land, `statusCheckRollup: []` indefinitely.

Evidence:

```
$ gh pr view 286 -R endojs/endo-but-for-bots --json mergeable,mergeStateStatus,statusCheckRollup
{"mergeStateStatus":"DIRTY","mergeable":"CONFLICTING","statusCheckRollup":[]}

$ gh api 'repos/endojs/endo-but-for-bots/actions/runs?head_sha=0359d1accb87299f5049a24e2f675b948ecad222' --jq .total_count
0

$ gh api 'repos/endojs/endo-but-for-bots/actions/runs?branch=feat/cli-http-client-mk-phase-1' --jq .total_count
0
```

Contrast with PR #284 (kriscendobot, draft, base `llm`, same author/posture):

```
$ gh pr view 284 -R endojs/endo-but-for-bots --json mergeable,mergeStateStatus
{"mergeStateStatus":"CLEAN","mergeable":"MERGEABLE"}
```

#284 enqueues CI normally because its merge ref builds.
The difference is the merge state, not the author, not the draft flag, not a workflow-approval gate, not a first-time-contributor gate.

Conflicting files (from `git merge-tree HEAD origin/llm` in the dispatch project worktree):

- `designs/README.md` (content conflict)
- `packages/daemon/src/daemon.js` (auto-merging; clean)
- `packages/daemon/src/host.js` (auto-merging; clean)
- `packages/daemon/src/interfaces.js` (auto-merging; clean)
- `packages/daemon/src/types.d.ts` (auto-merging; clean)

The only **content** conflict is `designs/README.md`.
The four `packages/daemon/src/*` paths auto-merge cleanly; they appear in the merge-tree output as "Auto-merging" lines, not as conflict records.
So the rebase is small: re-resolve the `designs/README.md` index entry against the current `llm` tip.

## Remediation taken

None on the project side.
The shepherd's *Conflicting PRs block CI dispatch* norm names this explicitly:

> This is a weaver task, not a shepherd one; hand off and stop pushing nudge commits.

Pushing an empty commit, calling `gh workflow run`, or adding a gating label would not help because the GitHub workflow dispatcher does not enqueue a `pull_request` run while the PR is CONFLICTING.
The fix is to rebase the branch over `llm`, resolve `designs/README.md`, force-push, and let CI dispatch on the post-rebase head.

## Final CI status

Unchanged: `statusCheckRollup: []` on head `0359d1ac`.
Cannot be made green from inside a shepherd dispatch.

## Recommendation to the contractor / liaison

Dispatch a **weaver** against PR #286 to rebase over `llm` and resolve the `designs/README.md` conflict.
On the post-rebase force-with-lease, GitHub will dispatch CI; the next shepherd / judge in the chain can resume from there.
The cleaner's commit (`0359d1ac`) and the builder's two earlier commits should remain in the post-rebase history; the only change is the rebase parent + the `designs/README.md` resolution.

Note for the cleaner's prior result entry (`091222Z-result-cleaner-638ea4.md`):
the cleaner suspected a GitHub-side queueing delay or workflow approval gate.
Neither is the cause.
The cleaner's evidence (PRs #149 and #134 having checks) was a useful negative; what completes the diagnosis is querying `mergeable_state` directly.
A future cleaner that observes zero CI runs after its own push should add this one-line query before speculating about approval gates:

```
gh pr view <N> -R <repo> --jq '{mergeable, mergeStateStatus}'
```

Self-improvement: `skills/pre-pr-checklist/SKILL.md` already has a *Pre-PR checklist* section centered on prettier / lint / docs / ava.
A complementary one-liner belongs in `skills/ci-status-summary/SKILL.md` § *Pitfalls* (or possibly a new *Diagnosing zero CI runs* note in `skills/pr-ci-watch/SKILL.md`'s *Notes from the field*) capturing the recipe: "When a PR shows `statusCheckRollup: []` indefinitely after a push, query `mergeable_state` before assuming a GitHub Actions queue delay or workflow-approval gate; `CONFLICTING/DIRTY` blocks `pull_request` workflow dispatch entirely.".
This is a structural lesson, not a one-off, so the row should land via a `message` to the liaison rather than be inlined here.
A separate `message` entry will follow.
