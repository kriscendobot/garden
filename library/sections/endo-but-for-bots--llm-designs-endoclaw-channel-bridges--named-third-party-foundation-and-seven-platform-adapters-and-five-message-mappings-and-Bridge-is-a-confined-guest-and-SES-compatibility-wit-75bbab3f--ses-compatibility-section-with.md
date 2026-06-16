---
title: §SES-Compatibility section with §three-named-fallback-paths
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

> The `chat` SDK is a TypeScript package with dependencies on `unified`, `remark-parse`, and `remark-stringify` (Markdown processing). These are pure JavaScript and should be compatible with SES lockdown, but the `chat` SDK itself has not been audited for SES compatibility.

§Honest-acknowledgment-of-untested-SES-compatibility + §three-named-fallback-paths:

```
1. Bundle the `chat` SDK and adapters via esbuild (same pattern as Lal/Fae bundling).
2. Test under SES lockdown for frozen-primordial compatibility.
3. Potentially shim or patch any SES-incompatible patterns (mutable module-level state, prototype mutation).
```

§The-third-path-acknowledges-the-need-for-shims if the SDK turns out to be incompatible.

### §Unconfined-plugin-fallback as §last-resort

> If the `chat` SDK proves incompatible with SES, the bridge could run as an unconfined plugin (like the web server) in an already-locked-down worker, accepting the reduced confinement in exchange for ecosystem access.

§Reduced-confinement-in-exchange-for-ecosystem-access — §the-honest-trade-off-named.

§Borrowable-pattern: §when-SES-compatibility-can't-be-guaranteed, §name-the-unconfined-fallback + §name-the-trade-off-being-accepted. §The-design-doesn't-pretend-confinement-is-unconditional + §names-the-conditions-under-which-it-degrades.

§Sibling to cycle 226 endoclaw-cluster's §two-different-confinement-philosophies + cycle 228's §named-future-stronger-isolation-mechanisms. §Three-cycles-with-graceful-degradation-of-confinement.
