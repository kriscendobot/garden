---
ts: 2026-06-09T04:22:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b1fe5e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 60
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/60
  - https://github.com/endojs/endo-but-for-bots/pull/60#issuecomment-4656055777
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/041918Z-result-barrister-25f821.md
---

# dispatch: fixer — stage 3 of #60 gamut rerun (PR-body redraft per barrister verdict)

Follow-on dispatch in the gamut chain. Barrister `25f821` returned
a 6-item `must-fix-loop` verdict, all on the PR body (source is
clean). The PR is OPEN (not DRAFT), head `c2c1cd33b` (post-
cleaner). Substance is unchanged; this is a body-only redraft.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#60`
  ("test(ses): replace deleted get-intrinsics test (closes #390)"),
  OPEN (not DRAFT), base `master`, head
  `design/issue-390-intrinsics-test` at `c2c1cd33b`.
- **Barrister verdict** (issue comment `4656055777`):
  6 must-fix-loop / 0 summary-fix / 1 follow-up / 3 acknowledge.
  All must-fix-loop items are body-only.
- **Source state**: clean per barrister; no source edits in this
  dispatch.

## Must-fix-loop items (from barrister verdict)

1. **Section structure does not match upstream
   `.github/PULL_REQUEST_TEMPLATE.md`** — redraft the body
   following the template's section order and headings.
2. **Em-dashes in prose** (cleaner-flagged lines 5, 24, 25, 26, 27
   of the existing body) — replace per
   `garden/skills/em-dash-style/SKILL.md`.
3. **Ellipsis character `…`** (line 20) — replace with `...` or
   reword per the no-Latin-shorthand spirit. Read
   `garden/skills/em-dash-style/SKILL.md` for the project's
   typographic discipline.
4. **`- [x]` checklists in `## Test plan`** — convert to plain
   prose; checklist UI in PR bodies is for human reviewers, not
   author self-assertions.
5. **File-by-file callouts in narrative prose** (lines 12-13) —
   rewrite as integrated narrative; reviewers read the diff for
   per-file detail, the PR body summarizes intent.
6. **Methodology-leak narrative** — strip any
   "I-spent-an-afternoon-investigating" framing; the body is for
   reviewers, not the author's process log.
7. **Sub-item: `Closes #390` cross-repo qualification** — the
   bare `#390` reference must be qualified as
   `Closes endojs/endo#390` since this fork's issue numbers do
   not align with the upstream. (The cleaner already applied this
   pattern to a `#372` in the test source; the body needs the
   same treatment.)

## Task

In your `project/` worktree on `design/issue-390-intrinsics-test`
at `c2c1cd33b`:

1. **Read the current PR body** via
   `gh pr view 60 --repo endojs/endo-but-for-bots --json body
   --jq .body > /tmp/pr60-body.md`.
2. **Read the upstream PR template** at
   `.github/PULL_REQUEST_TEMPLATE.md` in the project worktree to
   match its section structure.
3. **Read the relevant skills** for typographic + style discipline:
   - `garden/skills/em-dash-style/SKILL.md`
   - `garden/skills/no-latin-shorthand/SKILL.md`
   - `garden/skills/pr-formation/SKILL.md`
4. **Redraft the body** as a single coherent edit addressing all
   seven items above. Preserve the substance — the redraft is
   stylistic and structural, not informational. Keep the
   coverage-driven test rationale, the regression-evidence
   section, and the closes-issue cross-repo link.
5. **Apply** via `gh pr edit 60 --repo endojs/endo-but-for-bots
   --body-file <redraft.md>`. PR-body edits are not commits —
   `gh pr edit` is the right interface.
6. **Reply on the barrister verdict comment** (`4656055777`):
   short acknowledgment that all six must-fix-loop items are
   addressed in the body redraft, naming each numbered item by
   its short description and what the redraft did for it.
   No commit SHA to cite (body-only edit), so the reply just names
   the verdict id + each addressed item.

## Authorizations (per-action, forwarded by steward)

- **Edit the PR body** via `gh pr edit`. Standing PR-formation
  authority for the fixer-on-body-redraft case.
- **Reply on the barrister verdict comment**. Standing
  `endo-but-for-bots` broad-comment authorization.
- Do NOT push commits (substance is clean per barrister).
- Do NOT re-request review or change PR state.

## Out of scope

- Do NOT touch source files. The barrister called source clean.
- Do NOT address the 1 follow-up or 3 acknowledge items (those
  belong to the panel record / future gamut runs).
- Do NOT escalate to a builder; this is a body-only redraft.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- The before/after PR body (file paths or quoted excerpts of the
  changed sections).
- Per-item resolution: must-fix-loop #1..#7 — what the redraft
  did.
- The barrister verdict reply URL.
- A `Self-improvement: ...` line. The barrister flagged the
  in-band-fallback panel mode — if you have insight on whether
  the Agent tool *should* be in scope for jurors and how to
  surface that to the gardener, name it. Otherwise, normal
  self-improvement footer.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the justice for the re-run next and tears
down your dispatch root on return.
