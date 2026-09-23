---
ts: 2026-05-18T04:32:32Z
kind: result
role: gardener
---

# Result: integrator code-panel seat lands (sixteen to seventeen) and stale seat-count references swept

User dispatched a gardener (in this terminal session, not via the
liaison's `Agent` tool) to "create a juror based on feedback provided
in reviews by Kris Kowal."

## Empirical corpus

Walked the journal for kriskowal review feedback captured in fixer
and steward `result` and `dispatch` entries. Highest-signal quotes,
grouped by recurring pattern:

- **Merge-commit readability** (3+ instances): PR #128 / #129 / #109
  "Please refresh the title and description consistent with standing
  instructions"; "Please redraft the PR description and title to
  reflect the proposed changes. Use the github template for pull
  requests. Do not include checklists or draw attention to specific
  files."
- **Concept-namespace coherence**: PR #134 "Please return this to
  draft. We need to make progress on the Endo Gateway concept before
  we can sensibly run under Docker. The Gateway subsumes the
  ws-gateway.js here with the Weblet virtual host."
- **Roadmap escalation**: PR #134 follow-up "Please propose a change
  to the roadmap to raise the Gateway concern to M1."
- **Rename completeness sweep**: PR #109 "Please search for lingering
  remnants of the term 'syrups' and replace them with 'syrup-frame'."
- **Test pins constant, not comment**: PR #75 r3239227139 "I had a
  much simpler verification in mind, verifying that the magic number
  is indeed === 2 ** -53, rather than relying on the veracity of a
  comment."
- **Public surface in tests**: PR #247 r3244151411 "Why can we not
  simply import E from `@endo/eventual-send` in tests?"
- **Forward-compose probe**: PR #247 r3244147661 "This pattern will
  not work for packages using a `sesAva` block. Please investigate
  whether we will need to create a per-package set of ava config
  files, and if so, whether we can build on a base config."
- **Type-level discouragement over runtime guard**: PR #3257
  r3238971409 "For this, I am content discouraging this misuse with
  the type system."
- **Mermaid over ASCII**: PR #238 inline 3237804603 "the designer,
  builder, and reviewers should all strive to ensure that we use
  mermaid diagrams and eschew ASCII and line-art diagrams, since the
  former is more human-maintainable."
- **Convention probe**: kriscendobot/agoric-sdk#1 r3244366259 "Does
  this repository have a catalog.yml?"
- **Commit grouping**: PR #246 "Please reset and redistribute into
  sensibly grouped commits."
- **Master-base mirror**: PR #126 / #244 / #246 "Please also create
  a clone of this change based on master."
- **Cycle-obviation tracking**: PR #121 "Please check how much
  progress we have made on obviating cycles."
- **Minimum cleavage**: PR #261 "Let's move all the tests that do
  not depend on module-source or compartment-mapper back into ses
  proper. We only need to break the cycle for tests that reach
  down."

The unifying lens: each PR is read with the project's whole
structure in view (concept-namespace, package dependency graph,
roadmap, conventions, naming history) and the future reader (the
merge-commit reader, the contributor onboarding three months from
now, the engineer running the test six months from now) as the
implicit audience.

## Seat carved

`integrator` (code panel). The slug names the lens (not the
reviewer); per the four prior maintainer-modeled seats
(`purist` / `spec-keeper` / `wire-watcher` / `engine-realist`), the
empirical source is recorded inside the role file as
`@kriskowal` (Kris Kowal) across `endojs/endo` and
`endojs/endo-but-for-bots`.

## Files changed

New:

- `roles/integrator/AGENT.md`: the role file, modeled on the four
  prior maintainer-modeled seats. Primary surface walks the inquiry
  axes above; secondary overlap with packager (diff hygiene on the
  integration slice), archivist (docs prose on the project-map
  slice), and stylist (rename sweep). Distinct from `migrator`
  (migrator reads outward to callers; integrator reads outward to
  the project's existing structure and the future reader).

Updated for the new seat:

- `CLAUDE.md`: inventory paragraph (23 → 24 jury-seat roles; 16 → 17
  code-panel seats; +integrator in the role list and the code-panel
  seat list; new sentence noting the 2026-05-18 expansion).
- `skills/pr-creation-flow/SKILL.md`: code-panel seat list, "Why
  seventeen seats" heading and prose, "alongside the seventeen
  dispatches" idiom, Notes-from-the-field entry _2026-05-18_.
- `roles/judge/AGENT.md`: opening paragraph, panel-kind heading
  ("Code panel (17 seats)"), seat list, aggregation word-count range
  (1700-2750 words), in-band fallback note, post-2026-05-14
  framing paragraph.

Swept for 2026-05-15 drift (the prior gardener session expanded the
panel from twelve to sixteen seats but did not update every
current-state reference):

- `README.md`: top-level pipeline paragraph (12 → 17 with the full
  seat list including the four 2026-05-15 maintainer-modeled
  additions and the new integrator).
- `roles/liaison/AGENT.md`: gamut vocabulary (12 → 17) and the
  PR-creation-flow-chaining norm.
- `roles/steward/AGENT.md`: jury composition in the dispatch table
  and the gamut vocabulary.
- `roles/saboteur/AGENT.md`: "alongside the other sixteen seats"
  / "seventeen-seat code panel" line.
- `skills/panel-review/SKILL.md`: header paragraph, panel
  composition section, should-fix promotion rule, aggregation
  word-count range (1700-2750 words for code-panel default).
- `skills/garden-ab-evaluation/SKILL.md`: flow description ("current
  as of 2026-05-18"; sixteen-seat 2026-05-15 + seventeen-seat
  2026-05-18 noted as flow-shape change points), cost section.

Historical narrative references to the 2026-05-14 twelve-seat
redesign (in each prior seat's *narrower remit after the 2026-05-14
twelve-seat redesign* paragraph at `roles/<seat>/AGENT.md:13`, and
in the Notes-from-the-field entries dated _2026-05-14_) are
intentionally left intact: those describe what happened on
2026-05-14, not the current state, so the date pins them.

## Open questions for the user

The seat slug (`integrator`) is the gardener's pick; the maintainer
may prefer a different name. The four prior maintainer-modeled
seats name the lens via a job-noun (purist, spec-keeper,
wire-watcher, engine-realist); the integrator follows the same
convention. Alternative candidates considered and rejected:
`cartographer` (the "project map" metaphor is evocative but strays
from the actual review patterns into metaphor), `arborist` (the
tree-shaping frame covers most patterns but not test-pins-constant
or public-surface-in-tests), `map-keeper` (ambiguous with `Map`
data structure). If the maintainer prefers a different slug, the
rename is mechanical: edit the role file's filename and the seat
list in the four canonical places (CLAUDE.md, pr-creation-flow,
judge, panel-review).

## Self-improvement

Two notes from the engagement, neither of rule-threshold magnitude:

1. **Stale current-state references after a panel expansion are a
   recurring drift surface.** The 2026-05-15 expansion landed in
   `CLAUDE.md`, `pr-creation-flow`, and `judge/AGENT.md` but
   missed `README.md`, `panel-review`, `liaison`, `steward`,
   `saboteur`, and `garden-ab-evaluation`. The discipline
   `roles/gardener/AGENT.md` § Operating norms already names
   "audit the active library for drift between cited paths,
   conventions, and current reality" — what would help is a
   checklist of "places that name the panel size" so a future
   panel-size change touches them all. Candidate landing: a
   one-line "Sites that name the panel size" note at the top of
   `skills/pr-creation-flow/SKILL.md` § Jury composition (or a
   short helper file).
2. **The "name a seat after a person is a precedent to consider
   carefully" rule on `roles/decomplector/AGENT.md` § Role frame is
   the relevant precedent here.** The integrator seat slug is
   job-named, not eponymous; the empirical source is recorded
   inside the role file the way `purist` / `spec-keeper` /
   `wire-watcher` / `engine-realist` record theirs. Threshold not
   met for an additional rule; the existing precedent on
   decomplector and the four 2026-05-15 maintainer-modeled seats
   are sufficient.

Self-improvement: candidate landing — add a "Sites that name the
panel size" note to `skills/pr-creation-flow/SKILL.md` § Jury
composition so a future panel-size change has a single checklist.
Threshold met (the drift recurred twice now: at the 2026-05-15
+4 seats expansion and at this 2026-05-18 +1 seat expansion). Will
land in a separate commit on the same garden session.
