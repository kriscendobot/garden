---
ts: 2026-05-15T04:49:24Z
kind: result
role: judge
project: endo-but-for-bots
worktree: dispatches/judge--933354
prs:
  - repo: endojs/endo-but-for-bots
    pr: 264
    role: target
to: liaison
---

# Result: design-panel review on #264 (compartment-mapper-import-attributes)

PR: endojs/endo-but-for-bots#264, `design(compartment-mapper): import-attributes propagation proposal`, draft, branch `design/compartment-mapper-import-attributes` against `llm`, head `a2f4d7f48`. Stacked on PR #248 (sibling SES import-attributes design).

Panel kind: design-panel (5 seats: critic, skeptic, copyeditor, pedant, novice). File-list discrimination: both changed paths under `designs/` (`designs/compartment-mapper-import-attributes.md`, `designs/README.md`), no source changes; design-panel selected per `roles/judge/AGENT.md` § Panel-kind discrimination.

Panel execution: **in-band-fallback**. The dispatch harness surfaced no `Agent` or `Task` tool (probed via `ToolSearch`, returned no matches). Each seat's per-juror block was written in-band against `garden/roles/<seat>/AGENT.md` one at a time, then aggregated.

## Maintainer-comment scan

Per the dispatch prompt's instruction (lesson from PR #249 / #248):

- `gh api repos/endojs/endo-but-for-bots/pulls/264/comments --paginate` returned `[]` (no inline review comments).
- `gh pr view 264 --json reviews` returned `"reviews": []` (no kriskowal review, empty-body or otherwise).

No kriskowal inline comments to enumerate as must-fix alongside the panel's findings.

## Verdict

`COMMENTED` (self-PR fallback; `gh pr review --request-changes` blocked because the authenticated identity `kriscendobot` is also the PR author). The body carries the explicit "Must-fix before merge" heading so the dispatch matrix keys on it. The review went out via `gh pr review 264 -R endojs/endo-but-for-bots --comment --body-file ...`.

Counts:
- must-fix: 4
- should-fix: 5
- out of scope: 3

## Per-seat findings

- **critic** (`request-changes`): two findings. (a) Today-shape inaccuracy in `## Per-import attribute record` (line 142): claims `FileModuleConfiguration` records a `resolvedImports` map, but the schema at `packages/compartment-mapper/src/types/compartment-map-schema.ts` lines 233 to 239 has no `imports` field. The schema-bump diff at line 402 inherits the drift. (b) `## link.js` does not enumerate the `moduleMapHook` + attribute-bearing-entry interaction.
- **skeptic** (`request-changes`): three findings. (a) Three of four sibling-section anchors are dead (`## Compartment-mapper implications` at line 41, *Source dispatch* at line 263, *Compartment construction* at line 268, *Resolution and resolveHook* at line 491; the sibling's actual sections are `## Source-type multiplex`, `## importHook signature`, `## Memo key extension`, `## Backward compatibility for serialized bundles`). (b) Archive-replay arity-rule premise needs an explicit statement. (c) Test catalog omits the policy-attribute-passthrough assumption from `## Open questions` § 5.
- **copyeditor** (`comment-only`): four findings. Missing `pkg->>mod` arrow in the Mermaid; repetitive "carry rule" paragraph; varying "behavior is preserved" phrasing; tense slip between present and conditional in `## link.js`.
- **pedant** (`request-changes`): four findings. (a) `Status: Draft` is not in `designs/CLAUDE.md` § Status Values' enumerated set (use `Proposed` or extend the convention). (b) `designs/README.md` plan content is incomplete: missing milestone assignment, milestone-table entry, dependency-graph edge to `ses-import-attributes.md`, size/duration estimate, and milestone-totals update per `designs/CLAUDE.md` § Progress Tracking. (c) Inconsistent inner spacing in the partition table. (d) Inconsistent bullet punctuation in `## References`.
- **novice** (`request-changes`): four findings. Mermaid lifelines not introduced before the diagram; `withAttributes` example precedes the function summary in `## infer-exports.js`; "the arity rule from the SES side" cited without a fixed referent; test-catalog items hard to map back to design claims.

## Aggregated must-fix items

1. Accuracy: the `resolvedImports` / `FileModuleConfiguration` today-shape claim. (critic)
2. Sibling-anchor citations to nonexistent sections in PR #248. (skeptic)
3. `Status: Draft` is not a sanctioned value per `designs/CLAUDE.md`. (pedant)
4. `designs/README.md` plan content is incompletely updated (milestone assignment, dependency-graph edge, size estimate, milestone totals all missing). (pedant)

Aggregated should-fix items (5) and out-of-scope items (3) are in the formal review body posted to the PR.

## Un-draft status

**Not un-drafted.** Four in-scope must-fix items present. The judge's loop-termination rule (un-draft only when there are no in-scope must-fix items) applies; `gh pr ready 264` was not invoked. The PR stays draft pending a fixer dispatch.

## Recommended next stage

Fixer dispatch on #264 to address must-fix items 1 through 4 and (recommended) should-fix items 1 through 5. After the fixer reports back, the judge re-dispatches the design panel against the new head; if no must-fix items remain, the judge un-drafts.

## References

- Formal review body: posted to PR #264 via `gh pr review --comment` at 2026-05-15T04:49Z.
- Design under review: `designs/compartment-mapper-import-attributes.md` (587 lines).
- README diff: `designs/README.md` (one summary-table row added; plan content not updated).
- Sibling design: PR #248, branch `design/ses-import-attributes`, head `bc3720dbb`.

Self-improvement: nothing this time.
