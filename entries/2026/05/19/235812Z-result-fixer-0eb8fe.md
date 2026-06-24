---
ts: 2026-05-19T23:58:12Z
kind: result
role: fixer
worktree: dispatches/fixer--284d9f/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/19/233818Z-result-steward-49e1db.md
---

# Consolidate PR #302 design-status updates into PR #304

Dispatch: kriskowal asked on PR #304 (issue_comment 4493068464,
2026-05-19T23:33:18Z) to consolidate the (closed-unmerged) PR #302's
design-status updates into PR #304, the surviving sweep PR. PR #302's
batch update touched 12 design files; #304 had already touched 13.
Three files overlapped (designs/README.md, chat-view-edit-commands,
daemon-checkin-checkout) and were merged by hand for the union of
true-fact updates.

## What landed

Twelve per-file commits pushed onto `chore/designs-status-sweep-202605`
(new head `da9b45263`, was `e0b599f2c`):

| Commit     | Design                          | Status set            |
|------------|---------------------------------|-----------------------|
| f5f3a7899  | chat-focus-message              | Active -> Complete    |
| 21cfa0c3c  | chat-markdown-render            | Proposed -> Complete  |
| ce341810a  | chat-pending-commands           | Not Started -> In Progress (PR #133 open) |
| 4fcc62814  | daemon-capability-filesystem    | Not Started -> Reference |
| 37f9d4438  | daemon-message-streaming        | Draft -> In Progress (PR #287 open) |
| 816943c65  | daemon-mount                    | In Progress (body refreshed) |
| 7458667f8  | daemon-retention-paths          | Not Started -> In Progress (PR #284 open) |
| 6fd2bad5a  | platform-fs                     | In Progress -> Complete |
| 721e203f2  | retention-path-notation         | Proposed -> Reference |
| 8271180e1  | chat-view-edit-commands         | Status section consolidated (Complete; union of #302 + #304 facts) |
| 0f32f9241  | daemon-checkin-checkout         | Status section consolidated (Complete; union of #302 + #304 facts) |
| da9b45263  | README                          | Summary table, totals, Mermaid, milestones |

Per-design commits (one per design touched) per the dispatch's preferred
shape.

## Three overlap files (hand-merged for the union)

- **chat-view-edit-commands.md**: both PRs agreed Complete via commit
  ae2b074ac. Consolidated Status section now includes the typography /
  language-mode refinement SHAs (9af2ea9a1, 3faf49a21) from #304 and the
  file list (blob-viewer.js, markdown-preview.js, monaco-wrapper.js,
  language-detect.js, command-executor.js, index.css) plus the "modal
  viewer, Monaco editor, Markdown preview pipeline" framing from #302,
  plus the `/cat` alias note.

- **daemon-checkin-checkout.md**: both PRs agreed Complete. Consolidated
  Status section keeps #304's file-path detail (endo.js +
  commands/checkin.js + commands/checkout.js + @endo/platform framing)
  and adds #302's full commit history (d60ba38b2 initial verbs +
  a6e20c5e2 zip support + PR #153 verb-unification reshape commit
  8a8e872d4 merged 2026-05-12). Zip-archive interchange note pointing
  to exo-zip-package retained.

- **designs/README.md**: applied #302's nine summary-table-row updates
  on top of #304's existing rows (no row conflicted). Recomputed totals
  from #304's 36/16/37/8/3/3/2/1/1 (107 designs) to 39/18/34/6/2/5/2/0/1
  (107 designs). Mermaid graph: chat-pending-commands and
  daemon-message-streaming annotated IN PROGRESS; platform-fs annotated
  COMPLETE; daemon-capability-filesystem annotated REFERENCE. M1
  milestone table: platform-fs (Complete) and daemon-capability-filesystem
  (Reference) removed from active backlog (remaining 9 -> 7). M4
  milestone table: retention-path-notation removed (Reference; remaining
  11 -> 10). Total remaining 42 -> 39. daemon-mount body refreshed to
  note Phase 4 in PR #135, mount extensions in PR #127,
  followNameChanges in PR #277 (all open). Per-design size/duration
  table entries adjusted to match. Sweep note and trailing progress
  summary rewritten to cite both the 2026-05-18 and 2026-05-19 source
  sweeps. `chat-view-edit-commands` and `daemon-checkin-checkout`
  Updated-date cells bumped 2026-05-18 -> 2026-05-19 to match their
  per-file consolidated revisions.

## Re-verification of #302's "believe merged" miss cases

Per the dispatch's reminder, I re-verified the three PRs the steward
flagged: PR #133 (chat-pending-commands), PR #287
(daemon-message-streaming), PR #284 (daemon-retention-paths). All three
are OPEN (not merged) as of fetch. #302's diff already labeled them as
"In Progress (PR #N)" rather than "Complete", so the consolidation
carries that correct framing forward. The commit messages and the
per-file Status sections both note the open-PR state explicitly.

## Other verifications

- All commit SHAs cited by #302 (7592a18dd, 23f56256c, 2f17a6f56,
  e0dda06fb, d60ba38b2, a6e20c5e2, ae2b074ac) verified to exist in the
  repo.
- e0dda06fb (platform-fs initial commit) is reachable from `llm`.
- PR #122 (platform-fs) is CLOSED (closedAt 2026-05-10T11:07:34Z,
  mergedAt null); the platform-fs design is still Complete because the
  substance landed via direct llm commits, with PR #122 carrying
  review-cycle fixups (#302's framing). The consolidated Status section
  retains that correct framing.
- PR #135 (mount Phase 4), PR #127 (mount extensions), PR #277
  (followNameChanges) all OPEN.

## Push and CI

Push: `e0b599f2c..da9b45263 HEAD -> chore/designs-status-sweep-202605`
succeeded. PR #304 head SHA now `da9b452631fa36d6c438da3246a18e58be191ccb`,
state OPEN DRAFT.

Prettier check: `npx prettier --check designs/` reports "All matched
files use Prettier code style!" Pre-PR check passed locally so the
shepherd has nothing to retry on the lint surface.

No reply or top-level comment posted on PR #304: the dispatch task is
consolidation, not review-thread handling, and the dispatch prompt
did not authorize a PR comment. The maintainer's `gh pr view 304`
will show the new commits; that suffices for the consolidation request.

Self-improvement: nothing this time.
