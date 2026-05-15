---
ts: 2026-05-15T03:39:41Z
kind: result
role: gardener
project: garden
to: "*"
refs:
  - entries/2026/05/15/034700Z-dispatch-liaison-c9ded6.md
  - entries/2026/05/15/034700Z-dispatch-liaison-4a8df9.md
---

# Result: gardener c9ded6 (gap-revealing-build skill + 'probe #N' verb)

Encoded the recurring "attempt a tentative design to reveal gaps" pattern that the maintainer flagged on `endojs/endo-but-for-bots#138` (2026-05-15). The encoding is now in place; the companion builder dispatch (`4a8df9`) runs the pattern against #138 as the worked example.

## Slug and verb chosen

- **Skill slug:** `gap-revealing-build`. Picked over `design-stress-test`, `tentative-design-probe`, and `attempt-to-reveal-gaps` because the noun `gap` is what the deliverable centers on, and the present-participle form pairs cleanly with the existing `coverage-driven-testing`, `regression-evidence`, `adversarial-tests` skill-naming family.
- **Orchestrator verb:** **`probe #N`**. Picked over `prototype #N` (overlaps too much with builder shapes that produce mergeable code), `stress-test design #N` (too long for a daily verb), and `vet #N` (already overloaded with "approve / clear" connotations). Synonyms in the vocabulary tables: *probe the design at #N*, *attempt #N to reveal gaps*.

The verb's distinct semantics from *build #N*: `probe` produces a DRAFT PR carrying a structured gap report (no cleaner / judge / fixer / un-draft chain follows); `build` produces a mergeable feature PR (full gamut chain follows).

## Files edited

On garden `main`:

- `skills/gap-revealing-build/SKILL.md` (new). Sections: purpose, when-to-use, inputs, procedure (stop-at-every-ambiguity discipline; four-field gap-entry shape; required PR-body sections `## Gaps surfaced`, `## Skeleton implemented`, `## Skeleton not implemented`, `## Recommendations to design author`; PR stays DRAFT), output shape, notes, notes-from-the-field.
- `roles/builder/AGENT.md` : *Skills* list now references `gap-revealing-build` with the qualifier *consult only when the orchestrator's dispatch invokes the probe verb; not on normal `build #N` dispatches*.
- `roles/liaison/AGENT.md` § Vocabulary § Direct-dispatch verbs : added `probe #N` row between `build #N` and `design X`. Added a disambiguation note distinguishing *probe #N* from *build #N* with verb-cue heuristics.
- `roles/steward/AGENT.md` § Vocabulary § Direct-dispatch verbs : added matching `probe #N` row.
- `CLAUDE.md` § Orchestrator vocabulary glossary table : added `probe #N` row; updated *Current inventory* skills list to include `gap-revealing-build`.

Commit: `df6f0aa` on `main`, pushed to `origin/main`.

## What the encoding covers and what it does not

The encoding names two load-bearing rules that distinguish a probe from a build: (1) the *stop at every ambiguity* discipline (do not guess past a hand-waved mechanism; document and either skip or stop), and (2) the *PR stays DRAFT* invariant (no judge / cleaner / un-draft chain). It names the four-field gap-entry shape (*where in design* / *verbatim quote* / *what's needed* / *candidate resolutions with trade-offs* + *maintainer's call* label) and the required four PR-body sections. It does not prescribe a minimum or maximum gap count, leaves test-strategy decisions to the maintainer when the design has not finalized them, and notes that a probe with zero gaps is itself a valid finding (the design held up under contact).

The skill explicitly forbids two failure modes: (a) a normal `build #N` dispatch sliding into probe semantics mid-engagement when the design feels under-specified (the builder surfaces impasses via `message` and the orchestrator decides whether to re-dispatch as a probe), and (b) a fixer round on a prior probe's PR (a re-probe after design revision is a fresh dispatch with a fresh PR).

Self-improvement: nothing this time. The dispatch brief was crisp; the skill landed in one pass without surfacing a meta-rule about meta-evolution that warrants a separate journal entry.
