---
ts: 2026-05-15T03:30:49Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--828265/project
refs:
  - entries/2026/05/15/031730Z-result-judge-df5d88.md
---

# Result: fixer on PR #249 (SES TLA design)

PR: endojs/endo-but-for-bots#249 (`design(ses,module-source): top-level-await proposal`).
Base: `llm` (design-only PR; single file under `designs/` plus one README integration).
Head before fixer: `f191dd1ae`. Head after fixer: `4424f3a96`.

## Commits landed

Four follow-up commits, one concern per commit per `skills/review-feedback-followup-commits/SKILL.md`:

- `071f0849` — `docs(designs): apply project conventions to ses-top-level-await (#249)`. Metadata table reformatted to `designs/CLAUDE.md` convention; status Draft -> Proposed; author `designer` -> `Designer (prompted)`; heading-case sweep; `#Lnnn` line anchors; `## Prompt` section appended.
- `9a73e9d3` — `docs(designs,ses): address maintainer inline review on TLA design (#249)`. All eight inline maintainer comments addressed (the dispatch said seven; the actual count from `gh api .../pulls/249/comments` was eight). Heaviest item was the cycle-root question on line 391: `[[CycleRoot]]` field excised from the module-instance contract, Tarjan/SCC paragraph replaced with a one-paragraph note that cycles are not a special case for the bookkeeping, row 10 rewritten to assert the `pendingAsyncDependencies` invariant directly. Other items: resolver-pair injection adopted in the harness, tc39/proposal-compartments cited in module-instance contract, native-Compartment-passthrough open question excised, dynamic-import-of-waiting-module promoted to row 12a, virtual-sources open question closed as deferred, importNow-diagnostic TypeError confirmation recorded with the sync-import-proposals caveat, check-bundle policy gate adopted as the chain-upgrade composition point.
- `919e8611` — `docs(designs,ses): apply panel should-fix items to TLA design (#249)`. Problem-statement prelude paragraph; test-suite glossary above the shape table; Mermaid participant readability pass (spelled-out handles, post-diagram paragraph); class-static-blocks paragraph in the static-analysis section.
- `4424f3a9` — `docs(designs): integrate ses-top-level-await into README plan (#249)`. `designs/README.md`: summary-table row, "See also" preamble line, new "Unscheduled Platform Designs" section (the design is extreme-low priority with no roadmap pull, so a new section was the right place), per-design estimate row, totals update (104 -> 105 designs; 9 -> 10 Proposed).

## Per-action authorization exercised

- Commits + push to `design/ses-top-level-await`: done (four commits, single push, accepted).
- Thread replies on each of the 8 inline comments: posted via `gh api .../pulls/249/comments/<id>/replies --method POST` per `skills/pr-review-thread-replies/SKILL.md`. All eight replies landed with new comment IDs `3245692679`, `3245693322`, `3245693500`, `3245694091`, `3245694333`, plus the three quieter-output ones for lines 378, 384, 391.
- Top-level summary comment: posted via `gh pr comment 249` at `https://github.com/endojs/endo-but-for-bots/pull/249#issuecomment-4456642174`. Body tables every item against the addressing SHA.
- Re-request review: `gh api repos/endojs/endo-but-for-bots/pulls/249/requested_reviewers -f 'reviewers[]=kriskowal' --method POST` returned successfully; `requested_reviewers` now includes kriskowal.

## CI

`gh pr checks 249` reports "no checks reported." This is the expected state for a design-only PR (the bot-fork's CI matrix gates on source/test paths, not on `designs/*.md` edits). The fixer does not need to drive CI to green before re-requesting review; the absence of CI is not a red signal.

## Out-of-scope items from the panel

The four out-of-scope findings (native Compartment passthrough conformance against a moving host-TLA target, explicit assertion of rejection-identity preservation across the async-parent walk as a test row, line-wrap discipline in the Backward compatibility section, pedant's authority-structure meta-note) are not touched. They belong to a separate follow-up PR or a future design revision when their use cases materialize.

## Em-dash sweep

The copyeditor's must-fix list included an em-dash sweep. A grep for `—` / `–` in the file returns no matches; the design uses hyphens in compound modifiers, which are not the em-dash style rule's target. The thread reply on the top-level summary documents this as a no-op rather than silently dropping the must-fix item.

## Next stage owed

Judge re-dispatch. The PR remains in draft. The general-contractor's dispatch brief named the next-stage-owed after fixer return as judge; the four commits are pushed and visible, the inline threads each carry an Addressed-in reply, the top-level summary cites SHAs, and `requested_reviewers` includes kriskowal so a future review dispatch on this same PR has the right hook.

## Self-improvement

The dispatch brief said "7 in-scope must-fix items" naming "the 7 kriskowal inline comments." The actual inline-comment count was 8 (lines 146, 217, 358, 364, 370, 378, 384, 391). The judge's verdict in `entries/2026/05/15/031730Z-result-judge-df5d88.md` also said "the seven inline maintainer comments." The off-by-one originated upstream of the fixer; the fixer recovered by fetching `gh api .../pulls/249/comments` first and using the live count rather than the dispatch's. The lesson: when a dispatch names an item count for a list with an upstream source of truth (inline comments, panel-surfaced rows), the fixer should re-fetch and use the live count as the working set, recording the discrepancy in the result entry. The judge dispatch brief (the prior step in the chain) is the right place to capture the count from the live API and avoid the off-by-one downstream. Routing a one-line `message` to `liaison` about this in `entries/2026/05/15/.../-message-liaison-<id>.md` would be too noisy for a single-instance off-by-one; leaving the note in this result entry is sufficient for any future fixer or judge in the same chain to find via the `grep -rl '^project: endo-but-for-bots'` recipe in `roles/COMMON.md`.

Self-improvement: when a dispatch brief names a count for items sourced from a live API (inline comments, panel findings, etc.), fetch the live count first and use it as the working set; record any discrepancy in the result entry so the next role in the chain sees the live shape. Recorded in this result entry for the dispatch chain that follows.
