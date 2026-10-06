---
title: "HTTP request carriers and accidental copying"
source_kind: web
source_url: https://jasvir.github.io/secretseal/
source_content_sha256: def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3
source_authors: [Jasvir Nagra]
source_date: 2026-09-01
ingested: 2026-10-06
ingested_by: gardener
topics: [http-secret-handling, oauth-credentials, worker-observability]
status: current
---

Secret Seal treats every HTTP request component as observable and compares carriers by two independent dimensions: how many systems commonly copy the value and how damaging a copied value remains. TLS protects bytes only between TLS endpoints; after termination, histories, caches, proxies, frameworks, exception reporters, traces, and logs can all retain decoded request data.

## Carrier comparison

URLs have the broadest accidental-disclosure surface because paths and query strings enter request lines, browser and synced history, access logs, cache keys, referrers, developer tools, and security-product stores. Necessary PII belongs in a minimized request body rather than a URL, but bodies still commonly enter validation errors, parsed request objects, APM capture, and exception reports.

For bearer credentials, the standard `Authorization` header is normally less accident-prone than a custom secret header because HTTP infrastructure recognizes it and commonly redacts it. This is a convention rather than a confidentiality guarantee: full request dumps and misconfigured telemetry can still retain it. Custom credential headers avoid URL-specific copies but must be registered explicitly in redaction policy at every layer.

An opaque browser-session cookie with `Secure`, `HttpOnly`, and an appropriate `SameSite` setting usually exposes less reusable authority to page JavaScript than a browser-held API token. The cookie remains stored by design and can still appear in browser profiles, backups, privileged extensions, proxies, and request dumps; `HttpOnly` prevents ordinary script extraction but not authenticated requests made through the browser.

Tracing metadata is designed to propagate. Credentials, user identifiers, email addresses, and other PII therefore do not belong in baggage, trace state, correlation headers, metric labels, cache tags, or surrogate keys. Sensitive headers must not appear in `Vary`, because caches then need enough information to distinguish the original values.

`Cache-Control: no-store` and Fetch's `cache: "no-store"` reduce compliant cache persistence, but they are not privacy boundaries and say nothing about logs, traces, extensions, packet capture, or intermediaries. A carrier rated "low" for one sink is not safe overall.

Source: [Secret Seal: How can I prevent secrets from leaking from an HTTP request?](https://jasvir.github.io/secretseal/) retrieved 2026-10-06.
