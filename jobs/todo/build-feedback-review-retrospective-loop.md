<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-03T06:04:40Z -->

---
model: opus
---
# builder: implement the double-loop feedback-retrospective self-improvement mechanism

**Garden-infra build on `main2`** (isolated worktree off `origin/main2`; `git -C` discipline; explicit-pathspec commits; push `HEAD:main2`).

## Prerequisite

Build the mechanism designed by `design-feedback-retrospective` (its design doc under `designs/` in the garden repo — read it first; it is the spec). This job is blocked on that design and promoted when it lands.

## What to build (per the design; the shape kriskowal asked for)

For every PR comment the comment-watcher recognizes, in addition to the existing "address the feedback" job, dispatch a **second retrospective job** that:
1. Judges whether the comment is a genuine **review-process miss** (the review *should* have anticipated it) vs new/subjective direction — using the design's deterministic pre-filter + discriminator, so most comments do NOT spawn expensive work.
2. For a real miss: records a structured entry into the design's **review-miss store**, clustered by the design's failure-category taxonomy (root cause + which role/skill/juror-seat should have caught it).
3. Evaluates the design's **subjective threshold** against the cluster; when it trips, dispatches an **improvement job** scoped to the specific role / skill / context-library page / standing instruction, serving BOTH goals: **prevent** the error in the doing, and **add a review-cycle check** (juror-seat hint / `panel-hints` entry / panel-consulted skill) so the review catches it next time.

Wire it into the existing `comment-watcher`, `self-improvement`, `mentor`, `panel-hints`, and panel machinery rather than duplicating them. Keep the per-comment hot path cheap (deterministic pre-filter before any `claude -p`).

## Verify

Include a test / documented repro: a simulated review-miss comment produces the retrospective record; a cluster crossing the threshold produces an improvement job; a new-direction comment does NOT (the discriminator gates it); the existing "address the feedback" job is unaffected. Cite real runs per `garden/roles/COMMON.md` § Reporting.

## Definition of done

The double-loop is live in the gardener workflow per the design: comment → (1) address-feedback job [unchanged] + (2) retrospective job that records/clusters misses and, past the threshold, dispatches a prevention-plus-review-sensing improvement job. Tested, wired into existing machinery, landed on `main2` from an isolated worktree. Journal a `result` entry. Note it activates on the running fleet only after a deploy.
