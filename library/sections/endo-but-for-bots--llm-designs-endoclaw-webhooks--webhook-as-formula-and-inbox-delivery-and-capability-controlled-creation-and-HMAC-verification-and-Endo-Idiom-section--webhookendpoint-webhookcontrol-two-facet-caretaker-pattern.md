---
title: §WebhookEndpoint / WebhookControl two-facet caretaker pattern
source-slug: endo-but-for-bots--llm-designs-endoclaw-webhooks
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-webhooks.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-webhooks.md
total-lines: 79
ingest-cycle: 246
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section
---

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
