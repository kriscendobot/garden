---
title: "URL fragments, Performance Timeline retention, and split-knowledge links"
source_kind: web
source_url: https://jasvir.github.io/secretseal/
source_content_sha256: def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3
source_authors: [Jasvir Nagra]
source_date: 2026-09-01
ingested: 2026-10-06
ingested_by: gardener
topics: [http-secret-handling, capability-security]
status: current
---

A conforming browser omits the URL fragment from the HTTP request target and `Referer`, which makes a fragment useful for a narrow bootstrap value or the key half of a split-knowledge link. That property does not make the fragment a leak-proof home for PII or a reusable bearer credential: all same-origin page code can read it, and it can enter history, synced history, copied URLs, screenshots, crash reports, session replay, extensions, analytics, and client-side error telemetry.

## Cleanup is narrower than it looks

Removing a fragment with `history.replaceState` cleans the visible address and later history state, but it does not necessarily rewrite the current Navigation Timing entry or previously-created Resource Timing entries. Same-origin code that runs later may recover the initial navigation URL from `performance.getEntriesByType("navigation")`; `performance.clearResourceTimings()` does not remove the current navigation entry, and no cleanup can retract a value already observed by earlier code.

If later code must not recover a bootstrap URL, the bootstrap should run in a small isolated document before analytics or other nonessential code, then navigate to a genuinely new document whose initial URL never contained the fragment. Replacing the fragment in the same document is insufficient. A strict Content Security Policy and early cleanup reduce exposure but do not repair prior capture.

## Split knowledge

In a split-knowledge design, a server-visible location carries ciphertext and the fragment carries the decryption key. This can keep plaintext out of CDNs, TLS terminators, server caches, and early logs if the client uses authenticated encryption, a fresh high-entropy key per payload, bounded lifetime, and zero plaintext logging after decryption. It does not protect against malicious same-origin JavaScript, extensions, a compromised browser profile, history capture before cleanup, or code that sees the decrypted value.

The resulting design rule is narrow: a fragment is reasonable for short-lived, single-use bootstrap material whose possible disclosure is explicitly in the threat model. It is a poor resting place for durable reusable authority.

Source: [Secret Seal: How can I prevent secrets from leaking from an HTTP request?](https://jasvir.github.io/secretseal/) retrieved 2026-10-06.
