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

1. **rebase?** — a deterministic fresh-base/head check, then a safe rebase, run by
   `scripts/jobs/gardening/safe-rebase.sh` (wired as `GARDEN_SAFE_REBASE`). It
   compares HEAD to the (optionally freshly-fetched) base by ancestry: a branch that
   already carries the base tip is a quiet no-op; otherwise it replays the reviewed
   commits onto the fresh base. The one conflict class it resolves is a **lockfile-only
   conflict** — drop the stale `chore: Update yarn.lock` commit and regenerate the
   lockfile against the new base (skills/conflict-resolution § generated files;
   yarn-lock-separate-commit § Rebase recovery). ANY other conflict fails closed
   (rc 3) for a weaver/fixer rather than being resolved on agent discretion. This
   automates the routine stale-branch recovery a gardener did by hand for the approved
   Dependabot PR endojs/endo-but-for-bots#868. No `decide` call: freshness and the
   lockfile-only test are deterministic, and a real conflict is escalated, not judged.
2. **sense-gated automations** — docs/lint when Markdown changed; dependency
   checks when an `import` line moved; a workstation-coupling fixer when
   `detect-home-coupling.sh` finds a hardcoded `$HOME` in an added line; a
   comment-banner sweep when `detect-banners.sh` finds a decorative rule comment
   in an added code line; etc. (`run_if <sense…> -- <command…>`). Each
   deterministic detector is quiet-by-design and gates a best-effort `claude -p`
   handler.
3. **pre-push gate (always)** — run
   `scripts/jobs/gardening/pre-push-gates.sh`. It applies the project's
   format/lint fixers, runs every executable garden-specific probe, and runs
   typecheck. Any surviving finding blocks the push.
4. **evaluation gate (always)** — run the project's eval suite; *no* sense-gate.
   False positives fine, false negatives unacceptable. The default eval runner is
   the deterministic, no-LLM pre-PR verification harness
   `scripts/jobs/gardening/local-verify.sh` (format/lint/build/test/docgen,
   silent on success, git-hash-capturing failures for selective debugging-agent
   inspection); see [local-verify](../skills/local-verify/SKILL.md). It is wired
   as `GARDEN_EVAL`; a project overrides that with its own runner when needed.
5. **push for CI** — deterministic (identity owned by the boatman for upstream).
6. **loop decision** — `decide` whether to wait on CI and loop, or stop. Emits
   `loop` to the supervisor or exits quietly.

## Build handoff invariant

The builder's initial draft PR is followed by a durable board edge, not merely a
prompt instruction. When `gardener.sh` sees a genuinely completed `role: builder`
job, `auto-gauntlet-handoff.sh` extracts its reported PR URL and queries GitHub.
For an open draft feature PR it posts the idempotent `<build-base>-gauntlet` job
before the build can move from `doin/` to `tada/`. The posted job records the
source build and PR URL, which makes the handoff visible on the journal board.
A failed post leaves the build claim unfinished for requeue rather than silently
stranding a draft PR. Probe builds are recognized from their gap-revealing PR/body
annotation and deliberately skip this edge.

**"Reported" is load-bearing: only the completion report may name the build's own
PR.** A PR the build opened did not exist when the job was posted, so a GitHub PR
URL in the **job file** is by construction a *citation* — a PR the producer told the
build about — and never an artifact the build created. The hook originally scraped
both documents and took the first match, which on 2026-07-29 let the garden-`main2`
build `fix-pr-feedback-preflight-argv-e2big` (which opened no PR at all, and merely
cited the PR whose preflight had crashed) force-draft endojs/endo-but-for-bots#671 —
ready-for-review since 07-11, and under a live peer worker at that moment — and mint
a gauntlet to review it "cold". The hook now reads the report only, and logs a
job-file citation explicitly as a non-artifact. The deliberate trade: a builder that
pushed to a pre-existing PR named only in its job file loses its automatic handoff.
That is the right side to fail on — a missed handoff is still caught by the foreman
and the watchers, whereas force-drafting a live PR corrupts another worker's
in-flight work and nothing downstream can catch it.

**Second artifact test: the PR author must be the bot.** The report-only rule closes
the job-file path but not a completion report that cites *another author's* PR by full
URL (a related-work link), which the report scrape would still take as the build's own.
A build opens its PR under the bot identity (the fleet's `gh` wrapper pins every call
to it), so a PR authored by anyone else cannot be a build artifact no matter which
document named it. The hook now also queries `.author.login` and skips the handoff,
untouched, when it is not the bot. This is what closes the sibling incident on
2026-07-29: the build `fix-botanist-scripts-enabled-install-gap` (which opened no PR of
its own) named the live dependabot `@noble/curves` bump endojs/endo-but-for-bots#867 —
a PR a botanist had just cleared MERGE-NOW and that was waiting on the maintainer's
approval — as the botany that surfaced its gap, and the hook force-drafted it out of the
maintainer's queue, blocking its merge. The check runs before any mutation, so a
mis-identified PR is never re-drafted first.

The rebase and push mechanics are now real deterministic helpers, not placeholders:
the rebase stage defaults to `safe-rebase.sh` (fresh-base/head check, lockfile-only
recovery, fail-closed on any other conflict) and the push stage to
`safe-push-pr-head.sh` (never rewinds a peer's newer commits); both are quiet no-ops
under the scaffold's default `base` (`HEAD~1`) / unset remote wiring, and both are
overridable per project (`GARDEN_SAFE_REBASE` / `GARDEN_SAFE_PUSH`). The `GARDEN_EVAL`
gate likewise defaults to the `local-verify` harness rather than the original `true`
no-op. The control flow, quiet-on-success discipline, diverted tracing, and heuristic
gating are the reusable parts.
