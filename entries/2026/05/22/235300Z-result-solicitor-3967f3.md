---
ts: 2026-05-22T23:53:00Z
kind: result
role: solicitor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/234800Z-dispatch-general-contractor-3967f3.md
  - entries/2026/05/22/233559Z-result-solicitor-8b1fc0.md
  - entries/2026/05/22/235231Z-message-solicitor-3967f3.md
---

Design panel for PR #322 (design(familiar-flatpak-pipeline): Flatpak packaging proposal, #231 G4) round 2: **terminating**.

Panel kind: design-panel (paths: `designs/README.md`, `designs/familiar-flatpak-pipeline.md`; 781 additions over `origin/llm`).
Panel execution: in-band-fallback (no `Agent` tool in scope).

Panel-hints output verbatim:

```
Panel-kind: design-panel
Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice
  designs/README.md
  designs/familiar-flatpak-pipeline.md
Recommended total: 7 of 7 design-panel seats.
```

All seven seats re-fired. No overrides.

Verdict: **approve** (terminating). Formal review submitted via `gh pr review 322 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-322-r2.md` (the `--comment` fallback applies per `skills/panel-review/SKILL.md` § Pitfalls because the gh-authenticated identity `kriscendobot` is also the PR's author; `--approve` returned `Review Can not approve your own pull request` GraphQL error). Review submitted at 2026-05-22T23:51:47Z.

Disposition counts (round 2): 0 must-fix-loop, 0 summary-fix, 0 follow-up (new), 0 acknowledge (new), 0 drop. All round-1 dispositions stand:

- 3 round-1 must-fix-loop: verified addressed by fixer commit `efe14f625` (entries/2026/05/22/233700Z-dispatch-general-contractor-173961.md).
- 8 round-1 summary-fix: verified addressed by the same commit (the commit message embeds the bundle).
- 5 round-1 follow-ups: parked to ledger at `projects/endo-but-for-bots/followups/endo-but-for-bots--322.md` (created this round; not previously written because round 1 was non-terminating).
- 5 round-1 acknowledges: stand as-is.

Per-finding verification (against the round-2 document at `efe14f625`):

- **finish-args citations**: `whereEndoLog` and `whereEndoConfig` (both non-existent in `packages/where/index.js`) are dropped from the table at lines 173-184; the two `--filesystem=xdg-data/endo:create` and `--filesystem=xdg-config/endo:create` manifest lines also gone. The remaining `--filesystem=xdg-state/endo:create` and `--filesystem=xdg-cache/endo:create` lines cite `whereEndoState` and `whereEndoCache` (both verified in the public surface). Known Gaps TODO at lines 707-715 rewritten to cite the four real `@endo/where` names.
- **cross-references to familiar-release.md**: all 16 in-document call-sites now cite PR [#231](https://github.com/endojs/endo-but-for-bots/pull/231) by number (Source line, prose at lines 23/36/45/76/145/462/612/620/638/701/734, table cells at lines 176/184, heading at 555).
- **Open Questions section**: new `## Open Questions` at line 731 with three questions (base-branch choice; finish-args completeness; Flathub-listing scope). Question 1 carries the load-bearing rationale for the PR-number citation form.
- **Title Case heading sweep**: 26 headings across `##`, `###`, `####` levels all Title Case. The fixer's commit also added two new headings (`### Release-Blocking Policy for Flatpak Build Failure`, `#### Sandbox-Engagement Assertion`) both following the convention.
- **productName naming**: new paragraph at lines 232-238 names the `@electron/packager` `productName` convention the launcher depends on.
- **Flathub remote-add prerequisite**: install snippet at lines 470-481 leads with `flatpak remote-add` plus an explanatory comment; the CI step at lines 410-421 mirrors the same form.
- **Sandbox-engagement assertion**: `#### Sandbox-Engagement Assertion` at lines 533-553 prescribes `pgrep -af 'zypak-helper|bwrap'` with `test -s` and a non-zero exit on the no-process case. Framed as "fails closed; the bundle does not promote to release-eligible".
- **Release-blocking policy**: `### Release-Blocking Policy for Flatpak Build Failure` at lines 582-606 names the policy: the `make` job fails as a whole; no `continue-on-error: true` on Flatpak steps.
- **Existing matcher citation**: paragraph at lines 444-449 cites `familiar-release.yml` lines 132-136 with the matcher pattern.
- **Script-name unification**: mermaid diagram at line 68 and section heading at line 293 both read `flatpak-build.mjs`. Output directory `out/flatpak-build` at line 329 also consistent.
- **Copyeditor fixes**: lines 28-31 (comma splice recast as two sentences), line 176 (multi-sentence table cell collapsed), lines 192-198 (exclusions subsection now contains the previously-loose "explicitly not" sentence), line 242 (hanging "it" antecedent replaced with "The wrapper").

Post-loop actions (per `roles/solicitor/AGENT.md` § Operating norms § Post-loop actions before un-draft):

1. **Disposition-tagged review submitted** (above).
2. **Summary-fix job**: not posted; zero summary-fix dispositions this round (the round-1 bundle is already addressed in `efe14f625`).
3. **Followup ledger appended**: created `projects/endo-but-for-bots/followups/endo-but-for-bots--322.md` with the five round-1 follow-up items (the load-bearing reserved-capability skeptic finding; the two decomplector decomposition findings; the ergonomist CI-step split; the state-cohabitation note).
4. **Gardener message written**: `entries/2026/05/22/235231Z-message-solicitor-3967f3.md` routes the 13 round-1 `[proposed-rule: ...]` tags to the gardener with surface-grouped routing recommendations (design-document conventions, build-script and CI conventions, capability hygiene, table conventions).
5. **`gh pr ready 322`**: pending (will run after this entry commits).

The orchestrator (general-contractor in this dispatch's framing) may dispatch an `appellate` between steps 4 and 5 to appeal small-and-in-context `follow-up` or `acknowledge` items into `summary-fix` before un-draft. The follow-ups in this case are by their nature implementation-PR-time items (capability wiring; script decomposition; CI-step split; documentation grooming); none feel small-and-in-context enough to appeal. The acknowledges are taste-level and out of scope. The solicitor proceeds to step 5 unless the orchestrator interjects.

Operational notes:

- The local `feat/familiar-flatpak-pipeline` branch was at the pre-fixer commit `1aef055b6`; `git fetch origin feat/familiar-flatpak-pipeline` followed by `git checkout efe14f625` brought the worktree to the round-2 document. The lesson from round 1 (fetch the base branch before computing the diff) generalized: any sub-worktree that needs the latest PR-branch tip should refetch before diffing.
- The known race (parent `/home/kris/journal` worktree reset every 30s) did not interfere; the dispatch sub-worktree at `/home/kris/dispatches/solicitor--3967f3/journal/` is detached and isolated.

Self-improvement: nothing this time. The round-1 lesson (fetch base before diffing) generalizes to "fetch the branch you are about to checkout before checking it out" and is captured in the round-1 result entry's Self-improvement line. The round-2 dispatch's worked example is a second data point for the same lesson; no new structural lesson surfaces this round.
