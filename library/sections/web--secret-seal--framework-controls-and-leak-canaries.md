---
title: "Framework controls, safe request representations, and leak-canary testing"
source_kind: web
source_url: https://jasvir.github.io/secretseal/
source_content_sha256: def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3
source_authors: [Jasvir Nagra]
source_date: 2026-09-01
ingested: 2026-10-06
ingested_by: gardener
topics: [http-secret-handling, worker-observability, testing]
status: current
---

Leak resistance is a whole-path framework property, not a per-handler choice of header versus body. Secret Seal recommends sensitivity-labelled values, schema-derived redaction, deliberately lossy request views for logs and errors, automatic cache and referrer policy, reusable one-time-handle infrastructure, optional field encryption, credential brokers, sender constraints, egress controls, leak-canary tests, and retention orchestration.

## Data classification and safe diagnostics

Sensitive values should remain distinguishable from ordinary strings through parsing, validation, interpolation, exceptions, queues, storage objects, RPC boundaries, and asynchronous callbacks. Request and response schemas should classify fields once and generate redaction, validation-error filtering, telemetry filtering, cache policy, and encryption policy from that classification.

Loggers and exception reporters should not receive raw request objects. They should receive an allowlisted, deliberately lossy representation containing safe metadata and keyed fingerprints where correlation is needed. Deleting known secret field names from a serialized request is weaker than constructing the safe view, because aliases, nesting, arrays, and free-form strings escape deny lists. Temporary raw capture needs a narrow break-glass path, short retention, audited access, and automatic deletion.

## Automatic policy

Sensitive routes should receive `Cache-Control: no-store` and a strict `Referrer-Policy` automatically, reject public cache directives and secret-bearing `Vary` entries, disable body capture, and keep sensitive values out of cache tags. A credential broker should attach `Authorization` only for allowlisted origins, methods, and paths and strip it before redirects or error serialization. Egress policy belongs below application wrappers so a new HTTP client cannot bypass it accidentally.

## Leak-canary testing

A leak-canary test gives every sensitive carrier a unique, non-functional marker, exercises success and failure paths, and scans declared sinks such as access logs, application logs, traces, exception reports, caches, queues, and browser storage. A marker found outside its declared sink proves accidental propagation and identifies the carrier that leaked. This differs from a honeytoken: a honeytoken detects unexpected use that may indicate an attacker, while a leak canary detects accidental copying during tests.

The final preference is to avoid collection, use a server-side credential broker with an opaque `Secure; HttpOnly; SameSite` browser session where practical, keep browser-held API tokens short-lived and narrowly scoped when direct API access is required, minimize PII in bodies, and keep credentials and raw PII out of URLs, tracing baggage, metric labels, and cache keys.

Source: [Secret Seal: How can I prevent secrets from leaking from an HTTP request?](https://jasvir.github.io/secretseal/) retrieved 2026-10-06.
