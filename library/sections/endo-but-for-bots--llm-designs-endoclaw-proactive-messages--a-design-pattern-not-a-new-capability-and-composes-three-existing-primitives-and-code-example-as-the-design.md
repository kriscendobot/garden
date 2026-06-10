---
title: "designs/endoclaw-proactive-messages.md — a design pattern not a new capability + composes three existing primitives + code example as the design"
source-slug: endo-but-for-bots--llm-designs-endoclaw-proactive-messages
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-proactive-messages.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-proactive-messages.md
total-lines: 74
ingest-cycle: 257
ingest-date: 2026-06-10
lane: designs
---

# A design pattern not a new capability + composes three existing primitives + code example as the design

A §74-line **Not Started** design (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). Distinctive among endoclaw cluster members: §a-design-pattern-not-a-new-capability — explicitly classified as neither UI nor a new capability, but a composition of existing primitives.

## §A design pattern — not a new capability

§The-Summary-opens-with-the-load-bearing-classification: *A design pattern — not a new capability — for agents that initiate conversations with the host on a schedule*. §First-explicit-observation in library of §design-pattern-not-a-capability as named-design-axis.

§Three-named-categories-of-Endo-feature-classification now in library:

1. **Capability** — grants new authority. The endoclaw two-facet pattern. Cycles 222 (skill-registry), 226 (six-design-cluster), 232 (channel-bridges), 234 (OAuth), 244 (timer), 246 (webhooks), 253 (notifications).
2. **UI feature** — does not grant new authority. Cycle 255 (voice-input), cycles 248 (drag-drop) + 250 (inventory-grouping) for chat-UI cluster.
3. **Design pattern** — composes existing capabilities without introducing new ones. Cycle 257 (proactive-messages).

§Three-named-categories-as-Endo-feature-classification-axis. §First-explicit-observation in library of §three-named-categories-of-Endo-feature-classification (capability + UI-feature + design-pattern).

§Sibling-pattern-to-cycle-255's-UI-vs-capability-as-named-design-axis — §cycle-255-introduced-the-two-category-distinction + §cycle-257-extends-it-to-three-categories. §Two-cycles-with-explicit-Endo-feature-classification-axis (255 + 257). §The-three-category-classification-IS-the-design's-stance-toward-new-mechanism.

## §Code example as the design

```js
const setup = async (powers) => {
  const timer = await E(powers).lookup('timer');
  const gmail = await E(powers).lookup('gmail');
  const host = await E(powers).lookup('@host');

  // Morning briefing at 08:00 every day
  await E(timer).schedule('0 8 * * *', async () => {
    const unread = await E(gmail).fetch('/messages?q=is:unread&maxResults=5');
    const summary = await summarizeWithLLM(unread);
    await E(host).send('@host', summary);
  });
};
```

§The-code-example-IS-the-design — §the-fourteen-line-snippet shows the entire pattern. §No-Capability-Shape-section-because-no-new-capability — §the-code-example-replaces-the-Capability-Shape-section.

§First-explicit-observation in library of §code-example-as-the-design (as distinct from Capability-Shape-as-the-design). §When-a-design-is-a-composition-pattern-not-a-new-capability, §the-code-example-IS-the-spec + §the-Capability-Shape-section-is-absent-not-forgotten.

