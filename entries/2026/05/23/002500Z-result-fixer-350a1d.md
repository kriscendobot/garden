---
ts: 2026-05-23T00:25:00Z
kind: result
role: fixer
worktree: dispatches/fixer--350a1d/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/23/002000Z-dispatch-general-contractor-350a1d.md
  - entries/2026/05/23/001812Z-result-solicitor-050887.md
---

Addressed the one must-fix-loop item from solicitor-050887 round 1 on
PR #360 (`design(familiar): per-platform packaging lanes + CI pre-release
workflow with E2E (extends #231)`): the phase-ordering interlock between
`designs/familiar-pre-release-e2e.md` Phase 3 (workflow wiring,
MVR-completion) and `designs/familiar-platform-packaging.md` Phase 4b
(Windows signing, multi-week post-MVR).

Resolved via option (a) from the verdict (split, not just cross-link):

1. Split e2e Phase 3 into Phase 3a (MVR-completion subset: workflow file
   with Windows `make-nsis` + `e2e-windows` scaffolded as
   `continue-on-error` matrix entries that skip the EV-sign + E2E steps)
   and Phase 3b (cutover that flips both jobs to blocking, gated on
   packaging Phase 4b). Updated the prose paragraph below the phasing
   table to name which packaging phases each e2e phase assumes.
2. Added a paragraph beneath the job-topology mermaid diagram clarifying
   that the steady-state shape applies after Phase 3b; named the Phase
   3a non-blocking shape and the Phase 3b dependency on packaging Phase
   4b.
3. Cross-linked the dependency from the *other* side: packaging Phase
   4b's table cell now back-references e2e Phase 3b so a reader of
   `familiar-platform-packaging.md` sees what Phase 4b unblocks.
4. Bumped `Updated` to 2026-05-23 in both metadata tables and the
   `designs/README.md` summary table rows (per `designs/CLAUDE.md`).

**Rebase note**: the dispatch's project worktree was at stale base
`070438cb8` while the remote branch had been re-based to `b1c3f4dca`
upstream and re-pushed as `da5fc6606`. Cherry-picked the single fixer
commit onto the remote tip and pushed; net effect on the PR is one
additional commit on top of the existing head.

**Pre-push gate**: ran `pre-push-gates.sh`; the markdown sentence-per-line
probe surfaced findings, all on pre-existing numbered-list content in
the base files (not lines I introduced). My additions add no em-dashes
and conform to sentence-per-line. No yarn typecheck / lint regressions
(design-doc-only change).

**Commits pushed**:
- `83e2a8031` design(familiar): split e2e Phase 3 into 3a/3b, cross-link packaging Phase 4b

**Files touched**:
- `designs/familiar-pre-release-e2e.md` (Updated metadata; +12 lines
  after job-topology diagram; phasing table split 3 -> 3a/3b; prose
  paragraph below the table rewritten to name packaging-phase
  assumptions).
- `designs/familiar-platform-packaging.md` (Updated metadata; Phase 4b
  table cell now names "Unblocks ... e2e Phase 3b ...").
- `designs/README.md` (Updated dates in summary-table rows for both
  designs).

**Not done** (out of fixer lane / not requested):
- No PR comment posted; the dispatch did not authorize a top-level
  summary or thread reply. The contractor's next stage (solicitor round
  2) is the right venue for the round-1 followups (3 follow-up, 5
  acknowledge, 7 summary-fix) per the solicitor's parked post-loop
  actions.

**Report to contractor**: must-fix item addressed; PR #360 head is now
`83e2a8031`; ready for solicitor round 2.

Self-improvement: nothing this time. The dispatch hit a stale-base
rebase race (worktree pinned to `070438cb8`; remote had re-based to
`da5fc6606` between solicitor round 1 and fixer dispatch). The fix
(cherry-pick onto fetched remote tip rather than rebase a stale local
branch) is already documented in `skills/rebase-before-followup` and
`skills/conflict-resolution`; the situation surfaced cleanly and
resolved without lasting damage. No structural lesson.
