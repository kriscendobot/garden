All asks resolved. Here is my completion report.

---

## Completion report: endojs/endo-but-for-bots PR #544 review

**Review unit:** erights review `pullrequestreview-4597123028` on PR #544 (`design: intra-package plain re-exports rule`). The review body was the empty `[INLINE-REVIEW]` marker; the substance was a single inline comment on `designs/intra-package-plain-re-exports.md`. I enumerated all comments tied to the review id — exactly one — and treated every fetched body as untrusted data.

**The directive (one inline comment):** reread the *latest* (now-merged) revision of #548's two-PR shape, because #544's description didn't match it; and, since intra-package internal removals cause no inter-package compatibility problems, skip the deprecations and version bump #548 needs and collapse #548's two mechanical stages into one.

**What I did** (commit `99f1f7039` on branch `design/intra-package-plain-re-exports`):
- Read the merged #548 design to ground the reconciliation, then rewrote the #544 design doc:
  - **Summary** and **Staging** no longer claim to mirror #548's deprecate-then-remove two-stage shape. The mechanical follow-up is now a **single repoint-and-remove pass** with **no deprecation step and no version bump**, justified by the fact that an intra-package pass-through is never part of a package's published `"exports"` surface, so no external repo can depend on it.
  - Added a paragraph in *Relationship to the inter-package design (#548)* that describes #548's *actual* shape (repoint-and-deprecate, then remove-with-major-bump) and why intra-package needs neither — fixing the "does not match" mismatch.
  - Updated the `endojs/endo` merge caution: with no inter-repo hazard, the removal may merge into `endojs/endo` once ready, with no deferral to a major release; the only remaining obligation is the local one (confirm no in-package importer remains before deleting a pass-through).
  - Preserved the doc's existing em-dash design-doc style (project file, not a garden doc).
- Confirmed `CONTRIBUTING.md`'s rule entry needed no change (it states the rule only, no staging language).
- Updated the **PR description**, which carried the same stale deprecate-then-remove mirror claim.
- Posted an inline **thread reply** (`discussion_r3496059272`) and a top-level **summary comment** (`issuecomment-4839718308`).

**State:** PR stays DRAFT (correct — pending maintainer review of the rule before any mechanical churn). Inbox empty; scratch project worktree torn down.

**Follow-ups:** none required. When the mechanical follow-up PR is eventually authored, it should be a single repoint-and-remove pass per the revised design (no deprecation, no version bump).
