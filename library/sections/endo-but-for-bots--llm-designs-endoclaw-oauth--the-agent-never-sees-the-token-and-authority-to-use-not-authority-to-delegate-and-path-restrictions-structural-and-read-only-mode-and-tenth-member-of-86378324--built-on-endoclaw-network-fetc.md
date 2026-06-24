---
title: §Built-on-endoclaw-network-fetch (composable cluster)
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
section-id: the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
---

```
- endoclaw-network-fetch — underlying HTTP capability for making requests
- OAuth2 client library for token management (or minimal implementation)
- Daemon formula store for durable token persistence
```

§Three-named-Depends-On items. §Cycle-234-is-composed-on-top-of-cycle-226-network-fetch — §the-OAuth-capability-wraps-the-HttpClient-capability with §token-injection + §path-restrictions + §read-only-mode.

§Borrowable-pattern: §a-higher-level-capability-is-a-wrapper-around-a-lower-level-capability. §Cycle 226's network-fetch is the substrate; §cycle 234's OAuth is the §authenticated-decorator on top.

§Sibling to cycle 226 endoclaw-proactive-messages' §composable-with-other-capabilities — cycle 226 is the §composition-pattern; cycle 234 is the §composition-instance.

§The-OR-between *OAuth2 client library for token management* and *minimal implementation* — §when-the-design-doesn't-prescribe-which-library, §the-OR-leaves-it-open. §Borrowable-pattern: §when-a-design-can-use-an-existing-library-or-implement-minimally, §the-Depends-On-says-OR.
