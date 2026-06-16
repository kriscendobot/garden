---
title: §Method-placement-table — which methods sit on which facet
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

A §method-placement-table enumerates each method and its facet:

| Method | Facet | Notes |
|---|---|---|
| `request(req, cancellation)` | client | The use-the-policy authority. |
| `allowedOrigins()` | client | Inspection of own bounds. |
| `help()` | both | Each describes its own surface. |
| `inspect()` | controller | Read the current policy. |
| `setAllowedOrigins(origins)` | controller | Replaces the set. |
| `addAllowedOrigin(origin)` | controller | Convenience. |
| `removeAllowedOrigin(origin)` | controller | Convenience. |
| `setMaxRequestsPerMinute(n)` | controller | |
| `setMaxResponseBytes(n)` | controller | |
| `setTimeoutMs(n)` | controller | |
| `revoke()` | controller | Idempotent; flips the shared bit. |

§The-table-IS-the-cap-discipline-statement. §help-on-both-facets-is-a-named-asymmetry-not-a-symmetry — *each describes its own surface*. §When-each-facet-has-a-help-method, §each-help-describes-its-own-surface-not-the-pair's-surface.

§The-add-and-remove-convenience-methods are §the-CLI-verbs-`endo http allow / deny`-back-onto: without them the CLI would have to read-then-mutate-then-write the set, §which-races-against-any-concurrent-host-side-mutation. §When-a-mutation-naturally-decomposes-into-read-mutate-write, §the-controller-MUST-expose-it-as-an-atomic-operation + §the-CLI-verb-MUST-bind-to-the-atomic-operation + §convenience-methods-prevent-races.
