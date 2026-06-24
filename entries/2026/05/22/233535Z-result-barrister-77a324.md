---
ts: 2026-05-22T23:35:35Z
kind: result
role: barrister
worktree: dispatches/barrister--77a324/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/232900Z-dispatch-general-contractor-77a324.md
  - entries/2026/05/22/232757Z-result-cleaner-d38b8f.md
---

# Barrister panel result: PR #337 (Endo Gateway scaffolding slice 1)

First code-panel round on `endojs/endo-but-for-bots#337` (feat: Endo Gateway scaffolding slice 1, `@endo/where` host-scope path functions). 16-seat panel via in-band fallback (Agent tool absent).

## Panel composition

`bash garden/skills/panel-hints/panel-hints.sh --base origin/master .` output (verbatim):

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (4): changeset-auditor, curator, fast-checker, surfacer
  changeset-auditor  .changeset/endo-where-gateway-paths.md
  curator  packages/where/index.js
  fast-checker  packages/where/test/where-endo-gateway-cache.test.js
  surfacer  packages/where (2 surface files touched)
Content-triggered (1): engine-realist
  engine-realist  matched: virtual
Cross-panel (0): -
Suppressed (12): benchmarker, breaker, gateway, migrator, pruner, locksmith, purist, spec-keeper, warden, wire-watcher, copyeditor, pedant
Recommended total: 16 of 26 code-panel seats (+ 0 cross-panel).
```

Barrister-side overrides: none. Dispatched the full recommended 16-seat set. `engine-realist` fired on a false-positive regex match (`virtual` in "HTTP-virtual-hosts" prose) and contributes a `drop` finding; the suppression catalog of 12 seats reflects this PR's narrow surface (no SES/exo touch, no migration, no benchmark, no breaker invariants in scope).

## Panel execution

- Panel execution: in-band-fallback (Agent tool not in scope this dispatch).
- Panel kind: code-panel.
- Copilot reviewer add: fired (`gh pr edit 337 --add-reviewer @copilot`).

Each seat composed against `roles/jurors/<seat>/AGENT.md` one block at a time, aggregation deferred until all 16 blocks complete, per `skills/panel-review/SKILL.md` § In-band fallback.

## Verdict

- **Disposition counts**: 0 must-fix-loop, 2 summary-fix, 0 follow-up, 6 acknowledge, 2 drop.
- **Submission verb**: `--comment` (no must-fix-loop items; self-authored PR; non-blocking summary-fix items present).
- **Formal review URL**: `https://github.com/endojs/endo-but-for-bots/pull/337#pullrequestreview` (kriscendobot COMMENTED at 2026-05-22T23:33:44Z).

The PR landed clean from the cleaner's pass; the cleaner already pinned the registrar-composition and PROGRAMDATA-undefined invariants. CI is 18/18 SUCCESS at HEAD `304ee587c`. The barrister's loop terminates on this round.

## Findings summary

The two summary-fix items:

1. PR title scope (`feat(daemon,cli):` should be `feat(where):` since the slice ships entirely in `@endo/where`). One-line `gh pr edit` fix; no commit.
2. Three-way duplication of the `info.home\..\..\ProgramData` Windows fallback in `packages/where/index.js`. Hoist a `whereGatewayProgramData(env, info)` helper alongside the existing `whereHomeWindows`. Net-diff invariant under the 28-test set.

The six acknowledge items capture the panel's reasoning for things that look like findings on first read but are deliberate: peer-precedent test-arity discipline (`@ts-expect-error` with 2 args), Windows-pipe non-composition with `ENDO_GATEWAY_EPHEMERAL_STATE` (matches `whereEndoSock`'s precedent), env-trust posture (consistent with peer functions), absence of PR comments (scribe), and the changeset/surface/curator coherence.

The two drop items: engine-realist false-positive regex match, and fast-checker propertization being overkill on four pure path-builder functions.

## Post-loop actions (terminated round)

- Formal review submitted: `gh pr review 337 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-337/panel.md`.
- Copilot reviewer added.
- Summary-fix job posted: `jobs/open/20260522T233520Z--d830d2--endo-gateway-where-slice-1-337.md` (eligible: steward, general-contractor; both items inlined as actionable briefs).
- Follow-up ledger: not created (no `follow-up` dispositions).
- Gardener proposed-rule message: not written (no `[proposed-rule]` tags survived aggregation).
- `gh pr ready 337`: PR un-drafted at 2026-05-22T23:35Z. `isDraft: false`, `state: OPEN`, `reviewDecision: ""`.

Appellate dispatch (per the 2026-05-21 first-round-termination policy): the orchestrator's choice. The two summary-fix items already drove demotion candidates from acknowledge; the appellate would have very little to appeal here.

## Next stage

PR is post-loop, un-drafted. The orchestrator's next step is the summary-fix consumer (fixer dispatch from a steward or general-contractor claim) followed by whatever review the maintainer wishes. No further panel round expected.

Self-improvement: nothing this time. The in-band-fallback discipline worked cleanly on a 16-seat panel; the suppression catalog (12 of 26 seats deliberately not dispatched) shows panel-hints is doing its job on a narrow additive PR.
