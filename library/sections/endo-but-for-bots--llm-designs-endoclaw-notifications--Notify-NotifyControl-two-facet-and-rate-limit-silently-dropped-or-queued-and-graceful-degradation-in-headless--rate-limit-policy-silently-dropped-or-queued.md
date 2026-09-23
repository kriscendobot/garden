---
title: "§Rate-limit policy: silently-dropped-or-queued"
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

§The-rate-limit-policy: *Rate limiting is enforced in the `Notify` exo — calls exceeding the limit are silently dropped or queued*. §Silently-dropped-or-queued IS the policy choice (not "throws an error", not "blocks until allowed").

§When-a-rate-limited-capability-receives-a-call-that-exceeds-its-budget, §three-named-options: §silently-drop + §queue + §throw. §The-design-picks-silently-drop-OR-queue (the choice is left to the implementer) and explicitly rejects "throw". §When-the-caller-doesn't-care-about-individual-call-failure-but-cares-about-not-being-spammy, §silently-drop-or-queue-is-the-right-policy + §throwing-would-force-the-caller-to-implement-its-own-back-pressure.

§Sibling-pattern-to-cycle-244's-default-resolve-on-timeout — §two-different-shapes-of-default-non-error-policy: §cycle-244 timeout-default-resolves-forward-progress + §cycle-253 rate-limit-default-silently-drops-or-queues. §When-an-edge-case-could-throw-or-silently-handle, §pick-the-silent-handling-as-default-when-the-caller-doesn't-need-to-distinguish.

§First-explicit-observation in library of §silently-dropped-or-queued as named rate-limit policy.
