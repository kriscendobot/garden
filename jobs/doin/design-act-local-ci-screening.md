---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: integrate `act` (nektos/act) into the garden's pre-push verification

Maintainer directive (kriskowal, liaison session 2026-10-03): "There's a tool
called 'act' for running GitHub Actions locally. We might be more efficient
with CI action limits if we were anticipating failures by running the jobs
that we can locally. Please post a job to integrate 'act' in our gardener
workflows in advance of pushing to GitHub, to the extent it makes sense to
screen. That is, we have neither the means nor the need to run the Mac-specific
or Windows-specific CI jobs." Context: the fleet hit a real Actions-budget/CI
hiccup today (several gauntlets halted on red CI that turned out to clear on
retry — `ebfb-red-ci-gauntlets-resume-20261003`), which is what prompted this.

## Where this fits — read first

The garden already has a deterministic, no-LLM pre-push verification layer:
[`skills/local-verify/SKILL.md`](../../skills/local-verify/SKILL.md) (executable
`scripts/jobs/gardening/local-verify.sh`) and
[`skills/pre-push-gates/SKILL.md`](../../skills/pre-push-gates/SKILL.md)
(executable `scripts/jobs/gardening/pre-push-gates.sh`). Both exist specifically
to run CI's real lint/test/typecheck steps locally before every push, per the
maintainer's standing policy that **any CI failure is an automation defect**
(`local-verify`'s "Parity is the contract" section, and the
`ci-failure-is-automation-defect` precedent). Read both in full before
designing anything new.

**This means `act` is not a replacement for that layer — it's a different kind
of check.** `local-verify.sh` runs the project's package-manager scripts
directly (fast, no container, hand-maintained parity table). `act` instead
replays the actual GitHub Actions **workflow YAML** inside containers,
catching the class of defect `local-verify` structurally cannot: drift between
the hand-maintained local parity table and what the workflow file actually
does (setup steps, caching, env vars, matrix dimensions, a repo-root check a
per-package script misses — see the `endo-root-tsc-checkjs-ci-gap` precedent
for exactly this shape of gap). Design `act`'s role as **a parity-auditing
cross-check against `local-verify`'s candidate table**, not a parallel or
redundant gate. Where `act` catches something `local-verify` would have
missed, that's a `local-verify` coverage-gap bug to fix — the same disposition
`local-verify`'s own skill doc already prescribes for a local/CI discrepancy.

## Hard scope boundary (per the directive)

**Linux/`ubuntu-*`-runner jobs only.** `act` runs workflow jobs in Docker
containers and cannot execute a `macos-*` or `windows-*` runner's actual
environment — do not attempt to emulate or stub those; just skip any workflow
job whose `runs-on` isn't a Linux runner. Enumerate target repos' actual
workflow YAML (`endojs/endo-but-for-bots`, `kriscendobot/minion.town`, and any
other repo the fleet regularly gauntlets) to see what fraction of each
project's CI matrix is actually Linux-runnable and therefore in scope.

## The open feasibility question — investigate before designing further

`act`'s default (and primary documented) execution mode requires a **Docker
daemon** to spin up each job's runner container. I checked just now: **this
liaison's container has no `docker` binary and no Docker daemon** (`which
docker` → not found). Before writing a design that assumes `act` just works,
determine:

1. Does the **gardener's** execution environment (where `local-verify.sh` and
   `pre-push-gates.sh` actually run — check `scripts/jobs/gardening/` and how
   a gardener job's sandbox is constructed) have Docker access, even if this
   liaison session's container doesn't? They may not be the same sandbox.
2. If no Docker is available anywhere in the fleet's execution path, does
   `act` have a workable non-container ("host") execution mode for simple
   Linux-only jobs, and is it trustworthy enough to use here? Check `act`'s
   actual current documentation/flags — don't guess the syntax from memory.
3. If neither of the above holds, say so plainly and propose the real
   alternative (e.g., a host-level check outside the gardener's sandbox,
   gated behind a sysop op in the vocabulary `designs/sysop.md` already
   defines — or recommend NOT integrating `act` and explain why, citing the
   concrete blocker). A design that correctly concludes "infeasible as asked,
   here's why, here's what would unblock it" is a complete and useful
   deliverable — don't force a broken integration to appear to satisfy the
   ask.

## Deliverable

A design doc at `designs/act-local-ci-screening.md` (or whatever slug you find
more apt) covering: the feasibility finding above; which workflow jobs across
the fleet's actively-gauntleted repos are in scope (Linux-only); where this
hooks into the existing pipeline (a new step in `pre-push-gates.sh`,
`local-verify.sh`, or a separate opt-in script run less often given containers
are heavier than plain script runs); expected cost/benefit (CI-minutes saved
vs. local compute/time spent per push); and an explicit `## Open questions`
section for anything that's a real maintainer call rather than an engineering
judgment call (per `roles/designer/AGENT.md` operating norms — this repo's own
convention is direct-to-`main2` unless open questions require a review PR).
Do not implement in this job; a build job follows once the design lands.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T04:33:53Z
