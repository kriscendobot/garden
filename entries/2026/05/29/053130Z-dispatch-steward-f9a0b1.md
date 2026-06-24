---
ts: 2026-05-29T05:31:30Z
kind: dispatch
role: steward
host: endolinbot
to: gardener
dispatch_root: /home/kris/dispatches/gardener--d94d11
refs:
  - entries/2026/05/29/053100Z-dispatch-steward-e8f9a0.md
  - entries/2026/05/29/051600Z-result-steward-c6d7e8.md
  - https://github.com/endojs/endo-but-for-bots/pull/376
---

# dispatch: gardener — investigate missed maintainer review on PR #376

Maintainer directive in steward's terminal session at 2026-05-29T05:29Z:
*"Dispatch the gardener to investigate why this was missed and fix."*
("this" = the steward did not pick up kriskowal's COMMENTED review on
PR #376 posted at 2026-05-29T05:01:20Z and act on it autonomously; the
maintainer had to point it out in the terminal session about 28
minutes later.)

## What happened

PR #376 is a contractor-authored DRAFT design PR for
`endo-gateway-mcp`. The contractor's designer dispatch opened it at
2026-05-29T04:12Z. The maintainer kriskowal submitted a COMMENTED
review with 6 inline comments at 05:01:20Z. The daemon-log Monitor
surfaced the events as they arrived (`PullRequestReviewCommentEvent`
×6 + `PullRequestReviewEvent`). The steward's parent-context Monitors
saw them all.

At 05:01Z the steward read the review and decided to defer to the
contractor's pipeline ("this is contractor's slot work; not steward's
concern"). The reasoning was that the PR was opened by the
contractor's designer dispatch, so the contractor would presumably
pick up the maintainer review on its next per-cycle scan.

**That deferral was wrong.** The maintainer expected the steward
to dispatch a designer to address the feedback, not wait for the
contractor to do it. The 28-minute gap until the maintainer's
terminal-session reminder is the failure mode.

## Investigate

Likely contributing factors to surface and fix:

1. **The `monitor-endo-but-for-bots` skill's
   `PullRequestReviewEvent` row** — what does it say about
   COMMENTED reviews from kriskowal/jcorbin on garden-authored
   PRs? If the per-skill rule says "loud → dispatch fixer/designer
   per PR shape," the steward should have followed that even though
   the PR was contractor-opened. If the rule is silent or
   ambiguous on contractor-vs-steward ownership, that's the gap
   to close.
2. **The steward's mental model of "contractor's slot work"** —
   nothing in the AGENT.md or in any skill says "defer to
   contractor on PRs the contractor opened." That was the steward's
   own invention this morning. Either codify it explicitly (with
   the right exception for maintainer-feedback events that the
   contractor's slot machinery may take 30+ min to process), or
   establish the opposite default (steward dispatches on
   maintainer feedback events on ANY garden-authored DRAFT PR,
   regardless of who opened it; the contractor's slot framework
   handles its own initial-PR-drafting work but the steward owns
   maintainer-feedback response).
3. **Concurrent-orchestrator coordination on shared PRs** — when
   both the steward and the contractor are alive on the same
   host, and a maintainer review lands on a contractor-opened PR,
   which orchestrator dispatches the response? The job-board
   pattern handles work items but not in-line response-to-
   feedback. Investigate whether the right pattern is (a) post a
   `respond-to-feedback` job to the board for either orchestrator
   to claim, or (b) the steward always handles maintainer-feedback
   on every garden-authored PR (the contractor's pipeline takes
   over once the response push lands), or (c) something else.

## Fix

After investigation, **land the structural change** that closes
the gap:

- Edit `roles/steward/AGENT.md` and/or `skills/monitor-endo-but-for-bots/SKILL.md`
  to clarify the ownership question.
- If a new sub-section or skill is needed, draft and commit it on
  `main` (per the gardener role's authority on garden-meta
  evolution).
- Add a *Notes from the field* row pointing at this dispatch and
  this morning's miss as the precipitating evidence.
- Commit the change with a descriptive message and push to
  `origin/main`.

## Per-action authorizations (forwarded)

- Edit role files and skill files on the garden's `main` branch.
  This is the gardener's standing authority and the user's
  directive explicitly authorizes it.
- Commit and push to `origin/main`. Authorized.

## Not authorized

- Action on `endojs/endo-but-for-bots` PRs or upstream. The
  designer dispatch (parallel to this one) handles the actual
  response to the maintainer review on #376; you investigate the
  process gap.
- Modify the contractor's slot machinery or role file beyond
  what's needed to clarify the ownership question.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/gardener--d94d11/garden/roles/COMMON.md`
2. `/home/kris/dispatches/gardener--d94d11/garden/roles/gardener/AGENT.md`
3. `garden/roles/steward/AGENT.md` — current state
4. `garden/skills/monitor-endo-but-for-bots/SKILL.md` — current state
5. `garden/skills/self-improvement/SKILL.md` — for the lesson-routing
   discipline.
6. Other skills as needed.

This dispatch has no project worktree; the work is all in
`garden/`. Your cwd is the dispatch root.

## Report

A `result` journal entry. Include: the investigation findings, the
specific files edited on `main`, the commit SHA on `origin/main`,
and any follow-up message(s) routed to liaison/steward for items
that fall outside the gardener's authority.
