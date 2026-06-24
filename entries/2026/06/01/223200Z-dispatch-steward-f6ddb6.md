---
ts: 2026-06-01T22:32:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriskowal/garden
project: garden
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f6ddb6
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
---

# dispatch: fixer — kriskowal/garden#3 driver design review feedback

User directive: address kriskowal's review feedback on PR #3
(`design/driver`, kriscendobot-authored, DRAFT) by amending
`designs/driver.md` and (where applicable) `designs/README.md`.

This PR is the documented exception to the garden's "no PR workflows
for the garden's own repo" rule: a design proposal for a
script-orchestrated PR-creation flow ("driver"). DRAFT and remains DRAFT
after fixer completes.

## Review feedback to incorporate

### Top-level review body (COMMENTED, 2026-06-01T22:20:01Z)

1. **Errors → gardener inbox.** Establish a pattern: unexpected error
   in any driver shell script sends a message to the gardener's inbox
   (`journal/inboxes/<host>/gardener.md`). Each *numbered* driver gets
   its own mailbox (per the lane-number model in the inline comments).

2. **Coalesce the repo activity watcher** into a single process that
   deterministically appends messages to relevant inboxes in the
   journal. Drivers advertise which PRs they're subscribed to so the
   watcher knows the fanout.

3. **A driver picks up many kinds of job, including observing an
   error.** Multi-job-kind capability, not just per-PR work.

4. **Reactji-posting moves to the deterministic repo-activity
   monitor**, not an agent. Should make eyes-reactji more reliable.

5. **Worktree setup and teardown** are deterministic and driver-run
   (currently dispatched-Agent-side).

6. **Driver runs validation before CI handoff**: `yarn format`,
   tests relevant to changes, then `yarn build:types:check`,
   `yarn lint`, full tests, docs generation — *before* push to CI.

7. **Role-specific driver workflows.** A driver can pick up a job to
   respond to an issue, respond to a build request, a design request,
   a retcon/rebase. Classifying which role to dispatch may continue
   to be by inference (LLM-classified ok where deterministic
   predicate isn't feasible).

### Inline comments on `designs/driver.md`

- **Line 260** (Q1 Worker pool sizing): "I will manually scale the
  pool of concurrent drivers."
- **Line 262** (Q2 Failure modes for LLM): "Exponential backoff with
  full jitter." (for the `awaits-llm` retry timer)
- **Line 264** (Q3 Observability or related): "I will manually scale
  the driver pool. Each driver should be given a lane number when
  invoking the shell script."
- **Line 266**: "Nothing to change here."
- **Line 270**: "Fine."
- **Line 272** (Q8 Liaison & steward retention or migration): "This
  new workflow is experimental and existing systems should be
  preserved."
- **Line 274** (Q8 follow-on / scan-retirement): "We will keep these
  for now and dispatch through the drivers manually until that
  system is reliable."
- **Line 276** (Q9 Driver supervisor): "I am going to invoke the
  driver manually, like `roles/driver/driver.sh 1` for driver one.
  It should be bot supervised in the sense that it will trap all
  errors and report them to the gardener, with a transcript of the
  failure. This may require subshelling with `-x` so that there's
  an artifact to submit to the gardener."

The fixer should read each comment in context (use
`gh api 'repos/kriskowal/garden/pulls/3/comments?per_page=100'`
for the canonical anchor lines, since line numbers may shift after
edits).

## Task

Amend `designs/driver.md` to:

1. Resolve open questions that have direct kriskowal answers (lines
   260, 262, 264, 266, 270, 272, 274, 276). Convert them from
   "open" to "resolved with **Disposition:**" sub-sections; carry
   forward kriskowal's verbatim choice where it's unambiguous.

2. Add the top-level review themes as new design sections (or expand
   existing ones):
   - **Error reporting → gardener inbox** with per-lane mailbox
     fanout
   - **Coalesced repo-activity watcher** with driver PR-subscription
     advertising
   - **Multi-job-kind drivers** (not just per-PR)
   - **Reactji posting** as a deterministic monitor responsibility,
     not an agent action
   - **Deterministic worktree lifecycle** (setup + teardown by
     driver, not subagent)
   - **Driver-run pre-CI validation** (`yarn format` + relevant
     tests + full test/lint/docs before push)
   - **Role-specific driver workflows** with classification-by-
     inference where deterministic predicate is infeasible

3. Update the migration plan to reflect: experimental nature with
   *existing systems preserved*; manual dispatch through drivers
   first, until reliable; retire scan only after ≥95% reliability
   is observed.

4. Tighten the driver supervisor section (Q9) to the manual `driver.sh
   <lane>` invocation pattern with `-x` transcript subshelling and
   gardener-inbox error reporting.

The PR stays DRAFT. No comment posted on the PR — kriskowal's
threads should be resolved via PR-thread resolution after a follow-up
maintainer pass (separate dispatch if desired). The commit should be
a single chore commit on `design/driver`.

## Commit shape

```
design(driver): incorporate review feedback (kriskowal)

Address comments on PR #3:
- Resolve open questions 1, 2, ... with kriskowal's dispositions.
- Add sections for error→gardener-inbox, coalesced watcher,
  multi-job drivers, deterministic reactji, deterministic worktree
  lifecycle, pre-CI validation, role-specific workflows.
- Update migration plan: experimental, preserve existing systems,
  manual driver dispatch until reliable.
- Tighten driver supervisor: `driver.sh <lane>`, `-x` transcript,
  gardener-inbox error fan-out.
```

Force-with-lease push to `design/driver` is the right shape (append,
not rewrite — so a regular append push `git push origin
HEAD:design/driver` is fine; `--force-with-lease` is only needed
if the fixer wants to amend or rebase, which it should not).

## Per-action authorizations

- Edit `designs/driver.md` and `designs/README.md` (if needed for
  cross-references). Authorized.
- Run `git add`, `git commit` on the project worktree. Authorized.
- Regular append push to `kriskowal/garden:design/driver` under the
  bot identity (`endolinbot`). Authorized.

## Not authorized

- Force-pushing or rewriting `design/driver` history. The PR's
  commits are append-only.
- Un-drafting the PR (kriskowal directive: PR stays DRAFT until
  maintainer un-drafts).
- Posting any PR comment or resolving any review thread (a follow-up
  maintainer pass handles thread resolution).
- Modifying `roles/`, `skills/`, or `journal/` content. This is a
  design-doc edit only; no implementation work.
- Touching any other PR or branch.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--f6ddb6/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--f6ddb6/garden/roles/fixer/AGENT.md`
3. Skills referenced by the fixer just-in-time. The
   review-feedback-followup-commits skill is the closest existing
   match for the shape of work, but the target is a design doc
   rather than a feature implementation; adapt accordingly.

Project worktree at `project/` on `design/driver` (head
`d6efe0d3`).

## Report

A `result` journal entry. Include:
- New head SHA after push.
- Diff stat for `designs/driver.md` (and `designs/README.md` if
  touched).
- Which kriskowal comment lines were directly resolved (by line
  number), and which top-level themes were folded in.
- Local verification: confirm the file parses as markdown and that
  the open-questions section reads coherently.
- No PR comments posted (confirmation).
