---
title: §Six-step-OAuth-flow
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
1. Host initiates OAuth flow (browser redirect or device code grant) and stores the token in the daemon's formula store.
2. Host creates an OAuth / OAuthControl pair bound to the stored token and a base URL.
3. Host grants the OAuth facet to an agent via pet name.
4. Agent calls E(gmail).fetch('/gmail/v1/users/me/messages').
5. The OAuth exo prepends baseUrl + validates path + checks method + injects Authorization header + makes request.
6. Token refresh is handled transparently by the exo.
```

§Six-named-steps with §step-5-as-the-five-substep-internal-flow. §Borrowable-pattern: §the-exo-does-five-substeps-on-each-call (prepend + validate + check + inject + make); §the-user-sees-only-the-fetch-call.

§Token-refresh-handled-transparently-by-the-exo — §the-agent-doesn't-know-when-tokens-are-refreshed; §the-control-facet's-refresh-method-exists-for-explicit-force-refresh but the §default-path-is-transparent. §Borrowable-pattern: §lifecycle-events-handled-transparently-by-default + §explicit-control-via-control-facet-method.
