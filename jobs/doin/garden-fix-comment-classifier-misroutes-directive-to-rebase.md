# garden-infra fix: comment-watcher fallback misroutes feature directives to a code verb

## Symptom
A maintainer comment on endojs/endo-but-for-bots PR #405
(https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4819835663)
was a feature-refinement directive ("hide empty groups; regroup the inventory
into Directories / Agents / Personas / Values / Capabilities"). The
comment-watcher's ambiguity fallback (scripts/jobs/handlers/comment-claude.sh)
classified it as "rebase", producing job
'endojs-endo-but-for-bots-pr405-rebase'. The branch was already MERGEABLE, so
the resulting job had no real work to do, and the actual directive would have
been silently dropped had the claiming gardener executed the literal map.

## Root cause
comment-claude.sh forces `claude -p` to pick exactly one token from
`rebase | retcon | refresh | shepherd | gauntlet | attention | skip`. There is
no verb for "implement a feature change / fix the code", and the model chose a
code-mechanics verb (rebase) instead of the catch-all `attention` that the
header comment says is for "a genuine directive that needs a human-routed read".

## Fix to make (garden-infra discipline: isolated worktree off origin/main2)
1. Harden the fallback prompt in scripts/jobs/handlers/comment-claude.sh so a
   genuine implementation/feature/design directive that matches none of the
   mechanical verbs (rebase/retcon/refresh/shepherd/gauntlet) routes to
   `attention`, not to a mechanical verb guessed at random. Make the prompt
   state explicitly: the mechanical verbs are ONLY for their literal git/CI
   operation; anything asking to change behavior, UI, or code is `attention`.
2. Consider whether the deterministic verb table upstream of this fallback
   (in scripts/jobs/comment-watcher.sh) should also recognize that a directive
   naming a feature change with no mechanical verb is `attention` by default.
3. Add/extend a test under scripts/jobs/test/ that feeds a feature-change
   comment body and asserts the fallback returns `attention` (not a mechanical
   verb). The PR #405 comment body is a good fixture.

## Out of scope for this job
The PR #405 feature directive itself is being routed to the maintainer/liaison
separately (maintainer inbox message from the pr405-rebase gardener). This job
fixes only the classifier so future feature directives do not get misrouted.

---
claim:
  host: endolinbot
  gardener: 95
  claimed_at: 2026-06-27T17:55:15Z
