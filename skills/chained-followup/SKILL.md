---
created: 2026-08-14
updated: 2026-08-14
author: gardener
---

# Skill: chained-followup

Wire a follow-up job that must run **only after a design advances to a build** —
across a repo boundary, on an event no single job's completion cleanly names. Use
this when the work here depends on *another* design maturing (design → build →
landed), and posting a blind follow-up now would fire it far too early.

## Purpose

The maintainer's standing directive (kriskowal, kriscendobot/minion.town#41): when a
review says *"post a job to design X, and a follow-up to act on that implementation
here, triggered when it lands,"* do **not** post the follow-up straight into `todo/`.
Its precondition — a design that has not been built yet — is not satisfied, so it
would run against nothing. Instead introduce **a level of indirection**: a *notice*
job that watches the design advance to build and only then schedules the real
follow-up, anchored on that change. This skill is the reusable shape of that chain.

The garden already sequences jobs by board state — `blocked_on` + the unblock
watcher ([job-board](../job-board/SKILL.md)), and [orchestration](../orchestration/SKILL.md)
for multi-child fan-out. Those anchor on a **board base reaching `tada/`**. A chained
follow-up is the case those cannot express directly: the trigger is not "job D
finished" but "the design D produced has itself grown a build" — a *second-order*
event that lives in the project repo (a design PR merged, or a build PR opened
against it), not on the board. The indirection job is what turns that second-order
event back into a first-order board post.

## The shape: D → N → F

Three jobs, not one:

- **D — the design job.** The upstream design, posted normally to `todo/`
  (`post-job.sh`), typically in another repo (e.g. a daemon/formula design on
  `endojs/endo-but-for-bots`). Its deliverable is a design PR.
- **N — the notice (sentinel) job.** Posted **parked, blocked on D**
  (`post-plan.sh --blocked --blocked-on <D-base> <N-base>`). The unblock watcher
  promotes N when D reaches `tada/` — i.e. as soon as the design work is *done*, not
  before. N's whole job is the second-order check: has D's design **advanced to a
  build**? It reads the project repo deterministically (design PR state; whether a
  build PR exists that references the design) and branches:
  - **advanced to build** → N posts **F** (`post-job.sh`) with the concrete
    act-on-the-implementation body, anchored on the build (name the build PR/commit
    in F's body), and completes.
  - **not yet built** (design merged but no build; or design still open; or design
    declined) → N does **not** post F. It re-arms itself — re-park blocked on the
    build artifact if one is now nameable, or re-post itself blocked on D again / on
    a short `once:` schedule — and completes, so the notice recurs cheaply instead of
    firing F prematurely or dropping the thread. N never guesses; a declined design
    ends the chain with a note to the maintainer, not a follow-up against nothing.
- **F — the follow-up job.** The real work here. **Posted by N, never up front.**
  Because F is minted only when the trigger is real, it always runs against an
  implementation that exists.

The indirection is N. It converts "the design matured" (an event no `tada/` names)
into a board post, exactly when — and only if — the maturation happened.

## Procedure

1. **Post D** to `todo/`:
   `post-job.sh <D-base> <body>` — the design, in its home repo, with the design
   guidance and a back-reference to the originating PR/review.
2. **Post N parked, blocked on D:**
   `post-plan.sh --blocked --blocked-on <D-base> <N-base> <body>`.
   N's body must (a) name D, (b) spell the deterministic "advanced to build?" check
   against the project repo, (c) give the exact F-post command for the yes branch,
   and (d) give the re-arm action for the no branch. Keep the check **read-only and
   mechanical** — a `gh` PR-state query, not an LLM judgement — so N is cheap and
   safe to recur.
3. **Do NOT post F now.** F's body lives inside N's instructions; N posts it.

For a plain two-step dependency where the trigger really *is* "D finished" (no
second-order build event), skip N — a single `post-plan.sh --blocked --blocked-on D
F` is the lighter tool. Reach for the D→N→F chain only when the anchor is a design
*advancing*, which a bare `blocked_on` edge cannot see.

## Anchoring choices (pick the cheapest that is faithful)

- **`--blocked-on <D-base>`** (used above): promotes N when D completes. Simplest;
  N then does the build check itself. Preferred default.
- **`--blocked-on <PR-URL>`**: if the build will land as a *known* PR, N can block
  directly on that PR's merge and skip the recheck. Rare — usually the build PR
  number is not known when the chain is set up.
- **A `once:`/recurring sentinel schedule** ([schedule](../schedule/SKILL.md)) with a
  deterministic `preflight:` gate that exits 2 until the build exists: use when there
  is *no* board base to block on (the design is authored outside the fleet). The gate
  is the "advanced to build?" check; when it passes, the dispatched tick posts F.

## Pitfalls

- **Never post F up front.** A follow-up parked in `todo/` (or even plain
  `--deferred`, which the foreman auto-promotes) runs before the implementation
  exists. F must be minted *by* N.
- **The trigger is build, not design-done.** D reaching `tada/` means the *design*
  is written, not built. N must check the second-order event, not treat D's
  completion as the landing.
- **Re-arm on the no branch; do not drop the thread.** A design that merged but
  isn't built yet, or is still in review, must leave N (or an equivalent sentinel)
  live. Completing N with neither F nor a re-arm silently forgets the follow-up.
- **A declined design ends the chain deliberately** — with a maintainer note, not an
  F against nothing. Distinguish "not yet" (re-arm) from "never" (stop + report).
- **Read-only, deterministic check.** N's build detection is a `gh` metadata query
  in plain code, not a model reading untrusted PR prose (prompt-injection
  discipline, roles/COMMON.md). Keep the LLM out of the gate.

## Notes from the field

- _2026-08-14_: authored per kriscendobot/minion.town#41 review — the daemon-native
  "commit" formula design (D) on endo-but-for-bots, whose landing must trigger a
  minion.town git-remote follow-up (F). The review explicitly asked the gardener to
  "prepare a skill for this style of chained follow-ups"; this is it. First live use:
  the D→N→F chain posted for that PR (D `ebfb-daemon-commit-formula-design`, N
  `mtown-git-remote-followup-notice`, F minted by N).
