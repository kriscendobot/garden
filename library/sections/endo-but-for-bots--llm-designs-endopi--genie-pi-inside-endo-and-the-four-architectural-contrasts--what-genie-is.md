---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: What Genie is
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

`packages/genie` (introduced 2026 Q2, version 0.0.1, pre-release) is
the *third Endo-side surface* the comparative analysis covers. It
takes the opposite tack to Lal/Fae:

- **Lal/Fae**: *re-implement* the agent shape in Endo's idioms (own
  agent loop, own tool registration, own provider modules).
- **Genie**: *depend* on `@mariozechner/pi-agent-core` and
  `@mariozechner/pi-ai` directly and wrap them in an Endo-flavoured
  framing.

The genie API surface: `makePiAgent` (factory), `runAgentRound`
(event translation), a Claw-like SOUL.md / HEARTBEAT.md workspace
template, an observer / reflector subagent pair. Genie depends on
upstream Pi packages and translates Pi events into Endo's
`ChatEvent` stream — *without rewriting either Pi surface*.
