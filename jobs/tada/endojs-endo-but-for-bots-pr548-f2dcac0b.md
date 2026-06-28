Worktree torn down. Work complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #548 (review comment by erights).

**Directive (re-fetched, treated as data):** erights flagged that the design doc `designs/inter-package-plain-re-exports.md` had the two-PR staging inverted — it grouped *repointing* with *removal* in the follow-up PR, when repointing is the non-breaking step that belongs in the first PR alongside deprecation. Only removal of now-unreferenced re-exports should be deferred, because removal can break importers outside the repo not yet repointed.

**Routing decision:** well-scoped design-correction (fixer-shaped), commenting standing-authorized on endo-but-for-bots, erights is the named senior authority on endo. Did it directly in an isolated worktree off the PR head branch rather than dispatching further.

**What changed** (commit `a74cf628d`, pushed to `design/inter-package-plain-re-exports`):
- **Staging** section rewritten: PR 1 = repoint + deprecate (no compatibility problems); PR 2 = remove (deferred until repointing complete). Now ordered by compatibility risk, matching erights exactly.
- **Summary** "deprecate-then-remove" wording corrected to "repoint and deprecate first, then remove."
- **Relationship to #544** staging-shape note corrected.
- **Examples** section: split repoint (first PR) from the removal pass.
- **Open questions** (`export *` aggregators): de-coupled the judgment call from "the removal pass."
- `CONTRIBUTING.md` left unchanged — it states the rule only, not the staging.

**Communications posted** (both on PR #548):
- Inline reply on erights's thread: https://github.com/endojs/endo-but-for-bots/pull/548#discussion_r3487469596
- Top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/548#issuecomment-4825142541

**Verification:** documentation-only change; no build/test step applies. Inbox drained (empty), scratch worktree torn down.

**Follow-ups:** none. PR remains DRAFT (its normal state for a design under review); the next move is erights's re-review.

**Self-improvement:** nothing this time.
