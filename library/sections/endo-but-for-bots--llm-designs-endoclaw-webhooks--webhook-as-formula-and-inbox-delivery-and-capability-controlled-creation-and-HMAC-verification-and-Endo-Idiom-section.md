---
title: "designs/endoclaw-webhooks.md — Webhook-as-formula + inbox-delivery + capability-controlled-creation + HMAC-verification + Endo Idiom section"
source-slug: endo-but-for-bots--llm-designs-endoclaw-webhooks
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-webhooks.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-webhooks.md
total-lines: 79
ingest-cycle: 246
ingest-date: 2026-06-08
lane: designs
---

# Webhook-as-formula + inbox-delivery + capability-controlled-creation + HMAC-verification + Endo Idiom section

A §79-line **Not Started** design (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). Among the §shortest-design-doc-ingests-in-library so far.

## §The shortest endoclaw cluster member

§Seventy-nine-lines as a complete capability design. §No-implementation-phases + §no-numbered-Design-Decisions + §no-Test-plan-section + §no-Prompt-section — §the-design-is-mostly-Summary + §Capability-Shape + §How-It-Works + §Endo-Idiom + §Depends-On.

§When-a-capability-is-a-narrow-extension-of-an-existing-pattern, §the-design-doc-can-be-short + §the-existing-patterns-do-the-heavy-lifting + §the-design-just-names-the-extension. §First-explicit-observation in library of §short-design-doc-as-named-shape with §five-sections-only (Summary + Capability-Shape + How-It-Works + Endo-Idiom + Depends-On).

§Sibling-pattern-to-cycle-196's-endoclaw (parent design) — the design cluster members can vary widely in length; §two-different-shapes-of-cluster-member-length: §long (cycle 244's 837-line endoclaw-timer) + §short (cycle 246's 79-line endoclaw-webhooks).

## §Webhook as formula — the load-bearing claim

§The-Endo-Idiom-section opens with §Webhooks-are-formulas. *Each webhook endpoint is a durable formula in the daemon store. It survives restarts and has a stable URL. The agent holds it via pet name in its directory.*

§The-formula-IS-the-webhook + §the-formula-id-IS-the-URL-path (`POST /webhooks/<formula-id>`). §When-a-webhook-needs-a-stable-URL-that-survives-restarts, §the-formula-IS-the-stable-handle + §the-formula-id-IS-the-URL-component. §The-URL-stability-is-derived-from-the-formula-id-not-arranged-separately.

§Sibling-pattern-to-cycle-238's-the-controller-IS-the-pet-name-handle — §two-cycles-with-the-formula-or-pet-name-IS-the-stable-identifier. §Cycle-238's-controller-pet-name-survives-CLI-invocations; §cycle-246's-formula-id-survives-daemon-restarts + §IS-the-URL-path. §Two-different-substrates-for-stable-naming.

§Sibling-to-cycle-244's-IntervalScheduler-pet-name (named SCHEDULER in agent's pet store) — §three-cycles-with-stable-cap-handles-via-pet-name (238 + 244 + 246).

## §Inbox delivery — no new abstractions for webhook handling

§The-Endo-Idiom-section's-second-discipline: §Inbox-delivery. *Webhook payloads arrive as normal inbox messages. The agent processes them with the same `follow()` mechanism it uses for human messages. No special webhook handler API — just messaging.*

§Reuse-the-mail-system-not-build-a-parallel-delivery-mechanism. §The-payload-IS-a-`package`-message + §the-body-IS-the-message-text + §the-headers-ARE-the-metadata. §The-agent-doesn't-distinguish-webhook-from-human-message — §both-flow-through-the-same-follow()-mechanism.

§Ten-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246). §Sibling-to-cycle-244's-tick-events-as-messages-not-iterator-values (same mail-system reuse pattern); §three-cycles-with-mail-system-as-the-event-substrate (cycle 232 channel-bridges-as-inbox-messages + cycle 244 tick-events-as-messages + cycle 246 webhook-payloads-as-inbox-messages).

§When-an-event-stream-could-arrive-via-a-new-API-or-via-the-existing-mail-system, §reuse-the-mail-system + §the-agent's-existing-message-loop-handles-the-new-event-type + §no-new-handler-API. §Three-cycles-with-this-mail-system-reuse-discipline.

## §Capability-controlled creation — host grants the authority

§The-Endo-Idiom-section's-third-discipline: §Capability-controlled-creation. *Not every agent can create webhooks. The host grants webhook creation authority. An agent without this authority cannot expose endpoints on the gateway.*

§The-host-is-the-gatekeeper-for-webhook-creation + §the-agent-cannot-self-grant-the-authority + §the-default-is-no-authority. §When-a-capability-could-be-self-granted-by-an-agent, §design-the-default-as-no-authority + §the-host-grants-the-capability-explicitly + §the-grant-IS-the-authorization.

