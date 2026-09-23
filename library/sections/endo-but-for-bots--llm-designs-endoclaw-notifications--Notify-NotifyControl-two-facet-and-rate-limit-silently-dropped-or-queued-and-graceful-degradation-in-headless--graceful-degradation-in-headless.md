---
title: §Graceful degradation in headless
source-slug: endo-but-for-bots--llm-designs-endoclaw-notifications
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-notifications.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-notifications.md
total-lines: 55
ingest-cycle: 253
ingest-date: 2026-06-09
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless
---

§The-Endo-Idiom: *In Docker/headless mode, notifications degrade to log entries or could be forwarded to the Chat UI as system messages*. §Two-named-degradation-targets (log entries + Chat UI system messages).

§Graceful-degradation-across-substrates as named pattern. §When-the-primary-substrate-(Electron Notification API)-isn't-available, §degrade-to-the-next-best-substrate + §don't-fail-the-capability-itself. §The-agent's-API-doesn't-change; §the-substrate-the-API-routes-to-changes.

§First-explicit-observation in library of §graceful-degradation-across-substrates as named capability-implementation discipline.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling and cycle-246's-inbox-delivery — §three-different-shapes-of-substrate-routing in 2026-06: §cycle-244 forbids-ambient-substrate + §cycle-246 reuses-existing-mail-substrate + §cycle-253 degrades-to-alternate-substrate-when-primary-unavailable. §Three-cycles-with-named-substrate-routing-discipline.
