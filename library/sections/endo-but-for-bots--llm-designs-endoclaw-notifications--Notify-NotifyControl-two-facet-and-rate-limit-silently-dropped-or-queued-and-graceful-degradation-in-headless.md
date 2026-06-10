---
title: "designs/endoclaw-notifications.md — Notify/NotifyControl two-facet + rate-limit silently-dropped-or-queued + graceful degradation in headless"
source-slug: endo-but-for-bots--llm-designs-endoclaw-notifications
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-notifications.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-notifications.md
total-lines: 55
ingest-cycle: 253
ingest-date: 2026-06-09
lane: designs
---

# Notify/NotifyControl two-facet + rate-limit silently-dropped-or-queued + graceful degradation in headless + smallest endoclaw cluster member yet

A §55-line **Not Started** design (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). The §smallest endoclaw cluster member ingested so far (cycle 246's webhooks was 79 lines; this is 55).

## §Notify / NotifyControl — fifth instance of the caretaker two-facet

§The-canonical-two-facet-caretaker-pattern at its most compact:

```ts
interface Notify {
  notify(title: string, body: string): Promise<void>;
  help(): string;
}

interface NotifyControl {
  setMaxPerMinute(n: number): void;
  revoke(): void;
  help(): string;
}
```

§Two-method-use-facet (notify + help) + §three-method-control-facet (setMaxPerMinute + revoke + help). §Smallest-known-instance of the cluster's caretaker pattern. §Five-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253).

§Single-rate-limit-axis (`setMaxPerMinute`) — §the-simplest-possible-control-surface. §When-the-only-policy-knob-needed-is-a-rate-limit, §the-control-facet-can-be-three-methods-not-six. §Sibling-pattern-to-cycle-244's-IntervalControl (six methods) and cycle-246's-WebhookControl (four methods) — §three-cycles-with-variable-control-facet-size (244 + 246 + 253) — §the-control-facet's-method-count-IS-the-policy-surface's-size.

## §Rate-limit policy: silently-dropped-or-queued

§The-rate-limit-policy: *Rate limiting is enforced in the `Notify` exo — calls exceeding the limit are silently dropped or queued*. §Silently-dropped-or-queued IS the policy choice (not "throws an error", not "blocks until allowed").

§When-a-rate-limited-capability-receives-a-call-that-exceeds-its-budget, §three-named-options: §silently-drop + §queue + §throw. §The-design-picks-silently-drop-OR-queue (the choice is left to the implementer) and explicitly rejects "throw". §When-the-caller-doesn't-care-about-individual-call-failure-but-cares-about-not-being-spammy, §silently-drop-or-queue-is-the-right-policy + §throwing-would-force-the-caller-to-implement-its-own-back-pressure.

§Sibling-pattern-to-cycle-244's-default-resolve-on-timeout — §two-different-shapes-of-default-non-error-policy: §cycle-244 timeout-default-resolves-forward-progress + §cycle-253 rate-limit-default-silently-drops-or-queues. §When-an-edge-case-could-throw-or-silently-handle, §pick-the-silent-handling-as-default-when-the-caller-doesn't-need-to-distinguish.

§First-explicit-observation in library of §silently-dropped-or-queued as named rate-limit policy.

## §Graceful degradation in headless

§The-Endo-Idiom: *In Docker/headless mode, notifications degrade to log entries or could be forwarded to the Chat UI as system messages*. §Two-named-degradation-targets (log entries + Chat UI system messages).

§Graceful-degradation-across-substrates as named pattern. §When-the-primary-substrate-(Electron Notification API)-isn't-available, §degrade-to-the-next-best-substrate + §don't-fail-the-capability-itself. §The-agent's-API-doesn't-change; §the-substrate-the-API-routes-to-changes.

§First-explicit-observation in library of §graceful-degradation-across-substrates as named capability-implementation discipline.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling and cycle-246's-inbox-delivery — §three-different-shapes-of-substrate-routing in 2026-06: §cycle-244 forbids-ambient-substrate + §cycle-246 reuses-existing-mail-substrate + §cycle-253 degrades-to-alternate-substrate-when-primary-unavailable. §Three-cycles-with-named-substrate-routing-discipline.

## §The agent cannot discover or influence the control facet

§The-Endo-Idiom-paragraph: *The agent cannot discover or influence the control facet. Revocation is immediate — once revoked, all future `notify()` calls throw.*

§Two-named-isolation-properties: §the-agent-cannot-discover-the-control-facet + §the-agent-cannot-influence-the-control-facet. §Five-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253).

