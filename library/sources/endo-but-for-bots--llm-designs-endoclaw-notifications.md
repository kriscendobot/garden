---
title: "endoclaw-notifications — OS-level desktop notification capability via Familiar's Electron Notification API"
source-slug: endo-but-for-bots--llm-designs-endoclaw-notifications
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-notifications.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-notifications.md
total-lines: 55
status: Not Started (2026-03-03)
ingest-cycle: 253
ingest-date: 2026-06-09
lane: designs
---

# endoclaw-notifications.md

A 55-line **Not Started** design for a `Notify` capability that posts OS-level desktop notifications through Familiar's Electron `Notification` API. Parent: endoclaw. The smallest endoclaw cluster member ingested so far (cycle 246's webhooks was 79 lines; this is 55).

## Key design moves

- **§Notify / NotifyControl two-facet caretaker pattern** at its most compact (5th instance in library).
- **§Single rate-limit axis** (`setMaxPerMinute`) as the simplest possible control surface.
- **§Silently dropped or queued** as named rate-limit policy (vs throw).
- **§Graceful degradation across substrates** — primary substrate (Electron Notification) absent → degrade to alternate substrate (log entries or Chat UI system messages), not fail.
- **§Named non-dependency** as design discipline (explicit *No other designs required*).
- **§The agent cannot discover or influence the control facet** as canonical phrasing.
- **§Revocation is immediate + all future calls throw** as named permanence.
- **§Two-cycles-with-five-section-design-shape** (246 + 253).

## Section files

- [§Notify/NotifyControl two-facet + §rate-limit-silently-dropped-or-queued + §graceful-degradation-in-headless](../sections/endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless.md) — full 55-line design ingest.

## Ingest scope

Cycle 253 (designs-lane, after cycle 252's chat-lane): full 55-line design ingest. §First-explicit-observation of three patterns: §silently-dropped-or-queued as named rate-limit policy + §graceful-degradation-across-substrates as named capability-implementation discipline + §named-non-dependency as design discipline.
