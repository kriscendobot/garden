---
ts: 2026-06-01T23:32:45Z
kind: dispatch
role: fixer
host: endolinbot
repo: kriskowal/garden
project: garden
to: "*"
dispatch_root: /home/kris/dispatches/fixer--94995b
short_id: 94995b
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405327036
---

# dispatch: fixer — PR #3 CHANGES_REQUESTED (driver CI + per-iter capture)

## Maintainer directive

> Please add a CI job that runs the driver script tests. Shepherd
> until tests pass in CI.
>
> Please alter driver.sh such that it runs the loop body inside
> of a context that captures the stdout and stderr of the current
> loop iteration and feeds this to an agent for analysis and
> self improvement.
>
> kriskowal CHANGES_REQUESTED at PR #3 review 4405327036
> (2026-06-01T23:26:59Z)

## Two deliverables

### A. CI job for driver tests

The garden has no `.github/workflows/` directory yet. Create one
with a workflow that:
- Runs on push to the `design/driver` branch (and on PR events
  against `main` once the design lands).
- Sets up bash + `shellcheck` (the repo's existing executables
  use `#!/usr/bin/env bash`).
- Runs the driver test harness (`tests/driver/...` from the prior
  builder's deliverable) and the cleaner skeleton test
  (`skills/cleaner/test-cleaner.sh`).
- Fails the job if any test fails.

Shepherd CI until green per `skills/ci-status-summary/SKILL.md`
(no `--watch` blocking polls).

### B. Per-iteration capture + analyzer feed in driver.sh

Modify `roles/driver/driver.sh` so each loop iteration's stdout
and stderr are captured in a context (subshell + redirect to a
per-iteration transcript file). After the iteration, the
transcript is "fed to an agent for analysis and self
improvement."

The existing ERR/EXIT trap captures the whole-driver transcript
via `git hash-object -w --stdin`. This new ask is per-iteration,
not whole-driver — every loop iteration produces an artifact,
not just failure cases.

The "feed to an agent" mechanism needs an architectural choice.
Options:
1. Post a job on `journal/jobs/analyzer/open/` for each
   iteration; an analyzer worker (LLM-backed) claims and
   produces a `result` entry.
2. Append the transcript hash + context to
   `journal/inboxes/<host>/gardener.md` (extending the existing
   ERR/EXIT pattern from failure-only to every-iteration).
3. Write to `journal/drivers/<host>/<lane>/iterations/` and let
   a per-driver analyzer process poll.

Pick the option that fits the existing patterns. Surface the
choice in a top-level PR comment so the maintainer can confirm.

Self-improvement framing: the analyzer's output is intended to
improve the driver / roles / skills over time, similar to the
existing `skills/self-improvement/SKILL.md` discipline but
deterministically applied at every iteration.

## Discipline

- Per `roles/fixer/AGENT.md`:
  - One atomic commit per concern
    (`skills/review-feedback-followup-commits/SKILL.md`).
  - `skills/pre-push-gates/SKILL.md` before pushing.
  - `skills/ci-status-summary/SKILL.md` for the shepherd phase.
- The garden's `.github/workflows/` is new ground — keep the
  workflow minimal; the `zizmor` audit on the garden may or may
  not exist (check before adding any GitHub Actions YAML).
- Reply on the maintainer review thread (PR #3) citing the
  addressing SHA per
  `skills/pr-review-thread-replies/SKILL.md`.
- Re-request review after CI is green per the role file's JSON-
  body shape (`echo '{"reviewers":["kriskowal"]}' | gh api ...`).

## Authorization

- PR #3 posting authorized by the maintainer's review body.
- The garden is the bot's own repo; no cross-fork etiquette
  issues.

## Acceptance

- CI workflow file added; CI green on the new head.
- `driver.sh` modified to capture per-iteration stdout/stderr
  and feed the transcript to the chosen analyzer mechanism.
- Top-level PR comment surfacing the architectural choice for
  the analyzer feed mechanism.
- Maintainer review re-requested.

## Concurrent-orchestrator note

Today has seen TWO concurrent-orchestrator collisions
(#244 weaver/fixer at 20:03Z; PR #3 builder/builder at 23:00Z).
The steward's `shepherd → fixer` auto-chain may also fire on
this CHANGES_REQUESTED within minutes of the liaison's dispatch.
This dispatched fixer should detect a non-fast-forward on first
push, defer to any prior orchestrator's work, and add only what
was missing.

## Report

Return:
- CI workflow path + CI run URL + final CI status.
- driver.sh diff summary (commit SHA + one-paragraph description
  of the per-iteration capture mechanism).
- Top-level PR comment URL surfacing the analyzer-feed
  architectural choice.
- Reply URL on the review thread.
- Final `Self-improvement: ...`.
