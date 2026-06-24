---
ts: 2026-05-15T03:17:30Z
kind: result
role: judge
project: endo-but-for-bots
worktree: dispatches/judge--df5d88/project
refs:
  - entries/2026/05/15/031200Z-dispatch-general-contractor-df5d88.md
---

# Result: design-panel verdict on PR #249 (SES top-level-await design)

PR: endojs/endo-but-for-bots#249 (`design(ses,module-source): top-level-await proposal`).
Head: `f191dd1ae`.
Base: `llm` (design PR, design-only).

## Panel kind: design-panel

The PR's file list is exactly one path: `designs/ses-top-level-await.md` (391 additions, 0 deletions). Panel-kind discrimination per `roles/judge/AGENT.md` § Panel-kind discrimination resolves unambiguously to the five-seat design panel (critic, skeptic, copyeditor, pedant, novice). No `@copilot` request (design panel skips it).

## Panel execution: in-band-fallback

`ToolSearch` for `Agent` returned no matches; the harness did not surface a concurrent-dispatch tool. The judge fell back to in-band per `roles/judge/AGENT.md` § In-band fallback: each seat's block was written one at a time against the per-seat role file's primary surface, aggregation ran after all five blocks landed, and one formal `gh pr review` was submitted.

## Per-seat findings (high level)

- **critic**: request-changes. Design's technical shape is sound (synchronous fast path preserved, 262 fields grounded). Concerns: cycle-root necessity (maintainer questioned it on inline line 391); importNow guard cost (per-call DFS, not amortized at link); bundle-source coupling does not name the `check-bundle` path the maintainer raised on line 384.
- **skeptic**: request-changes. The seventeen-row test table is either acceptance criteria or illustrative; the design reads as both. Maintainer's resolver-pair harness shape (line 146) should be adopted or argued against. Open question 2 (`dynamic-import-of-waiting-module`) admits an incomplete row table. Class static blocks not addressed in static analysis.
- **copyeditor**: request-changes. Metadata table format mismatches `designs/CLAUDE.md` convention (`| Field | Value |` rather than `| | |` with bolded field names). Status `Draft` is not a valid project-defined status. Author `designer` does not follow the `Name (prompted)` convention. Em-dashes in prose; Mermaid participant naming hard to follow.
- **pedant**: request-changes. Design not added to `designs/README.md` (summary table, milestone, dependency graph) per `designs/CLAUDE.md` § Progress Tracking § Cross-document. No `## Prompt` section. Heading case inconsistent (`### Test fixtures that do NOT translate`). Inline file references missing `#Lnnn` anchors.
- **novice**: request-changes. Problem-statement structure dense for a first-time reader (recommend a prelude paragraph). Test-suite table cells reference design terms (`__moduleIsAsync__`, `[[AsyncEvaluation]]`) the reader has not seen yet. Mermaid diagram readability after the linker-bookkeeping prose. Open questions duplicate the Scope section.

All five seats converged on request-changes verdicts. No substantive disagreements.

## Verdict

Submitted as `--comment` (authenticated identity `kriscendobot` is also the PR author; `--request-changes` is GraphQL-blocked on self-authored PRs per `skills/panel-review/SKILL.md` § Pitfalls). The body carries the explicit "Must-fix before merge" heading the orchestrator's dispatch matrix keys on for bot-authored PRs.

Review submitted at 2026-05-15T03:15:06Z. URL: `https://github.com/endojs/endo-but-for-bots/pull/249#pullrequestreview-...` (the `gh pr review` call returned no URL; the review is observable via `gh api repos/endojs/endo-but-for-bots/pulls/249/reviews`).

## Counts

- Must-fix: 7 items (metadata table format, README integration, Prompt section, seven inline maintainer comments rolled into one item, em-dash sweep, heading-case sweep, file-line anchors).
- Should-fix: 5 items (Problem-statement prelude, test-suite glossary, dynamic-import-of-waiting-module row promotion, Mermaid participant naming, class static blocks).
- Out-of-scope: 4 items (native Compartment passthrough, rejection-identity test row, line-wrap discipline, pedant's authority-structure note).

## Un-draft status

**PR remains in draft.** Must-fix items present; the judge did not run `gh pr ready 249`. The next-stage-owed reads as fixer-owed once the orchestrator picks up this verdict.

The seven inline maintainer comments from the prior `CHANGES_REQUESTED` review are the largest must-fix surface (cycle-root justification or excision is the heaviest single item). The fixer dispatch brief should cite the inline-comment list verbatim and pair each item with the design-section that needs amendment.

## Self-improvement

Nothing this time. The in-band fallback procedure ran as documented; the panel-kind discrimination resolved cleanly; the placeholder kriskowal CHANGES_REQUESTED was treated per the dispatch's instruction (do not let an empty body bias the panel) while the substantive inline comments were surfaced as must-fix items because they are real maintainer feedback the fixer must address. The one observation worth recording is structural rather than skill-level: the dispatch brief named the kriskowal review as a "placeholder" but did not say the seven inline review comments on that same review carry substance; future judge dispatches against PRs with empty-body placeholder reviews should still inspect the inline comments via `gh api .../pulls/N/comments`. This is captured in the verdict body so a future fixer reads it.
