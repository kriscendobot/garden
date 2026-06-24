---
title: "§The-load-bearing-architectural-property: §the-agent-never-sees-the-token"
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

> The `OAuth` interface has no method that returns the credential. The agent can *use* the service but cannot extract the token to forward it elsewhere or use it on a different endpoint. This is the canonical ocap pattern: authority to use, not authority to delegate outside the capability graph.

§Borrowable-pattern: §authority-to-use-not-authority-to-delegate-outside-the-capability-graph. §The-canonical-ocap-pattern-named-explicitly. §The-agent-never-sees-the-token is §a-structural-invariant-of-the-interface-not-a-runtime-check.

§Borrowable-pattern: §when-a-capability-must-not-leak-its-underlying-credential, §design-the-interface-so-no-method-returns-the-credential + §the-credential-only-flows-through-the-call-not-through-a-getter.

§Sibling to cycle 226 endoclaw-cluster's §structural-confinement-checked-inside-exo-at-only-call-site + cycle 224 daemon-web-gateway's §bearer-token-as-formula-ID. §Different-from-cycle-224: cycle-224 makes the formula-ID-IS-the-token (the agent has the identifier); cycle-234 hides the token entirely (the agent never sees it). §Two-different-capability-shapes for §two-different-trust-relationships.
