---
ts: 2026-05-19T06:26:42Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/18/043327Z-result-designer-641f69.md
---

Revised `designs/garden-as-primer-and-journal.md` on branch
`garden-as-primer-and-journal-design` of `endojs/endo-but-for-bots`
to reflect the maintainer's clarification that the "journal" in the
prompt refers to the garden's own journal (the orphan-branch
append-only message bus that is the garden's working environment),
not to any Endo-side journal primitive, and that the direction of
inference points at Endo as the subject of the lessons rather than
the container the garden is moving into.

What changed from the prior draft (entry
`entries/2026/05/18/043327Z-result-designer-641f69.md`):

- Title and motivation: "Lessons from the Garden: shaping Endo's
  primer and agent harness for journal-driven multi-role workflows".
  The keyword is now *lessons* / *teaching example*, not *mapping*.
- *Background: the Endo primitives the garden will map onto* (four
  primitives, including a misread "journal in the Endo sense")
  becomes *Endo primitives in scope* (three primitives: primer,
  familiar, agent harness) plus an explicit gap section naming
  that there is no Endo-side journal primitive today.
- The new term *agent harness* is pinned to project sources:
  `packages/lal/agent.js` (the simpler harness),
  `packages/genie/src/agent/index.js` line 5 (the
  `TADA/genie/90_genie_setup.md` line 3 framing calls this "a
  mostly working core agent harness"), and
  `designs/cli-edit-verb.md` line 743 which names "off-the-shelf
  agent harnesses" as a category. Citations added.
- Each *lessons* subsection follows the prescribed three-paragraph
  shape: what the garden does, what primitive it depends on (with
  library citation), what Endo would need to provide (with project
  source citation, or an explicit gap-flag).
- The Sleeper Channels D1->D2 framing and the seven invariants
  preserved as the diagnostic ceiling and the threat-model walk.
- *Considered and rejected* gained a new entry: framing this as
  "port the garden onto Endo" is explicitly rejected, with the
  maintainer's clarification quoted.
- *Open questions* refreshed: Q4 (journal-exo method surface) now
  reads as "what new primitive shape, and how much daemon does it
  own" rather than "where do these methods sit in a hypothetical
  Endo journal primitive". Q6 (relation to `@endo/lal` and
  `@endo/genie`) refocused on harness choice (a new third harness,
  vs. extending one of the two existing ones, vs. division of
  labor) rather than "sibling / substrate / supersession". Two new
  questions added: Q7 on what a shipped "primer + harness +
  journal exo" artifact looks like, Q8 on whether the journal exo
  belongs in the daemon, the familiar, or its own caplet.
- `designs/README.md`: see-also entry and summary-table row
  updated to reflect the reframed abstract and the 2026-05-18
  update date.
- Em-dashes swept from prose per `skills/em-dash-style/SKILL.md`
  (the prior draft retained the originating-prompt's em-dash
  style; this revision applies the garden's rule).

Pivotal claim (revised): the garden runs a journal-driven multi-
role workflow today on a borrowed substrate (Claude Code + git +
bash); each architectural choice it made (orphan-branch journal,
per-dispatch worktree triple, role primers loaded just-in-time,
standing monitor daemons under bounded endowment) corresponds to
a primer or harness primitive Endo would need to provide to host
such a workflow natively, and this design extracts those lessons
and proposes the resulting shape for Endo's primer and agent
harness.

Key citations added (under the reframe):

- `packages/lal/agent.js` lines 1641-1656 (the primer check-in
  that makes primer choice a familiar property).
- `packages/genie/src/agent/index.js` (the second worked-example
  harness, per `TADA/genie/90_genie_setup.md` line 3's "mostly
  working core agent harness" framing).
- `designs/cli-edit-verb.md` line 743 ("off-the-shelf agent
  harnesses" as a category).
- `packages/lal/LAL-ARCHITECTURE.md` § *The Agent Loop in Detail*
  as the running-harness model.
- `journal/library/concepts/caretaker-pattern.md` (now cited
  explicitly under the journal-exo facet attenuation pattern).

Key citations removed (the original draft attached too much
weight to these):

- The "endo journal" framing around `endo--designs-daemon-persistence`
  and the conversion of journal entries into formula-graph values:
  preserved as a *possible Endo extension* (still cited under
  threat-model and append-only structure) but no longer presented
  as "this is what the garden's journal maps onto".

New open questions surfaced by the reframe:

- Q7: what does a shipped "primer + harness + journal exo"
  artifact look like in Endo's package ecosystem? (Is the harness
  an `@endo/agent-harness` abstract package that role-primer
  packages depend on?)
- Q8: where does the journal exo live in the daemon / familiar /
  caplet layer cake?

Still couldn't pin down:

- Whether the maintainer wants the journal exo as a daemon-resident
  primitive (the simplest match to the garden's current model) or
  as a caplet-resident one (matches the "any agent can read" property
  but couples the exo to the agent's address space). Listed as Q8.
- Whether a third, garden-specific agent harness should be authored
  or whether `lal` or `genie` should be extended. Listed as Q6.
- The cross-host Property F story (Q2 from the prior draft) is
  unchanged and still open; the reframe does not resolve it.

Branch `garden-as-primer-and-journal-design` updated (pushed; the
HEAD now reads `9f0b39f25 design: reframe — garden teaches Endo, not
the other way around` over the prior `731d094d4`). Push went out
via the SSH `push` URL the project remote already had configured;
no fall-back needed. No PR opened; the maintainer decides whether
to ferry.

Self-improvement: the prior dispatch (entry
`entries/2026/05/18/043327Z-result-designer-641f69.md`) flagged the
absence of a project-side journal primitive as a *thing it wanted to
look up but couldn't*, but folded that gap into the prose of the
*Background* section as if the gap were merely "this Endo word also
means several other things." A clearer discipline for the
designer's *Open questions* section would be: when a search for a
project-side primitive comes up empty, name the gap *as a top-level
open question* rather than as a parenthetical. The reframed design's
new Q8 (where does the journal exo live in the daemon / familiar /
caplet stack?) is the example of how that discipline would have
surfaced the gap earlier. Routing this as a `message` to liaison
for the designer-role file under `roles/designer/AGENT.md` §
*Operating norms*.
