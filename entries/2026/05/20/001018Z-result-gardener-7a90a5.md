---
ts: 2026-05-20T00:10:18Z
kind: result
role: gardener
dispatch_id: 7a90a5
refs:
  - entries/2026/05/20/000105Z-dispatch-steward-05b004.md
  - entries/2026/05/20/000105Z-dispatch-steward-3c22d7.md
  - entries/2026/05/20/000105Z-dispatch-steward-876d93.md
  - entries/2026/05/20/000240Z-message-steward-307fb.md
---

# Gardener 7a90a5 result: reinforce ack-on-pickup at the at-mention-derived-dispatch surface

## Task

Reinforce the practice of acking maintainer prompts with the `eyes` (👀) reactji immediately on pickup. The 2026-05-19T23:46Z to 23:56Z engagement surfaced four `@kriscendobot` directives on `endojs/endo-but-for-bots` PRs #301, #303, #305, #307 in a tight burst; the steward dispatched three in parallel and routed the fourth to liaison but acked none of the four with the reactji until the maintainer flagged two as "may have missed." Reactji was backfilled; the discipline gap was the per-cycle-survey-to-dispatch path not enforcing the ack-on-pickup invariant.

## Empirical pattern considered

Cadence-overrun on burst arrivals, not skill ignorance. The `reactji-acknowledgment` skill already prescribed "react at the moment the activity is noticed" (the triage-role-posts-first rule on its *When to use* section). The gap was at the **dispatch site** the at-mention surveillance Monitor feeds: the matrix's *Steward action* column named "dispatch a fixer" / "dispatch a designer" as if it were an atomic verb, with no explicit ordering of the reactji that should precede the `dispatch`-entry-and-`Agent`-invocation. On a single arrival the implicit ordering is easy to preserve; on a burst of four, the steward read the matrix, planned three parallel dispatches, wrote the three `dispatch` entries, invoked `Agent` three times, and only got to the reactji after the maintainer flagged the silence.

The remaining (#307) was routed back to the liaison via `message: steward → liaison` (the steward correctly recognized that the design-PR feedback wanted maintainer-judgment re-spec) but the same root cause silenced the ack: no reactji on the originating comment before writing the routing message.

## Lightest-touch change selected

Of the four candidate angles in the dispatch entry:

1. **Per-cycle survey sub-step** rejected. Reactji must happen between *notice* (Survey) and *dispatch* (Dispatch); a Survey sub-step is the wrong location.
2. **Reactji-skill *when* emphasis** insufficient on its own. The *When* prose is already correct; the empirical failure was at the call site, not the technique.
3. **At-mention surveillance ack-as-you-read note** accepted. This is the precise surface through which all four directives arrived in the precipitating engagement.
4. **COMMON.md global rule** rejected. Too broad; not every comment surface warrants reactji (worker roles inherit; review-bodies are not reactable; closed PRs are inert), and the cross-surface rule already exists at the technique-skill level.

Selected: angle 3, with one cross-reference each into the steward role file and the reactji-acknowledgment skill so the discipline is visible from every surface a reader might land on.

## Changes landed

Committed on `main` as `9ecbc32` on `kriskowal/garden`:

- **`skills/at-mention-surveillance/SKILL.md`**: new `### Ack on pickup, before dispatch` sub-section immediately after the reaction matrix. Names the sequencing the `reactji-acknowledgment` skill leaves to its caller; cites the technique skill; clarifies the surface-specific endpoint (`/issues/comments/` vs `/pulls/comments/` per the emit-line's `<surface>` field); calls out the silent-strand failure mode for burst arrivals; clarifies that the reactji is implicit in the per-action authorization that triggered the dispatch (no separate authorization needed). Frontmatter `updated` and `author` bumped (gardener prepended).
- **`roles/steward/AGENT.md`**: one-paragraph reinforcement appended to the existing `### @-mention surveillance` section (after the *Monitor runs as the third parent-context* paragraph), pointing to the new sub-section. Frontmatter `updated` bumped to 2026-05-20. The role file's per-cycle obligation now reads the ack-before-dispatch rule from the role file itself, not only from the skill body.
- **`skills/reactji-acknowledgment/SKILL.md`**: notes-from-the-field row capturing the cadence-overrun pattern. Names the empirical case (the four directives, the two flagged), names the per-surface fix location (the at-mention-surveillance § Ack on pickup, before dispatch sub-section), and names the pattern to watch for any future surveillance Monitor whose emit-line directly triggers a dispatch. Frontmatter `updated` bumped; author updated to `liaison, gardener`.

Each new bullet uses the `_YYYY-MM-DD_:` italics-prefix convention rather than the bullet-leader em-dash, per `skills/em-dash-style/SKILL.md` § Pitfalls (the existing 2026-05-15 row in the at-mention skill that uses an em-dash is left as-is for history).

## Self-improvement

Self-improvement: the gardener-queue self-improvement note for this dispatch is that **when a skill's reaction matrix has a *Caller action* column listing a verb like "dispatch X," that verb should be read as a phase boundary rather than an atomic action whenever an upstream sequencing discipline (reactji-ack, cross-link authorization, identity-switch precondition) applies to the same site**. The matrix shape is concise, which is correct, but the concision can hide a sequencing rule the caller would otherwise infer. The pattern recurs in other places: the dispatch contract's "Write a dispatch entry, then invoke `Agent`" reads as two phases; the boatman's "switch identity, then push" reads as two phases. Worth a future gardener pass to scan every "dispatch X" matrix row in `skills/*/SKILL.md` and check whether the implicit sequencing is documented or hidden. Single-observation-pattern today (one matrix surface, one sequencing gap); the gardener-queue threshold (`skills/self-improvement/SKILL.md` § Threshold) wants a second observation before this becomes a rule. Noted but not addressed in this dispatch.
