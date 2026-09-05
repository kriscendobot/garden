---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-05): gauntlets have become more
numerous and expensive. Revise the `builder` and `designer` roles so that
completing a build or design **no longer automatically triggers a gauntlet**
going forward — running the gauntlet should become an explicit, separately
requested act (the vocabulary already exists: "run the gauntlet #N").

## What exists today (read before touching anything)

The auto-gauntlet behavior is a deliberately **three-layer enforcement
mechanism**, not a simple convenience hook, built specifically to close a past
incident class — the "design-PR gauntlet-bypass" review-misses cluster
(`kriskowal/garden#7`, `endojs/endo-but-for-bots#809`,
`kriscendobot/minion.town#41`: three garden-owned design/build PRs that reached
maintainer review with **zero** panel/review staged, because nothing forced it).
The three layers:

1. **Stager** — `scripts/jobs/auto-gauntlet-handoff.sh`, fired from the worker
   completion path (`gardener.sh`) for every completed job, not just
   `role: builder` (it branches: builder → feature/probe path, any other role →
   design-PR path). It posts the `jobs/gauntlet/<g>.md` record and drafts the PR
   into the staged-gauntlet pipeline.
2. **Sensor** — `scripts/jobs/assert-design-pr-gauntlet.sh`, ALSO fired at
   completion, independently re-derives whether the job produced a bot-authored
   OPEN DRAFT design-only PR and **fails the completion** (job stays in `doin`,
   reaper retries) unless a gauntlet record already covers it. This is the part
   that makes today's invariant load-bearing, not advisory: a design PR
   currently **cannot** reach `tada` without a staged gauntlet.
3. **Backstop audit** — `scripts/jobs/design-pr-gauntlet-coverage-audit.sh`, a
   standing periodic sweep catching anything the two completion-time layers
   missed (drift, race, non-draft-at-completion edge cases they deliberately
   step aside for).

`roles/builder/AGENT.md` and `roles/designer/AGENT.md` themselves don't invoke
this directly — CLAUDE.md documents it as a **standing invariant**: "The
build's draft PR auto-runs the gauntlet ... no separate run the gauntlet #N is
needed" (with probes as the sole existing exception, per
`skills/gap-revealing-build/SKILL.md`).

## What to design

1. **The new default**: a completed build/design PR stays draft (or open,
   whichever is currently correct) and gets **no** gauntlet staged unless
   something explicitly requests one. Decide the exact trigger surface — most
   likely the existing "run the gauntlet #N" verb posting a gardener job that
   stages the record directly (skill: `pr-creation-flow`) — and whether probes
   change at all (they already don't auto-gauntlet, so likely unaffected).
2. **How not to regress into the exact incident this replaces.** Silently
   removing all three layers reopens the "PR merges with zero review" failure
   mode outright — that is presumably NOT what "no automatic trigger" is meant
   to permit. Consider what minimum guardrail should remain: e.g. a PR simply
   never gets un-drafted / never becomes mergeable-ready without SOME explicit
   act (a maintainer's "run the gauntlet" or "merge" word), versus actively
   asserting a gauntlet was staged. The sensor's failure mode (blocking `tada`)
   is specifically what makes review non-optional today; think through what,
   if anything, replaces that property once the automatic stage is gone.
3. **Cost accounting**: since the stated reason is that gauntlets are "more
   numerous and expensive," consider whether the real fix is narrower than
   "never automatic" — e.g. automatic gauntlet only for garden's own repo (cheap,
   self-contained) vs. always-manual for fork/PR work on `endojs/endo-but-for-bots`
   and `kriscendobot/minion.town` (where the recent cost/volume growth actually
   happened — see the fleet's own recent gauntlet census if useful grounding).
   Present this as a real alternative, not just the literal ask, since the
   maintainer's stated problem (cost/volume) and the literal ask (no automatic
   trigger for builder/designer) may have a better-fitting middle answer.
4. **Files to update**: `roles/builder/AGENT.md`, `roles/designer/AGENT.md`,
   `CLAUDE.md` (the "auto-gauntlet invariant" language in the orchestrator
   vocabulary table and the "Two standing behaviors" framing elsewhere),
   `scripts/jobs/auto-gauntlet-handoff.sh`, `scripts/jobs/
   assert-design-pr-gauntlet.sh`, `scripts/jobs/design-pr-gauntlet-coverage-audit.sh`
   (retire, narrow, or repurpose — don't leave them enforcing a rule that no
   longer applies), and `skills/pr-creation-flow/SKILL.md`.

## Landing

This reverses safety-motivated automation with real incident history behind
it. Per CLAUDE.md's own carve-out (a design landed on this repo whose content
carries a non-empty `## Open questions` section gets a review PR, not a bare
landing) — this almost certainly belongs in that category: state the trade-off
explicitly, name what guardrail (if any) replaces the sensor's hard-fail
property, and let the maintainer decide before it's load-bearing.
