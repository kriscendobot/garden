---
created: 2026-06-24
updated: 2026-08-12
author: gardener
---

# Skill: panel

The scripted jury-panel workflow: a gardener-supervised shell state machine
(`scripts/jobs/gardening/panel.sh`) that runs a jury panel over a PR, collects
each seat's verdict, decides the round's disposition, loops to a fixer stage
while changes are required, and terminates by un-drafting when the panel passes.

This is the v2 translation of v1's **judicial** workflow. In v1 an orchestrator
agent dispatched one of three judge roles (solicitor / barrister / justice) plus
an appellate, each of which fanned out a jury of subagents and aggregated their
verdicts by hand. In v2 the control flow is a shell script the gardener
supervises; `claude -p` is reserved for the genuine judgments — each seat's
review, the disposition decision, and the appellate pass. See
`designs/judicial-workflow.md` for what was deterministically scripted versus
left to `claude -p`, and `designs/gardening-state-machine.md` for the supervised-
script discipline this skill follows.

## When to use

- A draft PR has reached the review stage of its gardening lifecycle and needs a
  jury pass before un-draft. The gardener invokes `panel.sh` for the PR and
  reacts only to its terminal line (passed + un-drafted) or a `loop` / failure
  signal.
- A maintainer-requested standalone panel pass on a stale PR. Same script; the
  supervisor names the seat list via the env overrides if a reduced composition
  is wanted.

## Inputs

```
panel.sh <worktree> <pr-number> [base-ref]
```

- `<worktree>`: the project worktree holding the PR's head.
- `<pr-number>`: the PR under review (used in prompts, run-dir naming, the
  terminal line, and the un-draft hook).
- `[base-ref]`: the diff base for panel-kind sensing and the seat briefs
  (default `HEAD~1`).

Environment knobs (the supervisor owns these; the test hooks make the script
runnable non-interactively):

| Variable | Purpose |
|---|---|
| `GARDEN_ROOT` / `JURORS_DIR` | where the seat briefs live (`roles/jurors/<seat>/AGENT.md`). |
| `GARDEN_CODE_SEATS` | the 28-seat code-panel list (override for a reduced panel); includes the cost-gated `coverage-auditor`. |
| `GARDEN_DESIGN_SEATS` | the 7-seat design-panel list. |
| `GARDEN_PANEL_SEAT` | hook: run one seat's review (default shells `claude -p` with the seat brief). |
| `GARDEN_PANEL_DECIDE` | hook: aggregate verdicts → `must-fix` \| `pass` (default `claude -p`). |
| `GARDEN_PANEL_APPELLATE` | hook: the terminating-round appellate pass (default `claude -p`; set `:` to skip). |
| `GARDEN_PANEL_FIXER` | pluggable: project fixer invocation on non-terminating rounds (default no-op `true`). |
| `GARDEN_PANEL_UNDRAFT` | pluggable: the terminal un-draft call, e.g. `gh pr ready` (default no-op `true`). |
| `GARDEN_PANEL_RUNDIR` | on-disk scratch for per-seat blocks + aggregates (kept OUT of the supervisor's context). |
| `GARDEN_PANEL_RECORD` | the durable-record writer (default `scripts/jobs/panel-run-record.sh`; set `:` to skip the journal push). |
| `GARDEN_PANEL_REPO` | `<owner>/<repo>` for the record's store key (default: derived from the worktree's `origin`, else the worktree basename). Every remote-URL form git accepts reduces to the same key (`scripts/jobs/test/panel-repo-slug-test.sh`), so a run is keyed the same whether or not a caller passes this. |
| `GARDEN_PANEL_CONCURRENCY` | how many seats review at once (default 8); this is what makes the 28-seat panel fit a handler budget. |
| `GARDEN_PANEL_SEAT_ATTEMPTS` / `_BACKOFF` | per-seat retry-on-empty attempts (default 3) and backoff step in seconds (default 5). |
| `GARDEN_PANEL_MAX_ROUNDS` | loop-exit safety bound (default 8); not a normal exit path. |
| `GARDEN_TRACE` / `GARDEN_TRACE_LOG` | opt-in `set -x` diverted to a file via `BASH_XTRACEFD`. |

Two hook hazards, each paid for once:

