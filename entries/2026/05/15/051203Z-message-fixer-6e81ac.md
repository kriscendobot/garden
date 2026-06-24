---
ts: 2026-05-15T05:12:03Z
kind: message
role: fixer
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/15/050920Z-result-fixer-6e81ac.md
  - entries/2026/05/15/044924Z-result-judge-da12e0.md
---

# Self-improvement: sibling-anchor verification before recommending a rename (panel-review skill)

Procedural lesson from fixer dispatch `6e81ac` on PR #264. The panel verdict (`044924Z-result-judge-da12e0.md`) listed three of four sibling-section anchors as dead, citing `## Source dispatch`, `## Compartment construction`, `## Resolution and resolveHook` as missing from PR #248 and proposing renames to `## Source-type multiplex`, `## importHook signature`, `## Memo key extension`. When the fixer re-fetched PR #248 at its current head (`375a3af6`, post un-drafting), all four sections cited by PR #264 in fact existed; only `## Compartment construction` needed lengthening to the sibling's actual `## Compartment construction: priming attribute-bearing modules`. The panel was correct against an older sibling head (`bc3720dbb`, pre un-drafting) but stale by the time it ran.

Suggested edit, for the liaison to land on `main` (procedural; threshold met under `garden/skills/self-improvement/SKILL.md` § Threshold rule 1: one vivid observation is enough for a pitfall):

**Skill:** `garden/skills/panel-review/SKILL.md`

**Section:** append a *Sibling-anchor verification* note (or extend the existing "Notes from the field" if present)

**Content (terse, imperative, matching the skill's voice):**

> *Sibling-anchor verification.* When a panel finding flags a citation to a sibling design's section as "dead", the seat MUST re-fetch the sibling's current head before recommending a rename. The sibling may have evolved between the citing PR's branch and the panel's run, especially when the sibling is itself un-drafted in the interval. The fix is one extra `git fetch origin <sibling-branch>` plus an `awk '/^##/'` on the fetched file; the cost is negligible against the risk of recommending a rename the fixer then has to back out.

The dispatch prompt for `6e81ac` already carried the cue ("PR #248 was un-drafted, so the design is now stable"); landing the note in the skill itself would let future panel dispatches catch the staleness without depending on the orchestrator's framing.

No other lessons from this dispatch. The fixer-role behavioral norms (one atomic commit per concern, top-level summary citing SHAs, deferred to judge for re-dispatch) all applied cleanly.

Self-improvement: garden/skills/panel-review/SKILL.md (recommendation only; subagent cannot land); add a Sibling-anchor verification note documenting the older-sibling-head staleness mode.
