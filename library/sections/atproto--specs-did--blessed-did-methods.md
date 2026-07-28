---
title: Blessed DID methods (did:plc and did:web)
source_kind: web
source_url: https://atproto.com/specs/did
source_content_sha256: 624594bb04584d272731005ef390469357db8c9937211516ad94c5984fc3fedf
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [decentralized-identifiers, identity]
status: current
---

> Abstract: ATProto deliberately supports only two DID methods, `did:plc` (self-authenticating, built for atproto) and `did:web` (HTTPS plus DNS), and states the intent to keep the blessed set as small as possible rather than accept the open DID method registry. The section also records the load-bearing asymmetry between them: `did:web` "does not provide a mechanism for migration or recovering from loss of control of the domain name," which is exactly the property `did:plc` exists to supply.

AT Protocol uses Decentralized Identifiers (DIDs) as persistent account identifiers. The core DID standard was developed by the W3C and describes a framework for compliant identifier systems ("DID methods"), of which several exist. To ensure broad interoperation across the ecosystem, atproto only supports a small number of "blessed" DID methods.

An example DID is `did:plc:ewvi7nxzyoun6zhxrhs64oiz`.

## Blessed DID methods

Currently, atproto supports two DID methods:

- **`did:plc`**: "a self-authenticating DID method developed specifically for use with atproto."
- **`did:web`**: "a W3C community draft based on HTTPS (and DNS). The identifier section is a hostname. This method is supported in atproto to provide an independent alternative to `did:plc`."

> "It is possible that other methods will be supported in the future, but the intention is to keep the 'blessed' set as small as possible. It is certainly not the intention to support all or even a significant fraction of all DID methods."

This is a deliberate rejection of the open-method-registry posture of DID Core. A small blessed set is what makes cross-implementation resolution tractable.

## `did:web` in AT Protocol

> "The DID Web method is inherently tied to the domain name used, and does not provide a mechanism for migration or recovering from loss of control of the domain name."

Additional atproto restrictions on `did:web`:

- Only hostname-level DIDs are supported; path-based DIDs are not.
- The same top-level-domain restrictions that apply to handles (no `.arpa`, and so on) apply to `did:web` domains.
- The special `localhost` hostname is allowed only in testing and development environments.
- Port numbers (with the separating colon hex-encoded) are allowed only for `localhost`, and only in testing and development.

The practical consequence for any taxonomy of identifiers: a `did:web` account is grounded in DNS and TLS and in write access to a path, not in an unforgeable genesis fact. Whoever controls the domain controls the identity, with no recovery path. `did:plc` is the method that makes the "identifier survives key rotation and host migration" property real.

Source: [https://atproto.com/specs/did](https://atproto.com/specs/did), content SHA-256 `624594bb`.
