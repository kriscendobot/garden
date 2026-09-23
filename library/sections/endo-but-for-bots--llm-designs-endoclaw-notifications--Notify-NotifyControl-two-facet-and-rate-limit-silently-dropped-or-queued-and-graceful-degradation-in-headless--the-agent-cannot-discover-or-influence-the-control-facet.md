---
title: §The agent cannot discover or influence the control facet
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

§The-Endo-Idiom-paragraph: *The agent cannot discover or influence the control facet. Revocation is immediate — once revoked, all future `notify()` calls throw.*

§Two-named-isolation-properties: §the-agent-cannot-discover-the-control-facet + §the-agent-cannot-influence-the-control-facet. §Five-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253).

§Revocation-is-immediate (named) + §all-future-notify-calls-throw. §Three-cycles-with-revocation-IS-permanent + §calls-throw-after (238 + 244 + 246 + 253; actually four). Let me recount: cycle 238 controller's revoke, cycle 244 IntervalControl.revoke (permanent), cycle 246 WebhookControl.revoke (permanent), cycle 253 NotifyControl.revoke (immediate-and-future-calls-throw). §Four-cycles-with-revocation-as-named-permanent-state.
