---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Author skills/minion-town-ocapn-dispatch/SKILL.md — garden-side procedure for messaging kriscendobot's minion.town guest over OCapN

Maintainer (kriskowal, liaison session 2026-10-06), foresight directive: the
garden is moving toward coordinating with minion.town directly, including
eventually sending a message from the garden to kriscendobot's own guest
account on minion.town using the Endo CLI and OCapN. This skill is the
garden-side half of that: how a gardener or the liaison actually drives this
dispatch, once it's real — not a restatement of what OCapN or CapTP are in
general.

## Research first — verify current state, don't assume it's finished

The underlying transport is **partially proven, not fully landed**:
- `endojs/endo-but-for-bots#340` ("feat(daemon): OCapN-Noise transport for
  daemon-to-daemon connectivity") is **merged**.
- `endojs/endo-but-for-bots#693` ("demo(daemon): true cross-host Pet-Daemon
  invite/accept over wss + Noise (M5)") was **still OPEN, not merged** as of
  2026-10-06. Check its current state yourself — it may have landed by now,
  or may have been superseded; don't trust this note past today.
- Search the garden journal and both repos (`endojs/endo-but-for-bots`,
  `kriscendobot/minion.town`) for later work building on either PR —
  anything mentioning cross-host OCapN bootstrap, guest-to-guest invite,
  or a garden-host-to-minion.town connection specifically.

## Write the skill honestly reflecting what you find

- **If the cross-host path is genuinely usable today** (merged, has a real
  worked example somewhere): write the skill as an actual procedure — the
  concrete `endo` CLI invocations (or whatever the real interface turns out
  to be) a gardener or liaison would run to invite/accept and then send a
  message to kriscendobot's guest, citing the real commits/PRs as evidence
  it works, not as aspiration.
- **If it's still blocked on #693 or a successor landing**: write the skill
  as a clearly-marked "not yet usable" status page — what the plan is, what
  specifically is blocking it (cite the open PR), and what a future author
  needs to fill in once it lands. Do not write a procedure that looks
  executable today if it isn't; a skill that lies about its own readiness is
  worse than no skill. Say so plainly rather than softening it.
- Follow this repo's skill format exactly (`CLAUDE.md` § Adding a skill):
  purpose, inputs, state (if any), procedure, output shape, notes.
- Keep it garden-side-scoped: this is "how does *this fleet* dispatch a
  message," not a tutorial on OCapN/CapTP concepts in general — those belong
  in minion.town's own served getting-started guide
  (`kriscendobot/minion.town` draft PR #147,
  `designs/mcp-resources-getting-started.md`), not duplicated here.

## Output

Land `skills/minion-town-ocapn-dispatch/SKILL.md` directly on `main2` (no PR;
this repo's own convention for garden-library additions with no maintainer-
facing open question). Say in your completion report which of the two
outcomes above you landed (usable procedure vs. honest not-yet-ready status)
and why.
