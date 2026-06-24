---
title: §Architecture-ASCII-diagram (four-layer flow)
source-slug: endo-but-for-bots--llm-designs-endoclaw-channel-bridges
section-id: named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-channel-bridges.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-channel-bridges.md
total-lines: 183
status: Not Started (Parent: endoclaw)
ingest-cycle: 232
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
---

```
Platform (Slack, Telegram, ...)
    ↕  platform-specific protocol (handled by chat adapter)
[chat SDK — unified event model]
    ↕  thread.post() / onSubscribedMessage()
[Bridge Guest Plugin]
    ↕  E(host).send() / follow(inbox)
Endo Agent (handle + mailbox)
```

§Four-layer-flow with §named-interface-between-each-pair. §Borrowable-pattern: §when-a-design-bridges-two-substrates, §the-ASCII-diagram-shows-each-layer-and-each-interface; §the-design-doesn't-just-describe-the-endpoints-it-shows-the-translation-steps.

§Sibling to cycle 220 familiar-localhttp-protocol's §ASCII-mermaid-style-flow-diagram. §Both-designs-show-protocol-translation-at-each-layer.

§Six-cycles-with-ASCII-illustration in 2026-06 now: 214 (tree) + 218 (UI mockup) + 220 (flow diagram) + 228 (capability tree) + 230 (architecture overview) + 232 (four-layer translation flow).
