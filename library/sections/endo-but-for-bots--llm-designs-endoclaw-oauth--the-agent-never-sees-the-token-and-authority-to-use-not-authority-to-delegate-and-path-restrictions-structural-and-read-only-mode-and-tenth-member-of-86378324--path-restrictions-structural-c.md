---
title: §Path-restrictions-structural-confinement
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

> `OAuthControl.setAllowedPaths(['/gmail/v1/users/me/messages*'])` limits the agent to specific API endpoints. An agent with Gmail read access cannot call the Calendar API on the same Google domain.

§Within-the-baseUrl, §the-path-allowlist-further-confines-which-endpoints-are-callable. §Borrowable-pattern: §two-layer-confinement (baseUrl scope + path allowlist within scope). §The-baseUrl-IS-the-coarse-scope; §the-path-allowlist-IS-the-fine-scope.

§Sibling to cycle 226 endoclaw-network-fetch's §origin-allowlist-is-structural — both designs §allowlist-checked-inside-the-exo. §Different-layer: cycle 226 allowlist is origins (cross-host); cycle 234 allowlist is paths within a single host.

§The-example-is-particularly-load-bearing: §an-agent-with-Gmail-read-access-cannot-call-the-Calendar-API-on-the-same-Google-domain. §Two-Google-APIs-on-the-same-domain-with-different-confinement-scopes. §The-domain-is-not-the-confinement-boundary; §the-path-is.

§Borrowable-pattern: §named-positive-example-with-distinct-API-on-same-domain illustrates the §subdomain-vs-path-distinction.