§Four-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246). §Cycle-234's-the-agent-never-sees-the-token; §cycle-238's-the-controller-cap-the-host-retains; §cycle-244's-no-ambient-scheduling; §cycle-246's-capability-controlled-creation-for-webhooks.

## §HMAC verification — the secret is part of the formula

§The-Endo-Idiom-section's-fourth-discipline: §HMAC-verification. *The webhook stores a secret that external services use for payload signing (GitHub `X-Hub-Signature-256`, Stripe `Stripe-Signature`). The gateway verifies signatures before delivery, preventing spoofed events.*

§The-secret-IS-part-of-the-formula-state + §the-gateway-verifies-before-delivery + §the-agent-never-sees-an-unsigned-payload-from-an-external-source (when HMAC is configured). §When-an-external-service-can-sign-payloads, §store-the-shared-secret-in-the-formula + §verify-at-the-gateway-boundary-not-at-the-agent. §The-verification-IS-the-gateway's-responsibility-not-the-agent's.

§Two-named-external-services-cited-by-header-name (GitHub `X-Hub-Signature-256` + Stripe `Stripe-Signature`). §When-a-design-implements-a-protocol-shape-used-by-known-services, §cite-the-services-by-name-and-their-header-by-string + §the-implementer-knows-which-headers-to-honor-without-guessing.

§Sibling-to-cycle-234's-OAuth's-the-agent-never-sees-the-token — §two-cycles-with-the-secret-stays-at-the-gateway-or-control-facet-and-the-agent-uses-the-authenticated-channel-without-handling-the-credential.

## §WebhookEndpoint / WebhookControl two-facet caretaker pattern

```ts
interface WebhookEndpoint {
  url(): string;
  secret(): string;
  disable(): void;
  enable(): void;
  help(): string;
}

interface WebhookControl {
  setMaxPayloadBytes(n: number): void;
  setRateLimit(requestsPerMinute: number): void;
  revoke(): void;
  help(): string;
}
```

§WebhookEndpoint-has-five-methods + §WebhookControl-has-four-methods. §The-control-facet-has-the-policy-knobs (setMaxPayloadBytes + setRateLimit + revoke); §the-endpoint-facet-has-the-use-the-policy-methods (url + secret + disable + enable). §Four-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246).

§Asymmetry-note: §revoke()-is-on-the-control-facet + §disable()/enable()-are-on-the-endpoint-facet. §Two-different-shapes-of-deactivation: §disable-is-reversible (the agent can re-enable) + §revoke-is-permanent (the host destroys the formula). §When-a-capability-supports-both-reversible-and-permanent-deactivation, §put-the-reversible-on-the-use-facet + §put-the-permanent-on-the-control-facet. §First-explicit-observation in library of §two-shapes-of-deactivation (reversible-disable + permanent-revoke) as named distinction.

§Cycle-244's-IntervalControl-only-had-pause/resume-and-revoke (where pause/resume were on the control facet); §cycle-246's-WebhookControl has revoke but disable/enable are on the use facet. §Two-different-arrangements-of-the-reversible-vs-permanent-axis across cycles.

## §Depends-On section (different shape from Dependencies table)

```
## Depends On

- [gateway-bearer-token-auth](gateway-bearer-token-auth.md) — gateway must accept remote connections for webhooks to be useful
- [daemon-docker-selfhost](daemon-docker-selfhost.md) — self-hosted daemon is the primary deployment for webhooks
```

