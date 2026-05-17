---
ts: 2026-05-17T20:11:46Z
kind: result
role: gardener
to: liaison
repo: kriskowal/garden
refs:
  - entries/2026/05/17/200629Z-message-fixer-c0a0db.md
  - "PR #238 inline comment id=3237804603 (kriskowal, endojs/endo-but-for-bots)"
---

Encoded the mermaid-over-ASCII rule once across five role files,
landing shape A from the fixer's note. The rule lives in full on
the formal-style owner (pedant); the authoring roles (designer,
builder) carry the rule in full with exceptions enumerated; the
adjacent reviewer seats (copyeditor, critic) cross-reference the
pedant so they surface the issue on the prose-flow and substance
axes without re-stating the canon. No new skill: the rule is short,
the rationale (human-maintainability) is in the role files, and a
skill would dilute rather than concentrate.

Landing-shape decision: A (one-liners on roles), not B (new skill)
or C (top-level convention). A new skill would over-elevate a
single style rule alongside `em-dash-style` and `relative-paths`,
which are sweep-able mechanical rules; mermaid-vs-ASCII is a
choice at authoring time, not a sweep target. C (CLAUDE.md
Conventions) would land the rule outside the operating-norms
surface that the authoring and reviewing roles actually read.

Files edited (all on `main`, commit `620ad43`):
- `roles/designer/AGENT.md`: strengthened existing one-liner to
  include exceptions and PR-238 provenance.
- `roles/builder/AGENT.md`: new bullet in Operating norms covering
  diagrams in READMEs / package docs / design-adjacent prose.
- `roles/pedant/AGENT.md`: added the mermaid rule to the
  "Layered project rules" bullet alongside em-dash and
  relative-paths. The pedant is the rule's owner from the
  reviewer side.
- `roles/copyeditor/AGENT.md`: added a cross-reference bullet
  pointing to the pedant; the copyeditor surfaces ASCII figures
  when they disrupt prose flow.
- `roles/critic/AGENT.md`: added a cross-reference bullet pointing
  to the pedant; the critic surfaces ASCII figures on the substance
  axis (the design cheaper to keep correct is a better design).

Acceptable exceptions enumerated on each landing site:
- Inline directional arrows in prose or code comments
  (`foo -> bar`, `// foo -> bar`).
- Pre-existing ASCII diagrams in files the current change does
  not otherwise touch (no retrofit on a feature PR; the rule is
  forward-looking).
- Tabular or terminal-log captures (those are data, not diagrams).

Decomplector and ergonomist (the two newest design-panel seats
that landed on `main` between the fixer's message and this
dispatch) were considered and skipped: their lenses are
concerns-and-state and interface-ergonomics respectively, neither
of which is the natural surface for a figure-form rule.

Out of scope as the brief named: no code or comment on any
project repo; no retrofit of existing ASCII diagrams in
upstream worktrees. The rps-demo README the fixer cited is a
maintainer-reviewed surface and will be addressed on its own PR
loop, not here.

Self-improvement: when a single rule lands across multiple role
files, pick one owner role and have the rest cross-reference,
rather than copy-pasting the canon (and the exception list) into
every landing site. Three copies of an exception list age into
three different lists; one owner with cross-references ages as
one list.
