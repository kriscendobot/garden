---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Author a short stub: skills/ocap-attenuation-authoring/SKILL.md

Maintainer (kriskowal, liaison session 2026-10-06), foresight directive: as
part of the garden's move toward minion.town (coordination, messaging, caplet
validation, and creation of useful attenuations), stub a short placeholder
skill for **authoring a new, narrowly-scoped attenuation** of an existing
capability for a minion.town guest — e.g., "this caplet gets read-only access
to X and nothing else." This is deliberately a **stub, not a full procedure**
— minion.town's own access-control direction is still moving off OAuth scopes
toward object capabilities, and a full authoring playbook written against a
still-moving target would likely be wrong on arrival.

## What to base it on

Read `kriscendobot/minion.town`'s `designs/remove-toy-tools-and-prune-minion-scopes.md`
(the real design doc for the scopes-to-ocap migration direction) and any
later work that builds on it — check for successors or follow-on PRs before
writing anything, don't cite a possibly-superseded snapshot.

## What the stub should contain

- A short purpose statement: narrow-attenuation authoring for minion.town
  guests, garden-side.
- A clear, explicit **current status** note: the underlying access-control
  model is mid-migration (cite the real design and its current state), so
  this skill is a placeholder pointing at that design rather than a worked
  procedure, and should be expanded once the migration lands and a first
  real attenuation has actually been authored and used.
- Follow this repo's skill format (`CLAUDE.md` § Adding a skill) even though
  it's short: purpose, inputs, state, procedure (may just say "not yet
  — see status note"), output shape, notes.
- Do not invent a procedure to fill space. A short, honest stub is the
  correct deliverable here, not padding.

## Output

Land `skills/ocap-attenuation-authoring/SKILL.md` directly on `main2` (no
PR). Say in your completion report what you found about the migration's
current state and why you scoped the stub the way you did.
