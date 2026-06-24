---
title: §Power-levels-as-selectable-options
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

```
- `NONE`   — no endowments (pure sandboxed UI).
- `@endo`  — access to the Endo network (can look up capabilities by name).
- `@host`  — full host powers (development/trusted apps only).
- Custom   — select specific pet names to endow.
```

§Four-named-power-levels with §named-purpose-per-level. §The-`NONE`-power-level-is-the-safe-default (named explicitly in Security Considerations).

§Borrowable-pattern: §power-as-a-selectable-shape-with-safe-default + §custom-option-for-fine-grained-control + §development-mode-with-full-powers-named-as-such (§`@host`-is-explicitly-labeled-development/trusted-only). §Sibling to cycle 208 familiar-bundled-agents' §The-Powers-Problem-with-three-option-analysis; both designs §grapple-with-the-question-of-how-much-authority-to-grant-an-installed-application.