§Three-lookups-then-one-schedule — §the-composition-IS-the-pattern: §look-up-the-three-substrate-caps + §compose-them-in-a-single-async-callback + §the-callback-IS-the-agent's-policy. §Sibling-pattern-to-cycle-244's-IntervalScheduler-pet-name-handle (the scheduler's stable pet-name `SCHEDULER` accessible to the agent) — §cycle-257's-`E(powers).lookup('timer')` uses-the-same-discovery-mechanism.

## §`@host` as named special pet name

```js
const host = await E(powers).lookup('@host');
// ...
await E(host).send('@host', summary);
```

§The-`@host`-pet-name uses the §`@`-prefix-convention for §system-special-pet-names (sibling to cycle 250's reference to `@self` and `@agent`). §First-explicit-observation in library of §`@host`-as-named-special-pet-name + §the-`@`-prefix-as-system-namespace-convention.

§The-`@host`-IS-both-the-pet-name-of-the-host-and-the-target-of-the-message (`E(host).send('@host', summary)`). §The-double-use suggests `@host` is the canonical name for the host both as a referent and as a recipient.

§Sibling-pattern-to-cycle-250's-system-items-with-@-prefix-remain-with-existing-toggle — §two-cycles-with-`@`-prefix-system-pet-names (250 + 257). §First-explicit-observation in library of §the-`@`-prefix-as-system-pet-name-convention as named architecture-pattern.

## §`E(timer).schedule(cron, callback)` — note vs cycle 244's interface

§The-code-example-uses-`E(timer).schedule('0 8 * * *', callback)` — §cron-string-as-the-scheduler-API. §This-conflicts-with-cycle-244's-IntervalScheduler-which-takes-periodMs-not-cron. §Two-cycles-with-internally-inconsistent-design-vocabulary-in-the-same-cluster (244 + 257).

§Three-named-possibilities for the conflict: §the-Proactive-Messages-design-predates-the-Heartbeat-Scheduler-design-and-was-not-updated + §the-`timer`-in-cycle-257-is-a-different-capability-than-cycle-244's-IntervalScheduler + §the-cron-string-IS-meant-as-illustrative-pseudocode-not-the-literal-API.

§Reading-the-cycle-244-design-carefully (No-cron-semantics — Design Decision 5): *Any higher-level scheduling policy — "run at 8 AM daily," "run every weekday," etc. — is implemented by the agent in its tick handler*. §So-cycle-244's-IntervalScheduler-doesn't-support-cron + §cycle-257's-`E(timer).schedule('0 8 * * *', callback)`-must-be-an-agent-side-pseudocode-wrapper-around-the-IntervalScheduler.

§First-explicit-observation in library of §two-cluster-members-with-internally-inconsistent-design-vocabulary-resolved-by-reading-as-pseudocode. §The-inconsistency-IS-a-signal-that-the-cluster-vocabulary-is-still-evolving + §later-designs-may-clarify-which-shape-is-canonical.

§Sibling-pattern-to-cycle-250's-Options-Considered-with-preferred — §two-cycles-where-the-design-text-implies-a-canonical-API-that-was-revised-later. §Two-cycles-with-evidence-of-cluster-vocabulary-evolution (250 + 257).

## §The agent cannot exceed its granted capabilities

§The-Endo-Idiom-paragraph: *The agent cannot exceed its granted capabilities — if it only has read-only Gmail access, it cannot send emails. If its timer is capped at once per hour, it cannot spam.*

§Capability-by-construction-via-composition — §the-design-pattern-IS-bounded-by-the-substrate-caps + §the-pattern-itself-cannot-relax-the-bounds. §Six-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257).

§Two-named-grant-bounds-in-the-example: §read-only-Gmail-cannot-send + §timer-capped-at-once-per-hour-cannot-spam. §Each-bound-IS-the-substrate-cap's-policy-knob. §When-the-pattern-is-bounded-by-the-substrate-caps-not-by-its-own-logic, §name-the-bounds-explicitly + §the-bounds-IS-the-evidence-of-the-pattern's-safety.

## §Composition with existing notification capability

§The-Endo-Idiom-paragraph-closes-with: *The Familiar's notification capability ([endoclaw-notifications](endoclaw-notifications.md)) can complement this: the agent sends the briefing to the inbox and posts a desktop notification to alert the user.*

§Cross-cluster-composition — §the-proactive-messages-pattern-composes-with-the-notifications-capability + §the-composition-IS-the-design-extension-point. §Two-cycles-cross-referenced-as-complementary (257 + 253).

§First-explicit-observation in library of §cross-cluster-composition-as-named-design-extension-point. §When-two-cluster-members-are-complementary, §reference-the-other-in-the-Endo-Idiom-section + §don't-force-the-reader-to-discover-the-composition.

## §Four named use cases

§The-Use-Cases-section enumerates §four-named-uses:

1. Morning briefing (unread emails, today's calendar, weather)
2. Reminder for upcoming events
3. Alert when a monitored file or service changes
4. Periodic project status reports from git history

§Use-Cases-section-with-four-named-uses. §First-explicit-observation in library of §Use-Cases-section-as-named-design-doc-section (distinct from §How-It-Works-as-narrative + §Pattern-as-code-example). §The-section-doesn't-spec-each-use-case + §it-just-names-them-as-evidence-that-the-pattern-has-multiple-applications.

§Sibling-pattern-to-cycle-234's-Use-Cases-section (which enumerates five named OAuth targets) — §two-cycles-with-Use-Cases-section-enumerating-named-use-cases. §Two-cycles-with-enumerate-concrete-use-cases-and-then-generalize discipline.

## §No Capability Shape + No Interface Guards — design-pattern-shape evidence

§The-design-has §no-Capability-Shape-section + §no-Interface-Guards-section + §no-Formula-Type-section. §The-absence-of-these-sections IS-the-evidence-that-this-is-not-a-capability-design.

§Compare-to-cycle-244's-endoclaw-timer-which-has-all-three-sections + §cycle-244-IS-a-capability-design. §The-section-inventory-distinguishes-design-pattern-from-capability.

§First-explicit-observation in library of §the-section-inventory-distinguishes-design-pattern-from-capability.

## §Six-section design shape: Summary + Pattern + How-It-Works + Endo-Idiom + Use-Cases + Depends-On

§The-design's-six-named-sections: §Summary + §Pattern (code example) + §How-It-Works (numbered list) + §Endo-Idiom + §Use-Cases + §Depends-On. §Sibling-to-cycle-246's-five-section-shape (Summary + Capability-Shape + How-It-Works + Endo-Idiom + Depends-On) + cycle-253's-same-five-section-shape.

§Section-substitution: §the-Pattern-section-(code example)-replaces-the-Capability-Shape-section + §the-Use-Cases-section-is-added. §When-a-design-is-a-pattern-not-a-capability, §replace-Capability-Shape-with-Pattern (the code example) + §add-Use-Cases-to-show-the-pattern-has-multiple-applications.

§First-explicit-observation in library of §six-section-design-pattern-shape (distinct from §five-section-design-shape).

## §Depends On — three substrate dependencies

§Three-bullet-list:

- [endoclaw-timer](endoclaw-timer.md) — scheduling capability
- Data source capabilities (OAuth, Dir, etc.) for gathering information
- Existing Endo messaging (`send`, `package`)

§Three-substrate-dependencies-IS-the-composition-evidence. §The-pattern-doesn't-introduce-a-new-substrate + §it-uses-three-existing-ones. §The-Depends-On-list-IS-the-evidence-of-the-design-pattern-classification.

§Sibling-pattern-to-cycle-246's-`Endo-Idiom` opening assertion "Webhooks are formulas" — §two-cycles-with-Endo-Idiom-section-as-classification-evidence (246 + 257). §When-a-design-makes-a-load-bearing-classification-claim, §the-Endo-Idiom-section + §the-Depends-On-section-IS-the-evidence-for-the-claim.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §A-design-pattern-not-a-new-capability — load-bearing classification.
- §Three-named-categories-of-Endo-feature-classification (capability + UI-feature + design-pattern).
- §Code-example-as-the-design — fourteen-line snippet replaces Capability-Shape section.
- §Cross-cluster-composition-as-named-design-extension-point.
- §The-section-inventory-distinguishes-design-pattern-from-capability.
- §Capability-by-construction-via-composition — the design-pattern is bounded by the substrate caps.
- §Two-named-grant-bounds-in-the-example — each bound IS the substrate cap's policy knob.

**Tier-2 (design-doc shape patterns):**

- §Six-section design-pattern shape (Summary + Pattern + How-It-Works + Endo-Idiom + Use-Cases + Depends-On).
- §Pattern-section (code example) replaces Capability-Shape-section.
- §Use-Cases-section as named design-doc section.
- §Three-substrate-dependencies-IS-the-composition-evidence.

**Tier-3 (named comparisons):**

- §Six-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257).
- §Two-cycles-with-`@`-prefix-system-pet-names (250 + 257).
- §Two-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257).
- §Two-cycles-with-cross-cluster-composition (253 + 257).
- §Two-cycles-with-evidence-of-cluster-vocabulary-evolution (250 + 257) — the IntervalScheduler API mismatch between cycle 244 and cycle 257's code example.
- §Two-cycles-with-explicit-Endo-feature-classification-axis (255 + 257).

