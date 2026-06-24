---
ts: 2026-05-20T00:56:35Z
kind: result
role: fixer
worktree: dispatches/fixer--e1cd41/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/19/235812Z-result-fixer-0eb8fe.md
---

# Roadmap calibration on PR #304 per kriskowal CHANGES_REQUESTED

Dispatch: kriskowal CHANGES_REQUESTED on PR #304 at
2026-05-19T23:31:29Z (review only) asked for the completion dates to
reflect real completion dates "for roadmap calibration purposes",
using `git blame` to find both the completion date and the
active-development window.

Twenty-one design files touched on `chore/designs-status-sweep-202605`
got a new "Roadmap calibration (per `git blame` on `llm`)" subsection
appended to each existing Status section, plus a one-line bold
summary at the top of the Status. Per-design commits (matching the
prior fixer 0eb8fe's per-design discipline), with the three In
Progress and three Reference / Superseded designs grouped to keep the
commit count manageable.

## What landed

Seventeen commits pushed onto `chore/designs-status-sweep-202605`
(new head `176b3caae`, was `da9b45263`):

### Complete (12 designs, one commit each)

| Commit     | Design                          | Active dev window                       | Completion date / commit |
|------------|---------------------------------|-----------------------------------------|--------------------------|
| c7e3728f5  | base64-native-fallthrough       | 2026-04-29 (1 day)                      | 2026-04-29 / `7325bbe15` |
| d33675b2c  | ci-no-npm-lifecycle             | 2026-04-29 -> 2026-05-14 (16 days cal)  | 2026-05-14 / `ddbc8ad7e` (PR #126) |
| 86ee03dc5  | chat-view-edit-commands         | 2026-03-21 -> 2026-04-11 (21 days)      | 2026-03-23 / `ae2b074ac` + refinements through 2026-04-11 |
| 28ad3c841  | daemon-checkin-checkout         | 2026-03-17 -> 2026-05-18 (62 days cal)  | initial 2026-03-20 / `d60ba38b2`; unify 2026-05-18 / `8a8e872d4` (PR #153) |
| d997e422c  | daemon-content-store-gc         | 2026-03-21 -> 2026-05-12 (52 days cal)  | 2026-05-07 / `5798b56f5`+`8c0d7d849` (PR #99); follow-up 2026-05-12 / `e6d5ce6d6` (PR #225) |
| 0c273d04f  | hex-package                     | 2026-04-24 -> 2026-05-14 (21 days)      | initial pkg 2026-04-24 / `ad7a177e8`; dev-cycle break 2026-05-12 / `68246ad92` (PR #211) |
| 52a1643e0  | ocapn-noise-network             | 2025-09-16 -> 2026-05-07 (~233 days cal) | 2026-05-07 / `6a5aecd01` (PR #137) |
| b13b58d6f  | unhandled-rejection-display     | 2026-05-10 -> 2026-05-12 (3 days)       | 2026-05-11 / `a588f0b80` (PR #187) |
| 79843af56  | chat-rename-dismiss-to-clear    | 2026-03-03 -> 2026-05-06 (65 days cal)  | 2026-05-05 / `31df9e3cf` (PR #93) |
| bf3755aca  | chat-playwright-smoke           | 2026-05-06 (1 day)                      | 2026-05-06 / `460687c3a` (PR #94) |
| e9207dfaf  | chat-focus-message              | 2026-03-04 (1 day, atomic)              | 2026-03-04 / `7592a18dd` |
| 693017a18  | chat-markdown-render            | 2026-03-03 -> 2026-04-17 (46 days)      | 2026-03-26 / `23f56256c` + chat integration 2026-04-09 / `2f17a6f56` |
| 8daad264e  | platform-fs                     | 2026-03-20 -> 2026-05-11 (53 days cal)  | initial 2026-03-20 / `e0dda06fb` |

(Thirteen rows above — fourteen Complete designs ran, but the
`break-dev-dependency-cycles` one classifies as In Progress per the
PR's existing framing; it lives below.)

### In Progress (4 designs, two commits)

| Commit     | Design                          | State                                   |
|------------|---------------------------------|-----------------------------------------|
| 55fa31dc0  | daemon-mount                    | Phases 1-3+5 shipped 2026-03-21 / `e22f71327`; Phases 4+ open as PRs #135, #127, #277; partial Phase 6 absorbed by PR #153 / `8a8e872d4` 2026-05-18 |
| 8a0cd93d9  | break-dev-dependency-cycles     | Design 2026-05-10 (PR #206); Cuts 2-5 shipped 2026-05-11 -> 2026-05-14; Cut 1 open (PR #261) |
| ba241f114  | chat-pending-commands + daemon-message-streaming + daemon-retention-paths | All three have design landed (2026-03-13 / 2026-03-26 / 2026-05-01) and implementation open as PR #133 / #287 / #284 (no completion date yet) |

### Reference / Superseded (3 designs, one commit)

| Commit     | Design                          | Transition date                         |
|------------|---------------------------------|-----------------------------------------|
| 176b3caae  | daemon-capability-filesystem (Reference, transition 2026-03-21 when `daemon-mount` absorbed the implementable slice); retention-path-notation (Reference at landing 2026-05-10; `daemon-retention-paths` is the active vehicle); daemon-os-sandbox-plugin (Superseded 2026-05-07 when `endo-posix-sandbox` was mirrored into `designs/` as the successor) |

## Status-section shape adopted

Per the dispatch's example, each design now has:

```markdown
## Status

**<State>** (one-line completion / state summary with date and commit).

<existing prose retained unchanged>

### Roadmap calibration (per `git blame` on `llm`)

- Active development: <start> -> <end> (<duration>).
- Design phase: <commit list with dates>.
- Implementation phase: <commit list with dates and bursts>.
```

The "calendar" qualifier appears where the elapsed window is long but
the authoring bursts are concentrated, so that the maintainer can
see at a glance which designs were "actively in flight" vs which
sat queued.

## Notes on blame-ambiguous resolutions

- **base64-native-fallthrough**: design doc and implementation commit
  both land 2026-04-29, but the implementation commit (`7325bbe15`)
  is dated 2026-04-29 author-date though its content (the native
  fallthrough) was a squash-merge of upstream `endojs/endo#3216`.
  Treated 2026-04-29 as the canonical ship date.

- **ci-no-npm-lifecycle**: previous README text said "merged
  2026-05-15", actual squash-merge commit `ddbc8ad7e` author-date is
  2026-05-14. Used 2026-05-14 as canonical; flagged the discrepancy
  in the new section ("the bulk of the elapsed window was queue /
  review wait rather than active authoring") and corrected the
  parenthetical.

- **chat-rename-dismiss-to-clear**: previous text said "merged
  2026-05-04", actual GitHub merge commit `31df9e3cf` author-date is
  2026-05-05. Used 2026-05-05; same dateline-discrepancy note.

- **ocapn-noise-network**: previous text said "merged 2026-05-08",
  actual PR #137 merge commit `6a5aecd01` author-date is 2026-05-07.
  Same dateline-discrepancy note.

- **chat-focus-message**, **chat-playwright-smoke**, **daemon-mount**,
  **base64-native-fallthrough**: design and implementation landed
  atomically in the same commit (or same day). The "active span" for
  these is necessarily 1 day; the bursts collapse to a single moment.

- **chat-markdown-render**: cited commits `23f56256c` (merge of
  endolin/markmdown into llm) + `2f17a6f56` (chat integration) are
  preserved. The first-add of `packages/markmdown/` is `0dc176b47`
  same day as `23f56256c`. Treated the merge as the canonical
  package-landing commit; the package add and the merge are
  effectively simultaneous.

- **chat-pending-commands**, **daemon-message-streaming**,
  **daemon-retention-paths**: no completion date yet (impl open as a
  PR not merged to `llm`). Reported only design-phase date and the
  calendar gap since design.

- **daemon-capability-filesystem**, **retention-path-notation**: the
  "Reference transition" date is inferred from the date the
  superseding / successor design landed, not from a blame transition
  in the file's own Status header (the document was reframed without
  ceremony). Reported as inference.

- **daemon-os-sandbox-plugin**: the "Superseded transition" date is
  2026-05-07, the date `endo-posix-sandbox` mirrored into `designs/`
  (`fbf40d706`). The file's own Status field was already "Superseded
  by endo-posix-sandbox" at the start of this fixer dispatch; my
  edit added the transition-date row.

Nothing was un-pin-able. Every design either has a real completion
date (Complete) or a real "design landed; impl still open" state (In
Progress) or a real transition-to-reference date (Reference /
Superseded).

## Style and lint

- `yarn lint:prettier` (after `corepack yarn install`) reports "All
  matched files use Prettier code style!" (lint:prettier checks
  `.github` and `packages`, not `designs/`; ran the local prettier
  directly against each of the 21 edited design files: pass).
- Em-dash sweep (`em-dash-style` skill): three em-dashes accidentally
  introduced in early drafts (chat-focus-message, daemon-content-store-gc,
  daemon-mount) were rewritten before commit (period / colon).
- No CI checks reported on the branch (designs-only diff, no
  workflow trigger).

## Push and PR state

Push: `da9b45263..176b3caae HEAD -> chore/designs-status-sweep-202605`
succeeded. PR #304 head SHA now `176b3caae...`, state OPEN DRAFT.

No top-level summary comment posted on PR #304 and no review
re-request issued: the dispatch prompt did not include per-action
authorization for either, and the fixer external-repo etiquette
norm reserves both for explicitly forwarded authorizations. The
steward (next) decides whether to un-draft #304 directly or to
forward the per-action authorization for the fixer to post a
top-level summary first.

## Un-draft assessment

The maintainer's review asked for "the completion dates to reflect
the real completion date" plus "the time it was under active
development", both via `git blame`. Each design now carries:

1. A one-line bold completion line at the top of Status (date + ship
   commit + PR number where present).
2. An "Active development" line with the start->end span and a
   duration in days, with "calendar" qualifier where elapsed time is
   not active-authoring time.
3. A "Design phase" line naming the design-doc commits with dates.
4. An "Implementation phase" line naming the implementation commits
   with dates, broken into bursts where authoring was discontinuous.

That matches the example shape the maintainer offered ("Active
development: 2026-04-18 → 2026-05-12 (24 days) / Design phase / Implementation phase"). The
maintainer's roadmap-calibration bar should be met. Un-draft is the
steward's call.

Self-improvement: nothing this time.