§The-Depends-On-section-is-a-bullet-list-with-inline-rationale + §not-a-table-with-Relationship-column. §Two-different-shapes-of-dependency-record in library: §Dependencies-table-with-Relationship-column (seven cycles: 224 + 230 + 236 + 238 + 240 + 242 + 244) + §Depends-On-bullet-list-with-inline-rationale (this cycle's shape).

§First-explicit-observation in library of §Depends-On-bullet-list-as-distinct-from-Dependencies-table. §When-a-design-has-only-two-or-three-dependencies-with-short-rationales, §a-bullet-list-with-em-dash-rationale-is-sufficient + §the-table-shape-is-overkill. §The-form-IS-the-information-density-fit.

§Sibling-to-cycle-244's-three-row-Dependencies-table (where the design had explicit Relationship column); §cycle-246's-two-bullet-Depends-On-section is the lighter weight. §Two-different-shapes-of-dependency-record-fit-different-design-sizes.

## §Five-section design as named shape

§The-design's-section-list:

1. **Summary** (one paragraph)
2. **Capability Shape** (TypeScript interfaces)
3. **How It Works** (six-step numbered list)
4. **Endo Idiom** (four named disciplines)
5. **Depends On** (bullet list)

§Five-sections-as-named-design-shape. §No-Status-section-beyond-the-frontmatter + §no-Test-Plan + §no-Design-Decisions + §no-Open-Questions + §no-Prompt-section. §The-design-is-self-contained — §everything-needed-to-understand-the-capability-is-in-the-five-sections.

§When-a-design-is-mostly-a-named-application-of-existing-patterns, §the-five-section-shape-is-sufficient. §Sibling-to-cycle-242's-seven-named-Design-Decisions (where the design needed more structure); §cycle-246's-five-section-shape needs less structure because the cluster's existing patterns do the heavy lifting.

## §The Endo Idiom section as recurring design-doc shape

§Endo-Idiom-section enumerates §four-named-disciplines: §Webhooks-are-formulas + §Inbox-delivery + §Capability-controlled-creation + §HMAC-verification. §The-four-bold-headings-with-prose-rationale + §each-paragraph-IS-a-single-named-discipline.

§Two-cycles-with-Endo-Idiom-section-with-four-named-disciplines (cycle 232 channel-bridges + cycle 246 webhooks). §When-a-design-extends-an-existing-cluster-with-named-disciplines, §the-Endo-Idiom-section-IS-the-named-cluster's-vocabulary-applied-to-this-design.

§Cycle-232's-Endo-Idiom-had-five-named-disciplines; §cycle-246's-has-four. §Different-counts-each-time. §The-named-discipline-list-IS-the-design's-shape — §not-padded-to-a-template.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Webhook-as-formula — the formula IS the webhook + the formula-id IS the URL path.
- §Inbox-delivery — webhook payloads arrive as normal inbox messages; reuses `follow()` mechanism.
- §Capability-controlled-creation — host grants the authority; default is no authority.
- §HMAC-verification — secret stored in the formula; gateway verifies at the boundary.
- §Two-named-external-services-cited-by-header-name (GitHub + Stripe) — implementer knows which headers to honor.
- §WebhookEndpoint / WebhookControl two-facet caretaker pattern (fourth instance).
- §Two-shapes-of-deactivation — reversible disable on the use facet + permanent revoke on the control facet.

**Tier-2 (design-doc shape patterns):**

- §Short-design-doc-as-named-shape with five-sections-only.
- §Depends-On-bullet-list-as-distinct-from-Dependencies-table — lighter weight for two-or-three deps.
- §Five-section design as named shape (Summary + Capability Shape + How It Works + Endo Idiom + Depends On).
- §Endo-Idiom-section as recurring design-doc shape with N-named-disciplines.

**Tier-3 (named comparisons):**

- §The-cluster-grows-with-different-design-sizes (244 long + 246 short).
- §Two-different-shapes-of-dependency-record (Dependencies-table + Depends-On-bullet-list).
- §Three-cycles-with-mail-system-as-the-event-substrate (232 + 244 + 246).
- §Ten-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246).

## §Synthesis target — slot machine library

For a slot machine library:

- §Game-event-as-formula — each external event subscription is a durable formula with stable URL/identifier.
- §Inbox-delivery for §game-event-payloads-arrive-as-normal-game-messages.
- §Capability-controlled-creation — host grants the game-event-creation authority; default is no authority.
- §HMAC-verification for §external-payment-events-signed-by-payment-processor.
- §Two-named-external-services-cited-by-header-name for §game-payment-integration-with-Stripe-or-similar-header-conventions.
- §WebhookEndpoint / WebhookControl pattern for §game-event-endpoint-vs-game-event-control.
- §Two-shapes-of-deactivation — §reversible-disable for game-pause + §permanent-revoke for game-deletion.
- §Short-design-doc-as-named-shape for §game-feature-spec-extending-existing-cluster.
- §Depends-On-bullet-list-as-distinct-from-Dependencies-table for §lightweight-game-feature-spec.
- §Five-section design as named shape for §game-feature-doc-template.
- §Endo-Idiom-section as recurring design-doc shape for §game-design-doc's-vocabulary-applied-to-this-feature.

## §Library meta-counters

- §Library-reaches-752-sections at cycle 246 (designs-lane endoclaw-webhooks).
- §Eightieth-consecutive designs-chat alternation cycle (cycles 166-246).
- §Thirteenth-design-cluster-member for endoclaw + cli-http + cli-store (cycles 222 + 226 (six members) + 232 + 234 + 244 + 246 + ...).
- §Ten-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246).
- §Four-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246).
- §Four-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246).
- §Three-cycles-with-mail-system-as-the-event-substrate (232 + 244 + 246).
- §Three-cycles-with-stable-cap-handles-via-pet-name-or-formula-id (238 + 244 + 246).
- §Two-cycles-with-Endo-Idiom-section-with-N-named-disciplines (232 + 246) — cycle 232 had five + cycle 246 has four; §different-counts-each-time.
- §Two-different-shapes-of-dependency-record in library (Dependencies-table 224/230/236/238/240/242/244 + Depends-On-bullet-list 246).
- §Two-different-shapes-of-cluster-member-length (244 long 837-lines + 246 short 79-lines).
- §First-explicit-observation of §two-shapes-of-deactivation (reversible-disable + permanent-revoke).
- §First-explicit-observation of §short-design-doc-as-named-shape with five-sections-only.
- §First-explicit-observation of §Depends-On-bullet-list-as-distinct-from-Dependencies-table.

(Kris Kowal (prompted) authored)
