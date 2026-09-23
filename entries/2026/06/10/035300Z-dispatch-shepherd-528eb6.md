---
ts: 2026-06-10T03:53:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--528eb6
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4662462430
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/033100Z-result-builder-1f1de6.md
---

# dispatch: shepherd — drive PR #5 (agoric-sdk endo-sync mirror) CI to green per kriskowal directive

Maintainer directive on PR #5 (kriskowal at 2026-06-09T17:48:45Z,
issue comment `4662462430`):

> Pray shepherd.

The 👀 reactji is on the directive comment
(`reactions/367958203`).

PR #5 is the mirror of `Agoric/agoric-sdk#12527` (Endo dependency
sync) that builder `1f1de6` opened on the kriscendobot fork on
2026-06-09T03:31Z. The PR opened with 9 cherry-picked commits +
patch-set refresh; the version bump to the *current npm* Endo
versions (1.8.0/4.3.1/2.2.0) was documented in the PR body but
NOT landed because the root `yarn up` was blocked by
`eslint-plugin-import@catalog:dev: catalog "dev" not found or empty`.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`
  ("chore(deps): mirror Agoric/agoric-sdk#12527 (Endo sync) on
  current master"), DRAFT, base `master-daf7a86`, head
  `mirror/12527-endo-sync-refresh` at
  `962b1b5b9513e18e9b1c4d774c94810c7a07491e` (`962b1b5b9`).
  `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`.
- **CI on `962b1b5b9`**: 8 SUCCESS, 0 pending, 3 FAILURE:
  - `flake-check` — agoric-sdk's flaky-test detection meta-job.
    Diagnose first; this can be either a genuine flaky-test
    signal or a meta-failure about *which* test is the candidate.
  - `test-dapp (node-new)` — cross-package smoke on the newest
    Node LTS. Per agoric MAINTAINERS this is an **expected fail**
    on the node-new matrix; classify as `environment-acknowledge`
    unless evidence shows the failure is specifically this PR's.
  - `build (node-new)` — build on newest Node LTS. Could be a
    real failure tied to the patch refresh (Endo packages bumped
    in builder commit ladder) or pre-existing on master. Pull
    logs and classify.

## Task

In your `project/` worktree on
`mirror/12527-endo-sync-refresh` at `962b1b5b9`:

1. **Read** `garden/skills/pr-ci-watch/SKILL.md`,
   `garden/skills/ci-status-summary/SKILL.md` for the discipline.
   Read the builder's result entry
   (`journal/entries/2026/06/09/033100Z-result-builder-1f1de6.md`)
   for context: 9 commits cherry-picked clean; 6 patches deleted,
   1 renamed, 2 new; xsnap METER_TYPE unchanged; SwingSet
   snapshots regenerated; root `yarn up` blocked by
   `eslint-plugin-import@catalog:dev` (the npm-current-version
   bump was deferred).
2. **Per-failure diagnosis** via
   `gh run view <run-id> --log-failed --repo
   kriscendobot/agoric-sdk` for each of the 3 failures. Pre-count
   error lines (memory: pre-count via `grep -c error`).
3. **Classify each failure**:
   - **flake-shaped** (runner died, transient network, known
     intermittent): re-run via `gh run rerun <run-id> --failed`.
     Limit to two re-runs per job.
   - **environment-acknowledge** (test-dapp node-new is the
     prototype for this; document the prior agoric MAINTAINERS
     framing of node-new as expected-fail).
   - **substance fix-in-scope** (small change to land on this
     PR): apply, commit, push.
   - **substance escalate** `next: fixer` (out of shepherd scope):
     name the failure mode and the suggested fixer hand-off.
4. **If fix-in-scope edits land**: append-push to
   `mirror/12527-endo-sync-refresh` (DO NOT amend builder commits;
   DO NOT force-push). Re-watch CI to convergence.
5. **Post a top-level convergence summary** on PR #5 listing
   per-check terminal state, re-runs issued, any shepherd-side
   commits, classification per failure. End with: "CI in shape
   for review" if all-green or all-failures-acknowledge; OR
   "Escalating `next: fixer` for <reason>" if a substance issue
   needs the fixer.
6. **Reply on kriskowal's directive comment** (`4662462430`)
   confirming the dispatch's outcome. Short.

## Authorizations (per-action, forwarded by liaison)

- **Re-run failed CI jobs** via `gh run rerun --failed`. Up to
  two re-runs per job.
- **Push small shepherd-side fix commits** to
  `mirror/12527-endo-sync-refresh` (append push only; no amend
  of builder commits; no force-push).
- **Top-level summary comment** on PR #5. Standing maintainer-
  facing authority through the liaison's dispatch.
- **Reply on the directive comment**. Same authority.
- **Escalate to fixer** with `next: fixer` verdict if a failure
  is out-of-scope for shepherd.
- Do NOT re-request review (PR is DRAFT; the maintainer is
  watching directly).
- Do NOT mark the PR ready (gh pr ready); the maintainer un-drafts.

## Out of scope

- Do NOT attempt the deferred npm-version bump (1.8.0/4.3.1/2.2.0).
  That's a separate engagement once `eslint-plugin-import@catalog:dev`
  is unblocked.
- Do NOT touch the patch set, SwingSet snapshots, or xsnap
  METER_TYPE unless a CI failure log specifically points there.
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post branch tip SHAs (if any push lands).
- Per-failure diagnosis: pre-count, root cause, classification,
  addressing commit SHA if any.
- Re-runs issued (run-id + job + outcome).
- Convergence-summary comment URL.
- Reply URL on kriskowal's directive.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if green or all
  acknowledge-shaped; `next: fixer` with rationale if escalation
  is needed.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
