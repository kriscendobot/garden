---
ts: 2026-06-01T23:00:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriskowal/garden
project: garden
to: builder
dispatch_root: /home/kris/dispatches/builder--c597ae
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
  - entries/2026/06/01/223200Z-dispatch-steward-f6ddb6.md
  - entries/2026/06/01/223808Z-result-fixer-f6ddb6.md
  - entries/2026/06/01/223940Z-result-steward-f6ddb6.md
---

# dispatch: builder — implement driver from kriskowal/garden#3 design

kriskowal review on PR #3 (2026-06-01T22:58:40Z, review id
4405216188):

> Please dispatch a builder to implement the driver as described.
> This should surface clarifying questions. Please also ensure that
> the script is testable and tested, possibly using a mock garden.

Builds on the fixer pass `f6ddb6` (head `4ed88c93`) which incorporated
kriskowal's earlier review into the design doc.

## Task

Implement the driver as described in `designs/driver.md` (now at
head `4ed88c93`). The implementation lives on the `design/driver`
branch — same branch as the design, since the PR stays DRAFT until
maintainer un-drafts. Build incrementally:

1. **Skeleton first**: `roles/driver/driver.sh` accepting a single
   lane number argument (`./driver.sh 1`), with the error-trap →
   gardener-inbox pattern, `-x` subshell transcript capture, and a
   minimal state-machine scaffold. Get this committed and tested
   before adding workflow-specific state machines.

2. **Mock garden for testing**: kriskowal explicitly called for
   "possibly using a mock garden." The mock should let the driver
   exercise its state machine without touching the real
   `journal/`, `worktrees/`, or any upstream repo. A `tests/`
   directory with a setup script that creates a temporary mock
   garden (jail journal worktree, fake bare clone, stub
   `gh`/`git` shims as needed) is the natural shape.

3. **At least one workflow state machine end-to-end**: the simplest
   is probably the design-only-PR workflow (Phase 2 in the migration
   plan), because design PRs have no source-touching CI to wait on.
   Get one full happy-path exercised under the mock garden.

4. **Surface clarifying questions explicitly**: kriskowal asked for
   the implementation to surface clarifying questions. The builder
   should write any judgment calls or ambiguous-design-decision
   questions as a numbered list in the result entry. The dispatch
   journal entry from the fixer (`223200Z-dispatch-steward-f6ddb6`)
   and the result (`223940Z-result-steward-f6ddb6`) document what's
   already resolved; everything else surfaces.

5. **Commit shape**: one or more commits on `design/driver`,
   regular append push under `endolinbot` identity. Commit messages
   should follow the conventional pattern (`feat(driver): ...`,
   `test(driver): ...`, `chore(driver): ...`). The PR stays DRAFT;
   no PR comment posted.

## Scope boundaries

In-scope:
- `roles/driver/driver.sh` (the new role's executable)
- `roles/driver/AGENT.md` (operating brief, per the existing role
  layout convention)
- `skills/driver-*/SKILL.md` for any new skills the driver invokes
  (per the design's new artifact list: state machine, coalesced
  watcher, gardener-inbox reporting, pre-CI validation)
- `tests/driver/` or similar — the mock-garden test harness
- Any minor `designs/driver.md` clarifications that fall out of
  surfacing clarifying questions (only if the question can be
  answered deterministically by reading the design; otherwise
  surface in the result)

Out of scope:
- Touching `roles/steward/`, `roles/liaison/`, `roles/<other>/`
  configuration (the migration plan says these are preserved during
  the experiment).
- Implementing the *coalesced repo-activity watcher* (separate
  skill, separate dispatch).
- Implementing the *reactji-posting monitor* (separate skill,
  separate dispatch).
- Touching CI / GitHub Actions workflows.
- Touching `journal/` content outside the dispatched sub-worktree.
- Un-drafting the PR.
- Posting any PR comment or resolving any review thread.

## Per-action authorizations

- Create + edit files under `roles/driver/`, `skills/driver-*/`,
  `tests/driver/`. Authorized.
- Run `git add`, `git commit`. Authorized.
- Regular append push to `kriskowal/garden:design/driver`. Authorized
  (no force, no rewrite).
- Run the test harness locally (the mock-garden setup should make
  this self-contained). Authorized.

## Not authorized

- Modifying `roles/steward/AGENT.md`, `roles/liaison/AGENT.md`,
  `roles/<other-role>/AGENT.md` — those are preserved during the
  experiment per kriskowal's directive on line 272 of the design.
- Force-pushing or rewriting `design/driver` history.
- Touching any other branch.
- Posting a PR comment, resolving a review thread, or un-drafting.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--c597ae/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--c597ae/garden/roles/builder/AGENT.md`
3. `/home/kris/dispatches/builder--c597ae/project/designs/driver.md`
   (the design, at the updated head `4ed88c93`)
4. Skills referenced by the builder role just-in-time.

Project worktree at `project/` on `design/driver` (head
`4ed88c93`).

## Report

A `result` journal entry. Include:

- New head SHA after push (or list of new heads if multiple commits).
- List of files created / modified.
- A numbered list of clarifying questions raised (per kriskowal's
  explicit ask). Each question should name the design-doc location
  (line number or section heading) that the question relates to.
- Test results: which test cases pass, which fail, which were
  skipped and why. The mock garden setup + at-least-one workflow
  end-to-end happy-path should be running and passing.
- Confirmation that no PR comments were posted, no review threads
  resolved, PR remains DRAFT, no other PR or branch touched.

Surface clarifying questions liberally. The maintainer asked for
them; treat ambiguity as a feature, not a bug.
