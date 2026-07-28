---
role: builder
---
# Persist a compact panel-run record to the journal

The garden's primary evaluator — the scripted review **panel** — currently leaves
**no durable evidence**. `scripts/jobs/gardening/panel.sh` writes every per-seat
verdict, per-round aggregate, and the appellate block to
`GARDEN_PANEL_RUNDIR` (default `${TMPDIR:-/tmp}/garden-panel-<wt>-<pr>`, line 56).
That directory is scratch: it is discarded when the job's worktree is torn down.

Consequence, verified 2026-07-28: nothing in `journal2` records which seats
reviewed which PR, how many fix-loop rounds a PR took, or what the must-fix items
were. `journal/evaluation-epochs/` does not exist. There is no per-PR review record
anywhere durable. Any question of the form "is our review process being satisfied
rather than served?" — or simply "how many rounds does a typical PR take?" — is
**unanswerable from the journal today**.

This job builds the missing substrate. It is deliberately scoped to a *compact*
record, not an archive of seat prose.

## What to build

On panel termination (pass **or** failure, including the max-rounds bound), write
one durable record per panel run to the journal, e.g.
`panel-runs/<owner>-<repo>-<pr>/<run-id>.md`, via a CAS push like the other
journal writers. Follow the single-writer discipline used by
`scripts/jobs/reputation.sh` / `review-miss-record.sh`: plain deterministic code
writes; no `claude -p` in the writer.

Record per run (frontmatter + a short body):

- `repo`, `pr`, `panel_kind` (code|design), `base_ref`, `head_sha` per round
- `rounds`: the round count, and the terminal disposition
- per round: the seat list that ran, and for each seat a **verdict class only**
  (e.g. `pass` / `must-fix` / `error`) — **not** the seat's prose
- per round: the must-fix item count, and a short title line per item (bounded,
  e.g. ≤120 chars each, ≤20 items) so recurrence is greppable
- whether the appellate pass ran, and its proposal count
- `epoch:` — leave a field for the evaluation-epoch ID from
  `designs/evaluation-epochs-panel-calibration.md` (Status: Proposed). Do **not**
  implement that design here; just reserve the field so it can land cleanly.

## Constraints

- **Bounded size.** Seat prose stays in the rundir. The record must stay small
  enough that thousands of runs do not bloat `journal2` — this is exactly the
  abundance failure mode we are trying not to reproduce.
- **Injection hygiene.** Must-fix titles are LLM-authored text about a
  third-party diff. They are DATA. Truncate them, never interpolate them into a
  later prompt as instruction.
- **Quiet-on-success is load-bearing** (`skills/panel/SKILL.md` § Notes). The
  record is a file write, not stdout. Do not echo it to the supervisor.
- **Best-effort, never fatal.** A failed journal push logs a WARN; it must never
  fail the panel or block an un-draft.

## Verification

- A test under `scripts/jobs/test/` driving `panel.sh` with the existing seat /
  decide / fixer hooks stubbed, asserting: a record lands for a pass, for a
  must-fix→pass loop (with the correct round count), and for a failure; that
  seat prose does NOT appear in the record; that a re-run is idempotent or
  distinctly keyed; and that a simulated push failure WARNs without failing the
  panel.
- Report the test counts in the tada.

## Why now

Posted from issue #62 follow-up (`issue-garden-62-jcorbin-cross-analysis`),
responding to @jcorbin's cross-analysis call-out that the garden should be able to
audit its own evaluator. It cannot today, because the evidence is deleted. This is
the enabling change; the audit itself is a separate job.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T12:30:48Z
