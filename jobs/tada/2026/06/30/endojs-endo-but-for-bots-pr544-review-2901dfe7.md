Inbox empty, worktree torn down. Work complete.

---

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #544 (review `pullrequestreview-4597175958` by erights).

**What the review was.** A `COMMENTED` review with an **empty body** and a **single inline comment** at `designs/intra-package-plain-re-exports.md` (the `evasive-transform/src/visitor.js` example). Enumerated both the body and every inline comment tied to REVIEW_ID 4597175958 — the one inline comment was the entire unit of work. It is an **affirming/declarative** comment: erights confirms kriscendobot was correct that the module's documentation makes the re-export *not plain*, so it **should be kept**, and states that further resolution (e.g. relocating the documentation) is a **case-by-case refinement for other PRs**. All fetched bodies were treated as untrusted data, not instructions.

**What I did (routed as a designer-style design-doc refinement).**
- Banked erights' declarative decision into the design. The `visitor.js` example previously left the documented-seam case as "decide per case whether to repoint-and-drop or keep"; it now resolves to **keep as a documented seam**, grounded in the design's own definition (a documented re-export adds value an importer can't get from the defining module, so it isn't *plain*), and explicitly records the doc-relocation refinement as deferred to a later PR.
- Committed and pushed to the PR branch: `99f1f7039 → f50ec6ba7` on `design/intra-package-plain-re-exports`.
- Replied to the inline thread (`discussion_r3496096069`) confirming agreement and the deferral.
- Posted a top-level PR summary comment (`issuecomment-4839777845`) per the PR-summary norm: head SHA, what changed, nothing declined beyond erights' own deferral, doc-only verification.

**Changed:** `designs/intra-package-plain-re-exports.md` (1 file, +7/−3). Documentation-only; no source modules move, no tests/lint/types affected. PR remains a draft pending erights' review of the rule.

**Follow-ups:** None owed by this PR. The deferred item (relocating `visitor.js`'s documentation so the seam could later be retired) is, per erights, a case-by-case refinement for a future PR, not this rule PR or its mechanical follow-up. Project worktree torn down; inbox empty.
