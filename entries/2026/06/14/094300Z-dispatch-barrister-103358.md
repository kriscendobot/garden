---
ts: 2026-06-14T09:43:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: barrister
dispatch_root: /home/kris/dispatches/barrister--103358
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/091200Z-result-builder-7cfbcc.md
---

# dispatch: barrister — PR #440 formula-inspector (cuts 1+2+3) first code-panel round

Cleaner `b20d1e` finished re-gamut on PR #440 expanded scope (head `888951a9f`). PR DRAFT, base `llm`, covers cuts 1+2 (daemon `getFormula` + CLI `endo inspect`) plus cut 3 (chat surface: Value modal Formula back face, formula-view-registry, formula-view-component, flip / Shift+P / Escape / back-stack / gear icon, card-flip CSS, 35 new unit+component tests, 6 Playwright e2e stubs).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`, head `888951a9f`.
- **Cuts 1+2 commits**: per the prior weaver rebase onto llm.
- **Cut 3 commits**: `e894ffc09`, `3e5f44604`, `b446f5cc3`, `ab50308a3`; cleaner pushed `888951a9f` (object-shorthand fix).
- **CI status** (per cleaner): some pre-existing red from cut-1 hygiene (TypeScript errors in `packages/daemon/src/formula-record.js`, prettier drift in `packages/daemon/test/endo.test.js`) — these may surface as must-fix-loop items in your panel; they predate cut 3 but block merge.
- **Design merged**: `designs/formula-inspector.md` was merged via PR #439 onto `llm` at `aaff6ebaa`.

## Task

In your `project/` worktree at `888951a9f`:

1. Run `panel-hints.sh` to get the recommended seat count.
2. Compose the code panel + cross-panel design seats per `skills/panel-review/SKILL.md`. The PR includes substantial markdown (PR body), so cross-panel design seats are warranted.
3. Run the panel against the cut 1+2+3 diff vs base `llm`. Cut 3's substance is the new chat surface; cuts 1+2 may carry must-fix-loop items the cleaner's hygiene pass did not catch (TS errors + prettier drift).
4. Aggregate verdicts per disposition rubric (must-fix-loop / summary-fix / follow-up / acknowledge / drop).
5. Post the formal review as a top-level COMMENTED review on PR #440 (in-band fallback if Agent tool unavailable).
6. Post the summary-fix job(s) to the job board if any items remain after the loop terminates.
7. Append any follow-up items to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--440.md`.

## Authorizations

- Post panel review (COMMENTED state).
- Post summary-fix job entries to `journal/jobs/open/`.
- Append to followup ledger.
- Do NOT push to project.
- Do NOT un-draft (justice's responsibility after a clean re-run).

## Out of scope

- Do NOT touch daemon-cas (separate PR #442).
- Do NOT fold in cut 4 (separate PR #441).
- Do NOT comment on the maintainer's earlier directives about rebase or chat-vs-goblin-chat.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Panel composition + seat count.
- Verdict counts (must-fix-loop, summary-fix, follow-up, acknowledge, drop).
- The review URL.
- Job-board posting path(s).
- Followup ledger entries appended.
- A `Self-improvement: ...` line.
- **Recommended next stage**: if must-fix-loop > 0, `next: fixer-loop`; else `next: appellate`.

End your turn with a concise summary back to the orchestrator.
