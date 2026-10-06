---
created: 2026-10-06
updated: 2026-10-06
author: gardener
status: stub
---

# Skill: ocap-attenuation-authoring (stub)

## Purpose

Garden-side authoring of a new, **narrowly scoped attenuation** of an existing
capability for a minion.town guest: for example, "this caplet gets read-only
access to X and nothing else." The deliverable of a real run would be a
facet that exposes strictly less authority than the capability it wraps, plus
the grant site that hands only that facet to the guest.

## Current status: placeholder, not a procedure

This is a placeholder, not a playbook. minion.town's access-control model is
partway through a move off OAuth scopes and onto object capabilities, and a
step-by-step procedure written against it now would probably be wrong by the
time anyone used it.

State as of 2026-10-06 (minion.town `main` at `be0edb8`):

- **The directive.** OAuth scopes are a thin outer authentication layer.
  Authorization lives in the object capabilities the guest holds
  ([`designs/mcp-endo-guest.md`](https://github.com/kriscendobot/minion.town/blob/main/designs/mcp-endo-guest.md),
  "Access-control directive", maintainer, 2026-07-09).
- **The scope-pruning design.**
  [`designs/remove-toy-tools-and-prune-minion-scopes.md`](https://github.com/kriscendobot/minion.town/blob/main/designs/remove-toy-tools-and-prune-minion-scopes.md)
  (landed via [#30](https://github.com/kriscendobot/minion.town/pull/30))
  still has the header "design only". The pruning it describes has since been
  implemented by
  [#20](https://github.com/kriscendobot/minion.town/pull/20) (merged
  2026-08-21), which superseded the closed
  [#36](https://github.com/kriscendobot/minion.town/pull/36). The
  `mcp/minions:*` scopes and the toy tools are gone. `src/auth/scopes.ts` now
  holds only `mcp/tools` (the route gate) and `mcp/guest` (admission to your
  own guest), and it has no scope-to-tool table. Denial means a capability is
  absent, not that a scope is missing. The design doc's text predates that
  build, so treat it as history.
- **Follow-ups still open.**
  [#82](https://github.com/kriscendobot/minion.town/pull/82) makes
  `mcp/tools` imply `mcp/guest`, which removes the guest-scope ceremony.
  [#50](https://github.com/kriscendobot/minion.town/pull/50) adds a `whoami`
  baseline tool. Neither is merged.
- **Designs still in flux.** Some designs that would define how attenuations
  get authored are still open PRs:
  [#142](https://github.com/kriscendobot/minion.town/pull/142) (clip lifecycle
  rights as a per-clip controller exo, where attenuation wraps the parent
  controller) and
  [#37](https://github.com/kriscendobot/minion.town/pull/37) (ocap mailboxes:
  directional and recipient-restricted attenuations).

Expand this stub into a real procedure once two things are true: the
migration has settled (#82 and #142 resolved one way or the other), and the
garden has actually authored and used a first attenuation end to end. Write
the procedure from that run, not ahead of it.

## Inputs

- The existing capability to attenuate (which daemon formula or caplet power).
- The narrowed authority wanted, stated as the verbs the guest may exercise
  and nothing else.
- The guest it is for, and where it is granted (provisioning, `send`/`adopt`).

## State

None yet.

## Procedure

Not yet. See the status note above. Until a procedure exists, take the work
as a design or build job on `kriscendobot/minion.town` that follows that
repo's own designs. Do not invent a garden-side recipe.

These are prior attenuations already in minion.town's code. They are worth
reading as precedent, but they are not a template:

- `src/endo/gateway/site-register-caplet.ts` is a register-only facet of the
  site registry, with the owner fixed at the grant site.
- `src/endo/git-remote/capability.ts` binds a partition capability to the
  `read` or `readwrite` attenuation (the design's `write` is deferred).
- `designs/claude-agents-capability.md` describes an attenuated sub-factory
  delegated from the root account.

## Output shape

To be defined when the procedure exists. Expect a minion.town PR that adds the
facet and its grant site, with tests showing the guest cannot reach anything
outside the narrowed verbs.

## Notes

- This skill comes from the maintainer's foresight directive (liaison
  session, 2026-10-06) about the garden's move toward minion.town:
  coordination, messaging, caplet validation, and creating useful
  attenuations.
- Before expanding this skill, re-read the designs and PRs listed above. They
  are a snapshot and will drift.
