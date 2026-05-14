---
title: @endo/ocapn-noise (overview)
source: packages/ocapn-noise/README.md
source_repo: endojs/endo
source_commit: a1de705b
source_date: 2025-12-31
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn]
status: current
---

> Abstract: @endo/ocapn-noise: the noise-protocol netlayer implementation for OCapN. Provides integrity and confidentiality over an underlying transport, per the OCapN Netlayers spec requirements.

# `@endo/ocapn-noise`

Provides a [Noise Protocol](https://noiseprotocol.org/) netlayer for
`@endo/ocapn`.

The particular Noise Protocol variant is XX-x25519-ChaCha20Poly1305-Blake2 with
Ed25519 signature verification. Each party signs their ephemeral X25519 encryption
public key with their Ed25519 signing key during the handshake, providing
cryptographic proof of ownership of both key pairs.

Source: [packages/ocapn-noise/README.md](https://github.com/endojs/endo/blob/a1de705b/packages/ocapn-noise/README.md) at commit `a1de705b`.
