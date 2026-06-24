---
ts: 2026-05-22T23:51:00Z
kind: result
role: solicitor
worktree: dispatches/solicitor--07b99e/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/234200Z-dispatch-general-contractor-07b99e.md
---

Design-panel round 1 verdict on PR #358 (`design(daemon): importLocation from EndoMount with npm-registry-proxy + Go-like MVS`).

**Panel kind**: design-panel (seven seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).

**Panel execution**: in-band-fallback. `ToolSearch` returned no match for "Agent / task / subagent / dispatch"; per `skills/panel-review/SKILL.md` § In-band fallback the seven seat blocks were written one at a time against `garden/roles/jurors/<seat>/AGENT.md`, with the aggregation running after all seven blocks landed.

**panel-hints**: `bash garden/skills/panel-hints/panel-hints.sh --base llm` reported `code-panel` (path-triggered fan-out picked up many non-PR paths because the PR's base branch `llm` is far behind HEAD). The PR's actual diff (`git diff HEAD~1..HEAD`) is `designs/README.md` + `designs/daemon-worker-import-from-mount.md` only. Solicitor overrode to `design-panel` per `roles/judge/AGENT.md` § Panel-kind discrimination (paths all under `designs/`, no source/test touched).

**Disposition counts**: 2 must-fix-loop, 21 summary-fix, 5 follow-up, 7 acknowledge, 0 drop. Verdict: **does not terminate**.

**Formal review**: `gh pr review 358 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-358.md`. The submission fell back from `--request-changes` to `--comment` per the documented self-authored-PR pitfall (the PR's author is `kriscendobot`, also the bot identity); the verdict is preserved in the body's "Must-fix-loop" heading. The orchestrator's dispatch matrix keys off that heading for bot-authored PRs.

**Must-fix-loop summary (drives the next fixer dispatch)**:
1. § *ReadPowers synthesis: makeMountReadPowers* — the `packagesByName` map is keyed by `${name}@${version}` but the `endo-mount:/node_modules/<name>/...` URL carries only the bare name, and `resolvePackageRef(packagesByName, name)` is invoked but never defined. The sketch contradicts itself on the multi-major coexistence path the `RegistryResolution` type explicitly allows. Either show how the version is signaled through the URL or define `resolvePackageRef`.
2. § *Phased Implementation* Phase 5 — add a test for multi-major coexistence (`pkg@^1` direct + transitive `pkg@^2`; `RegistryResolution.packages[]` carries both; `importLocation` resolves each importer to its own major). The novel-behavior catalog gap.

**Post-loop actions (held until terminating round per `roles/solicitor/AGENT.md`)**:
- Followup ledger: appended this round at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--358.md` (status: parked, 5 items: workspace-protocol resolution, Yarn PnP loader support, Rust-side resolver callback boundary, Summary skimmability, `make<X>`/`makeFrom<X>` family rename pass).
- Summary-fix job: held; will post one bundle (21 items) on the terminating round.
- Gardener message: held; the round has 6 [proposed-rule] tags to inline (code-sketch helper signature; sharing-shape naming; URL-scheme nature-mirroring; design-summary glossing; interface interaction-model preamble; phase-heading deviation signaling).
- `gh pr ready 358`: held.

**Next**: orchestrator dispatches fixer with the two must-fix-loop items inline; on fixer return, re-dispatch the solicitor for round 2.

**Cross-link backfill**: not applicable (no upstream mirror yet; this is a fork-side design PR).

Self-improvement: panel-hints' diff-against-base heuristic produced a false `code-panel` discrimination because the PR's base branch (`llm`) is many commits behind HEAD; the PR's true diff (one commit) is design-only. A one-line message to the gardener noting that `panel-hints.sh` should prefer `git diff <merge-base>..HEAD` (or `gh pr view --json files` from the GitHub side) over `git diff <base>..HEAD` when the base branch is far behind, so the panel-kind discrimination tracks the PR's own diff rather than the branch divergence. Threshold per `skills/self-improvement/SKILL.md`: load-bearing (the wrong panel would have run the 26-seat code panel against a 2-file design PR), so this routes to a `message` entry to the gardener in a follow-up dispatch.
