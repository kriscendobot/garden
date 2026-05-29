---
title: Relationship to commands-as-messages, dependency framing, and the fallback role
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The design's self-positioning. The pending region is a UI-only solution; a sibling design (`daemon-commands-as-messages`) proposes the deeper daemon-side fix that would model commands as self-addressed messages. The pending-region design names the relationship explicitly and frames itself as the near-term solution and as a fallback if the daemon change is deferred. Notable as a worked example of *near-term-UI vs. invasive-daemon-change* dependency framing in this design corpus.
---

## Abstract

The pending region is a UI-only solution. It solves the immediate UX
problems (blocked input, invisible commands) without daemon changes,
but leaves a deeper asymmetry intact: the daemon's transcript
(`followMessages()`) records only inbound messages; outbound commands
are promises that settle and vanish. The sibling `daemon-commands-as-
messages` design proposes the deeper fix (model commands as
self-addressed messages, results as reply messages). If implemented,
that design would subsume the pending region. This design positions
itself explicitly as the near-term solution *and* as a fallback if
the daemon change is deferred — a dual role that is itself an
exemplar of *near-term-UI vs. invasive-daemon-change* dependency
framing.

## The deeper asymmetry the UI region cannot fix

The pending region resolves *blocked input* and surfaces *invisible
commands* during their in-flight phase. What it does not fix is the
**durability** of the command record. Once a card fades out, the
trace is gone. The daemon's `followMessages()` stream carries only
inbound messages; the outbound command (the user's "I dismissed
message 5") was never durable.

This is the same *asymmetric record* problem named in the
*motivation-and-problems* section: you see what others said to you
but not what you did. The pending region treats the in-flight phase;
the asymmetry returns once the cards fade.

## The deeper alternative (subsumption shape)

`daemon-commands-as-messages` proposes modeling commands themselves as
**self-addressed messages** in the daemon's mail system, with results
as **reply messages**. If implemented, the pending region's role
changes: pending commands are simply self-addressed messages whose
reply messages have not yet arrived. They are rendered inline in the
transcript, exactly where the user sees inbound messages from others.

The subsumption shape:

| Today | Pending region (this design) | Commands as messages (sibling design) |
|---|---|---|
| Spinner on send button | Card in pending region | Message in transcript, awaiting reply |
| Spinner disappears | Card fades / persists per success/failure | Reply message appears (or never does) |
| No record | Card visible during flight only | Both command and reply durable in `followMessages()` |

The pending region's value persists in the subsumed world only as
*formatting hints*: a self-addressed message without a reply renders
with a spinner, a settled one renders with the reply inline. The
transcript itself becomes the pending region.

## The fallback role (the dual-positioning move)

The design explicitly preserves its value even if the daemon change
ships:

> This design remains valuable as the near-term solution and as a
> fallback if the daemon change is deferred.

This is a load-bearing piece of dependency framing. The design is not
*blocked on* the daemon change; it ships first, and if the daemon
change never lands, the pending region remains the UX answer
indefinitely. If the daemon change does land, the pending region's
existence accelerates rollout (the chat UI already knows how to
render in-flight cards).

The dual-positioning is the canonical *near-term-UI vs. invasive-
daemon-change* shape in this design corpus: ship the UI fix that
covers the user's immediate pain, name the deeper architectural
question as a sibling design, and frame the UI fix as both immediate
solution *and* graceful-degradation path if the deeper change is
deferred. The two designs are not in tension; they cover different
time horizons of the same problem.

## Dependencies (from the design's appendix)

| Design | Relationship |
|--------|-------------|
| [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] | Command bar states and modeline that this design modifies (releasing the bar mid-flight is the modification) |
| `daemon-commands-as-messages` (not yet ingested) | Deeper daemon-level solution that would subsume the pending region |

## Implications for Endo

This design is one of several in the chat-cluster that operate at the
UI layer with explicit awareness of a deeper daemon-layer alternative.
The pattern is: identify a UX gap, design a UI-only fix scoped to a
handful of chat-package files, name the daemon-side alternative that
would obviate the UI fix, and frame the UI fix as both near-term
solution and fallback. The shape lets the chat client improve
continuously while the daemon question is debated separately, without
either workstream blocking the other.

## See also

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the asymmetric-record problem that survives even after the UI fix lands.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation move that is *scoped to three chat-package files* (no daemon changes), enabling the dual-positioning.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — the UI surface that exists today (after this design lands) and that would gracefully merge into the transcript if commands-as-messages ships.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine the pending region composes with.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