- **A `GARDEN_PANEL_SEAT` hook must not read its own block file.** The script runs
  `seat_review "$seat" > "$block"`, so the shell **truncates** `$GARDEN_PANEL_RUNDIR/round-<r>.<seat>.md`
  *before* the hook runs. A supervisor replaying already-collected blocks through
  the real script — the way to get `panel.sh`'s own sensing / aggregation /
  disposition over seats fanned out concurrently — must `cat` them from a separate
  **archive** directory. A hook that cats the run dir's own path emits nothing, and
  the block it was meant to replay is gone (endo-but-for-bots#713 backfill).
- **Hooks must live under `$GARDEN_SCRATCH`, not `/tmp`.** `/tmp` is `noexec` on
  the fleet's hosts, so a hook script placed there fails with exit 126
  (endo-but-for-bots#848 backfill).

## State

The panel/fixer loop is stateful within one invocation (it iterates rounds), but
the script holds no cross-invocation state. Each run's per-seat verdicts and
per-round aggregates land in `GARDEN_PANEL_RUNDIR` on disk; the supervisor reads
that directory only when it wants detail. Quiet-on-success means the routine
case never flows into the supervisor's window.

**One durable artifact escapes the rundir: the compact panel-run record.** The
rundir is scratch — torn down with the job's worktree — so on termination (pass,
the max-rounds bound, or a fail) the script BEST-EFFORT pushes ONE compact record
per run to `panel-runs/<owner>-<repo>-<pr>/<run-id>.md` on `journal2`, via a
separate deterministic writer (`scripts/jobs/panel-run-record.sh`; no `claude -p`,
single-writer CAS discipline like `reputation.sh`). The record carries only the
`repo` / `pr` / `panel_kind` / `base_ref`, the round count and terminal
disposition, per round the seat list with a **verdict class only** (never the
seat's prose) and the must-fix item count with a **truncated** title per item
(≤120 chars, ≤20/round), whether the appellate ran and its proposal count, and a
reserved `epoch:` field for `designs/evaluation-epochs-panel-calibration.md`. It
is deliberately compact so thousands of runs do not bloat `journal2`, and it is
best-effort: a failed push WARNs and never fails the panel or blocks an un-draft.
This is the substrate that lets the garden audit its own evaluator (how many
rounds a PR takes, which must-fix items recur) from the journal — evidence that
was previously deleted with the worktree.

## Procedure

1. **Sense the panel kind.** The script diffs `<base>...HEAD`. If every changed
   path is under a design directory (`designs/*.md`, `*/designs/*.md`) or matches
   `DESIGN*.md`, the panel is the **design panel** (7 seats); otherwise the
   **code panel** (28 seats). Any ambiguity (no base, git error, no changed
   files) falls to the code panel — the broader, safer panel, consistent with
   `sense.sh`'s bias toward over-reviewing.
2. **Short-circuit when there is no review surface.** Before any seat is
   dispatched, the script asks a deterministic question: is the diff against the
   base *empty*? A diagnostic baseline PR whose head is an empty commit on a
   frozen snapshot is the recurring shape (`endojs/endo-but-for-bots#847`,
   `chore(ci): establish current master baseline`: 0 files, 0 lines). There is no
   finding a seat could return over an empty diff, so the verdict is determined
   without asking: no change, no must-fix, `pass`. The script runs zero rounds,
   spends zero `claude -p`, skips the fixer and the appellate, and goes straight
   to the un-draft hook; single-round mode emits the same `pass` last token the
   staged-gauntlet driver reads. This is the seat-gate pattern the
   `coverage-auditor` already uses (deterministic pre-pass first, spend an LLM
   only when there is something to judge) raised to the whole panel. The gate is
   **narrow and fail-closed**: it fires only when git *agrees* there is nothing
   (the diff command exited 0, so a merge base exists, and both endpoints resolve
   to commits). A git error, a missing base, or a non-git worktree leaves the
   normal panel running: an empty diff we could not confirm is treated as a
   diff, the same bias toward over-reviewing step 1 takes. Regression guard:
   `scripts/jobs/test/panel-empty-diff-test.sh`.
3. **Fan the seats — concurrently, `GARDEN_PANEL_CONCURRENCY` (default 8) at a
   time.** For each seat in the matching list, the script shells one `claude -p`
   (the `seat_review` hook), briefing it with that seat's
   `roles/jurors/<seat>/AGENT.md` and the diff. Each seat returns one per-juror
   block, which the script files under the run dir; an empty or blank block is
   never legitimate signal, so the seat is retried with backoff and, once its
   attempts are spent, fails the panel loudly. After the join, a **second pass
   appends the blocks to the round aggregate in `$seats` order**, so the
   aggregate is byte-identical however the seats happened to interleave.
   Concurrency is what makes the panel fit a gardener's handler budget *by
   construction*: sequentially, a 28-seat code panel over a ~1500-line diff ran
   ~1.5–2.5 hours against a default `GARDEN_HANDLER_TIMEOUT` of 2400s. Panel jobs
   therefore resolve the 7200s `GARDEN_PANEL_HANDLER_TIMEOUT` role/stage default;
   the shared budget resolver enforces this instead of relying on every producer
   to remember an explicit header.
4. **Decide the disposition.** The script shells one `claude -p` (the
   `decide_disposition` hook) over the aggregate and reads back exactly
   `must-fix` or `pass`.
5. **Fixer loop.** On `must-fix`, the script invokes the project fixer hook with
   the must-fix items and re-runs the panel against the new head — the same loop
   v1 ran between a judge's request-changes verdict and the justice's re-review.
   The loop iterates until a `pass` (or the safety bound trips).
6. **Appellate pass.** On `pass`, the script shells the appellate hook over the
   passing aggregate; its conservative promotion proposals land in the run dir
   and are advisory (they do not block the un-draft).
7. **Terminate by un-drafting.** The script calls the un-draft hook (v1's
   `gh pr ready <N>`) and prints one terminal line. That line — passed + un-
   drafted — is the only thing the supervisor normally sees.

## Output

- **Quiet success:** one line, `panel #<N>: <kind> PASSED after <r> round(s); un-drafted.`
  An empty-diff PR reads `PASSED after 0 round(s) (empty diff); un-drafted.`,
  preceded on stderr by the one-line reason no seat was dispatched.
- **Failure:** a loud `panel #<N>: FAILED at <stage>` on stderr, non-zero exit.
- **Detail (on disk, not stdout):** `GARDEN_PANEL_RUNDIR/round-<r>.md` aggregates,
  `round-<r>.<seat>.md` per-seat blocks, and `appellate.md` proposals.
- **Durable (on `journal2`, not stdout):** one compact `panel-runs/<owner>-<repo>-<pr>/<run-id>.md`
  record per run (see § State), pushed best-effort on termination.

## Mapping the v1 roles onto v2 stages

| v1 role | v1 surface | v2 stage in `panel.sh` |
|---|---|---|
| **judge** (retired redirect) | panel-kind discrimination; foreperson | the `sense_panel_kind` step + the aggregate-and-decide control flow |
| **solicitor** | design-only PR; 7-seat design panel | the design-panel branch of seat selection |
| **barrister** | first code-panel round on a source PR | the first iteration of the loop on the code panel |
| **justice** | code-panel re-runs after a fixer push | the loop's subsequent iterations (re-review of the delta) |
| **appellate** | promote small-and-in-context deferrals before un-draft | the `appellate_pass` hook on the terminating round |
| the jury seats | one per-juror block each | the `seat_review` `claude -p` fan-out over `roles/jurors/<seat>/` |
| disposition rubric | judge classifies findings | the `decide_disposition` `claude -p` (`must-fix` \| `pass`) |

The three v1 judge roles collapse into one loop because their *difference* was
the briefing (first round vs delta re-review), which is now carried by the seat
prompt and the diff base rather than by a distinct dispatched role.

## Notes

- **Vocabulary.** v1 called the end-to-end chain "the gamut"; v2 calls it the
  **gauntlet**. The script and this skill use "gauntlet" / "panel" throughout.
- **Quiet-on-success is load-bearing.** Per-seat verdicts are voluminous; routing
  them to the run dir instead of stdout is what keeps the supervisor's context
  clean across many PRs. Do not echo seat blocks to stdout.
- **The fixer and un-draft hooks are pluggable on purpose.** They carry project-
  specific mechanics (which fixer to dispatch, which `gh` identity un-drafts) and
  default to no-ops so the control flow is testable without a live PR.
- **Panel-kind sensing is exact-match, like v1 panel-hints.** One source change
  among many design docs makes it a code-panel PR. There is no design-only-with-
  typo escape.
- _2026-08-01_: the empty-diff short-circuit (Procedure step 2) was added while
  running the gauntlet on `endojs/endo-but-for-bots#847`, a diagnostic baseline PR
  whose head is an empty commit on a frozen snapshot. Without the gate that PR
  dispatched all 28 code seats to review a zero-line diff. The gate's shape is
  deliberately the `coverage-auditor` seat-gate's, promoted from one seat to the
  whole panel: ask a deterministic question first, spend an LLM only on a real
  answer.
