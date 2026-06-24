---
title: §Authorization hardening — six SEPs for OAuth/OpenID Connect alignment
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
parent: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum
---

§Six-SEPs-harden-the-authorization-specification-to-align-more-closely-with-how-OAuth-2.0-and-OpenID-Connect-are-deployed-in-practice. §Six-named-SEPs:

- **SEP-2468**: §iss-parameter-validation-per-RFC-9207 (mix-up-attack mitigation).
- **SEP-837**: §OpenID-Connect-application_type-during-Dynamic-Client-Registration (avoids defaulting CLI clients to `"web"`).
- **SEP-2352**: §clients-bind-registered-credentials-to-the-issuing-authorization-server's-issuer + §re-register-when-a-resource-migrates-between-authorization-servers.
- **SEP-2207**: §how-to-request-refresh-tokens-from-OpenID-Connect-style-authorization-servers.
- **SEP-2350**: §scope-accumulation-during-step-up.
- **SEP-2351**: §the-.well-known-discovery-suffix.

§Each-SEP-cites-a-specific-OAuth-or-OpenID-Connect-real-world-deployment-pain-point. §When-a-protocol-hardens-against-existing-standards, §enumerate-the-SEPs-by-number-and-name-the-real-world-pain-each-addresses.

§The-future-direction-named: *In a future version, clients will be expected to reject responses that omit `iss`, so authorization servers should begin supplying it now if they don't already.*

§First-explicit-observation in library of §the-future-direction-named-in-a-current-release as named forward-compatibility-discipline. §Sibling-pattern-to-cycle-238's-reserved-future-siblings — §two-different-shapes-of-future-direction-naming: §cycle-238 reserved-verb-names + §cycle-251 future-rejection-policy-named-now.
