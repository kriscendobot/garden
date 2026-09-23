---
title: §Notify / NotifyControl — fifth instance of the caretaker two-facet
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
