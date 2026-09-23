---
ts: 2026-05-22T22:20:44Z
kind: result
role: appellate
project: endo-but-for-bots
to: general-contractor
refs:
  - entries/2026/05/22/222000Z-dispatch-general-contractor-da46e9.md
  - entries/2026/05/22/221735Z-result-barrister-0417a2.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 318
    role: target
---

# result: appellate da46e9 — appeal review on PR #318 (familiar CI G1)

Audited barrister-0417a2's 2 follow-up and 5 acknowledge dispositions against the small / in-context / loss-track-risk rubric. The two existing summary-fix items (PR-body followup tracking; `tags:`-after-`paths:` yaml reorder) already cover the load-bearing work; my pass yielded one promotion proposal.

## Proposed promotion

- **finding**: "The PR body references `designs/familiar-release.md` but that file does not exist on `feat/familiar-ci-build-pipeline` or `origin/llm`; it lives on `origin/design/familiar-release` and has not landed. Future readers of the merge commit will follow the doc reference into a dead link until the design PR (#231) merges. Recommend either landing #231 before #318 (the natural order) or footnoting the PR body to name the design's branch."
  **judge's disposition**: follow-up
  **appellate's proposal**: summary-fix (extend the existing de587a job's item 1)
  **rationale**: Small (one footnote sentence in the PR body). In-context (the fixer is already editing the PR body for the existing summary-fix item 1, so this adds one line to the same body edit; no new surface). Loss-track risk: moderate (parked-ledger resurfacing is conditional on #231 merging first; absent that, a maintainer reading the merge commit follows a dead doc reference with no automated re-surfacing). The mechanical fix is a one-bullet footnote ("designs/familiar-release.md lives on `origin/design/familiar-release` pending #231"). Combining this with the existing PR-body edit is strictly cheaper than a separate ledger revisit. [rule: `skills/panel-review/SKILL.md` § Follow-up ledger]

## Dispositions left intact

- **follow-up** (download-artifact Node-20 SHA bump): out-of-context. The PR did not touch download-artifact's SHA; bumping it expands the PR's surface beyond G1's gap-reveal purpose. Major-general sweep is the right venue. Deferral stands.
- **acknowledge** (Make-jobs failure): explicitly G1's design purpose; the existing summary-fix item 1 already tracks the gap in the PR body. Deferral stands.
- **acknowledge** (`fail-fast: false`, `concurrency` group, path filters, missing changeset): positive acknowledgments confirming the diff is well-justified. No actionable work. Deferrals stand.

## Recommendation to contractor

Extend the de587a job (still in `jobs/open/`, unclaimed) with a third bullet under item 1: append the design-branch footnote to the same PR-body edit. The followup-ledger entry for the dead-link follow-up should be removed once the fixer lands the footnote (or never written, if the contractor edits the ledger before the fixer claims).

After the amendment lands, **proceed to un-draft** via the contractor's next cycle: 0 must-fix-loop, 0 blocking items remain. The PR is ready for maintainer review once the body edit and yaml reorder land.

Considered 2 follow-up + 5 acknowledge = 7 dispositions; proposed 1 promotion.

Self-improvement: nothing this time.
