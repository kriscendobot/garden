---
title: §Five-step-bridge-plugin-flow
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
1. Receives platform credentials as an opaque capability (OAuth or HttpClient).
2. Instantiates the `chat` SDK with the appropriate adapter.
3. On platform message → forwards to the Endo agent's inbox via E(host).send(agentName, text).
4. Subscribes to the agent's inbox (follow) and forwards outgoing messages to the platform thread via thread.post().
5. Maps Endo message types to platform features.
```

§Five-named-bridge-steps. §The-bridge-IS-the-translator + §the-bridge-runs-as-a-confined-guest.

§Borrowable-pattern: §a-bridge-plugin-receives-credentials-as-capability + §instantiates-an-SDK + §forwards-bidirectionally + §maps-domain-types-to-platform-features.
