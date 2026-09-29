---
tier: mentat
dispatch: manual
---
# Confirm (or deny) and, if confirmed, implement non-Claude completion-nudge parity

You have full authority here — confirm or overturn the landed design's
conclusion yourself, and if it holds, carry it all the way through
implementation, gauntlet, and merge. No maintainer check-in is required
before proceeding either way; report what you did and why when done.

## Context

`designs/non-claude-completion-nudge-parity.md` (landed on `main2`,
commit `5b002b64606`, from job `design-nudge-continue-handler-parity-20260929`)
concludes that Codex, Kimi, and OpenCode all support same-session
continuation (contrary to the maintainer's initial suspicion that this was an
irreducible capability gap), with verification numbers cited in its own
report: OpenCode harness 9/9, Kimi harness 33/33, Codex resume handling 7/7,
pre-push probes 10/10. It recommends bounded nudge parity for Codex and Kimi,
keeping OpenCode disabled pending its existing paid canary. It is design-only
— nothing has been implemented yet.

## Task

1. **Confirm or deny.** Read the design and re-derive its central claim
   yourself — does each handler's actual CLI genuinely support a same-session
   resume/continue primitive the way the design says? Don't just trust the
   cited pass counts; spot-check the underlying mechanism for at least the
   Codex and Kimi cases (the ones the design recommends actually wiring up).
   If you find the design's conclusion doesn't hold, say so plainly, correct
   the design document (or supersede it), and stop there — do not implement
   against a conclusion you've just disproven.
2. **If confirmed:** implement bounded completion-nudge and same-session
   `continue` parity for Codex and Kimi, matching the existing Claude/monk
   handler's shape (`skills/job-board/SKILL.md` § Dispatch and headless
   completion — "a bounded in-process completion nudge and a same-session
   `continue` prompt for unfinished end-turns"). Leave OpenCode disabled, per
   the design's own recommendation, until its paid canary resolves.
3. Open a draft PR on the garden's own repo... wait: the garden repo takes no
   PR workflow for its own changes (`CLAUDE.md` § Conventions) — commit and
   push directly to `main2` from a worktree off `origin/main2`, the same way
   other garden-library changes land. Run the project's own test suite
   (whatever covers `scripts/jobs/handlers/`) before pushing.
4. Report the confirm/deny verdict, what you implemented (or why you didn't),
   and the landed commit.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T21:09:12Z
