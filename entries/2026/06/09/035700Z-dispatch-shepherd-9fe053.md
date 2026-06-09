---
ts: 2026-06-09T03:57:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--9fe053
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655836014
  - https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655929663
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/035513Z-result-fixer-140d8f.md
---

# dispatch: shepherd — drive PR #75 CI to green after the gibson042-feedback carry commit

Follow-on dispatch in the chain kriskowal scripted at
2026-06-09T03:38:11Z on PR #75 (issue comment `4655836014`):

> Per accept all feedback in this final review
> https://github.com/endojs/endo/pull/3232#pullrequestreview-4445424009
> and append a single commit with your changes, **then shepherd**.

The fixer (`140d8f`) completed the carry; this shepherd handles the
"then shepherd" step.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#75`
  ("feat(random,chacha12): factor @endo/random from @endo/chacha12
  [resync to actual/kriskowal-random-chacha20]"), OPEN (not DRAFT),
  base `master`, head `kriskowal-random-chacha12` at
  `e627f7b13be2f048ecc35d1a8f7f0826ddf0c917` (`e627f7b13`).
  `reviewDecision: CHANGES_REQUESTED` (stale — pre-carry).
- **Carry commit**: `e627f7b13` —
  *"fix(random,chacha12): address gibson042 final review on endo#3232"*.
  Per the fixer's result entry
  (`journal/entries/2026/06/09/035513Z-result-fixer-140d8f.md`):
  seven upstream inline suggestions applied, one mirror-side ask
  folded in (`packages/chacha12-fast-check-test/package.json` exports
  collapse), local `pre-push-gates`/`yarn build`/`yarn lint` green.
- **Initial CI snapshot at 03:57Z**: 8 SUCCESS, 9 pending, 0 FAILURE.
  Pending: browser-tests, lint, test-ocapn-guile-interop, test
  (22.x ubuntu/macos, 24.x ubuntu/macos), cover, viable-release.

## Task

In your `project/` worktree on the `kriskowal-random-chacha12`
branch at `e627f7b13`:

1. **Poll CI to convergence** via
   `garden/skills/pr-ci-watch/SKILL.md`. Watch all checks to a
   terminal state (SUCCESS or FAILURE). The fixer's local gates
   passed, so first-failure-on-real-issues is unlikely but not
   impossible (test-ocapn-guile-interop and browser-tests
   historically have flake patterns).
2. **Classify each failure** per `garden/skills/ci-status-summary/SKILL.md`
   when convergence shows red:
   - **Flake-shaped** (timeout, runner died, network hiccup, known
     intermittent): re-run the failed job via
     `gh run rerun <run-id> --failed`. Limit to two re-runs per
     job before escalating.
   - **Real failure** (deterministic test failure, build error,
     lint regression): diagnose via `gh run view --log-failed`,
     pre-count error lines (memory: pre-count via
     `grep -c error` on the log to gauge scope), and decide:
     in-scope (shepherd fixes in place) vs. out-of-scope
     (escalate to fixer with `next: fixer` verdict per the
     auto-chain rule).
3. **If in-scope shepherd fix is warranted**: edit, append a small
   chore-scoped commit (do NOT amend `e627f7b13`; that's the
   carry commit naming the maintainer's directive), push to
   `kriskowal-random-chacha12`, watch CI again.
4. **Once green**: post a top-level comment on PR #75 summarizing
   the convergence — green-check list, any re-runs needed, any
   shepherd-side commits added. Re-request review from kriskowal
   (the prior CHANGES_REQUESTED was on the pre-carry head; with
   feedback now applied AND CI green, re-request closes the loop
   the maintainer scripted).

## Authorizations (per-action, forwarded by steward)

- **Re-run failed CI jobs** via `gh run rerun --failed`. Up to
  two re-runs per job; beyond that, escalate.
- **Push small shepherd-side fix commits** to
  `kriskowal-random-chacha12` (append push only — no amend, no
  force-push). Implicit in the shepherd dispatch.
- **Top-level summary comment** on PR #75. Standing
  `endo-but-for-bots` broad-comment authorization.
- **Re-request review** from kriskowal once CI is green. The
  maintainer's chain explicitly ends with "shepherd"; closing the
  loop via re-request is the natural terminator.
- **Escalate to fixer** with `next: fixer` verdict if a failure is
  out-of-scope for shepherd. The steward auto-chains per memory
  rule *Auto-chain shepherd → fixer when shepherd escalates*; the
  shepherd just names the escalation.

## Out of scope

- Do NOT rebase or force-push. Append push only.
- Do NOT amend `e627f7b13` — that commit names the maintainer's
  directive and stays as the carry artifact.
- Do NOT touch the upstream endojs/endo#3232 PR.
- Do NOT mark the PR DRAFT.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- Per-check terminal state.
- Re-runs issued (run-id + job name + outcome).
- Any shepherd-side fix commits (SHA + scope + justification).
- The convergence-summary comment URL.
- Re-request-review URL/status.
- Escalation verdict (`next: fixer` with rationale) if applicable.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
