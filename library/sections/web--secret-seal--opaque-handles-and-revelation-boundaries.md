---
title: "Opaque handles, replay resistance, and revelation boundaries"
source_kind: web
source_url: https://jasvir.github.io/secretseal/
source_content_sha256: def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3
source_authors: [Jasvir Nagra]
source_date: 2026-09-01
ingested: 2026-10-06
ingested_by: gardener
topics: [http-secret-handling, capability-security, oauth-credentials]
status: current
---

An opaque handle, a nonce, a single-use token, a sender-bound token, and encryption solve different problems. Opacity removes embedded meaning; single-use semantics limit replay after successful redemption; sender binding reduces off-device portability; encryption hides a value from early intermediaries. None alone prevents accidental copying.

## A practical redemption primitive

A useful one-time handle is random, short-lived, bound to the expected subject or session, action, audience, and expiry, and stored server-side as a hash when the raw redeemable value is unnecessary. Redemption must be atomic and idempotent across retries: an identical retry should recover the original result without repeating the side effect, while a changed action or payload fails. This concurrency and recovery behavior belongs in shared infrastructure rather than being reimplemented by each handler.

Putting an opaque handle in a URL does not make the URL safe. Before redemption, the handle remains a credential and inherits browser-history, logging, referrer, and telemetry exposure. A sender-bound token similarly constrains off-device replay but cannot stop malicious code already running in the authorized browser from invoking the key or causing the browser to send an authenticated request.

## The revelation boundary

Tokenization reduces how many systems see plaintext but does not remove the point where data is evaluated, displayed, delivered, or otherwise used. At this revelation boundary, the resolver should return only the fact or field the caller needs rather than the whole source record. In an object-capability system, this suggests returning a narrow operation-bearing facet rather than routinely revealing the bearer representation behind it.

Containment creates concentrated crown jewels: the ingestion service, resolver, vault, authorized consumers, and key-use service. They need strict access control, purpose limitation, safe request representations, short retention, and observed leak tests. Authority and plaintext have been contained, not abolished.

Source: [Secret Seal: How can I prevent secrets from leaking from an HTTP request?](https://jasvir.github.io/secretseal/) retrieved 2026-10-06.