## §Synthesis target — slot machine library

For a slot machine library:

- §A-design-pattern-not-a-new-game-capability for §game-feature-patterns-that-compose-existing-rules.
- §Three-named-categories-of-game-feature-classification (game-capability + game-UI-feature + game-design-pattern).
- §Code-example-as-the-design for §game-pattern-snippet replaces game-rule-spec section.
- §Cross-cluster-composition for §game-feature-composes-with-other-game-features.
- §The-section-inventory-distinguishes-design-pattern-from-capability for §game-doc-classification.
- §Capability-by-construction-via-composition for §game-pattern-bounded-by-substrate-rules.
- §Use-Cases-section enumerating named game scenarios.

## §Library meta-counters

- §Library-reaches-763-sections at cycle 257 (designs-lane endoclaw-proactive-messages).
- §Ninetieth-consecutive designs-chat alternation cycle (cycles 166-250 + 252-257; cycle 251 was out-of-band papers).
- §Six-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257).
- §Two-cycles-with-`@`-prefix-system-pet-names (250 + 257).
- §Two-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257).
- §Two-cycles-with-cross-cluster-composition (253 + 257).
- §Two-cycles-with-evidence-of-cluster-vocabulary-evolution (250 + 257).
- §Two-cycles-with-explicit-Endo-feature-classification-axis (255 + 257).
- §Three-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257) — distinct from earlier counts because cycle 255 explicitly didn't use named disciplines.
- §First-explicit-observation of six patterns: §design-pattern-not-a-capability as named-design-axis + §three-named-categories-of-Endo-feature-classification + §code-example-as-the-design + §the-`@`-prefix-as-system-pet-name-convention + §cross-cluster-composition-as-named-design-extension-point + §the-section-inventory-distinguishes-design-pattern-from-capability.

(Kris Kowal (prompted) authored)
