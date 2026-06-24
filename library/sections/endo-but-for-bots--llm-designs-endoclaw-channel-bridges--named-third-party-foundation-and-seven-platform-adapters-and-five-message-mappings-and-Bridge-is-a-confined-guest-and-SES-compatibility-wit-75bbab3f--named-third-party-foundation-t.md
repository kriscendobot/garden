---
title: "§Named-third-party-foundation: the Vercel `chat` SDK"
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

> The [`chat`](https://www.npmjs.com/package/chat) package (Vercel) is the recommended foundation. It provides a unified adapter SDK: write bridge logic once against `Chat` + `thread.post()` / `thread.subscribe()`, and platform adapters handle protocol differences for Slack, Teams, Discord, Telegram, Google Chat, GitHub, and Linear.

§Borrowable-pattern: §recommend-a-named-third-party-SDK + §explain-the-abstraction-it-provides + §enumerate-the-platforms-it-covers. §The-design-doesn't-invent-a-bridge-SDK; §it-builds-on-an-existing-one.

§Sibling to cycle 226 endoclaw-cluster's §composable-with-other-capabilities — but cycle 232 §composes-with-external-not-just-Endo-substrates. §Endo-meets-the-broader-ecosystem at this design's boundary.

§Different-from-cycle-228 daemon-os-sandbox-plugin's §three-named-future-stronger-isolation-mechanisms (cycle 228 names future paths; cycle 232 names a current available SDK). §The-design-leans-on-existing-work-rather-than-naming-future-replacements.
