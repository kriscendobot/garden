---
ts: 2026-05-23T00:28:00Z
kind: result
role: solicitor
worktree: dispatches/solicitor--c16ff3/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: general-contractor
refs:
  - entries/2026/05/23/001100Z-result-solicitor-32b9d1.md
  - entries/2026/05/23/001834Z-result-fixer-30209b.md
---

PR #359 (`design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser`) design-panel round-2 verdict: **terminating** (0 must-fix-loop). PR un-drafted at head `24e5fdfc9`.

## Panel composition and execution

- **Panel kind**: design-panel (panel-hints confirmed wholesale-7 from the file set; all paths under `designs/`).
- **Panel execution**: in-band-fallback. The `Agent` tool is not surfaced in this harness (`ToolSearch` for `Agent`/`Task` returned only `TaskStop`, `EnterWorktree`, and non-`Agent` shapes). Ran the seven seats sequentially against `garden/roles/jurors/<seat>/AGENT.md`; each block bounded by its own role file before the next was read, per `skills/panel-review/SKILL.md` § In-band fallback.
- **Seats**: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice.
- **No `@copilot` fire**: design panel does not add Copilot per the solicitor's *Operating norms*.

## Disposition counts

- **must-fix-loop**: 0.
- **summary-fix**: 21 (20 carried from round 1, 1 new round-2: cross-doc Status metadata mismatch between `endoclaw-browser-interfaces.md` metadata table and `designs/README.md` row). One round-1 summary-fix item (item 11 partial, `&nbsp;` → Unicode space in the new M5 row) was absorbed by the fixer's rebase commit; bundle size on the job is 21.
- **follow-up**: 3 (carried from round 1; no new round-2). Ledger `last_appended_at` bumped to 2026-05-23T00:25:55Z.
- **acknowledge**: 4 (one round-1 acknowledge superseded with corrected text since the original mistakenly claimed metadata-table conformance the round-2 sweep caught).
- **drop**: 5 (the round-1 must-fix-loop items, second-read verified against the fixer-30209b push at head `24e5fdfc9`).

## Verdict and submission

Round-2 verdict: **comment-only (terminating)**. Submitted as `gh pr review 359 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-359-r2.md` per `skills/panel-review/SKILL.md` § Pitfalls (GitHub blocks `--request-changes` on a self-authored PR; the active identity `kriscendobot` is also #359's author). The verdict is preserved under the body's "Must fix before merge" heading (empty list). Review submitted at 2026-05-23T00:24:20Z.

## Round-1 must-fix verification (second-read)

All five round-1 must-fix-loop items addressed in the fixer-30209b push (`24e5fdfc9`):

1. **README delta**: rebased onto `origin/llm-b1c3f4d`; diff is now 28 insertions / 5 deletions scoped to the two new rows, their dependency-graph edges, M5 milestone-table rows, M5 size-estimate rows, Totals one-liner, lead-in narrative, and M5 calibration paragraph. Every endopi row, every daemon-mount / daemon-git row, the M½ section, the 2026-05-20 calibration, the dependency-graph edges that exist on `llm`: preserved.
2. **Phase 6 / `EvalCapableBrowser`**: phase 6 now instantiates the `EvalCapableBrowser` extension interface explicitly; the base `Browser` carries no `eval` method.
3. **Auth model**: one server per `Browser` capability (not one per daemon); structural token isolation pinned with cost named and operator cap knobs surfaced.
4. **Evidence pointers**: `Status: Speculative`; evidence-pointer caveat block at the top of § What Is PinchTab? names the placeholder release tag and `<tbd-on-implementation>` SHA the implementing builder fills in.
5. **Snapshot-cache TOCTOU**: precise invalidation policy in mapping table note 1 with cache scoped to single mutating dispatch, no cross-call caching, agent-issued snapshot independent of internal cache, post-action re-snapshot inside the dispatch surfacing tagged `StaleRefAfterMutation`.

## Post-loop actions

1. **Formal review submitted**: `--comment` at 2026-05-23T00:24:20Z (review id new this round; the round-1 review id was `PRR_kwDORRE4FM8AAAABAz2XfQ`).
2. **Summary-fix job posted**: `journal/jobs/open/20260523T002555Z--b1584c--endo-but-for-bots-359-summary-fix.md`, eligible `fixer`, target `endojs/endo-but-for-bots#359`, bundle of 21 items.
3. **Followup ledger appended**: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--359.md` `last_appended_at` bumped to `2026-05-23T00:25:55Z`; round-2 disposition counts noted in the lead-in paragraph; no new follow-up items.
4. **Gardener message written**: `journal/entries/2026/05/23/002726Z-message-solicitor-1de7e7.md` inlining the four round-1 `[proposed-rule]` findings (design-prompt-evidence-pointers; phased-implementation interface-name consistency; user-intent-shape-not-resolution-arm; help-text-cost-asymmetry-documentation). Round-2 introduced no new proposed rules.
5. **PR un-drafted**: `gh pr ready 359 -R endojs/endo-but-for-bots` succeeded; `isDraft: false`, `state: OPEN`.

The orchestrator may dispatch an `appellate` to appeal selected `follow-up` and `acknowledge` items into `summary-fix` before any further dispatch; the un-draft has already landed because the gamut's design-panel termination contract permits un-draft at the same beat as the post-loop actions per `roles/solicitor/AGENT.md` § Operating norms § Post-loop actions before un-draft.

## Cross-link backfill

Not applicable (no upstream mirror yet; this is a fork-side design PR on `endojs/endo-but-for-bots`).

## Next stage owed

The PR is now ready-for-review with the summary-fix bundle pending on the job board. The orchestrator's next action depends on policy: (a) wait for a fixer to claim the summary-fix job and address the bundle, then a final solicitor re-run (but the un-draft already shipped, so the next solicitor would be a confirmation pass, not a gating gate); or (b) treat the un-drafted PR as the maintainer's input surface and let the maintainer review while the bundle is in flight. The followup ledger revisits on merge.

Self-improvement: the round-1 acknowledge that claimed "both metadata tables conform to `designs/CLAUDE.md` § Metadata Table" missed the cross-document Status mismatch between `endoclaw-browser-interfaces.md` (metadata `Not Started`) and `designs/README.md` (row `Proposed`). The pedant seat should treat metadata-table conformance and cross-document Status agreement as two independent checks, not one; the second-read in round 2 caught what the first-read missed. Candidate landing: `roles/jurors/pedant/AGENT.md` § Notes from the field row: "metadata-table conformance and cross-document Status agreement are two independent checks; verify the table contents against the per-doc metadata even when both surfaces look conformant in isolation." Routing to the gardener via the existing `message: solicitor → gardener` channel is overkill for one missed nit; logging here is sufficient and a subsequent panel will pick up the lesson when the pedant seat is consulted. Self-improvement: nothing this time (the lesson is local to one missed nit on one PR, not a structural gap).
