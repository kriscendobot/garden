# Design: the gardening state machine as a supervised shell script

The v1 garden ran a PR through its lifecycle by having an **agent** walk a
checklist and hand off to the next subagent at each step. This generation keeps
the *same workflow* but moves the **state machine into a shell script** that a
gardener **supervises**. The script runs deterministic automation itself and
shells out to `claude -p` subagents only for *decisions* (how to proceed,
whether to loop). Scaffold: `scripts/jobs/gardening/garden-pr.sh`; heuristics:
`scripts/jobs/gardening/sense.sh`.

## Why a script, not an agent checklist

- **Determinism & cost.** Mechanical steps (rebase, run evals, push) don't need
  an LLM each time; a script does them reliably and cheaply. The LLM is reserved
  for genuine judgment calls.
- **Context protection.** The supervising agent's context is precious. The
  script is built to **write essentially nothing when it is working well** — its
  only output is the terminal state and any *real* failure. Routine progress
  does not flow into the supervisor's window.

## Supervisor responsibilities

- Invoke the script for a job; read its (small) output; react to a `loop` signal
  or a failure.
- **Evolve the script** when it fails in a fixable way — the state machine is
  data the supervisor owns and edits, then re-runs.
- **Divert debugging.** Tracing is opt-in and goes to a file, never stdout:
  `GARDEN_TRACE=1` makes the script `set -x` into `GARDEN_TRACE_LOG` (via
  `BASH_XTRACEFD`). The supervisor hands that trace log to a **dedicated
  debugging subagent**, so `set -x` noise never enters the supervisor's own
  context. The supervisor sees the debugger's conclusion, not the trace.

## Decision oracle

`decide "<question>"` shells to `claude -p` (overridable via `GARDEN_DECIDE` for
tests/non-interactive runs) for short answers like "rebase or skip?", "loop or
stop?". Decisions are small and explicit; everything else is deterministic.

## Heuristic gating (`sense.sh`)

Before running an automation that might be a waste of time, the script asks a
cheap heuristic whether it could matter. `sense.sh` is **quiet** (answers via
exit status: 0 = run it) and **biased toward false positives**:

- `changed-md <wt> [base]` — Markdown changed? (gate docs automation)
- `diff-keyword <wt> <kw> [base]` — keyword (e.g. `import`) in the diff hunks?
  (gate import-graph / dependency automation)
- `changed-glob <wt> <glob> [base]` / `any-change <wt> [base]`

**Asymmetry of error.** For *test/evaluation* triggers we can afford false
positives but not false negatives — skipping a needed check lets a regression
reach CI. So `sense.sh` answers **YES on any ambiguity** (missing base ref,
shallow clone, git error, unknown subcommand), and the state machine **does not
sense-gate the evaluation suite at all**: it errs toward running *all* evals
before submitting to GitHub CI. Sense-gating is only for *optional* automations
whose cost we want to avoid when a signal says they cannot matter.

## Stages (scaffold)

1. **rebase?** — sense whether the base moved; `decide` whether to rebase; do it.
2. **sense-gated automations** — docs/lint when Markdown changed; dependency
   checks when an `import` line moved; a workstation-coupling fixer when
   `detect-home-coupling.sh` finds a hardcoded `$HOME` in an added line; a
   comment-banner sweep when `detect-banners.sh` finds a decorative rule comment
   in an added code line; etc. (`run_if <sense…> -- <command…>`). Each
   deterministic detector is quiet-by-design and gates a best-effort `claude -p`
   handler.
3. **evaluation gate (always)** — run the project's eval suite; *no* sense-gate.
   False positives fine, false negatives unacceptable. The default eval runner is
   the deterministic, no-LLM pre-PR verification harness
   `scripts/jobs/gardening/local-verify.sh` (format/lint/build/test/docgen,
   silent on success, git-hash-capturing failures for selective debugging-agent
   inspection); see [local-verify](../skills/local-verify/SKILL.md). It is wired
   as `GARDEN_EVAL`; a project overrides that with its own runner when needed.
4. **push for CI** — deterministic (identity owned by the boatman for upstream).
5. **loop decision** — `decide` whether to wait on CI and loop, or stop. Emits
   `loop` to the supervisor or exits quietly.

The scaffold wires the rebase/push mechanics as placeholders where a project
plugs in its real commands; the `GARDEN_EVAL` gate now defaults to the
`local-verify` harness rather than the original `true` no-op. The control flow,
quiet-on-success discipline, diverted tracing, and heuristic gating are the
reusable parts.
