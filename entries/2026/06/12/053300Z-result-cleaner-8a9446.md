---
ts: 2026-06-12T05:33:00Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/cleaner--8a9446/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/12/052621Z-result-builder-4ef77c.md
---

Stage 1 of the #438 gamut. Pre-push-gates re-run, hygiene audit, PR body copy-edit. Coverage pass was out of scope (configuration and docs only; no behavior surface to test).

## Pre-push gate state

Re-ran `skills/pre-push-gates/pre-push-gates.sh --no-auto-fix --summary` against `origin/master-4a04d07`. Seven probes pass. `sentence-per-line-md` fires on `AGENTS.md` lines 44, 48, 59. All three are pre-existing prose lines from the base file (lines 18, 22, 33 at base; surfaced because the PR's new tsgo section pushed them down). The probe scans every changed `.md` file body, not just newly-added lines. The PR introduced no new sentence-per-line violations; the builder's note on this point is correct.

Probe summary:

```
filename-no-stutter            pass
no-ascii-banners               pass
no-inline-import-jsdoc         pass
no-non-ascii-in-source         pass
no-pull-citations              pass
security-md-hash-uniform       pass
sentence-per-line-md           fail (pre-existing AGENTS.md lines)
test-package-no-main           pass
```

The pre-existing finding is not the cleaner's to fix; it would warrant a follow-up sweep on AGENTS.md, separate from this PR.

## Hygiene audit (rebase-hygiene)

- behind base: 0
- ahead of base: 7
- merge commits: 0
- conflicts: clean (`MERGEABLE`)
- base: frozen-base-branch `master-4a04d07`

Branch is cleanly stacked. No rebase or weaver dispatch needed.

## CI state at cleaner exit

`lint` failed at builder-push time (the new `typecheck-all` / `typecheck-packages` steps surface the documented tsgo gaps). All other checks green or in progress. `mergeStateStatus: UNSTABLE` reflects only the documented-and-intentional lint failure. The PR is DRAFT and will stay DRAFT through the panel and any follow-up routing decision.

## PR body copy-edit

Applied a light copy-edit to the PR body (no commit churn). The builder's seven commits are untouched.

- Replaced em-dashes in the commit ladder with colons. The garden em-dash-style skill applies to PR bodies as bot-authored prose.
- Replaced Latin shorthand: `vs.` in three places became `compared to`; `e.g.,` became `for example`. Per garden no-latin-shorthand skill.
- Reframed "the dispatch's enumerated open questions" as "the open questions" to keep the body focused on the change rather than the agent flow that produced it.

Pre-edit body line count: 84. Post-edit: same shape, fewer style markers.

## Out of scope (panel's call)

The two material gaps documented in the PR body (tsgo's strict-mode JSDoc cascade; tsgo crashes on the unified compilation) are design departures for the panel to route. Each surfaces three options (root-cause fix; exclusion list; `continue-on-error`). The cleaner does not pick a route.

## Top-level summary posted

Posted to the PR as authorized by the dispatch brief: `https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4687787530`. Ends with `Next stage: barrister panel.`

## Recommendation

Dispatch barrister to run the code panel. The PR is DRAFT, will stay DRAFT, and the panel's primary value here is routing the two material gaps; the standard code-review checklist applies as a secondary lens. The builder's note to the orchestrator on panel-hints emphasis is worth carrying forward.

Self-improvement: nothing this time.
