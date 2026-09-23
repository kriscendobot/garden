---
ts: 2026-05-20T06:38:08Z
kind: result
role: shepherd
dispatch_id: 58c74b
dispatch_root: /home/kris/dispatches/shepherd--58c74b
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 252
    role: target
refs:
  - entries/2026/05/20/062915Z-result-weaver-b88864.md
  - entries/2026/05/20/063248Z-result-fixer-f818f0.md
---

# Result: shepherd cannot drive CI on PR #252 — blocked at CI dispatch (CONFLICTING)

Step 3 of the maintainer's "rebase, retcon, shepherd, conduct" chain on
PR #252. Blocked at the dispatch level: PR is `mergeable: CONFLICTING`
/ `mergeStateStatus: DIRTY`, so GitHub did not create the synthetic
merge ref and no `pull_request` workflow runs were dispatched for the
current PR head SHA. Per `roles/shepherd/AGENT.md` § "Conflicting PRs
block CI dispatch", this is a weaver task, not a shepherd one.

## State at start of dispatch

- PR head: `c7c590ff774bb2f4ce92016e51654a3db876bed0` (fixer ea45b1's
  post-retcon SHA, confirmed via `gh api .../pulls/252` and
  `git ls-remote origin design/...`).
- Parent of `c7c590ff7`: `ddbc8ad7e` (the merge-base used by the
  weaver b88864's rebase, which was correct *at that time*).
- Current `origin/llm`: `5a63ea22f` (advanced by 4 commits since
  `ddbc8ad7e`).
- Diagnosis (`gh api .../pulls/252 --jq '{mergeable, mergeable_state}'`):
  `{"mergeable":false,"mergeable_state":"dirty"}`.
- Workflow runs for `c7c590ff7`: **zero**
  (`gh api '.../actions/runs?head_sha=c7c590ff7...' --jq '.workflow_runs|length'`
  returns `0`). `gh pr checks 252` reports "no checks reported".
- `git merge-tree --merge-base=ddbc8ad7e origin/llm c7c590ff7`
  identifies content conflicts in **two files**:
  - `designs/README.md`
  - `designs/ocapn-noise-network.md`

## Root cause: retcon undid the weaver's base bump

The weaver b88864 (06:29Z) rebased the PR onto `origin/llm` then at
`c8f43c581 → 7406a7e77`, resolving 4 README/cross-link conflicts. The
fixer ea45b1 (06:32Z) then retconned 22 commits down to a single
commit `c7c590ff7`, and the natural retcon shape ("reset to
merge-base, replay the net diff as one commit") set the new commit's
parent back to `ddbc8ad7e` — the merge-base used **at weaver time** —
not to the post-rebase `origin/llm` tip. Because `origin/llm` has
since advanced past `ddbc8ad7e` with new commits touching
`designs/README.md` and `designs/ocapn-noise-network.md`, the PR
re-presents as DIRTY.

This is not a fixer bug per se — the retcon's invariance check (net
diff vs prior head) passed, and the previous tip `7406a7e77` *was* on
top of an even older `origin/llm` than current. The issue is that
"retcon to merge-base" is base-frozen; when the base moves between
the rebase and the retcon, the retcon needs a fresh weaver pass to
re-base onto the now-current upstream.

## Action: not pushing — escalating

Per `roles/shepherd/AGENT.md` § "Conflicting PRs block CI dispatch":
"This is a weaver task, not a shepherd one; hand off and stop pushing
nudge commits." A shepherd dispatch whose only available action is
"wait for CI" when no CI is or will be dispatched maps to the role's
"Watch-only dispatches are wrong dispatches" anti-pattern.

A `message` entry addressed to `liaison`, `steward`, and
`general-contractor` accompanies this result (see
`063808Z-message-shepherd-4fcff8.md`) requesting a fresh weaver
dispatch to re-rebase `c7c590ff7` onto current `origin/llm`
(`5a63ea22f`). The conflicts are deterministic (the same 2 README /
cross-link regions the weaver b88864 already resolved earlier today)
and a fresh weaver run will need to redo the same resolutions on the
single retcon'd commit.

Recommended sequence:
1. **weaver**: rebase `c7c590ff7` onto `origin/llm` (5a63ea22f),
   force-with-lease push. Conflicts will be in the same 2 files the
   prior weaver b88864 resolved (resolutions in that result entry).
2. **shepherd**: re-enter once `mergeable_state == "clean"` and CI
   begins dispatching on the new head SHA. Stays through CI green.
3. **conductor**: original chain step 4.

## Worktree state

Local detached HEAD remains at `b497f6903` (the pre-retcon 22-commit
history that was already force-replaced by the fixer; do not push it).
Remote `origin/design/ocapn-noise-session-reconnect` is at
`c7c590ff7`. No local commits were made. No remote pushes were made.
No PR comments were posted (the shepherd's "post green-run URL"
authorization was not in scope and the situation never produced a
green CI run to post about).

## Self-improvement

The `skills/retcon/SKILL.md` procedure should call out that when a
retcon follows a weaver in the "rebase, retcon, shepherd" chain, the
retcon's reset-to-merge-base step needs the **current** merge-base
with `origin/<base>`, not the merge-base captured at weaver time. If
the upstream advanced between the weaver finishing and the fixer
starting (which happens routinely on busy bases like `endojs`'s
`llm`), the retcon needs to be against the new merge-base to avoid
re-introducing DIRTY state. Lesson routed to `liaison` via the
message entry below.

Self-improvement: routed via `063808Z-message-shepherd-4fcff8.md`
(retcon-after-weaver merge-base freshness lesson for `skills/retcon`).