§Revocation-is-immediate (named) + §all-future-notify-calls-throw. §Three-cycles-with-revocation-IS-permanent + §calls-throw-after (238 + 244 + 246 + 253; actually four). Let me recount: cycle 238 controller's revoke, cycle 244 IntervalControl.revoke (permanent), cycle 246 WebhookControl.revoke (permanent), cycle 253 NotifyControl.revoke (immediate-and-future-calls-throw). §Four-cycles-with-revocation-as-named-permanent-state.

## §Standalone capability — no other designs required

§Depends-On-section: *Familiar (Electron) for desktop notifications + No other designs required; standalone capability*. §Two-bullet-list with §the-second-bullet-named-as-explicit-non-dependency.

§Named-non-dependency as design discipline. §When-a-capability-design-has-no-design-dependencies, §explicitly-say-so + §don't-omit-the-Depends-On-section + §the-explicit-non-dependency-IS-the-completeness-signal.

§Sibling-pattern-to-cycle-248's-Upgrade-Considerations-`None` and cycle-250's-Upgrade-Considerations-`No-migration-needed` — §three-cycles-with-explicit-acknowledgment-of-no-content-in-named-section (248 + 250 + 253). §Different-named-sections-with-same-acknowledgment-discipline.

## §Smallest endoclaw cluster member yet

§Section-count: Summary + Capability Shape + How It Works + Endo Idiom + Depends On — §the-same-five-section-shape-as-cycle-246-webhooks. §Two-cycles-with-the-five-section-shape (246 + 253).

§Endo-Idiom-section-IS-one-paragraph-with-two-named-properties (not four-named-disciplines as cycle 246 or five as cycle 232). §The-Endo-Idiom-section's-paragraph-count-varies-with-the-capability's-complexity. §When-a-capability-is-narrow-enough, §the-Endo-Idiom-can-be-a-single-paragraph + §don't-force-named-disciplines.

§How-It-Works-has-four-steps (host creates → agent calls → Familiar receives → rate-limit-enforced). §Smaller-than-cycle-246's-six-step-How-It-Works.

§The-design's-size-IS-the-capability's-complexity. §When-the-capability-IS-narrow, §the-design-IS-short. §Six-cycles-with-five-section-design-as-named-shape (246 + 253) — wait, two. Two-cycles-with-five-section-design-shape.

## §Borrowable patterns

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

## §Synthesis target — slot machine library

For a slot machine library:

- §game-notification / game-notification-control two-facet pattern for §player-notifications-with-host-rate-limit.
- §single-rate-limit-axis for §the-simplest-game-notification-control.
- §silently-dropped-or-queued for §game-notification-overflow-policy (game doesn't throw when the player is notified too fast).
- §graceful-degradation-across-substrates for §game-notification-degrades-to-game-log-when-desktop-API-absent.
- §two-named-degradation-targets for §game-log + §game-UI-banner.
- §named-non-dependency as completeness signal for §narrow-game-feature-with-no-design-deps.
- §the-agent-cannot-discover-or-influence-the-control-facet for §game-rule-cannot-self-grant-rate-bump.
- §revocation-is-immediate for §game-notification-revoke-and-future-calls-throw.

## §Library meta-counters

- §Library-reaches-759-sections at cycle 253 (designs-lane endoclaw-notifications).
- §Eighty-sixth-consecutive designs-chat alternation cycle (cycles 166-250 + 252-253; cycle 251 was out-of-band papers).
- §Smallest-endoclaw-cluster-member-yet at 55 lines.
- §Five-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253).
- §Five-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253).
- §Four-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253).
- §Three-cycles-with-named-substrate-routing-discipline (244 + 246 + 253).
- §Three-cycles-with-explicit-acknowledgment-of-no-content-in-named-section (248 + 250 + 253).
- §Three-cycles-with-variable-control-facet-size (244 six methods + 246 four methods + 253 three methods).
- §Two-cycles-with-five-section-design-shape (246 + 253).
- §Two-different-shapes-of-default-non-error-policy (244 + 253).
- §First-explicit-observation of three patterns: §silently-dropped-or-queued as named rate-limit policy + §graceful-degradation-across-substrates as named capability-implementation discipline + §named-non-dependency as design discipline.

(Kris Kowal (prompted) authored)
