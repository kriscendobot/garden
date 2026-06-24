---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §Notify / NotifyControl two-facet caretaker pattern at its most compact (5th instance).
- §Single-rate-limit-axis as the simplest possible control surface.
- §Silently-dropped-or-queued as named rate-limit policy (vs throw).
- §Graceful-degradation-across-substrates — primary substrate absent → degrade to alternate substrate, not fail.
- §Two-named-degradation-targets (log entries + Chat UI system messages).
- §Named-non-dependency as design discipline (explicit *No other designs required*).
- §The-agent-cannot-discover-or-influence-the-control-facet (canonical phrasing).
- §Revocation-is-immediate + §all-future-calls-throw as named permanence.

**Tier-2 (design-doc shape patterns):**

- §Two-cycles-with-five-section-design-shape (246 + 253).
- §Endo-Idiom-section-as-one-paragraph (not four-named-disciplines as cycle 246).
- §How-It-Works as four-step numbered list.
- §Two-bullet-list Depends-On with second bullet as explicit non-dependency.

**Tier-3 (named comparisons):**

- §Five-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253).
- §Five-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253).
- §Three-cycles-with-named-substrate-routing-discipline (244 forbid-ambient + 246 reuse-existing + 253 degrade-to-alternate).
- §Three-cycles-with-explicit-acknowledgment-of-no-content-in-named-section (248 + 250 + 253).
- §Two-different-shapes-of-default-non-error-policy (244 timeout-resolves-forward + 253 rate-limit-silently-drops-or-queues).
- §Three-cycles-with-variable-control-facet-size (244 six methods + 246 four methods + 253 three methods).
- §Smallest-endoclaw-cluster-member-yet at 55 lines.
