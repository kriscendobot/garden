---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Author skills/caplet-validation/SKILL.md — verifying a caplet's confinement and behavior before the garden trusts it

Maintainer (kriskowal, liaison session 2026-10-06), foresight directive: as
the garden moves work onto minion.town (coordination, messaging, and
eventually running largely within minion.town), it will need a repeatable way
to validate a **caplet** — minion.town's confined unit of capability/code —
actually respects its declared confinement boundary and does what it claims,
before the garden adopts, trusts, or publishes one. No skill like this exists
yet (checked: no `caplet`-named skill in `skills/` at all).

## Build on the precedent that already exists — don't invent from scratch

`kriscendobot/minion.town` draft PR #147
(`designs/mcp-resources-getting-started.md`, § 6 "Validation") already
designed a concrete validation harness for a related problem (verifying a
confined Claude session only uses the capabilities it's supposed to): a
**bare `claude -p` limited to just the relevant MCP tools**, with no garden
skills or prior context, run through a fixed set of tasks and graded by an
**independent verifier**, executed once before a change and once after, with
a pass bar (that design used 4 of 5 runs). Read that section in full. This
skill should generalize that same shape for caplets specifically: a minimal,
narrowly-scoped evaluation harness plus an independent verifier, not a new
mechanism.

Also read `roles/COMMON.md`'s prompt-injection/untrusted-content discipline
and this garden's existing adversarial-review precedent (the `saboteur` and
`warden` jury seats under `roles/jurors/`) for what "confirm the confinement
boundary actually holds" means in practice elsewhere in this garden, and
adapt rather than reinvent.

## What the skill needs to cover

- **Declared vs. granted capabilities**: how to check that a caplet's
  manifest/declaration of what it needs matches what it's actually been
  granted — no silent over-grant.
- **Functional correctness**: does it do what it claims, via the same
  before/after independent-verifier harness shape as PR #147.
- **Confinement**: does it ever reach for something outside its declared
  capability set — attempted escapes, not just successful ones, should count
  as a finding. State concretely how to detect an attempt versus a success
  (e.g., a capability call that fails closed is evidence the boundary holds,
  not a non-event to ignore).
- **Output shape**: a verdict a gardener or the liaison can act on directly
  (pass / fail-with-specifics / genuinely-ambiguous-needs-a-human), mirroring
  this garden's existing panel-review verdict conventions
  (`skills/panel-review/SKILL.md`) rather than inventing a new vocabulary.

## Output

Land `skills/caplet-validation/SKILL.md` directly on `main2` (no PR; no
maintainer-facing open question here — this is a garden-library addition).
Follow this repo's skill format (`CLAUDE.md` § Adding a skill): purpose,
inputs, state, procedure, output shape, notes. If minion.town doesn't yet
have a real caplet to validate against (check first), say so plainly and
write the skill as a procedure ready to apply to the first real one, rather
than inventing a fake example to validate against.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T19:12:19Z
