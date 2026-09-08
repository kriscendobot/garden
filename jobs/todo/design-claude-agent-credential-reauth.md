---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-08T18:55:17Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: credential expiry detection and operator-mediated reauthentication

Repo: `kriscendobot/minion.town` (with any generic half called out for `endojs/endo-but-for-bots`).
Child of arc https://github.com/kriscendobot/garden/issues/89 (item 3).

Nothing designed for this yet. Create the design.

A Claude agent instance running inside the Endo daemon on behalf of a guest must notice
that its credentials have expired and send a message to its **designated operator**
containing **the means, as a capability, to reauthenticate the bot**. Without this, every
credential expiry is a silent stall that only a human polling the system would catch.

Cover at least:
- **Detection.** How expiry is distinguished from a transient failure, a rate limit, a
  quota exhaustion, and a model-unavailable condition. The existing
  `designs/claude-agents-capability.md` already defines a `needs-auth` sentinel; build on
  it rather than inventing a parallel signal.
- **The designated operator.** How an agent knows who its operator is, when that binding
  is established, whether it can change, and what happens if the operator is unreachable
  or gone. Note the two credential kinds in play: a claude.ai subscription and a metered
  API key. They expire differently and may not warrant identical handling.
- **The reauth capability itself.** This is the load-bearing piece. The message carries a
  capability, not a URL and not an instruction, so specify: what object it is, what it
  authorizes exactly (reauthenticating one bot, nothing more), whether it is single-use,
  whether it expires, and what an attacker who intercepts it can and cannot do. Say why
  the attenuation is tight enough that mailing it is safe.
- **The transport.** Which mailbox or message path carries it. `designs/ocap-mailboxes.md`
  (https://github.com/kriscendobot/minion.town/pull/37) is the relevant prior art for
  bot-account mail; reuse it if it fits and say plainly if it does not.
- **Behavior while unauthenticated.** What the agent does between noticing expiry and
  being reauthenticated: does it drain its inbox, park it, or refuse? Messages must not be
  lost, and the never-reject contract in the capability design should be honored.
- **Generic versus minion.town-specific.** Anything reusable belongs in `@endo/*` per the
  standing minion.town principle. Split the design accordingly.

Deliverable: one design document. Do not build.
