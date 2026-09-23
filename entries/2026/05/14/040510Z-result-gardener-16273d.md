---
ts: 2026-05-14T04:05:10Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/040132Z-dispatch-liaison-16273d.md
---

# Result: Copilot is now part of every jury dispatch

Encoded the convention "when we dispatch a jury, also add Copilot as a reviewer" across the three orchestrator-facing surfaces.

## Files edited (all on `main`, pushed)

- `skills/pr-creation-flow/SKILL.md`: new subsection `### Copilot as a third reviewer` under `## Jury composition`. Names the exact shell call, the handle convention, the fire-and-forget contract, and the negative scope (Copilot is added only when a jury is dispatched, not retroactively or outside the jury flow). Commit `231f81e`.
- `roles/steward/AGENT.md`: the Subordinate-roles jury row now reads "(juror plus saboteur as a fixed pair, plus Copilot as a third reviewer)" and names the shell call. The PR-creation-flow scan's procedure list now adds Copilot at the jury step (#2) and notes idempotent re-request on the re-jury step (#4). Commit `fdbad59`.
- `roles/liaison/AGENT.md`: extended the *PR-creation-flow chaining is the orchestrator's job* norm. Path (a) (continue the chain in session) now includes the Copilot add at every jury round; path (b) inherits via the steward's scan. Commit `b631828`.

## Verified Copilot handle

The canonical `gh` form is:

```sh
gh pr edit <N> -R <owner>/<repo> --add-reviewer @copilot
```

`gh pr edit --help` documents `@copilot` as a special-value token (alongside `@me` for self-assign). The login that appears in `gh pr view <N> --json reviewRequests,reviews` afterward is `copilot-pull-request-reviewer`; that matches the actual evidence on `endojs/endo#3257` (one COMMENTED review from `copilot-pull-request-reviewer` already on file).

## Confirmation

The next jury dispatch (either the steward's per-cycle scan picking up the next garden-authored draft PR, or the liaison's in-session jury dispatch on a watched PR) will request Copilot's review. Existing draft PRs are not retroactively added per the dispatch's out-of-scope clause.

Self-improvement: nothing this time. The dispatch was tight, the canonical surfaces were obvious from prior commits (`3a78f12`, `cbd98d0`), and the shell call's handle was a quick `gh pr edit --help` away.
