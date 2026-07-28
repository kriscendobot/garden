---
created: 2026-06-24
updated: 2026-06-24
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
| `GARDEN_PANEL_CONCURRENCY` | how many seats review at once (default 8); this is what makes the 28-seat panel fit a handler budget. |
| `GARDEN_PANEL_SEAT_ATTEMPTS` / `_BACKOFF` | per-seat retry-on-empty attempts (default 3) and backoff step in seconds (default 5). |
| `GARDEN_PANEL_MAX_ROUNDS` | loop-exit safety bound (default 8); not a normal exit path. |
| `GARDEN_TRACE` / `GARDEN_TRACE_LOG` | opt-in `set -x` diverted to a file via `BASH_XTRACEFD`. |

## State

The panel/fixer loop is stateful within one invocation (it iterates rounds), but
the script holds no cross-invocation state. Each run's per-seat verdicts and
per-round aggregates land in `GARDEN_PANEL_RUNDIR` on disk; the supervisor reads
that directory only when it wants detail. Quiet-on-success means the routine
case never flows into the supervisor's window.

## Procedure

1. **Sense the panel kind.** The script diffs `<base>...HEAD`. If every changed
   path is under a design directory (`designs/*.md`, `*/designs/*.md`) or matches
   `DESIGN*.md`, the panel is the **design panel** (7 seats); otherwise the
   **code panel** (28 seats). Any ambiguity (no base, git error, no changed
   files) falls to the code panel — the broader, safer panel, consistent with
   `sense.sh`'s bias toward over-reviewing.
2. **Fan the seats — concurrently, `GARDEN_PANEL_CONCURRENCY` (default 8) at a
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
   ~1.5–2.5 hours against a default `GARDEN_HANDLER_TIMEOUT` of 2400s, so every
   auto-gauntlet and `run the gauntlet` job depended on a producer remembering to
   stamp `handler-timeout:` — a header, not an invariant.
3. **Decide the disposition.** The script shells one `claude -p` (the
   `decide_disposition` hook) over the aggregate and reads back exactly
   `must-fix` or `pass`.
4. **Fixer loop.** On `must-fix`, the script invokes the project fixer hook with
   the must-fix items and re-runs the panel against the new head — the same loop
   v1 ran between a judge's request-changes verdict and the justice's re-review.
   The loop iterates until a `pass` (or the safety bound trips).
5. **Appellate pass.** On `pass`, the script shells the appellate hook over the
   passing aggregate; its conservative promotion proposals land in the run dir
   and are advisory (they do not block the un-draft).
6. **Terminate by un-drafting.** The script calls the un-draft hook (v1's
   `gh pr ready <N>`) and prints one terminal line. That line — passed + un-
   drafted — is the only thing the supervisor normally sees.

## Output

- **Quiet success:** one line, `panel #<N>: <kind> PASSED after <r> round(s); un-drafted.`
- **Failure:** a loud `panel #<N>: FAILED at <stage>` on stderr, non-zero exit.
- **Detail (on disk, not stdout):** `GARDEN_PANEL_RUNDIR/round-<r>.md` aggregates,
  `round-<r>.<seat>.md` per-seat blocks, and `appellate.md` proposals.

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
