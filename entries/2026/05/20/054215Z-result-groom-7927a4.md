---
ts: 2026-05-20T05:42:15Z
kind: result
role: groom
project: endo-but-for-bots
worktree: dispatches/groom--7927a4/project
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/20/053048Z-dispatch-liaison-7927a4.md
---

# Result: groom full pass on designs/README.md (PR #312 draft)

Branch `groom/roadmap-2026-05-20` at head `40904b806` against `llm`.
PR https://github.com/endojs/endo-but-for-bots/pull/312 (DRAFT).
One commit: `docs(designs): groom roadmap — milestones + summary refresh
(Progress as of 2026-05-20)` (+137 / -77 on `designs/README.md`).

## Pre-flight note

The dispatch named HEAD `68246ad92` for `project/`, but that commit
was 91 commits behind `origin/llm` (the dispatch worktree was bare-
clone-stale relative to the live `llm` branch). Per groom procedure
step 2 (fast-forward to current tip), the pass ran from
`origin/llm@2d12449a0` so the milestone counts and status flips
reconciled against the live README, not the older one.

## Load-bearing deltas

### Summary-by-Milestone counts reconciled (the main correction)

The 2026-05-19 status sweep's narrative had mechanically decremented
from a 2026-05-08 baseline without absorbing milestone-table rows
added between 2026-05-08 and 2026-05-13:

| Milestone | Prior | Reconciled |
|---|---|---|
| M½ | 1 | 1 |
| M1 | 8 | **10** (absorbed `endo-gateway`) |
| M2 | 6 | 6 |
| M3 | 8 | **11** (absorbed `cli-store-verb-text-modes`, `cli-edit-verb`, `exo-zip-package`) |
| M4 | 10 | **11** (absorbed `daemon-retention-paths` net of `retention-path-notation` flip to Reference) |
| M5 | 6 | 6 |
| M6 | 2 | 2 |
| **Total** | 41 | **47** |

M3 effort widens from 5-7 weeks to 6-8 weeks reflecting the three
additional Proposed rows. Other per-milestone effort aggregates are
re-summed from the reconciled counts.

### Mermaid Gantt re-anchored

Prior Gantt anchored M½ to 2026-03-06; today is 2026-05-20 and that
anchor reflected the extraction date, not the current calendar. The
new Gantt anchors M½ to today with 1w remaining; downstream cascade.
Target-date shifts: M1 "Mid July → early August" → "Late July → early
August"; M3 "Late September → late October" → "Late October → early
November"; M4 "Early → late December" → "Mid December → mid January
2027"; M5 unchanged; M6 "Q3 2027" → "Q3 to Q4 2027".

### Status flips since prior snapshot

None. The 2026-05-19 sweep's per-design statuses already reflect the
shipped state on `llm`; nothing has flipped between then and 2026-05-20.

### New rows added to README this pass

None. The four designs the dispatch brief named:

- `chat-rename-dismiss-to-clear`: already flipped to **Complete** by
  the 2026-05-19 sweep (matches PR #299 mention in the dispatch).
- `forge-gap-analysis.md` (PR #310): on a side branch, not yet on
  `llm`; not eligible for README inclusion until merged. Bulletin
  already tracks this row.
- `patterns-diagnostic-feedback.md` (PR #307): on a side branch, not
  yet on `llm`; same as above.
- `familiar-release.md` (PR #231): exists on `llm` as a design file
  but is not in the README summary table; flagged below as an open
  question.

### Dep-graph cycles surfaced

None.

### Open-questions count

Two non-blocking observations for the maintainer (none warrant a
separate `message` entry per the dispatch's "skip if empty" guidance,
but flagging here for the result entry):

- `familiar-release.md` exists in `designs/` on `llm` but is not in
  the README's Summary table or any milestone table. It was added by
  PR #231 round-two work. If it should be in M1 or M3 (release-
  shaped capability rather than hygiene), the next targeted pass can
  add the row; the current pass kept the Summary-table walk
  mechanical against existing rows.
- Several design files lack any frontmatter Status field
  (`outliner-design-doc-2.md`, `outliner_drag_and_drop.md`,
  `OUTLINER_INTERACTION_PATTERNS.md`, `worker-rust-xs.md`,
  `hardened-text-codecs-shim.md`, `hardened-url-shim.md`,
  `daemon-engo-supervisor.md`, `daemon-locator-reference.md`).
  Two of these (`hardened-*-shim`) are listed in the README's
  "Recently added or revised" prose but not the Summary table.
  The prior 2026-05-19 sweep already flagged this; deferring to a
  curation-shaped follow-up rather than a groom pass.

### Recalibration deltas (load-bearing for completeness)

Per-size multipliers unchanged from 2026-05-14 (S 0.7, M 1.2, L 1.3,
XL conservative). Cumulative S bucket grows from 18 to 25
observations on 7 new merges in the 2026-05-14 to 2026-05-20 window
(`#293`, `#294`, `#291`, `#292`, `#126`, `#255`, `#245`). M and L
buckets unchanged. The XL bucket still has zero completed samples;
`endo-posix-sandbox` and `daemon-capability-bank` remain the
longest-running XL candidates with no terminal data.

Review-queue carry note (new): the open-PR backlog on
`endojs/endo-but-for-bots` has grown to ~30 PRs from ~14 at the
2026-05-14 round. The carry stays at 2 weeks per milestone but the
next pass may need to widen this if drainage does not match intake.

## Push and PR

`git push origin HEAD:refs/heads/groom/roadmap-2026-05-20` succeeded
first try (FETCH_HEAD matched `origin/llm@2d12449a0` at push time).
PR #312 opened DRAFT against `llm`. Per dispatch brief, the maintainer
un-drafts; the groom does not.

## Identity

Author and committer `endolinbot <main.barn5084@fastmail.com>` per
the dispatch-pinned worktree config. No `Co-authored-by` or
`Generated with [Claude Code]` trailers.

Self-improvement: the dispatch-worktree's bare-clone snapshot can lag
the live branch tip by many tens of commits (91 in this case). The
groom procedure's step 2 (fast-forward to current tip) caught it, but
a dispatch brief that names a specific HEAD SHA as authoritative
risks a subagent that trusts the brief without checking. Consider
adding to `roles/groom/AGENT.md` § Procedure step 2 a one-line note:
"if the dispatch brief names a HEAD SHA, treat it as a hint not a
contract; the live branch tip is the source of truth." Below the
threshold for a skill edit on one observation, but worth flagging.
