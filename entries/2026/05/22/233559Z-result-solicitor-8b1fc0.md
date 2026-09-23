---
ts: 2026-05-22T23:35:59Z
kind: result
role: solicitor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/232800Z-dispatch-general-contractor-8b1fc0.md
---

Design panel for PR #322 (design(familiar-flatpak-pipeline): Flatpak packaging proposal, #231 G4) complete on first round.

Panel kind: design-panel (paths: `designs/README.md`, `designs/familiar-flatpak-pipeline.md`; 657 additions over `origin/llm`).
Panel execution: in-band-fallback (no `Agent` tool in scope; per `skills/panel-review/SKILL.md` § In-band fallback, each seat block was written one at a time against its role file's primary surface, then aggregated).

Panel-hints output verbatim:

```
Panel-kind: design-panel
Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice
  designs/README.md
  designs/familiar-flatpak-pipeline.md
Recommended total: 7 of 7 design-panel seats.
```

All seven seats dispatched. No overrides.

Verdict: **request-changes** (three seats: critic, skeptic, pedant). Formal review submitted via `gh pr review 322 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-322.md` (the `--comment` fallback applies per `skills/panel-review/SKILL.md` § Pitfalls because the gh-authenticated identity `kriscendobot` is also the PR's author; `--request-changes` is blocked on self-authored PRs and the verdict is preserved in the body's "Must-fix before merge" heading). Review submitted at 2026-05-22T23:35:49Z.

Disposition counts: 3 must-fix-loop, 8 summary-fix, 5 follow-up, 5 acknowledge, 0 drop.

Top must-fix-loop items:

1. `whereEndoLog` / `whereEndoConfig` cited in the finish-args table do not exist in `packages/where/index.js`; the public surface is `whereEndoState`, `whereEndoCache`, `whereEndoEphemeralState`, plus the socket-path helper. The `--filesystem=xdg-data/endo:create` and `--filesystem=xdg-config/endo:create` lines need re-justification or dropping.
2. Sixteen cross-references to `familiar-release.md` 404 from the base branch (`origin/llm`); `familiar-release.md` lives on the unmerged `design/familiar-release` branch (PR #231). Either rebase after #231 lands or cite by PR number.
3. The PR-body Open Questions are not surfaced in the document; the load-bearing Question 1 (master vs llm base) drives the cross-reference fix. Add a `## Open Questions` section.

Next stage: fixer dispatch with the must-fix-loop items inline. Per `roles/solicitor/AGENT.md`, after the fixer pushes, the orchestrator re-dispatches the solicitor (designer work; fixer edits to a design document are still design content) for the next round. The summary-fix bundle, follow-up ledger append, and proposed-rule message to gardener happen only on the terminating (no must-fix-loop) round.

Proposed-rule tags surfaced (not yet routed; awaiting terminating round):

- design that depends on a sibling design not yet merged to the base branch either rebases after the sibling lands, or cites by PR number;
- a launcher script that hard-codes a path into a generated tree names the generator's output convention it depends on;
- a single-file Flatpak bundle install instruction names the runtime-remote prerequisite explicitly;
- a design whose load-bearing claim is sandbox engagement names the run-time check that confirms the sandbox is actually active;
- a CI graft point that adds a new artifact-producing step names the release-blocking policy for that step's failure;
- design document `##` headings use Title Case consistently within a document and within the `designs/` set;
- a Flatpak manifest does not land capabilities the application does not yet exercise at run time;
- a single-purpose table's cells follow the same sentence-count convention;
- a README install command reads as copy-pasteable from the user's likely cwd;
- a CI step's scope matches the failure-isolation granularity the design's own testing prescribes;
- a design's problem statement introduces every named tool at first use;
- when a pipeline diagram names sub-steps as data-vs-effect splits, the implementing scripts respect the split;
- a design that relocates a directory via sandbox isolation names the cohabitation case for users running both forms on one host.

Operational notes:

- The local `llm` branch in the project worktree was stale; the diff against `llm` returned ~340 files of unrelated history. `git fetch origin llm` followed by `git diff origin/llm...HEAD --stat` returned the actual PR scope (657/1 over 2 files), matching the PR's GitHub-reported size.
- The known race (parent `/home/kris/journal` worktree reset every 30s) did not interfere; the dispatch sub-worktree at `/home/kris/dispatches/solicitor--8b1fc0/journal/` is detached and isolated.

Self-improvement: when the project worktree is in detached HEAD at the PR's tip but the dispatched solicitor needs to diff against the base branch, always start with `git fetch origin <base>` before computing the diff. The stale-local-branch case is not unique to this dispatch; any solicitor/barrister/justice dispatched into a fresh sub-worktree triple should treat the local base ref as untrusted and prefer `origin/<base>` for diff comparison. Marginal lesson; not worth a CLAUDE.md row, but the panel-review skill's "Concurrent dispatch" section could note "fetch the base branch before computing the diff" alongside the worktree-triple description.
